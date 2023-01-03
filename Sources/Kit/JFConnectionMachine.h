//
//	The MIT License (MIT)
//
//	Copyright © 2015-2023 Jacopo Filié
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

#import <JFKit/JFStateMachine.h>

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * A list with the available connection states.
 */
typedef NS_ENUM(JFState, JFConnectionState)
{
	/**
	 * The state machine is ready to perform the connection.
	 */
	JFConnectionStateReady,
	
	/**
	 * The state machine is connected.
	 */
	JFConnectionStateConnected,
	
	/**
	 * The state machine is disconnected.
	 */
	JFConnectionStateDisconnected,
	
	/**
	 * The state machine has lost connection.
	 */
	JFConnectionStateConnectionLost,
	
	/**
	 * The state machine is in a dirty state because something went wrong while trying to disconnect or reset the machine. To leave this state, the machine can only try to perform the transition `resetting`.
	 */
	JFConnectionStateDirty,
};

/**
 * A list with the available connection state transitions.
 */
typedef NS_ENUM(JFStateTransition, JFConnectionTransition)
{
	/**
	 * The state machine is not performing any transition.
	 */
	JFConnectionTransitionNone = JFStateTransitionNone,
	
	/**
	 * The state machine is connecting: its state is changing from `ready` to `connected`; on failure, the ending state is `connection lost`.
	 */
	JFConnectionTransitionConnecting,
	
	/**
	 * The state machine is disconnecting: its state is changing from either `connected` or `connection lost` to `disconnected`; on failure, the ending state is `dirty`.
	 */
	JFConnectionTransitionDisconnecting,
	
	/**
	 * The state machine is losing connection: its state is changing from `connected` to `connection lost`; on failure, the ending state is still `connection lost`.
	 */
	JFConnectionTransitionLosingConnection,
	
	/**
	 * The state machine is reconnecting: its state is changing from `connection lost` to `connected`; on failure, the state does not change.
	 */
	JFConnectionTransitionReconnecting,
	
	/**
	 * The state machine is resetting: its state is changing from either `disconnected` or `dirty` to `ready`; on failure, the ending state is `dirty`.
	 */
	JFConnectionTransitionResetting,
};

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * The class `JFConnectionMachine` is a state machine that can be used to handle the state of a complex connection.
 */
@interface JFConnectionMachine : JFStateMachine

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

/**
 * Returns whether the machine is in state `connected`.
 */
@property (assign, readonly, getter=isConnected) BOOL connected;

/**
 * Returns whether the machine is performing state transition `connecting`.
 */
@property (assign, readonly, getter=isConnecting) BOOL connecting;

/**
 * Returns whether the machine is in state `connection lost`.
 */
@property (assign, readonly, getter=isConnectionLost) BOOL connectionLost;

/**
 * Returns whether the machine is in state `dirty`.
 */
@property (assign, readonly, getter=isDirty) BOOL dirty;

/**
 * Returns whether the machine is in state `disconnected`.
 */
@property (assign, readonly, getter=isDisconnected) BOOL disconnected;

/**
 * Returns whether the machine is performing state transition `disconnecting`.
 */
@property (assign, readonly, getter=isDisconnecting) BOOL disconnecting;

/**
 * Returns whether the machine is performing state transition `losing connection`.
 */
@property (assign, readonly, getter=isLosingConnection) BOOL losingConnection;

/**
 * Returns whether the machine is in state `ready`.
 */
@property (assign, readonly, getter=isReady) BOOL ready;

/**
 * Returns whether the machine is performing state transition `reconnecting`.
 */
@property (assign, readonly, getter=isReconnecting) BOOL reconnecting;

/**
 * Returns whether the machine is performing state transition `resetting`.
 */
@property (assign, readonly, getter=isResetting) BOOL resetting;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Initializes the state machine with the given delegate. The initial state of the machine is set to `ready`.
 * @param delegate The delegate of the state machine.
 * @return The initialized state machine.
 */
- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate;

// =================================================================================================
// MARK: Methods - Execution
// =================================================================================================

/**
 * Enqueues the state transition `connecting`.
 */
- (void)connect;

/**
 * Enqueues the state transition `connecting`.
 * @param context An object or collection associated with the state transition.
 * @param closure The closure to execute when the transition is finished.
 */
- (void)connect:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure;

/**
 * Enqueues the state transition `connecting`.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 * @deprecated Use '-connect:closure:' instead.
 */
- (void)connect:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion DEPRECATED_MSG_ATTRIBUTE("Use '-connect:closure:' instead.");

/**
 * Enqueues the state transition `disconnecting`.
 */
- (void)disconnect;

/**
 * Enqueues the state transition `disconnecting`.
 * @param context An object or collection associated with the state transition.
 * @param closure The closure to execute when the transition is finished.
 */
- (void)disconnect:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure;

/**
 * Enqueues the state transition `disconnecting`.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 * @deprecated Use '-disconnect:closure:' instead.
 */
- (void)disconnect:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion DEPRECATED_MSG_ATTRIBUTE("Use '-disconnect:closure:' instead.");

/**
 * Enqueues the state transition `losing connection`.
 */
- (void)loseConnection;

/**
 * Enqueues the state transition `losing connection`.
 * @param context An object or collection associated with the state transition.
 * @param closure The closure to execute when the transition is finished.
 */
- (void)loseConnection:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure;

/**
 * Enqueues the state transition `losing connection`.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 * @deprecated Use '-loseConnection:closure:' instead.
 */
- (void)loseConnection:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion DEPRECATED_MSG_ATTRIBUTE("Use '-loseConnection:closure:' instead.");

/**
 * Enqueues the state transition `reconnecting`.
 */
- (void)reconnect;

/**
 * Enqueues the state transition `reconnecting`.
 * @param context An object or collection associated with the state transition.
 * @param closure The closure to execute when the transition is finished.
 */
- (void)reconnect:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure;

/**
 * Enqueues the state transition `reconnecting`.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 * @deprecated Use '-reconnect:closure:' instead.
 */
- (void)reconnect:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion DEPRECATED_MSG_ATTRIBUTE("Use '-reconnect:closure:' instead.");

/**
 * Enqueues the state transition `resetting`.
 */
- (void)reset;

/**
 * Enqueues the state transition `resetting`.
 * @param context An object or collection associated with the state transition.
 * @param closure The closure to execute when the transition is finished.
 */
- (void)reset:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure;

/**
 * Enqueues the state transition `resetting`.
 * @param context An object or collection associated with the state transition.
 * @param completion The completion to execute when the transition is finished.
 * @deprecated Use '-reset:closure:' instead.
 */
- (void)reset:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion DEPRECATED_MSG_ATTRIBUTE("Use '-reset:closure:' instead.");

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
