//
//	The MIT License (MIT)
//
//	Copyright © 2015-2022 Jacopo Filié
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

#import "JFClosures.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFFailableClosure (/* Private */)

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) JFFailureBlock internalFailureBlock;
@property (strong, nonatomic, readonly, nullable) JFBlock internalSuccessBlock;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (JFFailureBlock)appendFinallyBlock:(JFBlock)finallyBlock toFailureBlock:(JFFailureBlock)failureBlock;
+ (JFBlock)appendFinallyBlock:(JFBlock)finallyBlock toSuccessBlock:(JFBlock)successBlock;
+ (JFFailureBlock)newFailureBlockForClosureBlock:(JFFailableClosureBlock)block;
+ (JFBlock)newSuccessBlockForClosureBlock:(JFFailableClosureBlock)block;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFFetchingClosure (/* Private */)

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) JFFailureBlock internalFailureBlock;
@property (strong, nonatomic, readonly, nullable) JFSuccessBlock internalSuccessBlock;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (JFFailureBlock)appendFinallyBlock:(JFBlock)finallyBlock toFailureBlock:(JFFailureBlock)failureBlock;
+ (JFSuccessBlock)appendFinallyBlock:(JFBlock)finallyBlock toSuccessBlock:(JFSuccessBlock)successBlock;
+ (JFFailureBlock)newFailureBlockForClosureBlock:(JFFetchingClosureBlock)block;
+ (JFSuccessBlock)newSuccessBlockForClosureBlock:(JFFetchingClosureBlock)block;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFClosure

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize block = _block;

// =================================================================================================
// MARK: Lifetime
// =================================================================================================

+ (instancetype)newWithBlock:(JFBlock)block
{
	return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(JFBlock)block
{
	self = [super init];
	
	_block = block;
	
	return self;
}

// =================================================================================================
// MARK: Methods
// =================================================================================================

- (void)execute
{
	[self executeAsync:NO];
}

- (void)executeAsync:(BOOL)async
{
	JFBlock block = self.block;
	
	if(!async)
	{
		block();
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block();
	});
}

- (void)executeOnQueue:(NSOperationQueue*)queue
{
	JFBlock block = self.block;

	[queue addOperationWithBlock:^{
		block();
	}];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFFailableClosure

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize block = _block;
@synthesize failureBlock = _failureBlock;
@synthesize finallyBlock = _finallyBlock;
@synthesize internalFailureBlock = _internalFailureBlock;
@synthesize internalSuccessBlock = _internalSuccessBlock;
@synthesize successBlock = _successBlock;

// =================================================================================================
// MARK: Lifetime
// =================================================================================================

+ (instancetype)newWithBlock:(JFFailableClosureBlock)block
{
	return [[self alloc] initWithBlock:block];
}

+ (instancetype)newWithFailureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithFailureBlock:failureBlock];
}

+ (instancetype)newWithSuccessBlock:(JFBlock)successBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock];
}

+ (instancetype)newWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock failureBlock:failureBlock];
}

+ (instancetype)newWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock failureBlock:failureBlock finallyBlock:finallyBlock];
}

- (instancetype)initWithBlock:(JFFailableClosureBlock)block
{
	self = [super init];
	
	_block = block;
	_internalFailureBlock = [JFFailableClosure newFailureBlockForClosureBlock:block];
	_internalSuccessBlock = [JFFailableClosure newSuccessBlockForClosureBlock:block];
	
	return self;
}

- (instancetype)initWithFailureBlock:(JFFailureBlock)failureBlock
{
	self = [super init];
	
	_failureBlock = failureBlock;
	_internalFailureBlock = failureBlock;
	
	return self;
}

- (instancetype)initWithSuccessBlock:(JFBlock)successBlock
{
	self = [super init];
	
	_internalSuccessBlock = successBlock;
	_successBlock = successBlock;
	
	return self;
}

- (instancetype)initWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock
{
	self = [super init];
	
	_failureBlock = failureBlock;
	_internalFailureBlock = failureBlock;
	_internalSuccessBlock = successBlock;
	_successBlock = successBlock;
	
	return self;
}

- (instancetype)initWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock
{
	self = [super init];
	
	_failureBlock = failureBlock;
	_finallyBlock = finallyBlock;
	_internalFailureBlock = [JFFailableClosure appendFinallyBlock:finallyBlock toFailureBlock:failureBlock];
	_internalSuccessBlock = [JFFailableClosure appendFinallyBlock:finallyBlock toSuccessBlock:successBlock];
	_successBlock = successBlock;
	
	return self;
}

// =================================================================================================
// MARK: Methods
// =================================================================================================

- (void)execute
{
	[self executeAsync:NO];
}

- (void)executeAsync:(BOOL)async
{
	JFBlock block = self.internalSuccessBlock;
	if(!block)
		return;
	
	if(!async)
	{
		block();
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block();
	});
}

- (void)executeOnQueue:(NSOperationQueue*)queue
{
	JFBlock block = self.internalSuccessBlock;
	if(!block)
		return;
	
	[queue addOperationWithBlock:^{
		block();
	}];
}

- (void)executeWithError:(NSError*)error
{
	[self executeWithError:error async:NO];
}

- (void)executeWithError:(NSError*)error async:(BOOL)async
{
	JFFailureBlock block = self.internalFailureBlock;
	if(!block)
		return;
	
	if(!async)
	{
		block(error);
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block(error);
	});
}

