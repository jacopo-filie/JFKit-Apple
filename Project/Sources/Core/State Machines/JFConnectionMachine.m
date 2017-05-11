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

#import "JFConnectionMachine.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN
@implementation JFConnectionMachine

// =================================================================================================
// MARK: Properties accessors - State
// =================================================================================================

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

// =================================================================================================
// MARK: Properties accessors - State (Transitions)
// =================================================================================================

- (BOOL)isConnecting
{
	return (self.currentTransition == JFConnectionTransitionConnecting);
}

- (BOOL)isDisconnecting
{
	return (self.currentTransition == JFConnectionTransitionDisconnecting);
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
	return (self.currentTransition == JFConnectionTransitionResetting);
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate
{
	return [self initWithState:JFConnectionStateReady delegate:delegate];
}

// =================================================================================================
// MARK: Methods - State management
// =================================================================================================

- (void)connect
{
	[self connect:nil];
}

- (void)connect:(JFSimpleCompletionBlock __nullable)completion
{
	[self connect:nil completion:completion];
}

- (void)connect:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:JFConnectionTransitionConnecting context:context completion:completion];
}

- (void)disconnect
{
	[self disconnect:nil];
}

- (void)disconnect:(JFSimpleCompletionBlock __nullable)completion
{
	[self disconnect:nil completion:completion];
}

- (void)disconnect:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:JFConnectionTransitionDisconnecting context:context completion:completion];
}

- (JFState)finalStateForFailedTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		case JFConnectionTransitionLosingConnection:
		case JFConnectionTransitionReconnecting:		retVal = JFConnectionStateLost;		break;
		case JFConnectionTransitionDisconnecting:
		case JFConnectionTransitionResetting:			retVal = JFConnectionStateDirty;	break;
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
		case JFConnectionTransitionReconnecting:		retVal = JFConnectionStateConnected;	break;
		case JFConnectionTransitionDisconnecting:		retVal = JFConnectionStateDisconnected;	break;
		case JFConnectionTransitionLosingConnection:	retVal = JFConnectionStateLost;			break;
		case JFConnectionTransitionResetting:			retVal = JFConnectionStateReady;		break;
		default:
		{
			retVal = [super finalStateForSucceededTransition:transition];
			break;
		}
	}
	return retVal;
}

- (NSArray<NSNumber*>*)initialStatesForTransition:(JFStateTransition)transition
{
	NSArray<NSNumber*>* retObj;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:			retObj = @[@(JFConnectionStateReady)];										break;
		case JFConnectionTransitionDisconnecting:		retObj = @[@(JFConnectionStateConnected), @(JFConnectionStateLost)];		break;
		case JFConnectionTransitionLosingConnection:	retObj = @[@(JFConnectionStateConnected)];									break;
		case JFConnectionTransitionReconnecting:		retObj = @[@(JFConnectionStateLost)];										break;
		case JFConnectionTransitionResetting:			retObj = @[@(JFConnectionStateDirty), @(JFConnectionStateDisconnected)];	break;
		default:
		{
			retObj = [super initialStatesForTransition:transition];
			break;
		}
	}
	return retObj;
}

- (void)loseConnection
{
	[self loseConnection:nil];
}

- (void)loseConnection:(JFSimpleCompletionBlock __nullable)completion
{
	[self loseConnection:nil completion:completion];
}

- (void)loseConnection:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:JFConnectionTransitionLosingConnection context:context completion:completion];
}

- (void)reconnect
{
	[self reconnect:nil];
}

- (void)reconnect:(JFSimpleCompletionBlock __nullable)completion
{
	[self reconnect:nil completion:completion];
}

- (void)reconnect:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:JFConnectionTransitionReconnecting context:context completion:completion];
}

- (void)reset
{
	[self reset:nil];
}

- (void)reset:(JFSimpleCompletionBlock __nullable)completion
{
	[self reset:nil completion:completion];
}

- (void)reset:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:JFConnectionTransitionResetting context:context completion:completion];
}

// =================================================================================================
// MARK: Methods - Utilities management
// =================================================================================================

- (NSString* __nullable)debugStringForState:(JFState)state
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

- (NSString* __nullable)debugStringForTransition:(JFStateTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:			retObj = @"Connecting";			break;
		case JFConnectionTransitionDisconnecting:		retObj = @"Disconnecting";		break;
		case JFConnectionTransitionLosingConnection:	retObj = @"LosingConnection";	break;
		case JFConnectionTransitionReconnecting:		retObj = @"Reconnecting";		break;
		case JFConnectionTransitionResetting:			retObj = @"Resetting";			break;
		default:
		{
			retObj = [super debugStringForTransition:transition];
			break;
		}
	}
	return retObj;
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
