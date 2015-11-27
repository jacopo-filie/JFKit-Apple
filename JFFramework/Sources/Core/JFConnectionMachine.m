//
//	The MIT License (MIT)
//
//	Copyright (c) 2015 Jacopo Filié
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

#import "JFShortcuts.h"
#import "JFTypes.h"



@interface JFConnectionMachine ()

#pragma mark Properties

// Data
@property (strong, nonatomic)	NSDictionary*	userInfo;

// Flags
@property (assign, nonatomic, getter = isCompletingCommand)	BOOL					completingCommand;
@property (assign, nonatomic, getter = isPerformingCommand)	BOOL					performingCommand;
@property (assign, readwrite)								JFConnectionState		state;
@property (assign, readwrite)								JFConnectionTransition	transition;


#pragma mark Methods

// Commands management
- (BOOL)	performCommandWithTransition:(JFConnectionTransition)transition userInfo:(NSDictionary*)userInfo;

// Events management
- (void)	onCommandCompleted:(BOOL)succeeded transition:(JFConnectionTransition)transition error:(NSError*)error;

// Notifications management
- (void)	notifyDidBeginTransition:(JFConnectionTransition)transition;
- (void)	notifyDidEndTransition:(JFConnectionTransition)transition;
- (void)	notifyDidEnterState:(JFConnectionState)state;
- (void)	notifyDidFailToEnterState:(JFConnectionState)state error:(NSError*)error;
- (void)	notifyDidFailToLeaveState:(JFConnectionState)state error:(NSError*)error;
- (void)	notifyDidLeaveState:(JFConnectionState)state;
- (void)	notifyWillBeginTransition:(JFConnectionTransition)transition;
- (void)	notifyWillEndTransition:(JFConnectionTransition)transition;
- (void)	notifyWillEnterState:(JFConnectionState)state;
- (void)	notifyWillLeaveState:(JFConnectionState)state;

@end



#pragma mark



@implementation JFConnectionMachine

#pragma mark Properties

// Data
@synthesize userInfo	= _userInfo;

// Flags
@synthesize completingCommand	= _completingCommand;
@synthesize performingCommand	= _performingCommand;
@synthesize state				= _state;
@synthesize transition			= _transition;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark Memory management

- (instancetype)init
{
	return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id<JFConnectionMachineDelegate>)delegate
{
	return [self initWithState:JFConnectionStateReady delegate:delegate];
}

- (instancetype)initWithState:(JFConnectionState)state delegate:(id<JFConnectionMachineDelegate>)delegate
{
	self = (delegate ? [super init] : nil);
	if(self)
	{
		// Flags
		_completingCommand	= NO;
		_performingCommand	= NO;
		_state				= state;
		_transition			= JFConnectionTransitionNone;
		
		// Relationships
		_delegate	= delegate;
	}
	return self;
}


#pragma mark Commands management

- (BOOL)connect
{
	return [self connect:nil];
}

- (BOOL)connect:(NSDictionary*)userInfo
{
	return [self performCommandWithTransition:JFConnectionTransitionConnecting userInfo:userInfo];
}

- (BOOL)disconnect
{
	return [self disconnect:nil];
}

- (BOOL)disconnect:(NSDictionary*)userInfo
{
	return [self performCommandWithTransition:JFConnectionTransitionDisconnecting userInfo:userInfo];
}

- (BOOL)performCommandWithTransition:(JFConnectionTransition)transition userInfo:(NSDictionary*)userInfo
{
	JFConnectionState state = self.state;
	JFConnectionState nextState;
	
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		case JFConnectionTransitionReconnecting:	nextState = JFConnectionStateConnected;		break;
		case JFConnectionTransitionDisconnecting:	nextState = JFConnectionStateDisconnected;	break;
		case JFConnectionTransitionResetting:		nextState = JFConnectionStateReady;			break;
			
		default:
			return NO;
	}
	
	@synchronized(self)
	{
		if([self isPerformingCommand] || ![[self class] isTransitionEnabled:transition fromState:state])
			return NO;
		
		self.performingCommand = YES;
	}
	
	self.userInfo = userInfo;
	
	[self notifyWillBeginTransition:transition];
	[self notifyWillLeaveState:state];
	[self notifyWillEnterState:nextState];
	
	JFBlock block = ^(void)
	{
		self.transition = transition;
		[self notifyDidBeginTransition:transition];
		
		id<JFConnectionMachineDelegate> delegate = self.delegate;
		
		switch(transition)
		{
			case JFConnectionTransitionConnecting:		[delegate connectionMachine:self performConnect:userInfo];		break;
			case JFConnectionTransitionDisconnecting:	[delegate connectionMachine:self performDisconnect:userInfo];	break;
			case JFConnectionTransitionReconnecting:	[delegate connectionMachine:self performReconnect:userInfo];	break;
			case JFConnectionTransitionResetting:		[delegate connectionMachine:self performReset:userInfo];		break;
				
			default:
				break;
		}
	};
	
	[MainOperationQueue addOperationWithBlock:block];
	
	return YES;
}

