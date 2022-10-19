//
//	The MIT License (MIT)
//
//	Copyright © 2015-2022 Jacopo Filié
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

#import "JFStrings.h"

#import "JFPreprocessorMacros.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Constants
// =================================================================================================

NSString* const JFEmptyString = @"";
NSString* const JFFalseString = @"False";
NSString* const JFNoString = @"No";
NSString* const JFTrueString = @"True";
NSString* const JFYesString = @"Yes";

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Functions - Comparisons
// =================================================================================================

BOOL JFStringIsEmpty(NSString* _Nullable string)
{
	return (string && [string isEqualToString:JFEmptyString]);
}

BOOL JFStringIsMadeOfCharacters(NSString* string, NSString* characters)
{
	NSCharacterSet* stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
	NSCharacterSet* charactersSet = [NSCharacterSet characterSetWithCharactersInString:characters];
	return [charactersSet isSupersetOfSet:stringSet];
}

BOOL JFStringIsNullOrEmpty(NSString* _Nullable string)
{
	return (!string || [string isEqualToString:JFEmptyString]);
}

// =================================================================================================
// MARK: Functions - Creation
// =================================================================================================

NSString* JFStringByReplacingKeysInFormat(NSString* format, NSDictionary<NSString*, NSString*>* values)
{
	if(values.count == 0)
		return [format copy];
	
	NSMutableString* retObj = [NSMutableString stringWithCapacity:format.length];
	
	NSScanner* scanner = [NSScanner scannerWithString:format];
	scanner.charactersToBeSkipped = nil;
	
	NSString* string = nil;
	while(![scanner isAtEnd])
	{
		if([scanner scanUpToString:@"%" intoString:&string])
			[retObj appendString:string];
		
		if([scanner isAtEnd])
			break;
		
		BOOL isFalsePositive = YES;
		for(NSString* key in values.allKeys)
		{
			if(![scanner scanString:key intoString:nil])
				continue;
			
			isFalsePositive = NO;
			[retObj appendString:[values objectForKey:key]];
			break;
		}
		
		if(isFalsePositive && [scanner scanString:@"%" intoString:&string])
			[retObj appendString:string];
	}
	
	return [retObj copy];
}

NSString* _Nullable JFStringFromPersonName(NSString* _Nullable givenName, NSString* _Nullable middleName, NSString* _Nullable familyName)
{
	if(!givenName && !middleName && !familyName)
		return nil;
	
	NSCharacterSet* characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	givenName = [givenName stringByTrimmingCharactersInSet:characterSet];
	middleName = [middleName stringByTrimmingCharactersInSet:characterSet];
	familyName = [familyName stringByTrimmingCharactersInSet:characterSet];
	
	BOOL isGivenNameValid = !JFStringIsNullOrEmpty(givenName);
	BOOL isMiddleNameValid = !JFStringIsNullOrEmpty(middleName);
	BOOL isFamilyNameValid = !JFStringIsNullOrEmpty(familyName);
	
	if(!isGivenNameValid && !isMiddleNameValid && !isFamilyNameValid)
		return nil;
	
	NSString* retObj = nil;
	
	if(@available(iOS 9.0, macOS 10.11, *))
	{
		NSPersonNameComponents* components = [NSPersonNameComponents new];
		if(isGivenNameValid)
			components.givenName = givenName;
		if(isMiddleNameValid)
			components.middleName = middleName;
		if(isFamilyNameValid)
			components.familyName = familyName;
		
		retObj = [NSPersonNameComponentsFormatter localizedStringFromPersonNameComponents:components style:NSPersonNameComponentsFormatterStyleLong options:0];
	}
	else
	{
		NSMutableArray* components = [NSMutableArray arrayWithCapacity:3];
		if(isGivenNameValid)
			[components addObject:givenName];
		if(isMiddleNameValid)
			[components addObject:middleName];
		if(isFamilyNameValid)
			[components addObject:familyName];
		
		retObj = [components componentsJoinedByString:@" "];
	}
	
	return retObj;
}

// =================================================================================================
// MARK: Functions - Creation (Objects conversion)
// =================================================================================================

NSString* _Nullable JFStringFromClassOfObject(id<NSObject> _Nullable object)
{
	return (object ? NSStringFromClass(object.class) : nil);
}

NSString* _Nullable JFStringFromCPointer(void* _Nullable pointer)
{
	return (pointer ? [NSString stringWithFormat:@"%p", pointer] : nil);
}

NSString* _Nullable JFStringFromCString(const char* _Nullable string)
{
	return JFStringFromEncodedCString(string, NSUTF8StringEncoding);
}

NSString* _Nullable JFStringFromEncodedCString(const char* _Nullable string, NSStringEncoding encoding)
{
	return (string ? [NSString stringWithCString:string encoding:encoding] : nil);
}

NSString* _Nullable JFStringFromObject(id<NSObject> _Nullable object)
{
	return (object ? [NSString stringWithFormat:@"<%@:%@>", JFStringFromClassOfObject(object), JFStringFromPointer(object)] : nil);
}

NSString* _Nullable JFStringFromPointer(id _Nullable object)
{
	return (object ? [NSString stringWithFormat:@"%p", object] : nil);
}

const char* _Nullable JFStringToCString(NSString* _Nullable string)
{
	return JFStringToEncodedCString(string, NSUTF8StringEncoding);
}

const char* _Nullable JFStringToEncodedCString(NSString* _Nullable string, NSStringEncoding encoding)
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

