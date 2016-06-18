//
//	The MIT License (MIT)
//
//	Copyright © 2015-2016 Jacopo Filié
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



#import "JFStateMachine.h"



#pragma mark - Types

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
	JFConnectionTransitionNone = JFStateTransitionNone,
	JFConnectionTransitionConnecting,
	JFConnectionTransitionDisconnectingFromConnected,
	JFConnectionTransitionDisconnectingFromLost,
	JFConnectionTransitionLosingConnection,
	JFConnectionTransitionReconnecting,
	JFConnectionTransitionResettingFromDisconnected,
	JFConnectionTransitionResettingFromDirty,
};



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@interface JFConnectionMachine : JFStateMachine

#pragma mark Properties

// State
@property (assign, nonatomic, readonly, getter=isConnected)		BOOL	connected;
@property (assign, nonatomic, readonly, getter=isDirty)			BOOL	dirty;
@property (assign, nonatomic, readonly, getter=isDisconnected)	BOOL	disconnected;
@property (assign, nonatomic, readonly, getter=isLost)			BOOL	lost;
@property (assign, nonatomic, readonly, getter=isReady)			BOOL	ready;


// Transition
@property (assign, nonatomic, readonly, getter=isConnecting)		BOOL	connecting;
@property (assign, nonatomic, readonly, getter=isDisconnecting)		BOOL	disconnecting;
@property (assign, nonatomic, readonly, getter=isLosingConnection)	BOOL	losingConnection;
@property (assign, nonatomic, readonly, getter=isReconnecting)		BOOL	reconnecting;
@property (assign, nonatomic, readonly, getter=isResetting)			BOOL	resetting;


#pragma mark Methods

// Memory management
- (instancetype)	initWithDelegate:(id<JFStateMachineDelegate>)delegate;	// The starting state is "Ready".

// State management
- (void)	connect;
- (void)	connect:(nullable JFSimpleCompletionBlock)completion;
- (void)	disconnect;
- (void)	disconnect:(nullable JFSimpleCompletionBlock)completion;
- (void)	loseConnection;
- (void)	loseConnection:(nullable JFSimpleCompletionBlock)completion;
- (void)	reconnect;
- (void)	reconnect:(nullable JFSimpleCompletionBlock)completion;
- (void)	reset;
- (void)	reset:(nullable JFSimpleCompletionBlock)completion;

@end
NS_ASSUME_NONNULL_END