- (BOOL)reconnect
{
	return [self reconnect:nil];
}

- (BOOL)reconnect:(NSDictionary*)userInfo
{
	return [self performCommandWithTransition:JFConnectionTransitionReconnecting userInfo:userInfo];
}

- (BOOL)reset
{
	return [self reset:nil];
}

- (BOOL)reset:(NSDictionary*)userInfo
{
	return [self performCommandWithTransition:JFConnectionTransitionResetting userInfo:userInfo];
}


#pragma mark Events management

- (void)onCommandCompleted:(BOOL)succeeded transition:(JFConnectionTransition)transition error:(NSError*)error
{
	JFConnectionTransition currentTransition = self.transition;
	
	@synchronized(self)
	{
		if(![self isPerformingCommand] || [self isCompletingCommand])
			return;
		
		if(currentTransition != transition)
			return;
		
		self.completingCommand = YES;
	}
	
	JFConnectionState state = self.state;
	JFConnectionState failureState;
	JFConnectionState successState;
	
	switch(transition)
	{
		case JFConnectionTransitionConnecting:
		case JFConnectionTransitionReconnecting:
		{
			failureState = JFConnectionStateLost;
			successState = JFConnectionStateConnected;
			break;
		}
		case JFConnectionTransitionDisconnecting:
		{
			failureState = JFConnectionStateUnknown;
			successState = JFConnectionStateDisconnected;
			break;
		}
		case JFConnectionTransitionResetting:
		{
			failureState = JFConnectionStateUnknown;
			successState = JFConnectionStateReady;
			break;
		}
		default:
			return;
	}
	
	JFConnectionState nextState = successState;
	
	[self notifyWillEndTransition:transition];
	
	BOOL isChangingState = YES;
	
	if(!succeeded)
	{
		if(state == failureState)
		{
			isChangingState = NO;
			[self notifyDidFailToLeaveState:state error:error];
		}
		
		[self notifyDidFailToEnterState:nextState error:error];
		
		nextState = failureState;
		
		if(isChangingState)
			[self notifyWillEnterState:nextState];
	}
	
	self.state = nextState;
	
	if(isChangingState)
	{
		[self notifyDidLeaveState:state];
		[self notifyDidEnterState:nextState];
	}
	
	NSDictionary* userInfo = self.userInfo;
	self.userInfo = nil;
	
	JFBlock block = ^(void)
	{
		self.transition = JFConnectionTransitionNone;
		[self notifyDidEndTransition:transition];
		
		id<JFConnectionMachineDelegate> delegate = self.delegate;
		
		switch(transition)
		{
			case JFConnectionTransitionConnecting:		[delegate connectionMachine:self didConnect:succeeded userInfo:userInfo error:error];		break;
			case JFConnectionTransitionDisconnecting:	[delegate connectionMachine:self didDisconnect:succeeded userInfo:userInfo error:error];	break;
			case JFConnectionTransitionReconnecting:	[delegate connectionMachine:self didReconnect:succeeded userInfo:userInfo error:error];		break;
			case JFConnectionTransitionResetting:		[delegate connectionMachine:self didReset:succeeded userInfo:userInfo error:error];			break;
				
			default:
				break;
		}
	};
	
	[MainOperationQueue addOperationWithBlock:block];
	
	@synchronized(self)
	{
		self.completingCommand = NO;
		self.performingCommand = NO;
	}
}

- (void)onConnectCompleted:(BOOL)succeeded error:(NSError*)error
{
	[self onCommandCompleted:succeeded transition:JFConnectionTransitionConnecting error:error];
}

- (void)onConnectionLost
{
	JFConnectionState currentState = self.state;
	JFConnectionState nextState = JFConnectionStateLost;
	
	@synchronized(self)
	{
		if([self isPerformingCommand])
			return;
		
		if(currentState != JFConnectionStateConnected)
			return;
		
		self.performingCommand = YES;
	}
	
	[self notifyWillLeaveState:currentState];
	[self notifyWillEnterState:nextState];
	
	self.state = nextState;
	
	[self notifyDidLeaveState:currentState];
	[self notifyDidEnterState:nextState];
	
	@synchronized(self)
	{
		self.performingCommand = NO;
	}
}

