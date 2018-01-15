//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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



#import "JFColor.h"

#import "JFString.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

UInt8 const JFColorRGB6ComponentMaxValue	= 0x3;
UInt8 const JFColorRGB12ComponentMaxValue	= 0xF;
UInt8 const JFColorRGB24ComponentMaxValue	= 0xFF;
UInt8 const JFColorRGBA8ComponentMaxValue	= 0x3;
UInt8 const JFColorRGBA16ComponentMaxValue	= 0xF;
UInt8 const JFColorRGBA32ComponentMaxValue	= 0xFF;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

JFColor* JFColorWithRGB(UInt8 r, UInt8 g, UInt8 b)
{
	return JFColorWithRGBA(r, g, b, UCHAR_MAX);
}

JFColor* JFColorWithRGB6Components(JFColorRGB6Components components)
{
	CGFloat maxValue = JFColorRGB6ComponentMaxValue;
	
	CGFloat r = (CGFloat)components.red / maxValue;
	CGFloat g = (CGFloat)components.green / maxValue;
	CGFloat b = (CGFloat)components.blue / maxValue;
	
	maxValue = UCHAR_MAX;
	
	return JFColorWithRGB((UInt8)(r * maxValue), (UInt8)(g * maxValue), (UInt8)(b * maxValue));
}

JFColor* JFColorWithRGB12Components(JFColorRGB12Components components)
{
	CGFloat maxValue = JFColorRGB12ComponentMaxValue;
	
	CGFloat r = (CGFloat)components.red / maxValue;
	CGFloat g = (CGFloat)components.green / maxValue;
	CGFloat b = (CGFloat)components.blue / maxValue;
	
	maxValue = UCHAR_MAX;
	
	return JFColorWithRGB((UInt8)(r * maxValue), (UInt8)(g * maxValue), (UInt8)(b * maxValue));
}

JFColor* JFColorWithRGB24Components(JFColorRGB24Components components)
{
	CGFloat maxValue = JFColorRGB24ComponentMaxValue;
	
	CGFloat r = (CGFloat)components.red / maxValue;
	CGFloat g = (CGFloat)components.green / maxValue;
	CGFloat b = (CGFloat)components.blue / maxValue;
	
	maxValue = UCHAR_MAX;
	
	return JFColorWithRGB((UInt8)(r * maxValue), (UInt8)(g * maxValue), (UInt8)(b * maxValue));
}

JFColor* JFColorWithRGBHex(unsigned int value)
{
	if(NSHostByteOrder() == NS_LittleEndian)
		value = NSSwapInt(value << 8);
	
	JFColorRGB24 color;
	color.value = value;
	
	return JFColorWithRGB24Components(color.components);
}

JFColor* JFColorWithRGBHexString(NSString* string)
{
	if(JFStringIsNullOrEmpty(string))
		return nil;
	
	NSScanner* scanner = [NSScanner scannerWithString:string];
	scanner.scanLocation = ([string hasPrefix:@"#"] ? 1 : 0);
	
	unsigned int value;
	if(![scanner scanHexInt:&value])
		return nil;
	
	return JFColorWithRGBHex(value);
}

