//
//	The MIT License (MIT)
//
//	Copyright © 2016-2024 Jacopo Filié
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

#import "JFStateMachine.h"

#import "JFAsynchronousBlockOperation.h"
#import "JFCompatibilityMacros.h"
#import "JFErrorFactory.h"
#import "JFShortcuts.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFStateMachine (/* Private */)

// =================================================================================================
// MARK: Properties - Errors
// =================================================================================================

@property (class, strong, nonatomic, readonly) JFErrorFactory* errorFactory;

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@property (strong, nonatomic, nullable) NSOperation* executingOperation;
@property (strong, nonatomic, nullable) JFStateMachineTransition* executingTransition;
@property (strong, nonatomic, readonly) NSOperationQueue* executionQueue;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (weak, nonatomic, readwrite, nullable) id<JFStateMachineDelegate> delegate;

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@property (assign, readwrite) JFState state;

// =================================================================================================
// MARK: Methods - Execution
// =================================================================================================

- (void)perform:(JFStateMachineTransition*)transition waitUntilFinished:(BOOL)waitUntilFinished queuePriority:(NSOperationQueuePriority)priority;

// =================================================================================================
// MARK: Methods - State
// =================================================================================================

- (BOOL)isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing _Nullable *)outError;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFStateMachine

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize executingOperation = _executingOperation;
@synthesize executingTransition = _executingTransition;
@synthesize executionQueue = _executionQueue;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize delegate = _delegate;

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@synthesize state = _state;

// =================================================================================================
// MARK: Properties (Accessors) - Errors
// =================================================================================================

+ (JFErrorFactory*)errorFactory
{
	static JFErrorFactory* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = [[JFErrorFactory alloc] initWithDomain:self.errorDomain];
	});
	return retObj;
}

+ (NSErrorDomain)errorDomain
{
	return @"com.jackfelle.stateMachine";
}

// =================================================================================================
// MARK: Properties (Accessors) - State
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
// MARK: Lifecycle
// =================================================================================================

- (void)dealloc
{
	[self.executionQueue cancelAllOperations];
}

