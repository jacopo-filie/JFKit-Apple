//
//	The MIT License (MIT)
//
//	Copyright © 2017 Jacopo Filié
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

#import "JFObserversController.h"

#import "JFReferences.h"
#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros - Types
// =================================================================================================

#if __has_feature(objc_arc_weak)
#define Reference	JFWeakReference
#else
#define Reference	JFUnsafeReference
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JFObserversController<ObjectType> ()

// MARK: Properties - Observers
@property (assign, nonatomic)			BOOL									needsCleanUp;
@property (strong, nonatomic, readonly)	NSMutableArray<Reference<ObjectType>*>*	references;

// MARK: Methods - Observers management
- (void)								cleanUp;
- (void)								cleanUpIfNeeded;
- (Reference<ObjectType>* __nullable)	referenceForObserver:(ObjectType)observer;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFObserversController

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize needsCleanUp	= _needsCleanUp;
@synthesize references		= _references;

// =================================================================================================
// MARK: Properties accessors - Observers
// =================================================================================================

- (void)setNeedsCleanUp:(BOOL)needsCleanUp
{
	if(needsCleanUp)
	{
		if(_needsCleanUp)
			return;
		
		_needsCleanUp = needsCleanUp;
		
#if __has_feature(objc_arc_weak)
        __typeof(self) __weak weakSelf = self;
#else
        __typeof(self) __strong weakSelf = self;
#endif
        
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			[weakSelf cleanUpIfNeeded];
		});
	}
	else
		_needsCleanUp = NO;
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Observers
		_needsCleanUp	= NO;
		_references		= [NSMutableArray<Reference<id>*> new];
	}
	return self;
}

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

- (void)notifyObservers:(void(^)(id observer))notificationBlock
{
	[self notifyObserversOnQueue:MainOperationQueue notificationBlock:notificationBlock waitUntilFinished:NO];
}

- (void)notifyObserversNow:(void(^)(id observer))notificationBlock
{
	NSArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		references = [references copy];
	}
	
	for(Reference<id>* reference in references)
	{
		id observer = reference.object;
		if(observer)
			notificationBlock(observer);
		else
			self.needsCleanUp = YES;
	}
}

- (void)notifyObserversOnQueue:(NSOperationQueue*)queue notificationBlock:(void(^)(id observer))notificationBlock waitUntilFinished:(BOOL)waitUntilFinished
{
	NSArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		references = [references copy];
	}
	
#if __has_feature(objc_arc_weak)
    __typeof(self) __weak weakSelf = self;
#else
    __typeof(self) __strong weakSelf = self;
#endif
	
	NSMutableArray<NSBlockOperation*>* operations = [NSMutableArray<NSBlockOperation*> arrayWithCapacity:references.count];
	for(Reference<id>* reference in references)
	{
		NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
			id observer = reference.object;
			if(observer)
				notificationBlock(observer);
			else
				weakSelf.needsCleanUp = YES;
		}];
		
		[operations addObject:operation];
	}
	
	[queue addOperations:operations waitUntilFinished:waitUntilFinished];
}

// =================================================================================================
// MARK: Methods - Observers management
// =================================================================================================

- (void)addObserver:(id)observer
{
	NSMutableArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		Reference<id>* oldReference = [self referenceForObserver:observer];
		if(!oldReference)
			[references addObject:[Reference<id> referenceWithObject:observer]];
	}
}

- (void)cleanUp
{
	NSMutableArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		NSMutableArray<Reference<id>*>* obsolete = [NSMutableArray<Reference<id>*> arrayWithCapacity:references.count];
		for(Reference<id>* reference in references)
		{
			if(!reference.object)
				[obsolete addObject:reference];
		}
		[references removeObjectsInArray:obsolete];
	}
}

- (void)cleanUpIfNeeded
{
	if([self needsCleanUp])
	{
		[self cleanUp];
		self.needsCleanUp = NO;
	}
}

- (Reference<id>* __nullable)referenceForObserver:(id)observer
{
	NSArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		BOOL needsCleanUp = NO;
		Reference<id>* retObj = nil;
		
		for(Reference<id>* reference in references)
		{
			id temp = reference.object;
			if(!temp)
				needsCleanUp = YES;
			
			if(temp == observer)
			{
				retObj = reference;
				break;
			}
		}
		
		if(needsCleanUp)
			self.needsCleanUp = YES;
		
		return retObj;
	}
}

- (void)removeObserver:(id)observer
{
	NSMutableArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		Reference<id>* oldReference = [self referenceForObserver:observer];
		if(oldReference)
			[references removeObject:oldReference];
	}
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
