//
//	The MIT License (MIT)
//
//	Copyright © 2019-2021 Jacopo Filié
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#import "JFExecutor.h"

#import "JFCompatibilityMacros.h"
#import "JFShortcuts.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFExecutor<__covariant OwnerType> (/* Private */)

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (JF_WEAK_OR_UNSAFE_UNRETAINED_PROPERTY, nonatomic, readwrite, nullable) OwnerType owner;

// =================================================================================================
// MARK: Properties - Service
// =================================================================================================

@property (strong, nonatomic, readonly) NSOperationQueue* queue;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (NSError*)newCanceledError;
+ (NSError*)newDeallocatedError;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFExecutor

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize owner = _owner;

// =================================================================================================
// MARK: Properties - Service
// =================================================================================================

@synthesize queue = _queue;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (void)dealloc
{
	[self cancelEnqueuedBlocks];
}

- (instancetype)initWithOwner:(id)owner
{
	return [self initWithOwner:owner queue:JFCreateSerialOperationQueue(ClassName)];
}

- (instancetype)initWithOwner:(id)owner queue:(NSOperationQueue*)queue
{
	self = [super init];
	
	_owner = owner;
	_queue = queue;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)clearOwner
{
	[self cancelEnqueuedBlocks];
	self.owner = nil;
}

// =================================================================================================
// MARK: Methods - Service
// =================================================================================================

- (void)cancelEnqueuedBlocks
{
	[self.queue cancelAllOperations];
}

- (void)enqueue:(void (^)(id owner))block
{
	[self enqueue:block failureBlock:nil waitUntilFinished:NO];
}

- (void)enqueue:(void (^)(id owner))block failureBlock:(JFFailureBlock _Nullable)failureBlock
{
	[self enqueue:block failureBlock:failureBlock waitUntilFinished:NO];
}

- (void)enqueue:(void (^)(id owner))block failureBlock:(JFFailureBlock _Nullable)failureBlock waitUntilFinished:(BOOL)waitUntilFinished
{
	BOOL __block executed = NO;
	
#if JF_WEAK_ENABLED
	JFWeakify(self.owner, Owner);
#else
	__typeof(self) __strong strongOwner = self.owner;
#endif
	NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
		executed = YES;
		
#if JF_WEAK_ENABLED
		JFStrongify(weakOwner, Owner);
#endif
		if(strongOwner)
		{
			block(strongOwner);
			return;
		}
		
		if(failureBlock)
			failureBlock([JFExecutor newDeallocatedError]);
	}];
	
	if(failureBlock)
	{
		operation.completionBlock = ^{
			if(!executed)
				failureBlock([JFExecutor newCanceledError]);
		};
	}
	
	[self.queue addOperations:@[operation] waitUntilFinished:waitUntilFinished];
}

- (void)enqueue:(void (^)(id owner))block waitUntilFinished:(BOOL)waitUntilFinished
{
	[self enqueue:block failureBlock:nil waitUntilFinished:waitUntilFinished];
}

- (void)execute:(void (^)(id owner))block
{
	[self execute:block failureBlock:nil waitUntilFinished:NO];
}

- (void)execute:(void (^)(id owner))block failureBlock:(JFFailureBlock _Nullable)failureBlock
{
	[self execute:block failureBlock:failureBlock waitUntilFinished:NO];
}

- (void)execute:(void (^)(id owner))block failureBlock:(JFFailureBlock _Nullable)failureBlock waitUntilFinished:(BOOL)waitUntilFinished
{
	if([NSOperationQueue currentQueue] != self.queue)
	{
		[self enqueue:block failureBlock:failureBlock waitUntilFinished:waitUntilFinished];
		return;
	}
	
	id owner = self.owner;
	if(owner)
		block(owner);
	else if(failureBlock)
		failureBlock([JFExecutor newDeallocatedError]);
}

- (void)execute:(void (^)(id owner))block waitUntilFinished:(BOOL)waitUntilFinished
{
	[self execute:block failureBlock:nil waitUntilFinished:waitUntilFinished];
}

+ (NSError*)newCanceledError
{
	return [NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil]; // TODO: create "canceled" error.
}

+ (NSError*)newDeallocatedError
{
	return [NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil]; // TODO: create "deallocated" error.
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