- (instancetype)initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate
{
	self = [super init];
	
	_delegate = delegate;
	_executionQueue = JFCreateSerialOperationQueue(ClassName);
	_state = state;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Execution
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
	JFErrorFactory* errorFactory = self.class.errorFactory;
	NSString* transitionString = [self stringFromTransition:transition.transition];
	
	JFOptionalErrorBlock cancelBlock = ^(NSError* _Nullable underlyingError) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
		JFFailableClosure* closure = transition.closure;
		JFSimpleCompletion* completion = transition.completion;
		if(!closure && !completion)
			return;
		
		NSInteger errorCode = JFStateMachineErrorTransitionCancelled;
		NSString* errorDescription = [NSString stringWithFormat:@"Transition '%@' cancelled.", transitionString];
		NSError* error = [errorFactory errorWithCode:errorCode description:errorDescription underlyingError:underlyingError];
		
		if(closure)
			[closure executeWithError:error async:YES];
		else if(completion)
			[completion executeWithError:error async:YES];
#pragma GCC diagnostic pop
	};
	
	NSError* error = nil;
	if(![self isValidTransition:transition.transition error:&error])
	{
		cancelBlock(error);
		return;
	}
	
	BOOL __block shouldSkipIsCancelledCheckOnCompletion = NO;
	
	JFAsynchronousBlockOperation* __block operation = nil;
	
	JFWeakifySelf;
	operation = [[JFAsynchronousBlockOperation alloc] initWithExecutionBlock:^{
		shouldSkipIsCancelledCheckOnCompletion = YES;
		
		JFStrongifySelf;
		if(!strongSelf)
		{
			cancelBlock([errorFactory errorWithCode:JFStateMachineErrorDeallocated]);
			[operation finish];
			return;
		}
		
		id<JFStateMachineDelegate> delegate = strongSelf.delegate;
		if(!delegate)
		{
			cancelBlock([errorFactory errorWithCode:JFStateMachineErrorMissingDelegate]);
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
			NSString* errorDescription = [NSString stringWithFormat:@"Transition '%@' not allowed from state '%@'.", transitionString, [strongSelf stringFromState:state]];
			cancelBlock([errorFactory errorWithCode:JFStateMachineErrorTransitionNotAllowed description:errorDescription]);
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
		
		JFFailableClosure* closure = [JFFailableClosure newWithBlock:^(BOOL succeeded, NSError* _Nullable error) {
			JFStrongifySelf;
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
			
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
			JFFailableClosure* closure = transition.closure;
			JFSimpleCompletion* completion = transition.completion;
			if(closure || completion)
			{
				if(closure)
				{
					if(succeeded)
						[closure executeAsync:YES];
					else
						[closure executeWithError:error async:YES];
				}
				else if(completion)
				{
					if(succeeded)
						[completion executeAsync:YES];
					else
						[completion executeWithError:error async:YES];
				}
			}
#pragma GCC diagnostic pop

			if(strongSelf)
			{
				JFStateMachineTransition* nextTransition = (succeeded ? transition.nextTransitionOnSuccess : transition.nextTransitionOnFailure);
				if(nextTransition)
					[strongSelf perform:nextTransition waitUntilFinished:NO queuePriority:NSOperationQueuePriorityHigh];
			}
			
			[operation finish];
		}];
		
		if(!delegate)
		{
			[closure execute];
			return;
		}
		
		if([delegate respondsToSelector:@selector(stateMachine:perform:context:closure:)])
			[delegate stateMachine:strongSelf perform:transition.transition context:transition.context closure:closure];
		else if([delegate respondsToSelector:@selector(stateMachine:perform:context:completion:)])
		{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
			[delegate stateMachine:strongSelf perform:transition.transition context:transition.context completion:[JFSimpleCompletion completionWithSuccessBlock:^{
				[closure execute];
			} failureBlock:^(NSError* error) {
				[closure executeWithError:error];
			}]];
#pragma GCC diagnostic pop
			return;
		}
		else
			[closure execute];
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
// MARK: Methods - Execution (Convenience)
// =================================================================================================

- (void)perform:(JFStateTransition)transition closure:(JFFailableClosure* _Nullable)closure
{
	[self perform:[[JFStateMachineTransition alloc] initWithTransition:transition context:nil closure:closure]];
}

- (void)perform:(JFStateTransition)transition completion:(JFSimpleCompletion* _Nullable)completion
{
	[self perform:[[JFStateMachineTransition alloc] initWithTransition:transition context:nil completion:completion]];
}

- (void)perform:(JFStateTransition)transition context:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure
{
	[self perform:[[JFStateMachineTransition alloc] initWithTransition:transition context:context closure:closure]];
}

- (void)perform:(JFStateTransition)transition context:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion
{
	[self perform:[[JFStateMachineTransition alloc] initWithTransition:transition context:context completion:completion]];
}

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)clearDelegate
{
	[self.executionQueue cancelAllOperations];
	self.delegate = nil;
}

// =================================================================================================
// MARK: Methods - State
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

- (BOOL)isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing _Nullable *)outError
{
	BOOL (^errorBlock)(NSInteger) = ^BOOL(NSInteger errorCode) {
		if(outError != NULL)
			*outError = [self.class.errorFactory errorWithCode:errorCode description:[NSString stringWithFormat:@"Transition '%@' validation failed.", [self stringFromTransition:transition]]];
		return NO;
	};
	
	if((transition == JFStateTransitionNone) || (transition == JFStateTransitionNotAvailable))
		return errorBlock(JFStateMachineErrorTransitionNotValid);
	
	if([self beginningStatesForTransition:transition].count == 0)
		return errorBlock(JFStateMachineErrorBeginningStateNotValid);
	
	if([self endingStateForSucceededTransition:transition] == JFStateNotAvailable)
		return errorBlock(JFStateMachineErrorEndingStateOnSuccessNotValid);
	
	if([self endingStateForFailedTransition:transition] == JFStateNotAvailable)
		return errorBlock(JFStateMachineErrorEndingStateOnFailureNotValid);
	
	return YES;
}

- (NSString* _Nullable)stringFromState:(JFState)state
{
	return JFStringFromNSInteger(state);
}

- (NSString* _Nullable)stringFromTransition:(JFStateTransition)transition
{
	return JFStringFromNSInteger(transition);
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFStateMachineTransition

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize closure = _closure;
@synthesize completion = _completion;
@synthesize context = _context;
@synthesize transition = _transition;

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@synthesize nextTransitionOnFailure = _nextTransitionOnFailure;
@synthesize nextTransitionOnSuccess = _nextTransitionOnSuccess;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithTransition:(JFStateTransition)transition context:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure
{
	self = [super init];
	_closure = closure;
	_context = context;
	_transition = transition;
	return self;
}

- (instancetype)initWithTransition:(JFStateTransition)transition context:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion
{
	self = [super init];
	_completion = completion;
	_context = context;
	_transition = transition;
	return self;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

