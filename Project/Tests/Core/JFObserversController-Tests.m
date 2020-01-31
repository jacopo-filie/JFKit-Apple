//
//	The MIT License (MIT)
//
//	Copyright © 2017-2020 Jacopo Filié
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

#import "JFObserversController.h"

#import "JFShortcuts.h"
#import "JFStrings.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFObserversController_Tests : XCTestCase

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (strong, nonatomic, nullable)	JFObserversController<NSObject*>*	observerController;
@property (strong, nonatomic, nullable)	NSArray<NSObject*>*					observers;

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testAsynchronousNotifications;
- (void)testSynchronousNotifications;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFObserversController_Tests

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize observerController = _observerController;
@synthesize observers = _observers;

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)setUp
{
	[super setUp];
	
	JFObserversController<NSObject*>* controller = [[JFObserversController<NSObject*> alloc] init];
	self.observerController = controller;
	
	NSUInteger count = 3;
	NSMutableArray<NSObject*>* observers = [[NSMutableArray<NSObject*> alloc] initWithCapacity:count];
	for(NSUInteger i = 1; i <= count; i++)
	{
		NSObject* observer = [NSObject new];
		[observers addObject:observer];
		[controller addObserver:observer];
	}
	
	self.observers = observers;
}

- (void)tearDown
{
	self.observerController = nil;
	self.observers = nil;
	
	[super tearDown];
}

- (void)testAsynchronousNotifications
{
	XCTestExpectation* expectation = [self expectationWithDescription:MethodName];
	
	NSUInteger __block counter = self.observers.count;
	
	[self.observerController notifyObservers:^(NSObject* observer) {
		if(--counter == 0)
			[expectation fulfill];
	}];
	
	XCWaitCompletionHandler handler = ^(NSError* error)
	{
		XCTAssertNil(error, @"Error: %@", error);
		XCTAssert((counter == 0), @"Counter is '%@'; it should be '0'.", JFStringFromNSUInteger(counter));
	};
	
	[self waitForExpectationsWithTimeout:1 handler:handler];
}

- (void)testSynchronousNotifications
{
	NSUInteger __block counter = self.observers.count;
	
	[self.observerController notifyObservers:^(NSObject* observer) {
		counter--;
	} async:NO];
	
	XCTAssert((counter == 0), @"Counter is '%@'; it should be '0'.", JFStringFromNSUInteger(counter));
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
