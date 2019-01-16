//
//	The MIT License (MIT)
//
//	Copyright © 2015-2019 Jacopo Filié
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

#import "JFUtilities.h"

#import "JFPreprocessorMacros.h"
#import "JFShortcuts.h"
#import "JFStrings.h"
#import "JFVersion.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFUtilities_Tests : XCTestCase

// =================================================================================================
// MARK: Methods - Tests management
// =================================================================================================

- (void)testConstants;
- (void)testFunctions;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFUtilities_Tests

// =================================================================================================
// MARK: Methods - Tests management
// =================================================================================================

- (void)testConstants
{
	// JFAnimationDuration
	NSTimeInterval value = JFAnimationDuration;
	NSTimeInterval result = 0.25;
	XCTAssert((value == result), @"The 'JFAnimationDuration' value is '%@'; it should be '%@'.", JFStringFromNSTimeInterval(value), JFStringFromNSTimeInterval(result));
}

- (void)testFunctions
{
	// JFAreObjectsEqual
	NSString* string = @"Test1";
	NSString* result = @"Test1";
	XCTAssert(JFAreObjectsEqual(string, result), @"The string value is '%@'; it should be '%@'.", string, result);
	result = @"Test2";
	XCTAssertFalse(JFAreObjectsEqual(string, result), @"The string value is '%@'; it should be '%@'.", string, result);
	result = nil;
	XCTAssertFalse(JFAreObjectsEqual(string, result), @"The string value is '%@'; it should be '%@'.", string, result);
	string = nil;
	XCTAssert(JFAreObjectsEqual(string, result), @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFDegreesFromRadians
	JFDegrees degrees = 90;
	JFRadians radians = M_PI / 2;
	JFDegrees converted = JFDegreesFromRadians(radians);
	XCTAssert((converted == degrees), @"The converted radians value is '%@'; it should be '%@'.", JFStringFromDouble(converted), JFStringFromDouble(degrees));
	
	// JFRadiansFromDegrees
	JFRadians reconverted = JFRadiansFromDegrees(converted);
	XCTAssert((reconverted == radians), @"The reconverted radians value is '%@'; it should be '%@'.", JFStringFromDouble(reconverted), JFStringFromDouble(radians));
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
