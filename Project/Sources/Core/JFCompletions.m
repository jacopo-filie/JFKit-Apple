//
//	The MIT License (MIT)
//
//	Copyright © 2015-2019 Jacopo Filié
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

#import "JFCompletions.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFCompletion (/* Private */)

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) JFFailureBlock internalFailureBlock;
@property (strong, nonatomic, readonly, nullable) JFSuccessBlock internalSuccessBlock;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (JFFailureBlock)newFailureBlockForCompletionBlock:(JFCompletionBlock)block;
+ (JFSuccessBlock)newSuccessBlockForCompletionBlock:(JFCompletionBlock)block;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFSimpleCompletion (/* Private */)

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) JFFailureBlock internalFailureBlock;
@property (strong, nonatomic, readonly, nullable) JFBlock internalSuccessBlock;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (JFFailureBlock)newFailureBlockForCompletionBlock:(JFSimpleCompletionBlock)block;
+ (JFBlock)newSuccessBlockForCompletionBlock:(JFSimpleCompletionBlock)block;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFCompletion

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize block = _block;
@synthesize failureBlock = _failureBlock;
@synthesize internalFailureBlock = _internalFailureBlock;
@synthesize internalSuccessBlock = _internalSuccessBlock;
@synthesize successBlock = _successBlock;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (instancetype)completionWithBlock:(JFCompletionBlock)block
{
	return [[self alloc] initWithBlock:block];
}

+ (instancetype)completionWithFailureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithFailureBlock:failureBlock];
}

+ (instancetype)completionWithSuccessBlock:(JFSuccessBlock)successBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock];
}

+ (instancetype)completionWithSuccessBlock:(JFSuccessBlock)successBlock failureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock failureBlock:failureBlock];
}

- (instancetype)initWithBlock:(JFCompletionBlock)block
{
	self = [super init];
	
	_block = block;
	_internalFailureBlock = [JFCompletion newFailureBlockForCompletionBlock:block];
	_internalSuccessBlock = [JFCompletion newSuccessBlockForCompletionBlock:block];
	
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

// =================================================================================================
// MARK: Methods - Execution
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

+ (JFFailureBlock)newFailureBlockForCompletionBlock:(JFCompletionBlock)block
{
	return ^(NSError* error) {
		block(NO, nil, error);
	};
}

+ (JFSuccessBlock)newSuccessBlockForCompletionBlock:(JFCompletionBlock)block
{
	return ^(id result) {
		block(YES, result, nil);
	};
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFSimpleCompletion

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize block = _block;
@synthesize failureBlock = _failureBlock;
@synthesize internalFailureBlock = _internalFailureBlock;
@synthesize internalSuccessBlock = _internalSuccessBlock;
@synthesize successBlock = _successBlock;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (instancetype)completionWithBlock:(JFSimpleCompletionBlock)block
{
	return [[self alloc] initWithBlock:block];
}

+ (instancetype)completionWithFailureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithFailureBlock:failureBlock];
}

+ (instancetype)completionWithSuccessBlock:(JFBlock)successBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock];
}

+ (instancetype)completionWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock
{
	return [[self alloc] initWithSuccessBlock:successBlock failureBlock:failureBlock];
}

- (instancetype)initWithBlock:(JFSimpleCompletionBlock)block
{
	self = [super init];
	
	_block = block;
	_internalFailureBlock = [JFSimpleCompletion newFailureBlockForCompletionBlock:block];
	_internalSuccessBlock = [JFSimpleCompletion newSuccessBlockForCompletionBlock:block];
	
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

// =================================================================================================
// MARK: Methods - Execution
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

+ (JFFailureBlock)newFailureBlockForCompletionBlock:(JFSimpleCompletionBlock)block
{
	return ^(NSError* error) {
		block(NO, error);
	};
}

+ (JFBlock)newSuccessBlockForCompletionBlock:(JFSimpleCompletionBlock)block
{
	return ^{
		block(YES, nil);
	};
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

