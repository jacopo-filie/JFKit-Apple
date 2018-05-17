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



#import "JFString.h"

#import "NSBundle+JFFramework.h"

#import "JFShortcuts.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

NSString* const	JFEmptyString	= @"";
NSString* const	JFFalseString	= @"False";
NSString* const	JFNoString		= @"No";
NSString* const	JFTrueString	= @"True";
NSString* const	JFYesString		= @"Yes";

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

BOOL JFStringIsEmpty(NSString* string)
{
	return (string && [string isEqualToString:JFEmptyString]);
}

BOOL JFStringIsMadeOfCharacters(NSString* string, NSString* characters)
{
	NSCharacterSet* stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
	NSCharacterSet* charactersSet = [NSCharacterSet characterSetWithCharactersInString:characters];
	return [charactersSet isSupersetOfSet:stringSet];
}

BOOL JFStringIsNullOrEmpty(NSString* string)
{
	return (!string || [string isEqualToString:JFEmptyString]);
}

NSString* JFStringMakeRandom(NSUInteger length)
{
	static NSString* characters = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	return JFStringMakeRandomWithCharacters(length, characters);
}

NSString* JFStringMakeRandomWithCharacters(NSUInteger length, NSString* characters)
{
	if(!characters)
		return nil;
	
	if((length == 0) || (JFStringIsEmpty(characters)))
		return JFEmptyString;
	
	u_int32_t count = (u_int32_t)[characters length];
	
	NSMutableString* retObj = [NSMutableString stringWithCapacity:length];
	for(NSUInteger i = 0; i < length; i++)
	{
		NSUInteger index = arc4random_uniform(count);
		[retObj appendFormat:@"%C", [characters characterAtIndex:index]];
	}
	return [retObj copy];
}


#pragma mark - Functions (Localization)

NSString* JFLocalizedString(NSString* key)
{
	if(JFStringIsNullOrEmpty(key))
		return nil;
	
	NSString* retObj = [MainBundle localizedStringForKey:key value:nil table:nil];
	if(retObj && ![retObj isEqualToString:key])
		return retObj;
	
	NSBundle* bundle = [NSBundle jf_frameworkResourcesBundle];
	return [bundle localizedStringForKey:key value:nil table:nil];
}


#pragma mark Functions (Object conversions)

NSString* JFStringFromClassOfObject(id<NSObject> object)
{
	if(!object)
		return nil;
	
	return NSStringFromClass([object class]);
}

NSString* JFStringFromCString(const char* string)
{
	return JFStringFromEncodedCString(string, NSUTF8StringEncoding);
}

NSString* JFStringFromEncodedCString(const char* string, NSStringEncoding encoding)
{
	if(!string)
		return nil;
	
	return [NSString stringWithCString:string encoding:encoding];
}

NSString* JFStringFromObject(id<NSObject> object)
{
	if(!object)
		return nil;
	
	return [NSString stringWithFormat:@"<%@: %@>", JFStringFromClassOfObject(object), JFStringFromPointerOfObject(object)];
}

NSString* JFStringFromPersonName(NSString* firstName, NSString* middleName, NSString* lastName)
{
	NSCharacterSet* characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	firstName	= [firstName stringByTrimmingCharactersInSet:characterSet];
	middleName	= [middleName stringByTrimmingCharactersInSet:characterSet];
	lastName	= [lastName stringByTrimmingCharactersInSet:characterSet];

	BOOL isFirstNameValid	= !JFStringIsNullOrEmpty(firstName);
	BOOL isMiddleNameValid	= !JFStringIsNullOrEmpty(middleName);
	BOOL isLastNameValid	= !JFStringIsNullOrEmpty(lastName);
	
	if(!isFirstNameValid && !isMiddleNameValid && !isLastNameValid)
		return nil;
	
	NSMutableArray* components = [NSMutableArray arrayWithCapacity:3];
	if(isFirstNameValid)	[components addObject:firstName];
	if(isMiddleNameValid)	[components addObject:middleName];
	if(isLastNameValid)		[components addObject:lastName];

	return [components componentsJoinedByString:@" "];
}

NSString* JFStringFromPointer(void* pointer)
{
	if(!pointer)
		return nil;
	
	return [NSString stringWithFormat:@"%p", pointer];
}

NSString* JFStringFromPointerOfObject(id<NSObject> object)
{
	if(!object)
		return nil;
	
	return [NSString stringWithFormat:@"%p", object];
}

const char* JFStringToCString(NSString* string)
{
	return JFStringToEncodedCString(string, NSUTF8StringEncoding);
}

const char* JFStringToEncodedCString(NSString* string, NSStringEncoding encoding)
{
	return [string cStringUsingEncoding:encoding];
}


#pragma mark Functions (Scalar conversions)

NSString* JFStringFromBool(BOOL value)
{
	return (value ? JFYesString : JFNoString);
}

NSString* JFStringFromBoolean(Boolean value)
{
	return (value ? JFTrueString : JFFalseString);
}

NSString* JFStringFromCGFloat(CGFloat value)
{
#if __LP64__
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
#if __LP64__
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
#if __LP64__
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
#if __LP64__
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
#if __LP64__
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
