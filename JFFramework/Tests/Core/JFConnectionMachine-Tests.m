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
@property (strong, nonatomic)	XCTestExpectation*	expectation;

// Flags
@property (assign, nonatomic)	BOOL	shouldFail;

// Relationships
@property (strong, nonatomic)	JFConnectionMachine*	machine;


#pragma mark Methods

// Common
- (void)	setUpWithDescription:(NSString*)description initialState:(JFConnectionState)state failureExpected:(BOOL)shouldFail;
- (void)	verifyResult:(JFConnectionState)expectedResult;
- (void)	waitExpectingResult:(JFConnectionState)expectedResult;

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


#pragma mark Common

- (void)setUpWithDescription:(NSString*)description initialState:(JFConnectionState)state failureExpected:(BOOL)shouldFail
{
	self.expectation = [self expectationWithDescription:description];
	self.machine = [[JFConnectionMachine alloc] initWithState:state delegate:self];
	self.shouldFail = shouldFail;
}

- (void)tearDown
{
	[super tearDown];
	self.expectation = nil;
	self.machine = nil;
	self.shouldFail = NO;
}

- (void)verifyResult:(JFConnectionState)expectedResult
{
	JFConnectionMachine* machine = self.machine;
	JFConnectionState state = machine.currentState;
	XCTAssert((state == expectedResult), @"The current state of the connection machine is '%@'; it should be '%@'.", [machine debugStringForState:state], [machine debugStringForState:expectedResult]);
}

- (void)waitExpectingResult:(JFConnectionState)expectedResult
{
	JFBlockWithError handler = ^(NSError* error)
	{
		XCTAssertNil(error, @"Error: %@", error);
		if(!error)
			[self verifyResult:expectedResult];
	};
	
	[self waitForExpectationsWithTimeout:ExpectationTimeOut handler:handler];
}


#pragma mark Tests

- (void)testConnectFailure
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateReady failureExpected:YES];
	[self.machine connect];
	[self waitExpectingResult:JFConnectionStateLost];
}

- (void)testConnectSuccess
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateReady failureExpected:NO];
	[self.machine connect];
	[self waitExpectingResult:JFConnectionStateConnected];
}

- (void)testDisconnectFromLostFailure
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateLost failureExpected:YES];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testDisconnectFromLostSuccess
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateLost failureExpected:NO];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDisconnected];
}

- (void)testDisconnectFromConnectedFailure
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateConnected failureExpected:YES];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testDisconnectFromConnectedSuccess
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateConnected failureExpected:NO];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDisconnected];
}

- (void)testLoseConnectionFailure
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateConnected failureExpected:YES];
	[self.machine loseConnection];
	[self waitExpectingResult:JFConnectionStateLost];
}

- (void)testLoseConnectionSuccess
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateConnected failureExpected:NO];
	[self.machine loseConnection];
	[self waitExpectingResult:JFConnectionStateLost];
}

- (void)testReconnectFailure
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateLost failureExpected:YES];
	[self.machine reconnect];
	[self waitExpectingResult:JFConnectionStateLost];
}

- (void)testReconnectSuccess
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateLost failureExpected:NO];
	[self.machine reconnect];
	[self waitExpectingResult:JFConnectionStateConnected];
}

- (void)testResetFromDirtyFailure
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateDirty failureExpected:YES];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testResetFromDirtySuccess
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateDirty failureExpected:NO];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateReady];
}

- (void)testResetFromDisconnectedFailure
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateDisconnected failureExpected:YES];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testResetFromDisconnectedSuccess
{
	[self setUpWithDescription:MethodName initialState:JFConnectionStateDisconnected failureExpected:NO];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateReady];
}


#pragma mark Protocol implementation (JFStateMachineDelegate)

- (void)stateMachine:(JFStateMachine*)sender didPerformTransition:(JFStateTransition)transition
{
	[self.expectation fulfill];
}

- (void)stateMachine:(JFStateMachine*)sender performTransition:(JFStateTransition)transition completion:(JFSimpleCompletionBlock __nonnull)completion
{
	[MainOperationQueue addOperationWithBlock:^{
		completion(!self.shouldFail, nil);
	}];
}

@end
