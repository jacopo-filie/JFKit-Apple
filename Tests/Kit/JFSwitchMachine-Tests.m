//
//	The MIT License (MIT)
//
//	Copyright © 2016-2024 Jacopo Filié
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

#import <XCTest/XCTest.h>

#import "JFSwitchMachine.h"

#import "JFShortcuts.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFSwitchMachine_Tests : XCTestCase <JFStateMachineDelegate>

// =================================================================================================
// MARK: Properties - Tests
// =================================================================================================

@property (strong, nonatomic, nullable)	XCTestExpectation*	expectation;
@property (strong, nonatomic, nullable)	JFSwitchMachine*	machine;
@property (assign, nonatomic)			BOOL				shouldFail;
@property (assign, nonatomic)			BOOL				shouldFullfillOnDidPerform;

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)setUpWithDescription:(NSString*)description beginningState:(JFSwitchState)state failureExpected:(BOOL)shouldFail;
- (void)testChainedTransitions;
- (void)testCloseFailure;
- (void)testCloseSuccess;
- (void)testOpenFailure;
- (void)testOpenSuccess;
- (void)verifyResult:(JFSwitchState)expectedResult;
- (void)waitExpectingResult:(JFSwitchState)expectedResult;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFSwitchMachine_Tests

// =================================================================================================
// MARK: Properties - Tests
// =================================================================================================

@synthesize expectation = _expectation;
@synthesize machine = _machine;
@synthesize shouldFail = _shouldFail;
@synthesize shouldFullfillOnDidPerform = _shouldFullfillOnDidPerform;

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)setUpWithDescription:(NSString*)description beginningState:(JFSwitchState)state failureExpected:(BOOL)shouldFail
{
	self.expectation = [self expectationWithDescription:description];
	self.machine = [[JFSwitchMachine alloc] initWithState:state delegate:self];
	self.shouldFail = shouldFail;
	self.shouldFullfillOnDidPerform = YES;
}

- (void)tearDown
{
	self.expectation = nil;
	self.machine = nil;
	self.shouldFail = NO;
	self.shouldFullfillOnDidPerform = YES;
	
	[super tearDown];
}

- (void)testChainedTransitions
{
	[self setUpWithDescription:MethodName beginningState:JFSwitchStateClosed failureExpected:NO];
	
	self.shouldFullfillOnDidPerform = NO;
	
	JFStateMachineTransition* openTransition = [[JFStateMachineTransition alloc] initWithTransition:JFSwitchTransitionOpening context:nil closure:nil];
	
	openTransition.nextTransitionOnSuccess = [[JFStateMachineTransition alloc] initWithTransition:JFSwitchTransitionClosing context:nil closure:[JFFailableClosure newWithBlock:^(BOOL succeeded, NSError* _Nullable error) {
		[self.expectation fulfill];
	}]];
	
	[self.machine perform:openTransition];
	
	[self waitExpectingResult:JFSwitchStateClosed];
}

- (void)testCloseFailure
{
	[self setUpWithDescription:MethodName beginningState:JFSwitchStateOpen failureExpected:YES];
	[self.machine close];
	[self waitExpectingResult:JFSwitchStateOpen];
}

- (void)testCloseSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFSwitchStateOpen failureExpected:NO];
	[self.machine close];
	[self waitExpectingResult:JFSwitchStateClosed];
}

- (void)testOpenFailure
{
	[self setUpWithDescription:MethodName beginningState:JFSwitchStateClosed failureExpected:YES];
	[self.machine open];
	[self waitExpectingResult:JFSwitchStateClosed];
}

- (void)testOpenSuccess
{
	[self setUpWithDescription:MethodName beginningState:JFSwitchStateClosed failureExpected:NO];
	[self.machine open];
	[self waitExpectingResult:JFSwitchStateOpen];
}

- (void)verifyResult:(JFSwitchState)expectedResult
{
	JFSwitchMachine* machine = self.machine;
	JFSwitchState state = machine.state;
	XCTAssert((state == expectedResult), @"The current state of the open/close machine is '%@'; it should be '%@'.", [machine stringFromState:state], [machine stringFromState:expectedResult]);
}

- (void)waitExpectingResult:(JFSwitchState)expectedResult
{
	[self waitForExpectationsWithTimeout:1 handler:^(NSError* error) {
		XCTAssertNil(error, @"Error: %@", error);
		if(!error)
			[self verifyResult:expectedResult];
	}];
}

// =================================================================================================
// MARK: Methods (JFStateMachineDelegate) - Execution
// =================================================================================================

- (void)stateMachine:(JFStateMachine*)sender didPerform:(JFStateTransition)transition context:(id _Nullable)context
{
	if(self.shouldFullfillOnDidPerform)
		[self.expectation fulfill];
}

- (void)stateMachine:(JFStateMachine*)sender perform:(JFStateTransition)transition context:(id _Nullable)context closure:(JFFailableClosure*)closure
{
	if(self.shouldFail)
		[closure executeWithError:[NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil] async:YES];
	else
		[closure executeAsync:YES];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
