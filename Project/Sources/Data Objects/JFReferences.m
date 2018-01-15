//
//	The MIT License (MIT)
//
//	Copyright © 2016-2018 Jacopo Filié
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

////////////////////////////////////////////////////////////////////////////////////////////////////

#import "JFReferences.h"

#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

#if JF_IOS || JF_TVOS
NS_ASSUME_NONNULL_BEGIN
@interface JFSoftReference<ObjectType> ()

// MARK: Properties - Data
#if __has_feature(objc_arc_weak)
@property (weak, nonatomic, nullable)	ObjectType	weakObject;
#endif

// MARK: Methods - Notifications management
- (void)	notifiedDidReceiveMemoryWarning:(NSNotification*)notification;

@end
NS_ASSUME_NONNULL_END
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

#if JF_IOS || JF_TVOS
NS_ASSUME_NONNULL_BEGIN
@implementation JFSoftReference

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize object		= _object;
#if __has_feature(objc_arc_weak)
@synthesize weakObject	= _weakObject;
#endif

// =================================================================================================
// MARK: Properties accessors - Data
// =================================================================================================

- (id __nullable)object
{
	@synchronized(self)
	{
#if __has_feature(objc_arc_weak)
		if(!_object)
			_object = self.weakObject;
#endif
		return _object;
	}
}

- (void)setObject:(id __nullable)object
{
	@synchronized(self)
	{
		BOOL shouldUpdateNotification = (!object != !_object);
		
		_object = object;
		
#if __has_feature(objc_arc_weak)
		self.weakObject = object;
#endif
		
		if(shouldUpdateNotification)
		{
			BOOL shouldRemoveObserver = !object;
			
			JFBlock block = ^(void)
			{
				if(shouldRemoveObserver)
					[MainNotificationCenter removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
				else
					[MainNotificationCenter addObserver:self selector:@selector(notifiedDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
			};
			
			[MainOperationQueue addOperationWithBlock:block];
		}
	}
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)referenceWithObject:(id __nullable)object
{
	JFSoftReference* retObj = [[JFSoftReference alloc] init];
	retObj.object = object;
	return retObj;
}

- (void)dealloc
{
	[MainNotificationCenter removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

- (void)notifiedDidReceiveMemoryWarning:(NSNotification*)notification
{
#if __has_feature(objc_arc_weak)
	id object = self.object;
	self.object = nil;
	self.weakObject = object;
#else
	self.object = nil;
#endif
}

@end
NS_ASSUME_NONNULL_END
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

#if !__has_feature(objc_arc_weak)
NS_ASSUME_NONNULL_BEGIN
@implementation JFUnsafeReference

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize object	= _object;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)referenceWithObject:(id __nullable)object
{
	JFUnsafeReference* retObj = [[JFUnsafeReference alloc] init];
	retObj.object = object;
	return retObj;
}

@end
NS_ASSUME_NONNULL_END
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

#if __has_feature(objc_arc_weak)
NS_ASSUME_NONNULL_BEGIN
@implementation JFWeakReference

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize object	= _object;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)referenceWithObject:(id __nullable)object
{
	JFWeakReference* retObj = [[JFWeakReference alloc] init];
	retObj.object = object;
	return retObj;
}

@end
NS_ASSUME_NONNULL_END
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
