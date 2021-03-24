//
//	The MIT License (MIT)
//
//	Copyright © 2019-2021 Jacopo Filié
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

#import "JFObjectIdentifier_Project.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFObjectIdentifier_Tests : XCTestCase

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testCurrentClearID;
- (void)testCurrentGetID;
- (void)testCurrentResetID;
- (void)testLegacyClearID;
- (void)testLegacyGetID;
- (void)testLegacyResetID;
- (void)testSharedClearID;
- (void)testSharedGetID;
- (void)testSharedResetID;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (JFObjectIdentifier* _Nullable)newCurrentIdentifier API_AVAILABLE(ios(8.0), macos(10.8));
- (JFObjectIdentifier*)newLegacyIdentifier;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFObjectIdentifier_Tests

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testCurrentClearID
{
	if(@available(macOS 10.8, *))
	{
		JFObjectIdentifier* identifier = [self newCurrentIdentifier];
		NSObject* object = [NSObject new];
		NSUInteger objectID = [identifier getID:object];
		[identifier clearID:object];
		XCTAssertNotEqual(objectID, [identifier getID:object]);
	}
}

- (void)testCurrentGetID
{
	if(@available(macOS 10.8, *))
	{
		JFObjectIdentifier* identifier = [self newCurrentIdentifier];
		NSObject* object = [NSObject new];
		NSUInteger objectID = [identifier getID:object];
		XCTAssertEqual(objectID, [identifier getID:object]);
	}
}

- (void)testCurrentResetID
{
	if(@available(macOS 10.8, *))
	{
		JFObjectIdentifier* identifier = [self newCurrentIdentifier];
		NSObject* object = [NSObject new];
		NSUInteger objectID = [identifier getID:object];
		[identifier resetID:objectID];
		XCTAssertNotEqual(objectID, [identifier getID:object]);
	}
}

- (void)testLegacyCleanRegistry
{
	JFObjectIdentifier* identifier = [self newLegacyIdentifier];
	
	NSUInteger count = 10;
	NSMutableArray<NSObject*>* objects = [NSMutableArray<NSObject*> arrayWithCapacity:count];
	NSMutableArray<NSNumber*>* objectIDs = [NSMutableArray<NSNumber*> arrayWithCapacity:count];
	
	@autoreleasepool
	{
		for(NSUInteger i = 0; i < count; i++)
		{
			NSObject* object = [NSObject new];
			[objects addObject:object];
			[objectIDs addObject:@([identifier getID:object])];
		}
		
		for(NSUInteger i = 0; i < count; i++)
			XCTAssertEqualObjects([objectIDs objectAtIndex:i], @([identifier getID:[objects objectAtIndex:i]]));
		
		XCTAssertEqual(count, identifier.count);
		
		count /= 2;
		for(NSUInteger i = 0; i < count; i++)
		{
			id object = [objects lastObject];
			[objects removeLastObject];
			[objectIDs removeLastObject];
			[identifier clearID:object];
		}
		
		for(NSUInteger i = 0; i < count; i++)
			XCTAssertEqualObjects([objectIDs objectAtIndex:i], @([identifier getID:[objects objectAtIndex:i]]));
		
		XCTAssertEqual(count, identifier.count);
	}
}

- (void)testLegacyClearID
{
	JFObjectIdentifier* identifier = [self newLegacyIdentifier];
	NSObject* object = [NSObject new];
	NSUInteger objectID = [identifier getID:object];
	[identifier clearID:object];
	XCTAssertNotEqual(objectID, [identifier getID:object]);
}

- (void)testLegacyGetID
{
	JFObjectIdentifier* identifier = [self newLegacyIdentifier];
	NSObject* object = [NSObject new];
	NSUInteger objectID = [identifier getID:object];
	XCTAssertEqual(objectID, [identifier getID:object]);
}

- (void)testLegacyResetID
{
	JFObjectIdentifier* identifier = [self newLegacyIdentifier];
	NSObject* object = [NSObject new];
	NSUInteger objectID = [identifier getID:object];
	[identifier resetID:objectID];
	XCTAssertNotEqual(objectID, [identifier getID:object]);
}

- (void)testSharedClearID
{
	JFObjectIdentifier* identifier = [JFObjectIdentifier sharedInstance];
	NSObject* object = [NSObject new];
	NSUInteger objectID = [identifier getID:object];
	[identifier clearID:object];
	XCTAssertNotEqual(objectID, [identifier getID:object]);
}

- (void)testSharedGetID
{
	JFObjectIdentifier* identifier = [JFObjectIdentifier sharedInstance];
	NSObject* object = [NSObject new];
	NSUInteger objectID = [identifier getID:object];
	XCTAssertEqual(objectID, [identifier getID:object]);
}

- (void)testSharedResetID
{
	JFObjectIdentifier* identifier = [JFObjectIdentifier sharedInstance];
	NSObject* object = [NSObject new];
	NSUInteger objectID = [identifier getID:object];
	[identifier resetID:objectID];
	XCTAssertNotEqual(objectID, [identifier getID:object]);
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (JFObjectIdentifier* _Nullable)newCurrentIdentifier API_AVAILABLE(ios(8.0), macos(10.8))
{
	return [[JFObjectIdentifier alloc] initWithCurrentImplementation];
}

- (JFObjectIdentifier*)newLegacyIdentifier
{
	return [[JFObjectIdentifier alloc] initWithLegacyImplementation];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