JFColor* JFColorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a)
{
	CGFloat maxValue = UCHAR_MAX;
	
	CGFloat red		= (CGFloat)r / maxValue;
	CGFloat green	= (CGFloat)g / maxValue;
	CGFloat blue	= (CGFloat)b / maxValue;
	CGFloat alpha	= (CGFloat)a / maxValue;
	
#if JF_MACOS
	return [JFColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
#else
	return [JFColor colorWithRed:red green:green blue:blue alpha:alpha];
#endif
}

JFColor* JFColorWithRGBA8Components(JFColorRGBA8Components components)
{
	CGFloat maxValue = JFColorRGBA8ComponentMaxValue;
	
	CGFloat r = (CGFloat)components.red / maxValue;
	CGFloat g = (CGFloat)components.green / maxValue;
	CGFloat b = (CGFloat)components.blue / maxValue;
	CGFloat a = (CGFloat)components.alpha / maxValue;
	
	maxValue = UCHAR_MAX;
	
	return JFColorWithRGBA((UInt8)(r * maxValue), (UInt8)(g * maxValue), (UInt8)(b * maxValue), (UInt8)(a * maxValue));
}

JFColor* JFColorWithRGBA16Components(JFColorRGBA16Components components)
{
	CGFloat maxValue = JFColorRGBA16ComponentMaxValue;
	
	CGFloat r = (CGFloat)components.red / maxValue;
	CGFloat g = (CGFloat)components.green / maxValue;
	CGFloat b = (CGFloat)components.blue / maxValue;
	CGFloat a = (CGFloat)components.alpha / maxValue;
	
	maxValue = UCHAR_MAX;
	
	return JFColorWithRGBA((UInt8)(r * maxValue), (UInt8)(g * maxValue), (UInt8)(b * maxValue), (UInt8)(a * maxValue));
}

JFColor* JFColorWithRGBA32Components(JFColorRGBA32Components components)
{
	CGFloat maxValue = JFColorRGBA32ComponentMaxValue;
	
	CGFloat r = (CGFloat)components.red / maxValue;
	CGFloat g = (CGFloat)components.green / maxValue;
	CGFloat b = (CGFloat)components.blue / maxValue;
	CGFloat a = (CGFloat)components.alpha / maxValue;
	
	maxValue = UCHAR_MAX;
	
	return JFColorWithRGBA((UInt8)(r * maxValue), (UInt8)(g * maxValue), (UInt8)(b * maxValue), (UInt8)(a * maxValue));
}

JFColor* JFColorWithRGBAHex(unsigned int value)
{
	if(NSHostByteOrder() == NS_LittleEndian)
		value = NSSwapInt(value);
	
	JFColorRGBA32 color;
	color.value = value;
	
	return JFColorWithRGBA32Components(color.components);
}

JFColor* JFColorWithRGBAHexString(NSString* string)
{
	if(JFStringIsNullOrEmpty(string))
		return nil;
	
	NSScanner* scanner = [NSScanner scannerWithString:string];
	scanner.scanLocation = ([string hasPrefix:@"#"] ? 1 : 0);
	
	unsigned int value;
	if(![scanner scanHexInt:&value])
		return nil;
	
	return JFColorWithRGBAHex(value);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

@implementation JFColor (JFFramework)

#pragma mark Properties accessors (Data)

- (JFColorRGB6)jf_colorRGB6
{
	CGFloat r, g, b;
	[self getRed:&r green:&g blue:&b alpha:NULL];
	
	CGFloat maxValue = JFColorRGB6ComponentMaxValue;
	
	CGFloat red		= (CGFloat)r * maxValue;
	CGFloat green	= (CGFloat)g * maxValue;
	CGFloat blue	= (CGFloat)b * maxValue;
	
	JFColorRGB6 retVal;
	retVal.components.red	= (UInt8)red;
	retVal.components.green	= (UInt8)green;
	retVal.components.blue	= (UInt8)blue;
	return retVal;
}

- (JFColorRGB12)jf_colorRGB12
{
	CGFloat r, g, b;
	[self getRed:&r green:&g blue:&b alpha:NULL];
	
	CGFloat maxValue = JFColorRGB12ComponentMaxValue;
	
	CGFloat red		= (CGFloat)r * maxValue;
	CGFloat green	= (CGFloat)g * maxValue;
	CGFloat blue	= (CGFloat)b * maxValue;
	
	JFColorRGB12 retVal;
	retVal.components.red	= (UInt8)red;
	retVal.components.green	= (UInt8)green;
	retVal.components.blue	= (UInt8)blue;
	return retVal;
}

- (JFColorRGB24)jf_colorRGB24
{
	CGFloat r, g, b;
	[self getRed:&r green:&g blue:&b alpha:NULL];
	
	CGFloat maxValue = JFColorRGB24ComponentMaxValue;
	
	CGFloat red		= (CGFloat)r * maxValue;
	CGFloat green	= (CGFloat)g * maxValue;
	CGFloat blue	= (CGFloat)b * maxValue;
	
	JFColorRGB24 retVal;
	retVal.components.red	= (UInt8)red;
	retVal.components.green	= (UInt8)green;
	retVal.components.blue	= (UInt8)blue;
	return retVal;
}

- (unsigned int)jf_colorRGBHex
{
	unsigned int retVal = self.jf_colorRGB24.value;
	
	if(NSHostByteOrder() == NS_LittleEndian)
		retVal = NSSwapInt(retVal << 8);
	
	return retVal;
}

- (NSString*)jf_colorRGBHexString
{
	JFColorRGB24 color = self.jf_colorRGB24;
	return [NSString stringWithFormat:@"%02x%02x%02x", color.components.red, color.components.green, color.components.blue];
}

- (JFColorRGBA8)jf_colorRGBA8
{
	CGFloat r, g, b, a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	
	CGFloat maxValue = JFColorRGBA8ComponentMaxValue;
	
	CGFloat red		= (CGFloat)r * maxValue;
	CGFloat green	= (CGFloat)g * maxValue;
	CGFloat blue	= (CGFloat)b * maxValue;
	CGFloat alpha	= (CGFloat)a * maxValue;
	
	JFColorRGBA8 retVal;
	retVal.components.red	= (UInt8)red;
	retVal.components.green	= (UInt8)green;
	retVal.components.blue	= (UInt8)blue;
	retVal.components.alpha	= (UInt8)alpha;
	return retVal;
}

- (JFColorRGBA16)jf_colorRGBA16
{
	CGFloat r, g, b, a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	
	CGFloat maxValue = JFColorRGBA16ComponentMaxValue;
	
	CGFloat red		= (CGFloat)r * maxValue;
	CGFloat green	= (CGFloat)g * maxValue;
	CGFloat blue	= (CGFloat)b * maxValue;
	CGFloat alpha	= (CGFloat)a * maxValue;
	
	JFColorRGBA16 retVal;
	retVal.components.red	= (UInt8)red;
	retVal.components.green	= (UInt8)green;
	retVal.components.blue	= (UInt8)blue;
	retVal.components.alpha	= (UInt8)alpha;
	return retVal;
}

- (JFColorRGBA32)jf_colorRGBA32
{
	CGFloat r, g, b, a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	
	CGFloat maxValue = JFColorRGBA32ComponentMaxValue;
	
	CGFloat red		= (CGFloat)r * maxValue;
	CGFloat green	= (CGFloat)g * maxValue;
	CGFloat blue	= (CGFloat)b * maxValue;
	CGFloat alpha	= (CGFloat)a * maxValue;
	
	JFColorRGBA32 retVal;
	retVal.components.red	= (UInt8)red;
	retVal.components.green	= (UInt8)green;
	retVal.components.blue	= (UInt8)blue;
	retVal.components.alpha	= (UInt8)alpha;
	return retVal;
}

- (unsigned int)jf_colorRGBAHex
{
	unsigned int retVal = self.jf_colorRGBA32.value;
	
	if(NSHostByteOrder() == NS_LittleEndian)
		retVal = NSSwapInt(retVal);
	
	return retVal;
}

- (NSString*)jf_colorRGBAHexString
{
	JFColorRGBA32 color = self.jf_colorRGBA32;
	return [NSString stringWithFormat:@"%02x%02x%02x%02x", color.components.red, color.components.green, color.components.blue, color.components.alpha];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
