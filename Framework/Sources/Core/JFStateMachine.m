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

#import "JFStateMachine.h"

#import "JFAsynchronousBlockOperation.h"
#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Constants
// =================================================================================================

JFState const			JFStateNotAvailable				= -1;
JFStateTransition const	JFStateTransitionNone			= 0;
JFStateTransition const	JFStateTransitionNotAvailable	= -1;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFStateMachine ()

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@property (strong, nonatomic, nullable)	NSOperation*				executingOperation;
@property (strong, nonatomic, nullable)	JFStateMachineTransition*	executingTransition;
@property (strong, nonatomic, readonly)	NSOperationQueue*			executionQueue;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

#if JF_WEAK_ENABLED
@property (weak, nonatomic, readwrite, nullable) id<JFStateMachineDelegate> delegate;
#else
@property (unsafe_unretained, nonatomic, readwrite, nullable) id<JFStateMachineDelegate> delegate;
#endif

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@property (assign, readwrite) JFState state;

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)perform:(JFStateMachineTransition*)transition waitUntilFinished:(BOOL)waitUntilFinished queuePriority:(NSOperationQueuePriority)priority;

// =================================================================================================
// MARK: Methods - State management
// =================================================================================================

- (BOOL)isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing __nullable *)outError;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFStateMachine

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize executingOperation	= _executingOperation;
@synthesize executingTransition	= _executingTransition;
@synthesize executionQueue		= _executionQueue;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize delegate	= _delegate;

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@synthesize state	= _state;

// =================================================================================================
// MARK: Properties accessors - State
// =================================================================================================

- (JFState)state
{
	@synchronized(self)
	{
		return _state;
	}
}

- (void)setState:(JFState)state
{
	@synchronized(self)
	{
		_state = state;
	}
}

- (JFStateTransition)transition
{
	@synchronized(self)
	{
		JFStateMachineTransition* transition = self.executingTransition;
		return (transition ? transition.transition : JFStateTransitionNone);
	}
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (void)dealloc
{
	[self.executionQueue cancelAllOperations];
}

- (instancetype)initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate
{
	self = [super init];
	if(self)
	{
		NSOperationQueue* executionQueue = [NSOperationQueue new];
		executionQueue.maxConcurrentOperationCount = 1;

		_delegate = delegate;
		_executionQueue = executionQueue;
		_state = state;
	}
	return self;
}

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)perform:(JFStateMachineTransition*)transition
{
	[self perform:transition waitUntilFinished:NO];
}

- (void)perform:(JFStateMachineTransition*)transition waitUntilFinished:(BOOL)waitUntilFinished
{
	[self perform:transition waitUntilFinished:waitUntilFinished queuePriority:NSOperationQueuePriorityNormal];
}

- (void)perform:(JFStateMachineTransition*)transition waitUntilFinished:(BOOL)waitUntilFinished queuePriority:(NSOperationQueuePriority)priority
{
	NSError* error = nil;
	if(![self isValidTransition:transition.transition error:&error])
	{
		JFSimpleCompletion* completion = transition.completion;
		if(completion)
			[completion executeWithError:error async:YES];
		return;
	}
	
	BOOL __block shouldSkipIsCancelledCheckOnCompletion = NO;
	
	void (^cancelBlock)(NSError* __nullable) = ^(NSError* __nullable underlyingError)
	{
		JFSimpleCompletion* completion = transition.completion;
		if(!completion)
			return;
		
		// TODO: replace with specific error.
		NSDictionary<NSErrorUserInfoKey, id>* userInfo = (underlyingError ? @{NSUnderlyingErrorKey:underlyingError} : nil);
		NSError* error = [NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:userInfo];
		[completion executeWithError:error async:YES];
	};
	
	JFAsynchronousBlockOperation* __block operation = nil;
	
#if JF_WEAK_ENABLED
	JFWeakifySelf;
#else
	__typeof(self) __strong strongSelf = self;
#endif
	
	operation = [[JFAsynchronousBlockOperation alloc] initWithExecutionBlock:^{
		shouldSkipIsCancelledCheckOnCompletion = YES;
		
#if JF_WEAK_ENABLED
		JFStrongifySelf;
		if(!strongSelf)
		{
			cancelBlock(nil);
			[operation finish];
			return;
		}
#endif
		
		id<JFStateMachineDelegate> delegate = strongSelf.delegate;
		if(!delegate)
		{
			// TODO: replace with specific error.
			cancelBlock([NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil]);
			[operation finish];
			return;
		}

		JFState state = strongSelf.state;
		NSArray<NSNumber*>* beginningStates = [strongSelf beginningStatesForTransition:transition.transition];
		
		BOOL isBeginningStateWrong = YES;
		for(NSNumber* beginningState in beginningStates)
		{
			if(beginningState.unsignedIntegerValue == state)
			{
				isBeginningStateWrong = NO;
				break;
			}
		}
		
		if(isBeginningStateWrong)
		{
			// TODO: replace with specific error.
			cancelBlock([NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil]);
			[operation finish];
			return;
		}

		if([delegate respondsToSelector:@selector(stateMachine:willPerform:context:)])
			[delegate stateMachine:strongSelf willPerform:transition.transition context:transition.context];
		
		@synchronized(strongSelf)
		{
			strongSelf.executingOperation = operation;
			strongSelf.executingTransition = transition;
		}
		
		JFSimpleCompletion* completion = [JFSimpleCompletion completionWithBlock:^(BOOL succeeded, NSError* __nullable error) {
#if JF_WEAK_ENABLED
			JFStrongifySelf;
#endif
			if(strongSelf)
			{
				JFState endingState = (succeeded ? [strongSelf endingStateForSucceededTransition:transition.transition] : [strongSelf endingStateForFailedTransition:transition.transition]);
				
				@synchronized(strongSelf)
				{
					strongSelf.executingOperation = nil;
					strongSelf.executingTransition = nil;
					strongSelf.state = endingState;
				}
				
				id<JFStateMachineDelegate> delegate = strongSelf.delegate;
				if(delegate && [delegate respondsToSelector:@selector(stateMachine:didPerform:context:)])
					[delegate stateMachine:strongSelf didPerform:transition.transition context:transition.context];
			}

			JFSimpleCompletion* completion = transition.completion;
			if(completion)
			{
				if(succeeded)
					[completion execute:YES];
				else
					[completion executeWithError:error async:YES];
			}
			
			if(strongSelf)
			{
				JFStateMachineTransition* nextTransition = (succeeded ? transition.nextTransitionOnSuccess : transition.nextTransitionOnFailure);
				if(nextTransition)
					[strongSelf perform:nextTransition waitUntilFinished:NO queuePriority:NSOperationQueuePriorityHigh];
			}
			
			[operation finish];
		}];
		
		[delegate stateMachine:strongSelf perform:transition.transition context:transition.context completion:completion];
	}];
	
	operation.completionBlock = ^{
		if(!shouldSkipIsCancelledCheckOnCompletion && [operation isCancelled])
			cancelBlock(nil);
		operation = nil;
	};
	
	operation.queuePriority = priority;
	
	NSMutableArray<NSOperation*>* operations = [NSMutableArray<NSOperation*> arrayWithCapacity:2];
	[operations addObject:operation];
	
	NSOperation* waitingOperation = nil;
	if(waitUntilFinished)
	{
		waitingOperation = [NSOperation new];
		[waitingOperation addDependency:operation];
		waitingOperation.queuePriority = priority;
		[operations addObject:waitingOperation];
	}
	
	[self.executionQueue addOperations:operations waitUntilFinished:waitUntilFinished];
}

