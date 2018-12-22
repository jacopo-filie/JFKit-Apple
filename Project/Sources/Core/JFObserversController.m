//
//	The MIT License (MIT)
//
//	Copyright © 2017-2018 Jacopo Filié
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

#import "JFBlocks.h"
#import "JFPreprocessorMacros.h"
#import "JFReferences.h"
#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros - Types
// =================================================================================================

#if JF_WEAK_ENABLED
#	define Reference JFWeakReference
#else
#	define Reference JFUnsafeReference
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFObserversController<ObserverType> ()

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (assign, nonatomic)			BOOL										needsCleanUp;
@property (strong, nonatomic, readonly)	NSMutableArray<Reference<ObserverType>*>*	references;

// =================================================================================================
// MARK: Methods - Observers management
// =================================================================================================

- (void)cleanUp;
- (void)cleanUpIfNeeded;
- (Reference<ObserverType>* __nullable)referenceForObserver:(ObserverType)observer;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFObserversController

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize needsCleanUp	= _needsCleanUp;
@synthesize references		= _references;

// =================================================================================================
// MARK: Properties accessors - Observers
// =================================================================================================

- (NSUInteger)count
{
	NSArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		NSUInteger retVal = 0;
		for(Reference<id>* reference in references)
		{
			if(reference.object)
				retVal++;
			else
				self.needsCleanUp = YES;
		}
		return retVal;
	}
}

- (void)setNeedsCleanUp:(BOOL)needsCleanUp
{
	if(needsCleanUp)
	{
		if(_needsCleanUp)
			return;
		
		_needsCleanUp = needsCleanUp;
		
#if JF_WEAK_ENABLED
		JFWeakifySelf;
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
		_needsCleanUp = NO;
		_references = [NSMutableArray<Reference<id>*> new];
	}
	return self;
}

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

- (void)notifyObservers:(void(^)(id observer))notificationBlock;
{
	[self notifyObservers:notificationBlock async:YES];
}

- (void)notifyObservers:(void(^)(id observer))notificationBlock async:(BOOL)async;
{
	NSArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		references = [references copy];
	}
	
	JFBlock block = ^(void)
	{
		for(Reference<id>* reference in references)
		{
			id observer = reference.object;
			if(observer)
				notificationBlock(observer);
			else
				self.needsCleanUp = YES;
		}
	};
	
	if(!async)
	{
		block();
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (void)notifyObservers:(void(^)(id observer))notificationBlock queue:(NSOperationQueue*)queue waitUntilFinished:(BOOL)waitUntilFinished;
{
	NSArray<Reference<id>*>* references = self.references;
	@synchronized(references)
	{
		references = [references copy];
	}
	
	NSBlockOperation* operation = [NSBlockOperation new];
	for(Reference<id>* reference in references)
	{
		[operation addExecutionBlock:^{
			id observer = reference.object;
			if(observer)
				notificationBlock(observer);
			else
				self.needsCleanUp = YES;
		}];
	}
	
	[queue addOperations:@[operation] waitUntilFinished:waitUntilFinished];
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
			{
				needsCleanUp = YES;
				continue;
			}
			
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

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
