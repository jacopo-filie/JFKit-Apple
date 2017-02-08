//
//	The MIT License (MIT)
//
//	Copyright © 2015-2017 Jacopo Filié
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

// =================================================================================================
// MARK: Types - State
// =================================================================================================

typedef NS_ENUM(JFState, JFConnectionState)
{
	JFConnectionStateReady,
	JFConnectionStateConnected,
	JFConnectionStateDisconnected,
	JFConnectionStateLost,
	JFConnectionStateDirty,
};

typedef NS_ENUM(JFStateTransition, JFConnectionTransition)
{
	JFConnectionTransitionNotAvailable = JFStateTransitionNotAvailable,
	JFConnectionTransitionNone = JFStateTransitionNone,
	JFConnectionTransitionConnecting,
	JFConnectionTransitionDisconnectingFromConnected,
	JFConnectionTransitionDisconnectingFromLost,
	JFConnectionTransitionLosingConnection,
	JFConnectionTransitionReconnecting,
	JFConnectionTransitionResettingFromDisconnected,
	JFConnectionTransitionResettingFromDirty,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JFConnectionMachine : JFStateMachine

// MARK: Properties - State
@property (assign, nonatomic, readonly, getter=isConnected)		BOOL	connected;
@property (assign, nonatomic, readonly, getter=isDirty)			BOOL	dirty;
@property (assign, nonatomic, readonly, getter=isDisconnected)	BOOL	disconnected;
@property (assign, nonatomic, readonly, getter=isLost)			BOOL	lost;
@property (assign, nonatomic, readonly, getter=isReady)			BOOL	ready;

// MARK: Properties - State (Transitions)
@property (assign, nonatomic, readonly, getter=isConnecting)		BOOL	connecting;
@property (assign, nonatomic, readonly, getter=isDisconnecting)		BOOL	disconnecting;
@property (assign, nonatomic, readonly, getter=isLosingConnection)	BOOL	losingConnection;
@property (assign, nonatomic, readonly, getter=isReconnecting)		BOOL	reconnecting;
@property (assign, nonatomic, readonly, getter=isResetting)			BOOL	resetting;

// MARK: Methods - Memory management
- (instancetype)	initWithDelegate:(id<JFStateMachineDelegate>)delegate;	// The starting state is "Ready".

// MARK: Methods - State management
- (void)	connect;
- (void)	connect:(JFSimpleCompletionBlock __nullable)completion;
- (void)	disconnect;
- (void)	disconnect:(JFSimpleCompletionBlock __nullable)completion;
- (void)	loseConnection;
- (void)	loseConnection:(JFSimpleCompletionBlock __nullable)completion;
- (void)	reconnect;
- (void)	reconnect:(JFSimpleCompletionBlock __nullable)completion;
- (void)	reset;
- (void)	reset:(JFSimpleCompletionBlock __nullable)completion;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
