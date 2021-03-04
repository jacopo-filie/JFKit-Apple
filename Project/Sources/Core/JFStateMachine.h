//
//	The MIT License (MIT)
//
//	Copyright © 2016-2021 Jacopo Filié
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

@import Foundation;

#import "JFCompletions.h"
#import "JFPreprocessorMacros.h"

@class JFStateMachineTransition;

@protocol JFStateMachineDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

/**
 * A constant that represents an invalid state.
 */
#define JFStateNotAvailable -1

/**
 * A constant that represents a state when no transition is executing.
 */
#define JFStateTransitionNone 0

/**
 * A constant that represents an invalid state transition.
 */
#define JFStateTransitionNotAvailable -1

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * An alias for values that represent a state.
 */
typedef NSInteger JFState;

/**
 * An alias for values that represent a state transition.
 */
typedef NSInteger JFStateTransition;

// =================================================================================================
// MARK: Types - Errors
// =================================================================================================

/**
 * A list of all errors generated inside the state machine.
 */
typedef NS_ENUM(NSInteger, JFStateMachineError) {
	
	/**
	 * The requested transition is not valid because there is no beginning state that allows it.
	 */
	JFStateMachineErrorBeginningStateNotValid,
	
	/**
	 * The state machine has already been deallocated.
	 */
	JFStateMachineErrorDeallocated,
	
	/**
	 * The requested transition is not valid because there is no ending state available for it in case of failure.
	 */
	JFStateMachineErrorEndingStateOnFailureNotValid,
	
	/**
	 * The requested transition is not valid because there is no ending state available for it in case of success.
	 */
	JFStateMachineErrorEndingStateOnSuccessNotValid,
	
	/**
	 * The state machine can't perform any transition without a delegate.
	 */
	JFStateMachineErrorMissingDelegate,
	
	/**
	 * The transition has been cancelled due to some underlying error.
	 */
	JFStateMachineErrorTransitionCancelled,
	
	/**
	 * The transition is not allowed from the current state of the machine.
	 */
	JFStateMachineErrorTransitionNotAllowed,
	
	/**
	 * The requested transition is not valid because its value is the same as the keys `JFStateTransitionNone` or `JFStateTransitionNotAvailable`.
	 */
	JFStateMachineErrorTransitionNotValid,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * The class `JFStateMachine` encapsulates all the necessary code to handle thread-safety when working with a finite-state machine. It enqueues each request (if it's considered valid) and performs each one sequentially by asking its delegate to execute the transition and call the completion callback when the transition is finished. There's no way to perform a transition between two states that are not directly linked: to do it the state machine must execute multiple transitions through all the intermediary steps. You can chain together multiple transitions by using the class `JFStateMachineTransition` and its properties `nextTransitionOnFailure` and `nextTransitionOnSuccess`, but be careful because not all the given transitions are performed: if any analyzed transition does not pass the validation step, its completion (if set) is called due to the cancellation of the operation and the following chained transitions are simply ignored; also transitions that are chained on a path that is not executed (for example: a transition set to perform on failure but the current transition succeeds) are ignored and their completions are never called.
 */
@interface JFStateMachine : NSObject

// =================================================================================================
// MARK: Properties - Errors
// =================================================================================================

/**
 * The domain of all the errors generated inside the state machine.
 */
@property (class, strong, nonatomic, readonly) NSErrorDomain errorDomain;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

#if JF_WEAK_ENABLED
/**
 * The delegate of the state machine.
 */
@property (weak, nonatomic, readonly, nullable) id<JFStateMachineDelegate> delegate;
#else
/**
 * The delegate of the state machine.
 * @warning Remember to use `-clearDelegate` to unset the delegate when it is not available anymore because it may become a dangling pointer otherwise.
 */
@property (unsafe_unretained, nonatomic, readonly, nullable) id<JFStateMachineDelegate> delegate;
#endif

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

/**
 * The current state of the machine.
 */
@property (assign, readonly) JFState state;

/**
 * The current state transition that the machine is performing. If the state machine is not performing any transition, the value is `JFStateTransitionNone`.
 */
@property (assign, readonly) JFStateTransition transition;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the state machine with the given initial state and the delegate that will execute the state transitions.
 * @param state The state that the machine will have in the beginning.
 * @param delegate The delegate that will execute the state transitions.
 * @return An initialized instance of the state machine.
 */
- (instancetype)initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Execution
// =================================================================================================

/**
 * Performs the given transition without waiting for it to be finished.
 * @param transition The transition (or chain of transitions) to perform.
 */
- (void)perform:(JFStateMachineTransition*)transition;

/**
 * Performs the given transition.
 * @param transition The transition (or chain of transitions) to perform.
 * @param waitUntilFinished `YES` if the calling thread should wait until the transition is finished, `NO` otherwise.
 */
- (void)perform:(JFStateMachineTransition*)transition waitUntilFinished:(BOOL)waitUntilFinished;

/**
 * The calling thread will wait until all enqueued state transitions are finished.
 */
- (void)waitUntilAllTransitionsAreFinished;

/**
 * The calling thread will wait until the currently executed state transition is finished.
 */
- (void)waitUntilCurrentTransitionIsFinished;

// =================================================================================================
// MARK: Methods - Execution (Convenience)
// =================================================================================================

/**
 * A convenient method to enqueue a state transition without creating an instance of the class `JFStateMachineTransition`: the wrapping will be implicitly done for you.
 * @param transition The transition to perform.
 * @param completion The completion to execute when the transition is finished.
 */
- (void)perform:(JFStateTransition)transition completion:(JFSimpleCompletion* __nullable)completion;

/**
 * A convenient method to enqueue a state transition without creating an instance of the class `JFStateMachineTransition`: the wrapping will be implicitly done for you.
 * @param transition The transition to perform.
 * @param context An object or collection associated with the given transition.
 * @param completion The completion to execute when the transition is finished.
 */
- (void)perform:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

/**
 * Cancels all enqueued transitions and unsets the delegate of the state machine.
 * @warning On systems where the `weak` keyword is not available, you can use this method to prevent the risk of a dangling pointer creation.
 */
- (void)clearDelegate;

// =================================================================================================
// MARK: Methods - State
// =================================================================================================

/**
 * Returns the list of available states from which the given transition can begin.
 * @param transition The state transition.
 * @return The list of available states from which the given transition can begin.
 */
- (NSArray<NSNumber*>*)beginningStatesForTransition:(JFStateTransition)transition;

/**
 * Returns the ending state for the given transition when it fails.
 * @param transition The state transition.
 * @return The ending state for the given transition when it fails.
 */
- (JFState)endingStateForFailedTransition:(JFStateTransition)transition;

/**
 * Returns the ending state for the given transition when it succeeds.
 * @param transition The state transition.
 * @return The ending state for the given transition when it succeeds.
 */
- (JFState)endingStateForSucceededTransition:(JFStateTransition)transition;

/**
 * Returns a string containing the given state.
 * @param state The state to convert to string.
 * @return A string containing the given state, or `nil` if the given state is not valid.
 */
- (NSString* __nullable)stringFromState:(JFState)state;

/**
 * Returns a string containing the given state transition.
 * @param transition The state transition to convert to string.
 * @return A string containing the given state transition, or `nil` if the given state transition is not valid.
 */
- (NSString* __nullable)stringFromTransition:(JFStateTransition)transition;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * The delegate of the state machine is responsible for actually executing the state transition that the machine needs to perform. It can also be notified when that state transition is about to begin or has just finished.
 */
@protocol JFStateMachineDelegate <NSObject>

// =================================================================================================
// MARK: Methods - Execution
// =================================================================================================

@required

/**
 * Asks the delegate to perform the given transition, using the given context. When the delegate finishes the state transition, it must respond using the given completion.
 * @param sender The state machine that is sending the request.
 * @param transition The requested state transition.
 * @param context An object or collection associated with the given transition.
 * @param completion A callback to use when the delegate completes the state transition to notify the state machine that is can resume its work.
 */
- (void)stateMachine:(JFStateMachine*)sender perform:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion*)completion;

@optional

/**
 * Notifies the delegate that a state transition has just finished.
 * @param sender The state machine that is sending the request.
 * @param transition The state transition that has just finished.
 * @param context An object or collection associated with the given transition.
 */
- (void)stateMachine:(JFStateMachine*)sender didPerform:(JFStateTransition)transition context:(id __nullable)context;

/**
 * Notifies the delegate that a state transition is about to begin.
 * @param sender The state machine that is sending the request.
 * @param transition The state transition that is about to begin.
 * @param context An object or collection associated with the given transition.
 */
- (void)stateMachine:(JFStateMachine*)sender willPerform:(JFStateTransition)transition context:(id __nullable)context;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * The class `JFStateMachineTransition` wraps the needed information to perform any state transition in a finite-state machine. It also exposes a couple of properties (`nextTransitionOnFailure` and `nextTransitionOnSuccess`) that lets you chain various state transitions when they need to be performed sequentially. Note that chained transitions are always executed in a single batch, they are never interrupted by other state transitions.
 */
@interface JFStateMachineTransition : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The callback to execute when the state transition is finished.
 */
@property (strong, nonatomic, readonly, nullable) JFSimpleCompletion* completion;

/**
 * An object or collection associated with the state transition.
 */
@property (strong, nonatomic, readonly, nullable) id context;

/**
 * The state transition to perform.
 */
@property (assign, nonatomic, readonly) JFStateTransition transition;

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

/**
 * The state transition to perform if this transition fails.
 */
@property (strong, nonatomic, nullable) JFStateMachineTransition* nextTransitionOnFailure;

/**
 * The state transition to perform if this transition succeeds.
 */
@property (strong, nonatomic, nullable) JFStateMachineTransition* nextTransitionOnSuccess;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes a state machine transition using the given state transition, context and completion.
 * @param transition The state transition to perform.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 * @return The initialized state machine transition.
 */
- (instancetype)initWithTransition:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion NS_DESIGNATED_INITIALIZER;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
