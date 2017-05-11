//
//	The MIT License (MIT)
//
//	Copyright © 2016-2017 Jacopo Filié
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

#import "JFShortcuts.h"
#import "JFStateMachineErrorsManager.h"
#import "JFString.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros - String constants
// =================================================================================================

#define JFStateMachineSerialQueueName	JFReversedDomain @".stateMachine.queue"

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN

// =================================================================================================
// MARK: Functions (Definition) - Concurrency management
// =================================================================================================

static	void	dispatchSyncOnMainQueue(JFBlock block);

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JFStateMachine ()

#pragma mark Properties

// MARK: Properties - Concurrency
#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic, readonly)	dispatch_queue_t	serialQueue;
#else
@property (assign, nonatomic, readonly)	dispatch_queue_t	serialQueue;
#endif

// MARK: Properties - Errors
@property (strong, nonatomic, readonly)	JFStateMachineErrorsManager*	errorsManager;

// MARK: Properties accessors - State
- (void)	setCurrentState:(JFState)currentState andTransition:(JFStateTransition)currentTransition;

// MARK: Methods - State management
- (void)	completeTransition:(BOOL)succeeded error:(NSError* __nullable)error context:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion;
- (BOOL)	isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing __nullable *)outError;
- (void)	performTransitionOnQueue:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFStateMachine

#pragma mark Properties

// =================================================================================================
// MARK: Properties - Concurrency
// =================================================================================================

@synthesize serialQueue	= _serialQueue;

// =================================================================================================
// MARK: Properties - Errors
// =================================================================================================

@synthesize errorsManager	= _errorsManager;

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@synthesize currentState		= _currentState;
@synthesize currentTransition	= _currentTransition;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize delegate	= _delegate;

// =================================================================================================
// MARK: Properties accessors - State
// =================================================================================================

- (JFState)currentState
{
	@synchronized(self)
	{
		return _currentState;
	}
}

- (JFStateTransition)currentTransition
{
	@synchronized(self)
	{
		return _currentTransition;
	}
}

- (void)setCurrentState:(JFState)currentState andTransition:(JFStateTransition)currentTransition
{
	@synchronized(self)
	{
		_currentState		= currentState;
		_currentTransition	= currentTransition;
	}
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
	dispatch_release(self.serialQueue);
#endif
}

- (instancetype)initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate
{
	self = [super init];
	if(self)
	{
		// Concurrency
		_serialQueue	= dispatch_queue_create(JFStringToCString(JFStateMachineSerialQueueName), DISPATCH_QUEUE_SERIAL);
		
		// Errors
		_errorsManager	= [JFStateMachineErrorsManager sharedManager];
		
		// Relationships
		_delegate	= delegate;
		
		// State
		_currentState		= state;
		_currentTransition	= JFStateTransitionNone;
	}
	return self;
}

// =================================================================================================
// MARK: Methods - State management
// =================================================================================================

- (void)completeTransition:(BOOL)succeeded error:(NSError* __nullable)error context:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	JFStateTransition transition = self.currentTransition;
	
	JFState finalState = (succeeded ? [self finalStateForSucceededTransition:transition] : [self finalStateForFailedTransition:transition]);
	
	[self setCurrentState:finalState andTransition:JFStateTransitionNone];
	
	id<JFStateMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(stateMachine:didPerformTransition:context:)])
	{
		dispatchSyncOnMainQueue(^{
			[delegate stateMachine:self didPerformTransition:transition context:context];
		});
	}
	
	if(completion)
	{
		dispatchSyncOnMainQueue(^{
			completion(succeeded, error);
		});
	}
	
	dispatch_resume(self.serialQueue);
}

- (JFState)finalStateForFailedTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

- (JFState)finalStateForSucceededTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

- (JFState)initialStateForTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

