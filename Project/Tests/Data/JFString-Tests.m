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

#import "JFStrings.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFString_Tests : XCTestCase

// =================================================================================================
// MARK: Methods - Tests management
// =================================================================================================

- (void)testConstants;
- (void)testFunctions;
- (void)testMacros;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFString_Tests

// =================================================================================================
// MARK: Methods - Tests management
// =================================================================================================

- (void)testConstants
{
	// JFEmptyString
	NSString* emptyString = JFEmptyString;
	NSString* emptyStringResult = @"";
	XCTAssert([emptyString isEqualToString:emptyStringResult], @"The 'JFEmptyString' value is '%@'; it should be '%@'.", emptyString, emptyStringResult);
	
	// JFFalseString
	NSString* falseString = JFFalseString;
	NSString* falseStringResult = @"False";
	XCTAssert([falseString isEqualToString:falseStringResult], @"The 'JFFalseString' value is '%@'; it should be '%@'.", falseString, falseStringResult);
	
	// JFNoString
	NSString* noString = JFNoString;
	NSString* noStringResult = @"No";
	XCTAssert([noString isEqualToString:noStringResult], @"The 'JFNoString' value is '%@'; it should be '%@'.", noString, noStringResult);
	
	// JFTrueString
	NSString* trueString = JFTrueString;
	NSString* trueStringResult = @"True";
	XCTAssert([trueString isEqualToString:trueStringResult], @"The 'JFTrueString' value is '%@'; it should be '%@'.", trueString, trueStringResult);
	
	// JFYesString
	NSString* yesString = JFYesString;
	NSString* yesStringResult = @"Yes";
	XCTAssert([yesString isEqualToString:yesStringResult], @"The 'JFYesString' value is '%@'; it should be '%@'.", yesString, yesStringResult);
}

