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

#import "JFStateMachine.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef NS_ENUM(JFState, JFConnectionState)
{
	JFConnectionStateReady,
	JFConnectionStateConnected,
	JFConnectionStateDisconnected,
	JFConnectionStateConnectionLost,
	JFConnectionStateDirty,
};

typedef NS_ENUM(JFStateTransition, JFConnectionTransition)
{
	JFConnectionTransitionNone = JFStateTransitionNone,
	JFConnectionTransitionConnecting,
	JFConnectionTransitionDisconnecting,
	JFConnectionTransitionLosingConnection,
	JFConnectionTransitionReconnecting,
	JFConnectionTransitionResetting,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFConnectionMachine : JFStateMachine

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@property (assign, readonly, getter=isConnected) BOOL connected;
@property (assign, readonly, getter=isConnecting) BOOL connecting;
@property (assign, readonly, getter=isConnectionLost) BOOL connectionLost;
@property (assign, readonly, getter=isDirty) BOOL dirty;
@property (assign, readonly, getter=isDisconnected) BOOL disconnected;
@property (assign, readonly, getter=isDisconnecting) BOOL disconnecting;
@property (assign, readonly, getter=isLosingConnection) BOOL losingConnection;
@property (assign, readonly, getter=isReady) BOOL ready;
@property (assign, readonly, getter=isReconnecting) BOOL reconnecting;
@property (assign, readonly, getter=isResetting) BOOL resetting;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

// The starting state is "Ready".
- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate;

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)connect;
- (void)connect:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;
- (void)disconnect;
- (void)disconnect:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;
- (void)loseConnection;
- (void)loseConnection:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;
- (void)reconnect;
- (void)reconnect:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;
- (void)reset;
- (void)reset:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