- (BOOL)isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing __nullable *)outError
{
	BOOL (^errorBlock)(NSError*) = ^BOOL(NSError* error)
	{
		if(outError != NULL)
			*outError = error;
		return NO;
	};
	
	JFStateMachineErrorsManager* errorsManager = self.errorsManager;
	
	if((transition == JFStateTransitionNone) || (transition == JFStateTransitionNotAvailable))
		return errorBlock([errorsManager errorWithCode:JFStateMachineErrorInvalidTransition]);
	
	JFState initialState = [self initialStateForTransition:transition];
	if(initialState == JFStateNotAvailable)
		return errorBlock([errorsManager errorWithCode:JFStateMachineErrorInvalidInitialState]);
	
	JFState finalState = [self finalStateForSucceededTransition:transition];
	if(finalState == JFStateNotAvailable)
		return errorBlock([errorsManager errorWithCode:JFStateMachineErrorInvalidFinalStateOnSuccess]);
	
	finalState = [self finalStateForFailedTransition:transition];
	if(finalState == JFStateNotAvailable)
		return errorBlock([errorsManager errorWithCode:JFStateMachineErrorInvalidFinalStateOnFailure]);
	
	return YES;
}

- (void)performTransition:(JFStateTransition)transition completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:transition context:nil completion:completion];
}

- (void)performTransition:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	JFBlockWithError errorBlock = ^(NSError* error)
	{
		if(completion)
		{
			dispatchSyncOnMainQueue(^{
				completion(NO, error);
			});
		}
	};
	
	NSError* error = nil;
	if(![self isValidTransition:transition error:&error])
	{
		errorBlock(error);
		return;
	}
	
	JFStateMachineErrorsManager* errorsManager = self.errorsManager;
	
	WeakifySelf;
	
	JFBlock block = ^(void)
	{
		StrongifySelf;
		if(!strongSelf)
		{
			errorBlock([errorsManager errorWithCode:JFStateMachineErrorDeallocated]);
			return;
		}
		
		if([strongSelf initialStateForTransition:transition] != strongSelf.currentState)
		{
			errorBlock([errorsManager errorWithCode:JFStateMachineErrorWrongInitialState]);
			return;
		}
		
		[strongSelf performTransitionOnQueue:transition context:context completion:completion];
	};
	
	dispatch_async(self.serialQueue, block);
}

- (void)performTransitionOnQueue:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	dispatch_suspend(self.serialQueue);
	
	id<JFStateMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(stateMachine:willPerformTransition:context:)])
	{
		dispatchSyncOnMainQueue(^{
			[delegate stateMachine:self willPerformTransition:transition context:context];
		});
	}
	
	[self setCurrentState:self.currentState andTransition:transition];
	
	JFSimpleCompletionBlock transitionCompletion = ^(BOOL succeeded, NSError* error)
	{
		// It's easier to force the machine to stay alive by keeping a strong reference to itself while a transition is performed.
		[self completeTransition:succeeded error:error context:context completion:completion];
	};
	
	dispatchSyncOnMainQueue(^{
		[delegate stateMachine:self performTransition:transition context:context completion:transitionCompletion];
	});
}

// =================================================================================================
// MARK: Methods - Utilities management
// =================================================================================================

- (NSString* __nullable)debugStringForState:(JFState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFStateNotAvailable:	retObj = @"JFStateNotAvailable";	break;
		default:														break;
	}
	return retObj;
}

- (NSString* __nullable)debugStringForTransition:(JFStateTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFStateTransitionNone:			retObj = @"JFTransitionNone";			break;
		case JFStateTransitionNotAvailable:	retObj = @"JFTransitionNotAvailable";	break;
		default:																	break;
	}
	return retObj;
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN

// =================================================================================================
// MARK: Functions (Implementation) - Concurrency management
// =================================================================================================

static void dispatchSyncOnMainQueue(JFBlock block)
{
	if([NSThread isMainThread])
		block();
	else
		dispatch_sync(dispatch_get_main_queue(), block);
}

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