- (void)executeWithError:(NSError*)error queue:(NSOperationQueue*)queue
{
	JFFailureBlock block = self.internalFailureBlock;
	if(!block)
		return;
	
	[queue addOperationWithBlock:^{
		block(error);
	}];
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (JFFailureBlock)appendFinallyBlock:(JFBlock)finallyBlock toFailureBlock:(JFFailureBlock)failureBlock
{
	return ^(NSError* error) {
		failureBlock(error);
		finallyBlock();
	};
}

+ (JFBlock)appendFinallyBlock:(JFBlock)finallyBlock toSuccessBlock:(JFBlock)successBlock
{
	return ^{
		successBlock();
		finallyBlock();
	};
}

+ (JFFailureBlock)newFailureBlockForClosureBlock:(JFFailableClosureBlock)block
{
	return ^(NSError* error) {
		block(NO, error);
	};
}

+ (JFBlock)newSuccessBlockForClosureBlock:(JFFailableClosureBlock)block
{
	return ^{
		block(YES, nil);
	};
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFFetchingClosure

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize block = _block;
@synthesize failureBlock = _failureBlock;
@synthesize finallyBlock = _finallyBlock;
@synthesize internalFailureBlock = _internalFailureBlock;
@synthesize internalSuccessBlock = _internalSuccessBlock;
@synthesize successBlock = _successBlock;

// =================================================================================================
// MARK: Lifetime
// =================================================================================================

+ (instancetype)newWithBlock:(JFFetchingClosureBlock)block
{
	return [[self alloc] initWithBlock:block];
}

+ (instancetype)newWithFailureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithFailureBlock:failureBlock];
}

+ (instancetype)newWithSuccessBlock:(JFSuccessBlock)successBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock];
}

+ (instancetype)newWithSuccessBlock:(JFSuccessBlock)successBlock failureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock failureBlock:failureBlock];
}

+ (instancetype)newWithSuccessBlock:(JFSuccessBlock)successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock failureBlock:failureBlock finallyBlock:finallyBlock];
}

- (instancetype)initWithBlock:(JFFetchingClosureBlock)block
{
	self = [super init];
	
	_block = block;
	_internalFailureBlock = [JFFetchingClosure newFailureBlockForClosureBlock:block];
	_internalSuccessBlock = [JFFetchingClosure newSuccessBlockForClosureBlock:block];
	
	return self;
}

- (instancetype)initWithFailureBlock:(JFFailureBlock)failureBlock
{
	self = [super init];
	
	_failureBlock = failureBlock;
	_internalFailureBlock = failureBlock;
	
	return self;
}

- (instancetype)initWithSuccessBlock:(JFSuccessBlock)successBlock
{
	self = [super init];
	
	_internalSuccessBlock = successBlock;
	_successBlock = successBlock;
	
	return self;
}

- (instancetype)initWithSuccessBlock:(JFSuccessBlock)successBlock failureBlock:(JFFailureBlock)failureBlock
{
	self = [super init];
	
	_failureBlock = failureBlock;
	_internalFailureBlock = failureBlock;
	_internalSuccessBlock = successBlock;
	_successBlock = successBlock;
	
	return self;
}

- (instancetype)initWithSuccessBlock:(JFSuccessBlock)successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock
{
	self = [super init];
	
	_failureBlock = failureBlock;
	_finallyBlock = finallyBlock;
	_internalFailureBlock = [JFFetchingClosure appendFinallyBlock:finallyBlock toFailureBlock:failureBlock];
	_internalSuccessBlock = [JFFetchingClosure appendFinallyBlock:finallyBlock toSuccessBlock:successBlock];
	_successBlock = successBlock;
	
	return self;
}

// =================================================================================================
// MARK: Methods
// =================================================================================================

- (void)executeWithError:(NSError*)error
{
	[self executeWithError:error async:NO];
}

- (void)executeWithError:(NSError*)error async:(BOOL)async
{
	JFFailureBlock block = self.internalFailureBlock;
	if(!block)
		return;
	
	if(!async)
	{
		block(error);
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block(error);
	});
}

- (void)executeWithError:(NSError*)error queue:(NSOperationQueue*)queue
{
	JFFailureBlock block = self.internalFailureBlock;
	if(!block)
		return;
	
	[queue addOperationWithBlock:^{
		block(error);
	}];
}

- (void)executeWithResult:(id)result
{
	[self executeWithResult:result async:NO];
}

- (void)executeWithResult:(id)result async:(BOOL)async
{
	JFSuccessBlock block = self.internalSuccessBlock;
	if(!block)
		return;
	
	if(!async)
	{
		block(result);
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block(result);
	});
}

- (void)executeWithResult:(id)result queue:(NSOperationQueue*)queue
{
	JFSuccessBlock block = self.internalSuccessBlock;
	if(!block)
		return;
	
	[queue addOperationWithBlock:^{
		block(result);
	}];
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (JFFailureBlock)appendFinallyBlock:(JFBlock)finallyBlock toFailureBlock:(JFFailureBlock)failureBlock
{
	return ^(NSError* error) {
		failureBlock(error);
		finallyBlock();
	};
}

+ (JFSuccessBlock)appendFinallyBlock:(JFBlock)finallyBlock toSuccessBlock:(JFSuccessBlock)successBlock
{
	return ^(id result) {
		successBlock(result);
		finallyBlock();
	};
}

+ (JFFailureBlock)newFailureBlockForClosureBlock:(JFFetchingClosureBlock)block
{
	return ^(NSError* error) {
		block(NO, nil, error);
	};
}

+ (JFSuccessBlock)newSuccessBlockForClosureBlock:(JFFetchingClosureBlock)block
{
	return ^(id result) {
		block(YES, result, nil);
	};
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
