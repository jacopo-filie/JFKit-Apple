//
//	The MIT License (MIT)
//
//	Copyright © 2019 Jacopo Filié
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

#import "JFDeallocNotifier.h"
#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFDeallocNotifier_Tests : XCTestCase

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testAttachToMultipleObject;
- (void)testAttachToObject;
- (void)testDetachFromMultipleObject;
- (void)testDetachFromObject;
- (void)testInitWithBlock;
- (void)testMultipleAttachToObject;
- (void)testMultipleDetachFromObject;
- (void)testNotifierWithBlock;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFDeallocNotifier_Tests

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testAttachToMultipleObject
{
	XCTestExpectation* expectation = [self expectationWithDescription:MethodName];
	
	@autoreleasepool
	{
		NSObject* object1 = [NSObject new];
		NSObject* object2 = [NSObject new];
		NSObject* object3 = [NSObject new];
		
		JFDeallocNotifier* notifier = [JFDeallocNotifier notifierWithBlock:^{
			[expectation fulfill];
		}];
		
		[notifier attachToObject:object1];
		[notifier attachToObject:object2];
		[notifier attachToObject:object3];
	}
	
	[self waitForExpectationsWithTimeout:1 handler:^(NSError* __nullable error) {
		XCTAssertNil(error, @"Error: %@", error);
	}];
}

- (void)testAttachToObject
{
	XCTestExpectation* expectation = [self expectationWithDescription:MethodName];
	
	@autoreleasepool
	{
		NSObject* object = [NSObject new];
		
		JFDeallocNotifier* notifier = [JFDeallocNotifier notifierWithBlock:^{
			[expectation fulfill];
		}];
		
		[notifier attachToObject:object];
	}
	
	[self waitForExpectationsWithTimeout:1 handler:^(NSError* __nullable error) {
		XCTAssertNil(error, @"Error: %@", error);
	}];
}

- (void)testDetachFromMultipleObject
{
	XCTestExpectation* expectation = [self expectationWithDescription:MethodName];
	NSObject* object1 = [NSObject new];
	NSObject* object2 = [NSObject new];
	NSObject* object3 = [NSObject new];
	
	@autoreleasepool
	{
		JFDeallocNotifier* notifier = [JFDeallocNotifier notifierWithBlock:^{
			[expectation fulfill];
		}];
		
		[notifier attachToObject:object1];
		[notifier attachToObject:object2];
		[notifier attachToObject:object3];
		
		[notifier detachFromObject:object1];
		[notifier detachFromObject:object2];
		[notifier detachFromObject:object3];
	}
	
	[self waitForExpectationsWithTimeout:1 handler:^(NSError* __nullable error) {
		XCTAssertNil(error, @"Error: %@", error);
	}];
}

- (void)testDetachFromObject
{
	XCTestExpectation* expectation = [self expectationWithDescription:MethodName];
	NSObject* object = [NSObject new];
	
	@autoreleasepool
	{
		JFDeallocNotifier* notifier = [JFDeallocNotifier notifierWithBlock:^{
			[expectation fulfill];
		}];
		
		[notifier attachToObject:object];
		
		[notifier detachFromObject:object];
	}
	
	[self waitForExpectationsWithTimeout:1 handler:^(NSError* __nullable error) {
		XCTAssertNil(error, @"Error: %@", error);
	}];
}

- (void)testInitWithBlock
{
	JFBlock block = ^{};
	JFDeallocNotifier* notifier = [[JFDeallocNotifier alloc] initWithBlock:block];
	XCTAssertNotNil(notifier);
	XCTAssertEqual(notifier.block, block);
}

- (void)testMultipleAttachToObject
{
	XCTestExpectation* expectation = [self expectationWithDescription:MethodName];
	
	@autoreleasepool
	{
		NSObject* object = [NSObject new];
		
		JFDeallocNotifier* notifier = [JFDeallocNotifier notifierWithBlock:^{
			[expectation fulfill];
		}];
		
		[notifier attachToObject:object];
		[notifier attachToObject:object];
		[notifier attachToObject:object];
	}
	
	[self waitForExpectationsWithTimeout:1 handler:^(NSError* __nullable error) {
		XCTAssertNil(error, @"Error: %@", error);
	}];
}

- (void)testMultipleDetachFromObject
{
	XCTestExpectation* expectation = [self expectationWithDescription:MethodName];
	NSObject* object = [NSObject new];
	
	@autoreleasepool
	{
		JFDeallocNotifier* notifier = [JFDeallocNotifier notifierWithBlock:^{
			[expectation fulfill];
		}];
		
		[notifier attachToObject:object];
		
		[notifier detachFromObject:object];
		[notifier detachFromObject:object];
		[notifier detachFromObject:object];
	}
	
	[self waitForExpectationsWithTimeout:1 handler:^(NSError* __nullable error) {
		XCTAssertNil(error, @"Error: %@", error);
	}];
}

- (void)testNotifierWithBlock
{
	JFBlock block = ^{};
	JFDeallocNotifier* notifier = [JFDeallocNotifier notifierWithBlock:block];
	XCTAssertNotNil(notifier);
	XCTAssertEqual(notifier.block, block);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
