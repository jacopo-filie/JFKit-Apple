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



#import	"JFPreprocessorMacros.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Macros

#define JFKVCPropertyName(_property)	[[JFKVCPropertyPath(_property) componentsSeparatedByString:@"."] lastObject]
#define JFKVCPropertyPath(_property)	(@#_property)
#define JFReversedDomain				@"com.jackfelle"

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

FOUNDATION_EXPORT NSString* const	JFEmptyString;
FOUNDATION_EXPORT NSString* const	JFFalseString;
FOUNDATION_EXPORT NSString* const	JFNoString;
FOUNDATION_EXPORT NSString* const	JFTrueString;
FOUNDATION_EXPORT NSString* const	JFYesString;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions (Comparison)

FOUNDATION_EXPORT BOOL	JFStringIsEmpty(NSString* string);
FOUNDATION_EXPORT BOOL	JFStringIsMadeOfCharacters(NSString* string, NSString* characters);
FOUNDATION_EXPORT BOOL	JFStringIsNullOrEmpty(NSString* string);


#pragma mark - Functions (Creation)

FOUNDATION_EXPORT NSString*	JFStringMakeRandom(NSUInteger length);
FOUNDATION_EXPORT NSString*	JFStringMakeRandomWithCharacters(NSUInteger length, NSString* characters);


#pragma mark Functions (Object conversions)

FOUNDATION_EXPORT NSString*		JFStringFromClassOfObject(id<NSObject> object);
FOUNDATION_EXPORT NSString*		JFStringFromCString(const char* string);
FOUNDATION_EXPORT NSString*		JFStringFromEncodedCString(const char* string, NSStringEncoding encoding);
FOUNDATION_EXPORT NSString*		JFStringFromObject(id<NSObject> object);
FOUNDATION_EXPORT NSString*		JFStringFromPointer(void* pointer);
FOUNDATION_EXPORT NSString*		JFStringFromPointerOfObject(id<NSObject> object);
FOUNDATION_EXPORT const char*	JFStringToCString(NSString* string);
FOUNDATION_EXPORT const char*	JFStringToEncodedCString(NSString* string, NSStringEncoding encoding);


#pragma mark Functions (Scalar conversions)

FOUNDATION_EXPORT NSString*	JFStringFromBool(BOOL value);
FOUNDATION_EXPORT NSString*	JFStringFromBoolean(Boolean value);
FOUNDATION_EXPORT NSString*	JFStringFromCGFloat(CGFloat value);
FOUNDATION_EXPORT NSString*	JFStringFromDouble(double value);
FOUNDATION_EXPORT NSString*	JFStringFromFloat(float value);
FOUNDATION_EXPORT NSString*	JFStringFromFloat32(Float32 value);
FOUNDATION_EXPORT NSString*	JFStringFromFloat64(Float64 value);
FOUNDATION_EXPORT NSString*	JFStringFromFormattedDouble(double value, UInt8 decimalDigits, BOOL fixed);
FOUNDATION_EXPORT NSString*	JFStringFromFormattedFloat(float value, UInt8 decimalDigits, BOOL fixed);
FOUNDATION_EXPORT NSString*	JFStringFromHex(unsigned int value);
FOUNDATION_EXPORT NSString*	JFStringFromInt(int value);
FOUNDATION_EXPORT NSString*	JFStringFromLong(long value);
FOUNDATION_EXPORT NSString*	JFStringFromLongLong(long long value);
FOUNDATION_EXPORT NSString*	JFStringFromNSInteger(NSInteger value);
FOUNDATION_EXPORT NSString*	JFStringFromNSTimeInterval(NSTimeInterval value);
FOUNDATION_EXPORT NSString*	JFStringFromNSUInteger(NSUInteger value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt8(SInt8 value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt16(SInt16 value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt32(SInt32 value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt64(SInt64 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt8(UInt8 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt16(UInt16 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt32(UInt32 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt64(UInt64 value);
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedInt(unsigned int value);
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedLong(unsigned long value);
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedLongLong(unsigned long long value);

////////////////////////////////////////////////////////////////////////////////////////////////////
