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

#import	"JFPreprocessorMacros.h"
#import "JFShortcuts.h"
#import "JFString.h"
#import "JFUtilities.h"



@interface JFUtilities_Tests : XCTestCase

@end



#pragma mark



@implementation JFUtilities_Tests

#pragma mark Tests

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
	
	// JFCheckSystemVersion
	string = JFSystemVersion();
	XCTAssert(JFCheckSystemVersion(string, JFRelationEqual), @"Failed to validate the current system version; the tested value is '%@'.", string);
	
	// JFSystemVersion
#if JF_TARGET_OS_OSX
	SInt32 majorVersion, minorVersion, patchVersion;
	Gestalt(gestaltSystemVersionMajor, &majorVersion);
	Gestalt(gestaltSystemVersionMinor, &minorVersion);
	Gestalt(gestaltSystemVersionBugFix, &patchVersion);
	result = [NSString stringWithFormat:@"%@.%@.%@", JFStringFromSInt32(majorVersion), JFStringFromSInt32(minorVersion), JFStringFromSInt32(patchVersion)];
#else
	result = SystemVersion;
	while([[result componentsSeparatedByString:@"."] count] < 3)
		result = [result stringByAppendingString:@".0"];
#endif
	XCTAssert(JFAreObjectsEqual(string, result), @"The string value is '%@'; it should be '%@'.", string, result);
}

@end
