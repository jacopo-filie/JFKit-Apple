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

#if JF_IOS
@import UIKit;
#endif

#import "JFBlocks.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

#if JF_IOS
@interface JFSoftReference<ObjectType> ()

// =================================================================================================
// MARK: Properties - Memory
// =================================================================================================

#	if JF_WEAK_ENABLED
@property (weak, nonatomic, nullable)	ObjectType	weakObject;
#	endif

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

- (void)notifiedDidReceiveMemoryWarning:(NSNotification*)notification;

@end
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

#if JF_IOS
@implementation JFSoftReference

// =================================================================================================
// MARK: Properties - Memory
// =================================================================================================

@synthesize object		= _object;
#	if JF_WEAK_ENABLED
@synthesize weakObject	= _weakObject;
#	endif

// =================================================================================================
// MARK: Properties accessors - Memory
// =================================================================================================

- (id __nullable)object
{
	@synchronized(self)
	{
#	if JF_WEAK_ENABLED
		if(!_object)
			_object = self.weakObject;
#	endif
		return _object;
	}
}

- (void)setObject:(id __nullable)object
{
	@synchronized(self)
	{
		BOOL shouldUpdateNotification = (!object != !_object);
		
		_object = object;
		
#	if JF_WEAK_ENABLED
		self.weakObject = object;
#	endif
		
		if(shouldUpdateNotification)
		{
			NSNotificationCenter* center = NSNotificationCenter.defaultCenter;
			NSString* name = UIApplicationDidReceiveMemoryWarningNotification;
			
			if(!object)
				[center removeObserver:self name:name object:nil];
			else
				[center addObserver:self selector:@selector(notifiedDidReceiveMemoryWarning:) name:name object:nil];
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
	@synchronized(self)
	{
		[NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
}

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

- (void)notifiedDidReceiveMemoryWarning:(NSNotification*)notification
{
#	if JF_WEAK_ENABLED
	// `weakObject` is set to `object` in the `setObject:` method, so we must hold the object here in a local variable before resetting the instance properties, otherwise the object will be lost before having a chance to restore it on the next call to the `object` method.
	id object = self.object;
#	endif
	
	self.object = nil;
	
#	if JF_WEAK_ENABLED
	self.weakObject = object;
#	endif
}

@end
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

#if !JF_WEAK_ENABLED
@implementation JFUnsafeReference

// =================================================================================================
// MARK: Properties - Memory
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
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

#if JF_WEAK_ENABLED
@implementation JFWeakReference

// =================================================================================================
// MARK: Properties - Memory
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
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

