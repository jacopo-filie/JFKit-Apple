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



#import <XCTest/XCTest.h>

#import "JFConnectionMachine.h"
#import "JFShortcuts.h"
#import "JFTypes.h"



#pragma mark - Constants

static	NSTimeInterval	ExpectationTimeOut	= 2.5;



#pragma mark



@interface JFConnectionMachine_Tests : XCTestCase <JFStateMachineDelegate>

#pragma mark Properties

// Expectations
@property (strong, nonatomic)	XCTestExpectation*		expectation;

// Flags
@property (assign, nonatomic)	BOOL	shouldFail;

// Relationships
@property (strong, nonatomic)	JFConnectionMachine*	machine;

@end



#pragma mark



@implementation JFConnectionMachine_Tests

#pragma mark Properties

// Expectations
@synthesize expectation	= _expectation;

// Flags
@synthesize shouldFail	= _shouldFail;

// Relationships
@synthesize machine	= _machine;


#pragma mark Tests

- (void)testConnectFailure
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateReady delegate:self];
	self.shouldFail = YES;
	
	[self.machine connect];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateLost;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testConnectSuccess
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateReady delegate:self];
	self.shouldFail = NO;
	
	[self.machine connect];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateConnected;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testLoseConnectionFailure
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateConnected delegate:self];
	self.shouldFail = YES;
	
	[self.machine loseConnection];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateConnected;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testLoseConnectionSuccess
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateConnected delegate:self];
	self.shouldFail = NO;
	
	[self.machine loseConnection];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateLost;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testDisconnectFailure
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateConnected delegate:self];
	self.shouldFail = YES;
	
	[self.machine disconnect];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateDirty;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testDisconnectSuccess
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateConnected delegate:self];
	self.shouldFail = NO;
	
	[self.machine disconnect];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateDisconnected;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testReconnectFailure
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateLost delegate:self];
	self.shouldFail = YES;
	
	[self.machine reconnect];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateLost;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testReconnectSuccess
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateLost delegate:self];
	self.shouldFail = NO;
	
	[self.machine reconnect];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateConnected;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testResetFailure
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateDisconnected delegate:self];
	self.shouldFail = YES;
	
	[self.machine reset];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateDirty;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}

- (void)testResetSuccess
{
	self.expectation = [self expectationWithDescription:MethodName];
	self.machine = [[JFConnectionMachine alloc] initWithState:JFConnectionStateDisconnected delegate:self];
	self.shouldFail = NO;
	
	[self.machine reset];
	
	JFBlockWithError handler = ^(NSError* error)
	{
		if(error)
		{
			NSLog(@"Timeout error: %@", error);
			return;
		}
		
		JFConnectionState state = self.machine.currentState;
		JFConnectionState result = JFConnectionStateReady;
		XCTAssert((state == result), @"The current state of the connection machine is '%@'; it should be '%@'.", [self.machine debugStringForState:state], [self.machine debugStringForState:result]);
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}


#pragma mark Protocol implementation (JFStateMachineDelegate)

- (void)stateMachine:(JFStateMachine*)sender didPerformTransition:(JFStateTransition)transition
{
	[self.expectation fulfill];
}

- (void)stateMachine:(JFStateMachine*)sender performTransition:(JFStateTransition)transition
{
	[MainOperationQueue addOperationWithBlock:^{
		[sender onTransitionCompleted:!self.shouldFail error:nil];
	}];
}

- (void)stateMachine:(JFStateMachine*)sender willPerformTransition:(JFStateTransition)transition
{}

@end
