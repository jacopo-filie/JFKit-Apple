//
//	The MIT License (MIT)
//
//	Copyright © 2016-2019 Jacopo Filié
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

#import "JFAsynchronousOperation.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFAsynchronousOperation ()

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@property (readwrite, getter=isExecuting)	BOOL	executing;
@property (readwrite, getter=isFinished)	BOOL	finished;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFAsynchronousOperation

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize executing	= _executing;
@synthesize finished	= _finished;

// =================================================================================================
// MARK: Properties accessors - Execution
// =================================================================================================

- (BOOL)isAsynchronous
{
	return YES;
}

- (BOOL)isExecuting
{
	@synchronized(self)
	{
		return _executing;
	}
}

- (void)setExecuting:(BOOL)executing
{
	@synchronized(self)
	{
		static NSString* key = @"isExecuting";
		
		[self willChangeValueForKey:key];
		_executing = executing;
		[self didChangeValueForKey:key];
	}
}

- (BOOL)isFinished
{
	@synchronized(self)
	{
		return _finished;
	}
}

- (void)setFinished:(BOOL)finished
{
	@synchronized(self)
	{
		static NSString* key = @"isFinished";
		
		[self willChangeValueForKey:key];
		_finished = finished;
		[self didChangeValueForKey:key];
	}
}

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)finish
{
	@synchronized(self)
	{
		if(![self isExecuting])
			return;
		
		self.executing = NO;
		self.finished = YES;
	}
}

- (void)main
{}

- (void)start
{
	if([self isCancelled])
	{
		[self finish];
		return;
	}
	
	self.executing = YES;
	[self main];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