- (void)onDisconnectCompleted:(BOOL)succeeded error:(NSError*)error
{
	[self onCommandCompleted:succeeded transition:JFConnectionTransitionDisconnecting error:error];
}

- (void)onReconnectCompleted:(BOOL)succeeded error:(NSError*)error
{
	[self onCommandCompleted:succeeded transition:JFConnectionTransitionReconnecting error:error];
}

- (void)onResetCompleted:(BOOL)succeeded error:(NSError*)error
{
	[self onCommandCompleted:succeeded transition:JFConnectionTransitionResetting error:error];
}


#pragma mark Notifications management

- (void)notifyDidBeginTransition:(JFConnectionTransition)transition
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:didBeginTransition:)])
		[delegate connectionMachine:self didBeginTransition:transition];
}

- (void)notifyDidEndTransition:(JFConnectionTransition)transition
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:didEndTransition:)])
		[delegate connectionMachine:self didEndTransition:transition];
}

- (void)notifyDidEnterState:(JFConnectionState)state
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:didEnterState:)])
		[delegate connectionMachine:self didEnterState:state];
}

- (void)notifyDidFailToEnterState:(JFConnectionState)state error:(NSError*)error
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:didFailToEnterState:error:)])
		[delegate connectionMachine:self didFailToEnterState:state error:error];
}

- (void)notifyDidFailToLeaveState:(JFConnectionState)state error:(NSError*)error
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:didFailToLeaveState:error:)])
		[delegate connectionMachine:self didFailToLeaveState:state error:error];
}

- (void)notifyDidLeaveState:(JFConnectionState)state
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:didLeaveState:)])
		[delegate connectionMachine:self didLeaveState:state];
}

- (void)notifyWillBeginTransition:(JFConnectionTransition)transition
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:willBeginTransition:)])
		[delegate connectionMachine:self willBeginTransition:transition];
}

- (void)notifyWillEndTransition:(JFConnectionTransition)transition
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:willEndTransition:)])
		[delegate connectionMachine:self willEndTransition:transition];
}

- (void)notifyWillEnterState:(JFConnectionState)state
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:willEnterState:)])
		[delegate connectionMachine:self willEnterState:state];
}

- (void)notifyWillLeaveState:(JFConnectionState)state
{
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(connectionMachine:willLeaveState:)])
		[delegate connectionMachine:self willLeaveState:state];
}


#pragma mark Utilities management

+ (NSString*)debugStringFromState:(JFConnectionState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFConnectionStateConnected:	retObj = @"Connected";		break;
		case JFConnectionStateDisconnected:	retObj = @"Disconnected";	break;
		case JFConnectionStateLost:			retObj = @"Lost";			break;
		case JFConnectionStateReady:		retObj = @"Ready";			break;
		case JFConnectionStateUnknown:		retObj = @"Unknown";		break;
			
		default:
			break;
	}
	return retObj;
}

+ (NSString*)debugStringFromTransition:(JFConnectionTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFConnectionTransitionConnecting:		retObj = @"Connecting";		break;
		case JFConnectionTransitionDisconnecting:	retObj = @"Disconnecting";	break;
		case JFConnectionTransitionNone:			retObj = @"None";			break;
		case JFConnectionTransitionReconnecting:	retObj = @"Reconnecting";	break;
		case JFConnectionTransitionResetting:		retObj = @"Resetting";		break;
			
		default:
			break;
	}
	return retObj;
}

+ (BOOL)isTransitionEnabled:(JFConnectionTransition)transition fromState:(JFConnectionState)state
{
	if(transition == JFConnectionTransitionNone)
		return NO;
	
	BOOL connecting		= NO;
	BOOL disconnecting	= NO;
	BOOL reconnecting	= NO;
	BOOL resetting		= NO;
	
	switch(transition)
	{
		case JFConnectionTransitionConnecting:		connecting		= YES;	break;
		case JFConnectionTransitionDisconnecting:	disconnecting	= YES;	break;
		case JFConnectionTransitionReconnecting:	reconnecting	= YES;	break;
		case JFConnectionTransitionResetting:		resetting		= YES;	break;
			
		default:
			break;
	}
	
	BOOL retVal = NO;
	switch(state)
	{
		case JFConnectionStateConnected:	retVal = disconnecting;						break;
		case JFConnectionStateDisconnected:	retVal = resetting;							break;
		case JFConnectionStateLost:			retVal = (disconnecting || reconnecting);	break;
		case JFConnectionStateReady:		retVal = (connecting || resetting);			break;
		case JFConnectionStateUnknown:		retVal = resetting;							break;
			
		default:
			break;
	}
	return retVal;
}

@end
