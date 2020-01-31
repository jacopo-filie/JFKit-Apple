//
//	The MIT License (MIT)
//
//	Copyright © 2016-2020 Jacopo Filié
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

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * A list with the available switch states.
 */
typedef NS_ENUM(JFState, JFSwitchState)
{
	/**
	 * The state machine is closed.
	 */
	JFSwitchStateClosed,
	
	/**
	 * The state machine is open.
	 */
	JFSwitchStateOpen,
};

/**
 * A list with the available switch state transitions.
 */
typedef NS_ENUM(JFStateTransition, JFSwitchTransition)
{
	/**
	 * The state machine is not performing any transition.
	 */
	JFSwitchTransitionNone = JFStateTransitionNone,
	
	/**
	 * The state machine is closing: its state is changing from `open` to `closed`; on failure, the state does not change.
	 */
	JFSwitchTransitionClosing,
	
	/**
	 * The state machine is opening: its state is changing from `closed` to `open`; on failure, the state does not change.
	 */
	JFSwitchTransitionOpening,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * The class `JFSwitchMachine` is a dual state machine that can be used to handle situations where something can be either open or closed.
 */
@interface JFSwitchMachine : JFStateMachine

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

/**
 * Returns whether the machine is in state `closed`.
 */
@property (assign, readonly, getter=isClosed) BOOL closed;

/**
 * Returns whether the machine is performing state transition `closing`.
 */
@property (assign, readonly, getter=isClosing) BOOL closing;

/**
 * Returns whether the machine is in state `open`.
 */
@property (assign, readonly, getter=isOpen) BOOL open;

/**
 * Returns whether the machine is performing state transition `opening`.
 */
@property (assign, readonly, getter=isOpening) BOOL opening;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

/**
 * Initializes the state machine with the given delegate. The initial state of the machine is set to `closed`.
 * @param delegate The delegate of the state machine.
 * @return The initialized state machine.
 */
- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate;

// =================================================================================================
// MARK: Methods - Execution
// =================================================================================================

/**
 * Enqueues the state transition `closing`.
 */
- (void)close;

/**
 * Enqueues the state transition `closing`.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 */
- (void)close:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;

/**
 * Enqueues the state transition `opening`.
 */
- (void)open;

/**
 * Enqueues the state transition `opening`.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 */
- (void)open:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
