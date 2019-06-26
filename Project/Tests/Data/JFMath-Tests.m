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

#import "JFMath.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFMath_Tests : XCTestCase

// =================================================================================================
// MARK: Tests
// =================================================================================================

- (void)testFloatingPointComparison;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFMath_Tests

// =================================================================================================
// MARK: Tests
// =================================================================================================

- (void)testFloatingPointComparison
{
	XCTAssertEqual(JFCompareFloatValues(0.00, 0.00, 0), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(1.00, 1.00, 0), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(2.50, 2.50, 0), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(2.40, 2.50, 0), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(2.50, 2.40, 0), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(2.54, 2.55, 1), NSOrderedSame);
	
	XCTAssertEqual(JFCompareFloatValues(2.40, 2.50, 1), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(2.45, 2.55, 1), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(2.54, 2.55, 2), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(2.54, 3.55, 1), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(-3.54, 2.55, 0), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(-3.54, 2.55, 1), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(-3.54, 2.55, 2), NSOrderedAscending);
	
	XCTAssertEqual(JFCompareFloatValues(2.50, 2.40, 1), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(2.55, 2.45, 1), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(2.55, 2.45, 2), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(3.55, 2.45, 2), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(2.55, -3.45, 0), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(2.55, -3.45, 1), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(2.55, -3.45, 2), NSOrderedDescending);
	
	XCTAssertEqual(JFCompareFloatValues(100.0000000001, 100.0000000001, 9), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(100.0000000001, 100.0000000002, 9), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(100.0000000001, 100.0000000009, 9), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(100.1000000000, 100.0000000009, 1), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(100.1000000001, 100.0000000009, 1), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(100.1000000000, 100.0000000009, 5), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(100.1000000001, 100.0000000009, NSDecimalNoScale), NSOrderedDescending);
	XCTAssertEqual(JFCompareFloatValues(100.0000000000, 100.0000000009, NSDecimalNoScale), NSOrderedAscending);
	
	XCTAssertEqual(JFCompareFloatValues(-100.0000000001, -100.0000000001, 9), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(-100.0000000001, -100.0000000002, 9), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(-100.0000000001, -100.0000000009, 9), NSOrderedSame);
	XCTAssertEqual(JFCompareFloatValues(-100.1000000000, -100.0000000009, 1), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(-100.1000000001, -100.0000000009, 1), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(-100.1000000000, -100.0000000009, 5), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(-100.1000000001, -100.0000000009, NSDecimalNoScale), NSOrderedAscending);
	XCTAssertEqual(JFCompareFloatValues(-100.0000000000, -100.0000000009, NSDecimalNoScale), NSOrderedDescending);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
