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



#import "JFConnectionMachine.h"



NS_ASSUME_NONNULL_BEGIN
@implementation JFConnectionMachine

#pragma mark Properties accessors (State)

- (BOOL)isConnected
{
	return (self.currentState == JFConnectionStateConnected);
}

- (BOOL)isDirty
{
	return (self.currentState == JFConnectionStateDirty);
}

- (BOOL)isDisconnected
{
	return (self.currentState == JFConnectionStateDisconnected);
}

- (BOOL)isLost
{
	return (self.currentState == JFConnectionStateLost);
}

- (BOOL)isReady
{
	return (self.currentState == JFConnectionStateReady);
}


#pragma mark Properties accessors (Transition)

- (BOOL)isConnecting
{
	return (self.currentTransition == JFConnectionTransitionConnecting);
}

- (BOOL)isDisconnecting
{
	JFStateTransition transition = self.currentTransition;
	return ((transition == JFConnectionTransitionDisconnectingFromConnected) || (transition == JFConnectionTransitionDisconnectingFromLost));
}

- (BOOL)isLosingConnection
{
	return (self.currentTransition == JFConnectionTransitionLosingConnection);
}

- (BOOL)isReconnecting
{
	return (self.currentTransition == JFConnectionTransitionReconnecting);
}

- (BOOL)isResetting
{
	JFStateTransition transition = self.currentTransition;
	return ((transition == JFConnectionTransitionResettingFromDirty) || (transition == JFConnectionTransitionResettingFromDisconnected));
}


#pragma mark Memory management

- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate
{
	return [self initWithState:JFConnectionStateReady delegate:delegate];
}


#pragma mark State management

- (void)connect
{
	[self connect:nil];
}

- (void)connect:(nullable JFSimpleCompletionBlock)completion
{
	[self performTransition:JFConnectionTransitionConnecting completion:completion];
}

- (void)disconnect
{
	[self disconnect:nil];
}

- (void)disconnect:(nullable JFSimpleCompletionBlock)completion
{
	JFConnectionTransition transition;
	switch(self.currentState)
	{
		case JFConnectionStateConnected:	transition = JFConnectionTransitionDisconnectingFromConnected;	break;
		case JFConnectionStateLost:			transition = JFConnectionTransitionDisconnectingFromLost;		break;
		default:
		{
			transition = JFStateTransitionNotAvailable;
			break;
		}
	}
	[self performTransition:transition completion:completion];
}

- (void)loseConnection
{
	[self loseConnection:nil];
}

- (void)loseConnection:(nullable JFSimpleCompletionBlock)completion
{
	[self performTransition:JFConnectionTransitionLosingConnection completion:completion];
}

- (void)reconnect
{
	[self reconnect:nil];
}

- (void)reconnect:(nullable JFSimpleCompletionBlock)completion
{
	[self performTransition:JFConnectionTransitionReconnecting completion:completion];
}

- (void)reset
{
	[self reset:nil];
}

- (void)reset:(nullable JFSimpleCompletionBlock)completion
{
	JFConnectionTransition transition;
	switch(self.currentState)
	{
		case JFConnectionStateDirty:		transition = JFConnectionTransitionResettingFromDirty;			break;
		case JFConnectionStateDisconnected:	transition = JFConnectionTransitionResettingFromDisconnected;	break;
		default:
		{
			transition = JFStateTransitionNotAvailable;
			break;
		}
	}
	[self performTransition:transition completion:completion];
}


#pragma mark Utilities management

- (nullable NSString*)debugStringForState:(JFState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFConnectionStateConnected:	retObj = @"Connected";		break;
		case JFConnectionStateDirty:		retObj = @"Dirty";			break;
		case JFConnectionStateDisconnected:	retObj = @"Disconnected";	break;
		case JFConnectionStateLost:			retObj = @"Lost";			break;
		case JFConnectionStateReady:		retObj = @"Ready";			break;
		default:
		{
			retObj = [super debugStringForState:state];
			break;
		}
	}
	return retObj;
}

- (nullable NSString*)debugStringForTransition:(JFStateTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:					retObj = @"Connecting";					break;
		case JFConnectionTransitionDisconnectingFromConnected:	retObj = @"DisconnectingFromConnected";	break;
		case JFConnectionTransitionDisconnectingFromLost:		retObj = @"DisconnectingFromLost";		break;
		case JFConnectionTransitionLosingConnection:			retObj = @"LosingConnection";			break;
		case JFConnectionTransitionReconnecting:				retObj = @"Reconnecting";				break;
		case JFConnectionTransitionResettingFromDisconnected:	retObj = @"ResettingFromDisconnected";	break;
		case JFConnectionTransitionResettingFromDirty:			retObj = @"ResettingFromDirty";			break;
		default:
		{
			retObj = [super debugStringForTransition:transition];
			break;
		}
	}
	return retObj;
}

- (JFState)finalStateForFailedTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		case JFConnectionTransitionLosingConnection:
		case JFConnectionTransitionReconnecting:				retVal = JFConnectionStateLost;			break;
		case JFConnectionTransitionDisconnectingFromConnected:
		case JFConnectionTransitionDisconnectingFromLost:
		case JFConnectionTransitionResettingFromDisconnected:
		case JFConnectionTransitionResettingFromDirty:			retVal = JFConnectionStateDirty;		break;
		default:
		{
			retVal = [super finalStateForFailedTransition:transition];
			break;
		}
	}
	return retVal;
}

- (JFState)finalStateForSucceededTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		case JFConnectionTransitionReconnecting:				retVal = JFConnectionStateConnected;	break;
		case JFConnectionTransitionDisconnectingFromConnected:
		case JFConnectionTransitionDisconnectingFromLost:		retVal = JFConnectionStateDisconnected;	break;
		case JFConnectionTransitionLosingConnection:			retVal = JFConnectionStateLost;			break;
		case JFConnectionTransitionResettingFromDisconnected:
		case JFConnectionTransitionResettingFromDirty:			retVal = JFConnectionStateReady;		break;
		default:
		{
			retVal = [super finalStateForSucceededTransition:transition];
			break;
		}
	}
	return retVal;
}

- (JFState)initialStateForTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:					retVal = JFConnectionStateReady;		break;
		case JFConnectionTransitionDisconnectingFromConnected:
		case JFConnectionTransitionLosingConnection:			retVal = JFConnectionStateConnected;	break;
		case JFConnectionTransitionDisconnectingFromLost:
		case JFConnectionTransitionReconnecting:				retVal = JFConnectionStateLost;			break;
		case JFConnectionTransitionResettingFromDisconnected:	retVal = JFConnectionStateDisconnected;	break;
		case JFConnectionTransitionResettingFromDirty:			retVal = JFConnectionStateDirty;		break;
		default:
		{
			retVal = [super initialStateForTransition:transition];
			break;
		}
	}
	return retVal;
}

@end
NS_ASSUME_NONNULL_END