- (void)waitUntilAllTransitionsAreFinished
{
	[self.executionQueue waitUntilAllOperationsAreFinished];
}

- (void)waitUntilCurrentTransitionIsFinished
{
	NSOperation* operation;
	@synchronized(self)
	{
		operation = self.executingOperation;
	}
	[operation waitUntilFinished];
}

// =================================================================================================
// MARK: Methods - Execution management (Convenience)
// =================================================================================================

- (void)perform:(JFStateTransition)transition completion:(JFSimpleCompletion* __nullable)completion
{
	[self perform:[[JFStateMachineTransition alloc] initWithTransition:transition context:nil completion:completion]];
}

- (void)perform:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion
{
	[self perform:[[JFStateMachineTransition alloc] initWithTransition:transition context:context completion:completion]];
}

// =================================================================================================
// MARK: Methods - Observers management
// =================================================================================================

- (void)clearDelegate
{
	[self.executionQueue cancelAllOperations];
	self.delegate = nil;
}

// =================================================================================================
// MARK: Methods - State management
// =================================================================================================

- (NSArray<NSNumber*>*)beginningStatesForTransition:(JFStateTransition)transition
{
	return @[];
}

- (JFState)endingStateForFailedTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

- (JFState)endingStateForSucceededTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

- (BOOL)isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing __nullable *)outError
{
	BOOL (^errorBlock)(NSInteger) = ^BOOL(NSInteger errorCode)
	{
		if(outError != NULL)
			*outError = [NSError errorWithDomain:ClassName code:errorCode userInfo:nil];
		return NO;
	};
	
	if((transition == JFStateTransitionNone) || (transition == JFStateTransitionNotAvailable))
		return errorBlock(NSIntegerMax); // TODO: replace with specific error.
	
	if([self beginningStatesForTransition:transition].count == 0)
		return errorBlock(NSIntegerMax); // TODO: replace with specific error.
	
	if([self endingStateForSucceededTransition:transition] == JFStateNotAvailable)
		return errorBlock(NSIntegerMax); // TODO: replace with specific error.
	
	if([self endingStateForFailedTransition:transition] == JFStateNotAvailable)
		return errorBlock(NSIntegerMax); // TODO: replace with specific error.
	
	return YES;
}

- (NSString* __nullable)stringFromState:(JFState)state
{
	return nil;
}

- (NSString* __nullable)stringFromTransition:(JFStateTransition)transition
{
	return nil;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFStateMachineTransition

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize completion	= _completion;
@synthesize context		= _context;
@synthesize transition	= _transition;

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize nextTransitionOnFailure	= _nextTransitionOnFailure;
@synthesize nextTransitionOnSuccess	= _nextTransitionOnSuccess;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)initWithTransition:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion
{
	self = [super init];
	if(self)
	{
		_completion = completion;
		_context = context;
		_transition = transition;
	}
	return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

