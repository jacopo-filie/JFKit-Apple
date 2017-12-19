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

////////////////////////////////////////////////////////////////////////////////////////////////////

#import "JFStrings.h"

#import "JFPreprocessorMacros.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Constants
// =================================================================================================

NSString* const	JFEmptyString	= @"";
NSString* const	JFFalseString	= @"False";
NSString* const	JFNoString		= @"No";
NSString* const	JFTrueString	= @"True";
NSString* const	JFYesString		= @"Yes";

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Functions - Comparisons
// =================================================================================================

BOOL JFStringIsEmpty(NSString* __nullable string)
{
	return (string && [string isEqualToString:JFEmptyString]);
}

BOOL JFStringIsMadeOfCharacters(NSString* string, NSString* characters)
{
	NSCharacterSet* stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
	NSCharacterSet* charactersSet = [NSCharacterSet characterSetWithCharactersInString:characters];
	return [charactersSet isSupersetOfSet:stringSet];
}

BOOL JFStringIsNullOrEmpty(NSString* __nullable string)
{
	return (!string || [string isEqualToString:JFEmptyString]);
}

// =================================================================================================
// MARK: Functions - Creation (Objects conversion)
// =================================================================================================

NSString* __nullable JFStringFromClassOfObject(id<NSObject> __nullable object)
{
	return (object ? NSStringFromClass(object.class) : nil);
}

NSString* __nullable JFStringFromCPointer(void* __nullable pointer)
{
	return (pointer ? [NSString stringWithFormat:@"%p", pointer] : nil);
}

NSString* __nullable JFStringFromCString(const char* __nullable string)
{
	return JFStringFromEncodedCString(string, NSUTF8StringEncoding);
}

NSString* __nullable JFStringFromEncodedCString(const char* __nullable string, NSStringEncoding encoding)
{
	return (string ? [NSString stringWithCString:string encoding:encoding] : nil);
}

NSString* __nullable JFStringFromObject(id<NSObject> __nullable object)
{
	return (object ? [NSString stringWithFormat:@"<%@:%@>", JFStringFromClassOfObject(object), JFStringFromPointer(object)] : nil);
}

NSString* __nullable JFStringFromPointer(id __nullable object)
{
	return (object ? [NSString stringWithFormat:@"%p", object] : nil);
}

const char* __nullable JFStringToCString(NSString* __nullable string)
{
	return JFStringToEncodedCString(string, NSUTF8StringEncoding);
}

const char* __nullable JFStringToEncodedCString(NSString* __nullable string, NSStringEncoding encoding)
{
	return (string ? [string cStringUsingEncoding:encoding] : NULL);
}

// =================================================================================================
// MARK: Functions - Creation (Randomization)
// =================================================================================================

NSString* JFStringMakeRandom(NSUInteger length)
{
	static NSString* characters = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	return JFStringMakeRandomWithCharacters(length, characters);
}

NSString* JFStringMakeRandomWithCharacters(NSUInteger length, NSString* characters)
{
	if((length == 0) || (JFStringIsEmpty(characters)))
		return JFEmptyString;
	
	u_int32_t count = (u_int32_t)characters.length;
	
	NSMutableString* retObj = [NSMutableString stringWithCapacity:length];
	for(NSUInteger i = 0; i < length; i++)
	{
		NSUInteger index;
		if(@available(macOS 10.7, *))
			index = arc4random_uniform(count);
		else
			index = arc4random() % count;
		[retObj appendFormat:@"%C", [characters characterAtIndex:index]];
	}
	return [retObj copy];
}

// =================================================================================================
// MARK: Functions - Creation (Scalars conversion)
// =================================================================================================

NSString* JFStringFromBOOL(BOOL value)
{
	return (value ? JFYesString : JFNoString);
}

NSString* JFStringFromBoolean(Boolean value)
{
	return (value ? JFTrueString : JFFalseString);
}