- (void)testFunctions
{
	// JFStringIsEmpty
	XCTAssertFalse(JFStringIsEmpty(nil), @"The string is nil but the function returned 'YES'.");
	XCTAssert(JFStringIsEmpty(@""), @"The string is empty but the function returned 'NO'.");
	XCTAssertFalse(JFStringIsEmpty(@"Test"), @"The string is not empty but the function returned 'YES'.");
	
	// JFStringIsMadeOfCharacters
	NSString* characters = @"Test";
	NSString* string = @"Test";
	XCTAssert(JFStringIsMadeOfCharacters(string, characters), @"The string is '%@'; it should only contain characters '%@'.", string, characters);
	string = @"Tester";
	XCTAssertFalse(JFStringIsMadeOfCharacters(string, characters), @"The string is '%@'; it should nly contain characters '%@'.", string, characters);
	string = @"Tes";
	XCTAssert(JFStringIsMadeOfCharacters(string, characters), @"The string is '%@'; it should nly contain characters '%@'.", string, characters);
	
	// JFStringIsNullOrEmpty
	XCTAssert(JFStringIsNullOrEmpty(nil), @"The string is nil but the function returned 'NO'.");
	XCTAssert(JFStringIsNullOrEmpty(@""), @"The string is empty but the function returned 'NO'.");
	XCTAssertFalse(JFStringIsNullOrEmpty(@"Test"), @"The string is not empty nor nil but the function returned 'YES'.");
	
	// JFStringMakeRandom
	NSUInteger lengths[3] = {0, 1, 10};
	for(NSUInteger i = 0; i < 3; i++)
	{
		NSUInteger length = lengths[i];
		NSString* randomString = JFStringMakeRandom(length);
		NSUInteger currentLength = [randomString length];
		XCTAssert((currentLength == length), @"The random string length is '%@'; it should be '%@'.", JFStringFromNSUInteger(currentLength), JFStringFromNSUInteger(length));
	}
	
	// JFStringMakeRandomWithCharacters
	for(NSUInteger i = 0; i < 3; i++)
	{
		NSUInteger length = lengths[i];
		NSString* randomString = JFStringMakeRandomWithCharacters(length, characters);
		NSUInteger currentLength = [randomString length];
		XCTAssert((currentLength == length), @"The random string length is '%@'; it should be '%@'.", JFStringFromNSUInteger(currentLength), JFStringFromNSUInteger(length));
		XCTAssert(JFStringIsMadeOfCharacters(randomString, characters), @"The random string is '%@'; it should be made only of characters '%@'.", randomString, characters);
	}
	
	// JFStringFromClassOfObject
	string = JFStringFromClassOfObject(nil);
	XCTAssertFalse(string, @"The string value is '%@'; it should be nil.", string);
	string = JFStringFromClassOfObject(self);
	NSString* result = @"JFString_Tests";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromCString
	string = JFStringFromCString(NULL);
	XCTAssertFalse(string, @"The string value is '%@'; it should be nil.", string);
	string = JFStringFromCString("");
	result = @"";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromCString("Test");
	result = @"Test";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromEncodedCString
	string = JFStringFromEncodedCString(NULL, NSUTF8StringEncoding);
	XCTAssertFalse(string, @"The string value is '%@'; it should be nil.", string);
	string = JFStringFromEncodedCString("", NSUTF8StringEncoding);
	result = @"";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromEncodedCString("Test", NSUTF8StringEncoding);
	result = @"Test";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromEncodedCString("àèìòù", NSUTF8StringEncoding);
	result = @"àèìòù";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromEncodedCString("àèìòù", NSASCIIStringEncoding);
	result = @"Ã Ã¨Ã¬Ã²Ã¹";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromEncodedCString("àèìòù", NSISOLatin1StringEncoding);
	result = @"Ã Ã¨Ã¬Ã²Ã¹";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromObject
	string = JFStringFromObject(nil);
	XCTAssertFalse(string, @"The string value is '%@'; it should be nil.", string);
	string = JFStringFromObject(self);
	result = [NSString stringWithFormat:@"<JFString_Tests:%@>", JFStringFromPointer(self)];
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromCPointer
	char* cString = "Test";
	string = JFStringFromCPointer(nil);
	XCTAssertFalse(string, @"The string value is '%@'; it should be nil.", string);
	string = JFStringFromCPointer(cString);
	result = [NSString stringWithFormat:@"%p", cString];
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromPointer
	string = JFStringFromPointer(nil);
	XCTAssertFalse(string, @"The string value is '%@'; it should be nil.", string);
	string = JFStringFromPointer(self);
	result = [NSString stringWithFormat:@"%p", self];
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringToCString
	const char* constCString = JFStringToCString(nil);
	XCTAssertFalse(constCString, @"The string value is '%@'; it should be nil.", string);
	string = JFEmptyString;
	constCString = JFStringToCString(string);
	const char* constCResult = "";
	XCTAssert(strcmp(constCString, constCResult) == 0, @"The string value is '%s'; it should be '%s'.", constCString, constCResult);
	string = @"Test";
	constCString = JFStringToCString(string);
	constCResult = "Test";
	XCTAssert(strcmp(constCString, constCResult) == 0, @"The string value is '%s'; it should be '%s'.", constCString, constCResult);
	
	// JFStringToEncodedCString
	constCString = JFStringToEncodedCString(nil, NSASCIIStringEncoding);
	XCTAssertFalse(constCString, @"The string value is '%@'; it should be nil.", string);
	string = JFEmptyString;
	constCString = JFStringToEncodedCString(string, NSASCIIStringEncoding);
	constCResult = "";
	XCTAssert(strcmp(constCString, constCResult) == 0, @"The string value is '%s'; it should be '%s'.", constCString, constCResult);
	string = @"Test";
	constCString = JFStringToEncodedCString(string, NSASCIIStringEncoding);
	constCResult = "Test";
	XCTAssert(strcmp(constCString, constCResult) == 0, @"The string value is '%s'; it should be '%s'.", constCString, constCResult);
	
	// JFStringFromBOOL
	string = JFStringFromBOOL(YES);
	result = JFYesString;
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromBOOL(NO);
	result = JFNoString;
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromBoolean
	string = JFStringFromBoolean(true);
	result = JFTrueString;
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromBoolean(false);
	result = JFFalseString;
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromCGFloat
	string = JFStringFromCGFloat(0);
	result = @"0";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromCGFloat((CGFloat)0.15);
	result = @"0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromCGFloat((CGFloat)-0.15);
	result = @"-0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromDouble
	string = JFStringFromDouble(0);
	result = @"0";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromDouble(0.15);
	result = @"0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromDouble(-0.15);
	result = @"-0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromFloat
	string = JFStringFromFloat(0);
	result = @"0";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFloat((float)0.15);
	result = @"0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFloat((float)-0.15);
	result = @"-0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromFloat32
	string = JFStringFromFloat32(0);
	result = @"0";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFloat32((Float32)0.15);
	result = @"0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFloat32((Float32)-0.15);
	result = @"-0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromFloat64
	string = JFStringFromFloat64(0);
	result = @"0";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFloat64(0.15);
	result = @"0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFloat64(-0.15);
	result = @"-0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromFormattedDouble
	string = JFStringFromFormattedDouble(0, 2, NO);
	result = @"0";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedDouble(0, 2, YES);
	result = @"0.00";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedDouble(0.15, 3, NO);
	result = @"0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedDouble(0.16, 1, YES);
	result = @"0.2";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedDouble(-0.14, 1, NO);
	result = @"-0.1";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedDouble(-0.14, 3, YES);
	result = @"-0.140";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromFormattedFloat
	string = JFStringFromFormattedFloat(0, 2, NO);
	result = @"0";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedFloat(0, 2, YES);
	result = @"0.00";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedFloat((float)0.15, 3, NO);
	result = @"0.15";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedFloat((float)0.16, 1, YES);
	result = @"0.2";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedFloat((float)-0.14, 1, NO);
	result = @"-0.1";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	string = JFStringFromFormattedFloat((float)-0.14, 3, YES);
	result = @"-0.140";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromHex
	string = JFStringFromHex(0xABCDEF01);
	result = @"abcdef01";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromInt
	string = JFStringFromInt(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromLong
	string = JFStringFromLong(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromLongLong
	string = JFStringFromLongLong(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromNSInteger
	string = JFStringFromNSInteger(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromNSTimeInterval
	string = JFStringFromNSTimeInterval(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromNSUInteger
	string = JFStringFromNSUInteger(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromSInt8
	string = JFStringFromSInt8(127);
	result = @"127";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromSInt16
	string = JFStringFromSInt16(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromSInt32
	string = JFStringFromSInt32(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromSInt64
	string = JFStringFromSInt64(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromUInt8
	string = JFStringFromUInt8(100);
	result = @"100";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromUInt16
	string = JFStringFromUInt16(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromUInt32
	string = JFStringFromUInt32(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromUInt64
	string = JFStringFromUInt64(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromUnsignedInt
	string = JFStringFromUnsignedInt(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromUnsignedLong
	string = JFStringFromUnsignedLong(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
	
	// JFStringFromUnsignedLongLong
	string = JFStringFromUnsignedLongLong(5600);
	result = @"5600";
	XCTAssert([string isEqualToString:result], @"The string value is '%@'; it should be '%@'.", string, result);
}

- (void)testMacros
{
	// JFKVCPropertyName
	NSString* propertyName			= JFKVCPropertyName(self.continueAfterFailure);
	NSString* propertyNameResult	= @"continueAfterFailure";
	XCTAssert([propertyName isEqualToString:propertyNameResult], @"The 'propertyName' value is '%@'; it should be '%@'.", propertyName, propertyNameResult);
	
	// JFKVCPropertyPath
	NSString* propertyPath			= JFKVCPropertyPath(self.continueAfterFailure);
	NSString* propertyPathResult	= @"self.continueAfterFailure";
	XCTAssert([propertyPath isEqualToString:propertyPathResult], @"The 'propertyPath' value is '%@'; it should be '%@'.", propertyPath, propertyPathResult);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
