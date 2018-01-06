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

#import <XCTest/XCTest.h>

#import "JFConnectionMachine.h"

#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFConnectionMachine_Tests : XCTestCase <JFStateMachineDelegate>

// =================================================================================================
// MARK: Properties - Tests
// =================================================================================================

@property (strong, nonatomic, nullable)	XCTestExpectation*		expectation;
@property (strong, nonatomic, nullable)	JFConnectionMachine*	machine;
@property (assign, nonatomic)			BOOL					shouldFail;
@property (assign, nonatomic)			BOOL					shouldFulfillOnDidPerform;

// =================================================================================================
// MARK: Methods - Tests management
// =================================================================================================

- (void)setUpWithDescription:(NSString*)description beginningState:(JFConnectionState)state failureExpected:(BOOL)shouldFail;
- (void)testChainedTransitions;
- (void)testConnectFailure;
- (void)testConnectSuccess;
- (void)testDisconnectFromLostFailure;
- (void)testDisconnectFromLostSuccess;
- (void)testDisconnectFromConnectedFailure;
- (void)testDisconnectFromConnectedSuccess;
- (void)testLoseConnectionFailure;
- (void)testLoseConnectionSuccess;
- (void)testReconnectFailure;
- (void)testReconnectSuccess;
- (void)testResetFromDirtyFailure;
- (void)testResetFromDirtySuccess;
- (void)testResetFromDisconnectedFailure;
- (void)testResetFromDisconnectedSuccess;
- (void)verifyResult:(JFConnectionState)expectedResult;
- (void)waitExpectingResult:(JFConnectionState)expectedResult;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFConnectionMachine_Tests

// =================================================================================================
// MARK: Properties - Tests
// =================================================================================================

@synthesize expectation	= _expectation;
@synthesize machine		= _machine;
@synthesize shouldFail	= _shouldFail;

// =================================================================================================
// MARK: Methods - Tests management
// =================================================================================================

- (void)setUpWithDescription:(NSString*)description beginningState:(JFConnectionState)state failureExpected:(BOOL)shouldFail
{
	self.expectation = [self expectationWithDescription:description];
	self.machine = [[JFConnectionMachine alloc] initWithState:state delegate:self];
	self.shouldFail = shouldFail;
	self.shouldFulfillOnDidPerform = YES;
}

- (void)tearDown
{
	self.expectation = nil;
	self.machine = nil;
	self.shouldFail = NO;
	self.shouldFulfillOnDidPerform = YES;

	[super tearDown];
}

- (void)testChainedTransitions
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateReady failureExpected:NO];
	
	self.shouldFulfillOnDidPerform = NO;
	
	JFStateMachineTransition* connectTransition = [[JFStateMachineTransition alloc] initWithTransition:JFConnectionTransitionConnecting context:nil completion:nil];
	
	JFStateMachineTransition* loseConnectionTransition = [[JFStateMachineTransition alloc] initWithTransition:JFConnectionTransitionLosingConnection context:nil completion:nil];
	connectTransition.nextTransitionOnSuccess = loseConnectionTransition;
	
	JFStateMachineTransition* reconnectTransition = [[JFStateMachineTransition alloc] initWithTransition:JFConnectionTransitionReconnecting context:nil completion:nil];
	loseConnectionTransition.nextTransitionOnSuccess = reconnectTransition;
	
	JFStateMachineTransition* disconnectTransition = [[JFStateMachineTransition alloc] initWithTransition:JFConnectionTransitionDisconnecting context:nil completion:nil];
	reconnectTransition.nextTransitionOnSuccess = disconnectTransition;
	
	JFSimpleCompletion* resetCompletion = [JFSimpleCompletion completionWithBlock:^(BOOL succeeded, NSError* __nullable error) {
		[self.expectation fulfill];
	}];
	
	disconnectTransition.nextTransitionOnSuccess = [[JFStateMachineTransition alloc] initWithTransition:JFConnectionTransitionResetting context:nil completion:resetCompletion];
	
	[self.machine perform:connectTransition];
	
	[self waitExpectingResult:JFConnectionStateReady];
}

- (void)testConnectFailure
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateReady failureExpected:YES];
	[self.machine connect];
	[self waitExpectingResult:JFConnectionStateConnectionLost];
}

- (void)testConnectSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateReady failureExpected:NO];
	[self.machine connect];
	[self waitExpectingResult:JFConnectionStateConnected];
}

- (void)testDisconnectFromLostFailure
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnectionLost failureExpected:YES];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testDisconnectFromLostSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnectionLost failureExpected:NO];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDisconnected];
}

- (void)testDisconnectFromConnectedFailure
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnected failureExpected:YES];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testDisconnectFromConnectedSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnected failureExpected:NO];
	[self.machine disconnect];
	[self waitExpectingResult:JFConnectionStateDisconnected];
}

- (void)testLoseConnectionFailure
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnected failureExpected:YES];
	[self.machine loseConnection];
	[self waitExpectingResult:JFConnectionStateConnectionLost];
}

- (void)testLoseConnectionSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnected failureExpected:NO];
	[self.machine loseConnection];
	[self waitExpectingResult:JFConnectionStateConnectionLost];
}

- (void)testReconnectFailure
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnectionLost failureExpected:YES];
	[self.machine reconnect];
	[self waitExpectingResult:JFConnectionStateConnectionLost];
}

- (void)testReconnectSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateConnectionLost failureExpected:NO];
	[self.machine reconnect];
	[self waitExpectingResult:JFConnectionStateConnected];
}

- (void)testResetFromDirtyFailure
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateDirty failureExpected:YES];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testResetFromDirtySuccess
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateDirty failureExpected:NO];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateReady];
}

- (void)testResetFromDisconnectedFailure
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateDisconnected failureExpected:YES];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateDirty];
}

- (void)testResetFromDisconnectedSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFConnectionStateDisconnected failureExpected:NO];
	[self.machine reset];
	[self waitExpectingResult:JFConnectionStateReady];
}

- (void)verifyResult:(JFConnectionState)expectedResult
{
	JFConnectionMachine* machine = self.machine;
	JFConnectionState state = machine.state;
	XCTAssert((state == expectedResult), @"The current state of the connection machine is '%@'; it should be '%@'.", [machine stringFromState:state], [machine stringFromState:expectedResult]);
}

- (void)waitExpectingResult:(JFConnectionState)expectedResult
{
	XCWaitCompletionHandler handler = ^(NSError* error)
	{
		XCTAssertNil(error, @"Error: %@", error);
		[self verifyResult:expectedResult];
	};
	
	[self waitForExpectationsWithTimeout:1 handler:handler];
}

// =================================================================================================
// MARK: Protocols (JFStateMachineDelegate) - State management
// =================================================================================================

- (void)stateMachine:(JFStateMachine*)sender didPerform:(JFStateTransition)transition context:(id __nullable)context
{
	if(self.shouldFulfillOnDidPerform)
		[self.expectation fulfill];
}

- (void)stateMachine:(JFStateMachine*)sender perform:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion*)completion
{
	if(self.shouldFail)
		[completion executeWithError:[NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil] async:YES];
	else
		[completion execute:YES];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
