//
//	The MIT License (MIT)
//
//	Copyright © 2015-2021 Jacopo Filié
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

#import "JFColors.h"
#import "JFStrings.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFColor_Tests : XCTestCase

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testCategory;
- (void)testConstants;
- (void)testFunctions;
- (void)testMacros;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFColor_Tests

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testCategory
{
	UInt8 value = JFColorRGBA32ComponentMaxValue;
	JFColor* color = JFColorWithRGBA(value, 0, value, value);
	
	// jf_colorRGB6
	value = JFColorRGB6ComponentMaxValue;
	JFColorRGB6 colorRGB6 = color.jf_colorRGB6;
	XCTAssert((colorRGB6.components.blue == value), @"The blue value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.blue), JFStringFromUInt8(value));
	XCTAssert((colorRGB6.components.green == 0), @"The green value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.green), JFStringFromUInt8(0));
	XCTAssert((colorRGB6.components.red == value), @"The red value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.red), JFStringFromUInt8(value));
	
	// jf_colorRGB12
	value = JFColorRGB12ComponentMaxValue;
	JFColorRGB12 colorRGB12 = color.jf_colorRGB12;
	XCTAssert((colorRGB12.components.blue == value), @"The blue value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.blue), JFStringFromUInt8(value));
	XCTAssert((colorRGB12.components.green == 0), @"The green value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.green), JFStringFromUInt8(0));
	XCTAssert((colorRGB12.components.red == value), @"The red value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.red), JFStringFromUInt8(value));
	
	// jf_colorRGB24
	value = JFColorRGB24ComponentMaxValue;
	JFColorRGB24 colorRGB24 = color.jf_colorRGB24;
	XCTAssert((colorRGB24.components.blue == value), @"The blue value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.blue), JFStringFromUInt8(value));
	XCTAssert((colorRGB24.components.green == 0), @"The green value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.green), JFStringFromUInt8(0));
	XCTAssert((colorRGB24.components.red == value), @"The red value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGB6.components.red), JFStringFromUInt8(value));
	
	// jf_colorRGBHex
	value = JFColorRGB24ComponentMaxValue;
	unsigned int colorRGBHex = color.jf_colorRGBHex;
	unsigned int result = 0xFF00FF;
	XCTAssert((colorRGBHex == result), @"The hex value is '%@'; it should be '%@'.", JFStringFromHex(colorRGBHex), JFStringFromHex(result));
	
	// jf_colorRGBHexString
	NSString* colorRGBHexString = [color.jf_colorRGBHexString uppercaseString];
	NSString* resultString = @"FF00FF";
	XCTAssert([colorRGBHexString isEqualToString:resultString], @"The hex value is '%@'; it should be '%@'.", colorRGBHexString, resultString);
	
	// jf_colorRGBA8
	value = JFColorRGBA8ComponentMaxValue;
	JFColorRGBA8 colorRGBA8 = color.jf_colorRGBA8;
	XCTAssert((colorRGBA8.components.blue == value), @"The blue value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA8.components.blue), JFStringFromUInt8(value));
	XCTAssert((colorRGBA8.components.green == 0), @"The green value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA8.components.green), JFStringFromUInt8(0));
	XCTAssert((colorRGBA8.components.red == value), @"The red value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA8.components.red), JFStringFromUInt8(value));
	XCTAssert((colorRGBA8.components.alpha == value), @"The alpha value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA8.components.alpha), JFStringFromUInt8(value));
	
	// jf_colorRGBA16
	value = JFColorRGBA16ComponentMaxValue;
	JFColorRGBA16 colorRGBA16 = color.jf_colorRGBA16;
	XCTAssert((colorRGBA16.components.blue == value), @"The blue value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA16.components.blue), JFStringFromUInt8(value));
	XCTAssert((colorRGBA16.components.green == 0), @"The green value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA16.components.green), JFStringFromUInt8(0));
	XCTAssert((colorRGBA16.components.red == value), @"The red value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA16.components.red), JFStringFromUInt8(value));
	XCTAssert((colorRGBA16.components.alpha == value), @"The alpha value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA16.components.alpha), JFStringFromUInt8(value));
	
	// jf_colorRGBA32
	value = JFColorRGBA32ComponentMaxValue;
	JFColorRGBA32 colorRGBA32 = color.jf_colorRGBA32;
	XCTAssert((colorRGBA32.components.blue == value), @"The blue value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA32.components.blue), JFStringFromUInt8(value));
	XCTAssert((colorRGBA32.components.green == 0), @"The green value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA32.components.green), JFStringFromUInt8(0));
	XCTAssert((colorRGBA32.components.red == value), @"The red value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA32.components.red), JFStringFromUInt8(value));
	XCTAssert((colorRGBA32.components.alpha == value), @"The alpha value is '%@'; it should be '%@'.", JFStringFromUInt8(colorRGBA32.components.alpha), JFStringFromUInt8(value));
	
	// jf_colorRGBAHex
	value = JFColorRGBA32ComponentMaxValue;
	unsigned int colorRGBAHex = color.jf_colorRGBAHex;
	result = 0xFF00FFFF;
	XCTAssert((colorRGBAHex == result), @"The hex value is '%@'; it should be '%@'.", JFStringFromHex(colorRGBAHex), JFStringFromHex(result));
	
	// jf_colorRGBAHexString
	NSString* colorRGBAHexString = [color.jf_colorRGBAHexString uppercaseString];
	resultString = @"FF00FFFF";
	XCTAssert([colorRGBAHexString isEqualToString:resultString], @"The hex value is '%@'; it should be '%@'.", colorRGBAHexString, resultString);
}

- (void)testConstants
{
	// JFColorRGB6ComponentMaxValue
	UInt8 value = JFColorRGB6ComponentMaxValue;
	UInt8 result = 0x3;
	XCTAssert((value == result), @"The max value is '%@'; it should be '%@'.", JFStringFromUInt8(value), JFStringFromUInt8(result));
	
	// JFColorRGB12ComponentMaxValue
	value = JFColorRGB12ComponentMaxValue;
	result = 0xF;
	XCTAssert((value == result), @"The max value is '%@'; it should be '%@'.", JFStringFromUInt8(value), JFStringFromUInt8(result));
	
	// JFColorRGB24ComponentMaxValue
	value = JFColorRGB24ComponentMaxValue;
	result = 0xFF;
	XCTAssert((value == result), @"The max value is '%@'; it should be '%@'.", JFStringFromUInt8(value), JFStringFromUInt8(result));
	
	// JFColorRGBA8ComponentMaxValue
	value = JFColorRGBA8ComponentMaxValue;
	result = 0x3;
	XCTAssert((value == result), @"The max value is '%@'; it should be '%@'.", JFStringFromUInt8(value), JFStringFromUInt8(result));
	
	// JFColorRGBA16ComponentMaxValue
	value = JFColorRGBA16ComponentMaxValue;
	result = 0xF;
	XCTAssert((value == result), @"The max value is '%@'; it should be '%@'.", JFStringFromUInt8(value), JFStringFromUInt8(result));
	
	// JFColorRGBA32ComponentMaxValue
	value = JFColorRGBA32ComponentMaxValue;
	result = 0xFF;
	XCTAssert((value == result), @"The max value is '%@'; it should be '%@'.", JFStringFromUInt8(value), JFStringFromUInt8(result));
}

- (void)testFunctions
{
	UInt8 value = JFColorRGBA32ComponentMaxValue;
	
	// JFColorWithRGB
	JFColor* color = JFColorWithRGB(0, value, 0);
	unsigned int hex = color.jf_colorRGBHex;
	unsigned int result = 0x00FF00;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGB6Components
	value = JFColorRGB6ComponentMaxValue;
	JFColorRGB6Components RGB6Components = {value, 0, value};
	color = JFColorWithRGB6Components(RGB6Components);
	hex = color.jf_colorRGBHex;
	result = 0xFF00FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGB12Components
	value = JFColorRGB12ComponentMaxValue;
	JFColorRGB12Components RGB12Components = {0, 0, value};
	color = JFColorWithRGB12Components(RGB12Components);
	hex = color.jf_colorRGBHex;
	result = 0x0000FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGB24Components
	value = JFColorRGB24ComponentMaxValue;
	JFColorRGB24Components RGB24Components = {value, 0, 0};
	color = JFColorWithRGB24Components(RGB24Components);
	hex = color.jf_colorRGBHex;
	result = 0xFF0000;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGBHex
	color = JFColorWithRGBHex(0x0FF000);
	hex = color.jf_colorRGBHex;
	result = 0x0FF000;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGBHexString
	color = JFColorWithRGBHexString(@"000FF0");
	hex = color.jf_colorRGBHex;
	result = 0x000FF0;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	XCTAssertNil(JFColorWithRGBHexString(nil));
	XCTAssertNil(JFColorWithRGBHexString(JFEmptyString));
	XCTAssertNil(JFColorWithRGBHexString(@"Wrong string."));

	// JFColorWithRGBA
	color = JFColorWithRGBA(0, value, 0, value);
	hex = color.jf_colorRGBAHex;
	result = 0x00FF00FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGBA8Components
	value = JFColorRGBA8ComponentMaxValue;
	JFColorRGBA8Components RGBA8Components = {value, 0, 0, value};
	color = JFColorWithRGBA8Components(RGBA8Components);
	hex = color.jf_colorRGBAHex;
	result = 0xFF0000FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGBA16Components
	value = JFColorRGBA16ComponentMaxValue;
	JFColorRGBA16Components RGBA16Components = {value, 0, value, 0};
	color = JFColorWithRGBA16Components(RGBA16Components);
	hex = color.jf_colorRGBAHex;
	result = 0xFF00FF00;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGBA32Components
	value = JFColorRGBA32ComponentMaxValue;
	JFColorRGBA32Components RGBA32Components = {value, value, value, 0};
	color = JFColorWithRGBA32Components(RGBA32Components);
	hex = color.jf_colorRGBAHex;
	result = 0xFFFFFF00;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGBAHex
	color = JFColorWithRGBAHex(0x0FF00FF0);
	hex = color.jf_colorRGBAHex;
	result = 0x0FF00FF0;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorWithRGBAHexString
	color = JFColorWithRGBAHexString(@"0FFFFFF0");
	hex = color.jf_colorRGBAHex;
	result = 0x0FFFFFF0;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	XCTAssertNil(JFColorWithRGBAHexString(nil));
	XCTAssertNil(JFColorWithRGBAHexString(JFEmptyString));
	XCTAssertNil(JFColorWithRGBAHexString(@"Wrong string."));
}

- (void)testMacros
{
	// JFColorAlpha
	JFColor* color = JFColorAlpha(JFColorRGBA32ComponentMaxValue);
	unsigned int hex = color.jf_colorRGBAHex;
	unsigned int result = 0x000000FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorBlue
	color = JFColorBlue(JFColorRGBA32ComponentMaxValue);
	hex = color.jf_colorRGBAHex;
	result = 0x0000FFFF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorCyan
	color = JFColorCyan(JFColorRGBA32ComponentMaxValue);
	hex = color.jf_colorRGBAHex;
	result = 0x00FFFFFF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorGray
	color = JFColorGray(JFColorRGBA32ComponentMaxValue);
	hex = color.jf_colorRGBAHex;
	result = 0xFFFFFFFF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorGreen
	color = JFColorGreen(JFColorRGBA32ComponentMaxValue);
	hex = color.jf_colorRGBAHex;
	result = 0x00FF00FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorMagenta
	color = JFColorMagenta(JFColorRGBA32ComponentMaxValue);
	hex = color.jf_colorRGBAHex;
	result = 0xFF00FFFF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorRed
	color = JFColorRed(JFColorRGBA32ComponentMaxValue);
	hex = color.jf_colorRGBAHex;
	result = 0xFF0000FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
	
	// JFColorYellow
	color = JFColorYellow(JFColorRGBA32ComponentMaxValue);
	hex = color.jf_colorRGBAHex;
	result = 0xFFFF00FF;
	XCTAssert((hex == result), @"The color hex value is '%@'; it should be '%@'.", JFStringFromHex(hex), JFStringFromHex(result));
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
