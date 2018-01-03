//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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

#import "JFBlocks.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation JFCompletion

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize block	= _block;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)completionWithBlock:(JFCompletionBlock)block
{
	return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(JFCompletionBlock)block
{
	self = [super init];
	if(self)
	{
		// Execution
		_block	= block;
	}
	return self;
}

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)executeWithError:(NSError*)error
{
	[self executeWithError:error async:NO];
}

- (void)executeWithError:(NSError*)error async:(BOOL)async
{
	JFCompletionBlock block = self.block;
	
	if(!async)
	{
		block(NO, nil, error);
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block(NO, nil, error);
	});
}

- (void)executeWithError:(NSError*)error queue:(NSOperationQueue*)queue
{
	JFCompletionBlock block = self.block;
	[queue addOperationWithBlock:^{
		block(NO, nil, error);
	}];
}

- (void)executeWithResult:(id)result
{
	[self executeWithResult:result async:NO];
}

- (void)executeWithResult:(id)result async:(BOOL)async
{
	JFCompletionBlock block = self.block;
	
	if(!async)
	{
		block(YES, result, nil);
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block(YES, result, nil);
	});
}

- (void)executeWithResult:(id)result queue:(NSOperationQueue*)queue
{
	JFCompletionBlock block = self.block;
	[queue addOperationWithBlock:^{
		block(YES, result, nil);
	}];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFSimpleCompletion

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize block	= _block;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)completionWithBlock:(JFSimpleCompletionBlock)block
{
	return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(JFSimpleCompletionBlock)block
{
	self = [super init];
	if(self)
	{
		// Execution
		_block	= block;
	}
	return self;
}

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)execute
{
	[self execute:NO];
}

- (void)execute:(BOOL)async
{
	JFSimpleCompletionBlock block = self.block;
	
	if(!async)
	{
		block(YES, nil);
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block(YES, nil);
	});
}

- (void)executeOnQueue:(NSOperationQueue*)queue
{
	JFSimpleCompletionBlock block = self.block;
	[queue addOperationWithBlock:^{
		block(YES, nil);
	}];
}

- (void)executeWithError:(NSError*)error
{
	[self executeWithError:error async:NO];
}

- (void)executeWithError:(NSError*)error async:(BOOL)async
{
	JFSimpleCompletionBlock block = self.block;
	
	if(!async)
	{
		block(NO, error);
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		block(NO, error);
	});
}

- (void)executeWithError:(NSError*)error queue:(NSOperationQueue*)queue
{
	JFSimpleCompletionBlock block = self.block;
	[queue addOperationWithBlock:^{
		block(NO, error);
	}];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