NSString* JFStringFromCGFloat(CGFloat value)
{
#if JF_ARCH64
	return JFStringFromDouble(value);
#else
	return JFStringFromFloat(value);
#endif
}

NSString* JFStringFromDouble(double value)
{
	return [NSString stringWithFormat:@"%lg", value];
}

NSString* JFStringFromFloat(float value)
{
	return [NSString stringWithFormat:@"%g", value];
}

NSString* JFStringFromFloat32(Float32 value)
{
	return JFStringFromFloat(value);
}

NSString* JFStringFromFloat64(Float64 value)
{
	return JFStringFromDouble(value);
}

NSString* JFStringFromFormattedDouble(double value, UInt8 decimalDigits, BOOL fixed)
{
	NSString* formatString = [NSString stringWithFormat:@"%%.%@l%c", JFStringFromUInt8(decimalDigits), (fixed ? 'f' : 'g')];
	return [NSString stringWithFormat:formatString, value];
}

NSString* JFStringFromFormattedFloat(float value, UInt8 decimalDigits, BOOL fixed)
{
	NSString* formatString = [NSString stringWithFormat:@"%%.%@%c", JFStringFromUInt8(decimalDigits), (fixed ? 'f' : 'g')];
	return [NSString stringWithFormat:formatString, value];
}

NSString* JFStringFromHex(unsigned int value)
{
	return [NSString stringWithFormat:@"%x", value];
}

NSString* JFStringFromInt(int value)
{
	return [NSString stringWithFormat:@"%d", value];
}

NSString* JFStringFromLong(long value)
{
	return [NSString stringWithFormat:@"%ld", value];
}

NSString* JFStringFromLongLong(long long value)
{
	return [NSString stringWithFormat:@"%lld", value];
}

NSString* JFStringFromNSInteger(NSInteger value)
{
#if JF_ARCH64
	return JFStringFromLong(value);
#else
	return JFStringFromInt(value);
#endif
}

NSString* JFStringFromNSTimeInterval(NSTimeInterval value)
{
	return JFStringFromDouble(value);
}

NSString* JFStringFromNSUInteger(NSUInteger value)
{
#if JF_ARCH64
	return JFStringFromUnsignedLong(value);
#else
	return JFStringFromUnsignedInt(value);
#endif
}

NSString* JFStringFromSInt8(SInt8 value)
{
	return [NSString stringWithFormat:@"%hhd", value];
}

NSString* JFStringFromSInt16(SInt16 value)
{
	return [NSString stringWithFormat:@"%hd", value];
}

NSString* JFStringFromSInt32(SInt32 value)
{
#if JF_ARCH64
	return [NSString stringWithFormat:@"%d", (signed int)value];
#else
	return [NSString stringWithFormat:@"%ld", (signed long)value];
#endif
}

NSString* JFStringFromSInt64(SInt64 value)
{
	return [NSString stringWithFormat:@"%lld", value];
}

NSString* JFStringFromUInt8(UInt8 value)
{
	return [NSString stringWithFormat:@"%hhu", value];
}

NSString* JFStringFromUInt16(UInt16 value)
{
	return [NSString stringWithFormat:@"%hu", value];
}

NSString* JFStringFromUInt32(UInt32 value)
{
#if JF_ARCH64
	return [NSString stringWithFormat:@"%u", (unsigned int)value];
#else
	return [NSString stringWithFormat:@"%lu", (unsigned long)value];
#endif
}

NSString* JFStringFromUInt64(UInt64 value)
{
	return [NSString stringWithFormat:@"%llu", value];
}

NSString* JFStringFromUnsignedInt(unsigned int value)
{
	return [NSString stringWithFormat:@"%u", value];
}

NSString* JFStringFromUnsignedLong(unsigned long value)
{
	return [NSString stringWithFormat:@"%lu", value];
}

NSString* JFStringFromUnsignedLongLong(unsigned long long value)
{
	return [NSString stringWithFormat:@"%llu", value];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

