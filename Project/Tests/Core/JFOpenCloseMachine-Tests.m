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



#import <XCTest/XCTest.h>

#import "JFOpenCloseMachine.h"
#import "JFShortcuts.h"
#import "JFTypes.h"



#pragma mark - Constants

static	NSTimeInterval	ExpectationTimeOut	= 2.5;



#pragma mark



@interface JFOpenCloseMachine_Tests : XCTestCase <JFStateMachineDelegate>

#pragma mark Properties

// Expectations
@property (strong, nonatomic)	XCTestExpectation*	expectation;

// Flags
@property (assign, nonatomic)	BOOL	shouldFail;

// Relationships
@property (strong, nonatomic)	JFOpenCloseMachine*	machine;


#pragma mark Methods

// Common
- (void)	setUpWithDescription:(NSString*)description initialState:(JFOpenCloseState)state failureExpected:(BOOL)shouldFail;
- (void)	verifyResult:(JFOpenCloseState)expectedResult;
- (void)	waitExpectingResult:(JFOpenCloseState)expectedResult;

@end



#pragma mark



@implementation JFOpenCloseMachine_Tests

#pragma mark Properties

// Expectations
@synthesize expectation	= _expectation;

// Flags
@synthesize shouldFail	= _shouldFail;

// Relationships
@synthesize machine	= _machine;


#pragma mark Common

- (void)setUpWithDescription:(NSString*)description initialState:(JFOpenCloseState)state failureExpected:(BOOL)shouldFail
{
	self.expectation = [self expectationWithDescription:description];
	self.machine = [[JFOpenCloseMachine alloc] initWithState:state delegate:self];
	self.shouldFail = shouldFail;
}

- (void)tearDown
{
	[super tearDown];
	self.expectation = nil;
	self.machine = nil;
	self.shouldFail = NO;
}

- (void)verifyResult:(JFOpenCloseState)expectedResult
{
	JFOpenCloseMachine* machine = self.machine;
	JFOpenCloseState state = machine.currentState;
	XCTAssert((state == expectedResult), @"The current state of the open/close machine is '%@'; it should be '%@'.", [machine debugStringForState:state], [machine debugStringForState:expectedResult]);
}

- (void)waitExpectingResult:(JFOpenCloseState)expectedResult
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

- (void)testCloseFailure
{
	[self setUpWithDescription:MethodName initialState:JFOpenCloseStateOpened failureExpected:YES];
	[self.machine close];
	[self waitExpectingResult:JFOpenCloseStateOpened];
}

- (void)testCloseSuccess
{
	[self setUpWithDescription:MethodName initialState:JFOpenCloseStateOpened failureExpected:NO];
	[self.machine close];
	[self waitExpectingResult:JFOpenCloseStateClosed];
}

- (void)testOpenFailure
{
	[self setUpWithDescription:MethodName initialState:JFOpenCloseStateClosed failureExpected:YES];
	[self.machine open];
	[self waitExpectingResult:JFOpenCloseStateClosed];
}

- (void)testOpenSuccess
{
	[self setUpWithDescription:MethodName initialState:JFOpenCloseStateClosed failureExpected:NO];
	[self.machine open];
	[self waitExpectingResult:JFOpenCloseStateOpened];
}


#pragma mark Protocol implementation (JFStateMachineDelegate)

- (void)stateMachine:(JFStateMachine*)sender didPerformTransition:(JFStateTransition)transition context:(id _Nullable)context
{
	[self.expectation fulfill];
}

- (void)stateMachine:(JFStateMachine*)sender performTransition:(JFStateTransition)transition context:(id _Nullable)context completion:(JFSimpleCompletionBlock __nonnull)completion
{
	[MainOperationQueue addOperationWithBlock:^{
		completion(!self.shouldFail, nil);
	}];
}

@end
