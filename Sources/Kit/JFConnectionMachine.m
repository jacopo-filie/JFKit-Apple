//
//	The MIT License (MIT)
//
//	Copyright © 2015-2024 Jacopo Filié
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

#import "JFConnectionMachine.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFConnectionMachine

// =================================================================================================
// MARK: Properties (Accessors) - State
// =================================================================================================

- (BOOL)isConnected
{
	return (self.state == JFConnectionStateConnected);
}

- (BOOL)isConnecting
{
	return (self.transition == JFConnectionTransitionConnecting);
}

- (BOOL)isConnectionLost
{
	return (self.state == JFConnectionStateConnectionLost);
}

- (BOOL)isDirty
{
	return (self.state == JFConnectionStateDirty);
}

- (BOOL)isDisconnected
{
	return (self.state == JFConnectionStateDisconnected);
}

- (BOOL)isDisconnecting
{
	return (self.transition == JFConnectionTransitionDisconnecting);
}

- (BOOL)isLosingConnection
{
	return (self.transition == JFConnectionTransitionLosingConnection);
}

- (BOOL)isReady
{
	return (self.state == JFConnectionStateReady);
}

- (BOOL)isReconnecting
{
	return (self.transition == JFConnectionTransitionReconnecting);
}

- (BOOL)isResetting
{
	return (self.transition == JFConnectionTransitionResetting);
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate
{
	return [self initWithState:JFConnectionStateReady delegate:delegate];
}

// =================================================================================================
// MARK: Methods - State
// =================================================================================================

- (void)connect
{
	[self connect:nil closure:nil];
}

- (void)connect:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure
{
	[self perform:JFConnectionTransitionConnecting context:context closure:closure];
}

- (void)connect:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion
{
	[self perform:JFConnectionTransitionConnecting context:context completion:completion];
}

- (void)disconnect
{
	[self disconnect:nil closure:nil];
}

- (void)disconnect:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure
{
	[self perform:JFConnectionTransitionDisconnecting context:context closure:closure];
}

- (void)disconnect:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion
{
	[self perform:JFConnectionTransitionDisconnecting context:context completion:completion];
}

- (void)loseConnection
{
	[self loseConnection:nil closure:nil];
}

- (void)loseConnection:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure
{
	[self perform:JFConnectionTransitionLosingConnection context:context closure:closure];
}

- (void)loseConnection:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion
{
	[self perform:JFConnectionTransitionLosingConnection context:context completion:completion];
}

- (void)reconnect
{
	[self reconnect:nil closure:nil];
}

- (void)reconnect:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure
{
	[self perform:JFConnectionTransitionReconnecting context:context closure:closure];
}

- (void)reconnect:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion
{
	[self perform:JFConnectionTransitionReconnecting context:context completion:completion];
}

- (void)reset
{
	[self reset:nil closure:nil];
}

- (void)reset:(id _Nullable)context closure:(JFFailableClosure* _Nullable)closure
{
	[self perform:JFConnectionTransitionResetting context:context closure:closure];
}

- (void)reset:(id _Nullable)context completion:(JFSimpleCompletion* _Nullable)completion
{
	[self perform:JFConnectionTransitionResetting context:context completion:completion];
}

// =================================================================================================
// MARK: Methods - State
// =================================================================================================

- (NSArray<NSNumber*>*)beginningStatesForTransition:(JFStateTransition)transition
{
	NSArray<NSNumber*>* retObj;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		{
			retObj = @[@(JFConnectionStateReady)];
			break;
		}
		case JFConnectionTransitionDisconnecting:
		{
			retObj = @[@(JFConnectionStateConnected), @(JFConnectionStateConnectionLost)];
			break;
		}
		case JFConnectionTransitionLosingConnection:
		{
			retObj = @[@(JFConnectionStateConnected)];
			break;
		}
		case JFConnectionTransitionReconnecting:
		{
			retObj = @[@(JFConnectionStateConnectionLost)];
			break;
		}
		case JFConnectionTransitionResetting:
		{
			retObj = @[@(JFConnectionStateDirty), @(JFConnectionStateDisconnected)];
			break;
		}
		default:
		{
			retObj = [super beginningStatesForTransition:transition];
			break;
		}
	}
	return retObj;
}

- (JFState)endingStateForFailedTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		case JFConnectionTransitionLosingConnection:
		case JFConnectionTransitionReconnecting:
		{
			retVal = JFConnectionStateConnectionLost;
			break;
		}
		case JFConnectionTransitionDisconnecting:
		case JFConnectionTransitionResetting:
		{
			retVal = JFConnectionStateDirty;
			break;
		}
		default:
		{
			retVal = [super endingStateForFailedTransition:transition];
			break;
		}
	}
	return retVal;
}

- (JFState)endingStateForSucceededTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		case JFConnectionTransitionReconnecting:
		{
			retVal = JFConnectionStateConnected;
			break;
		}
		case JFConnectionTransitionDisconnecting:
		{
			retVal = JFConnectionStateDisconnected;
			break;
		}
		case JFConnectionTransitionLosingConnection:
		{
			retVal = JFConnectionStateConnectionLost;
			break;
		}
		case JFConnectionTransitionResetting:
		{
			retVal = JFConnectionStateReady;
			break;
		}
		default:
		{
			retVal = [super endingStateForSucceededTransition:transition];
			break;
		}
	}
	return retVal;
}

- (NSString* _Nullable)stringFromState:(JFState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFConnectionStateConnected:
		{
			retObj = @"Connected";
			break;
		}
		case JFConnectionStateConnectionLost:
		{
			retObj = @"ConnectionLost";
			break;
		}
		case JFConnectionStateDirty:
		{
			retObj = @"Dirty";
			break;
		}
		case JFConnectionStateDisconnected:
		{
			retObj = @"Disconnected";
			break;
		}
		case JFConnectionStateReady:
		{
			retObj = @"Ready";
			break;
		}
		default:
		{
			retObj = [super stringFromState:state];
			break;
		}
	}
	return retObj;
}

- (NSString* _Nullable)stringFromTransition:(JFStateTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		{
			retObj = @"Connecting";
			break;
		}
		case JFConnectionTransitionDisconnecting:
		{
			retObj = @"Disconnecting";
			break;
		}
		case JFConnectionTransitionLosingConnection:
		{
			retObj = @"LosingConnection";
			break;
		}
		case JFConnectionTransitionReconnecting:
		{
			retObj = @"Reconnecting";
			break;
		}
		case JFConnectionTransitionResetting:
		{
			retObj = @"Resetting";
			break;
		}
		default:
		{
			retObj = [super stringFromTransition:transition];
			break;
		}
	}
	return retObj;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
