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

@import CoreGraphics;
@import Foundation;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

/**
 * Converts the given property into a string to use for KVC.
 * @param _property The property to convert to string.
 * @return A string containing the `property` name.
 */
#define JFKVCPropertyName(_property) [[JFKVCPropertyPath(_property) componentsSeparatedByString:@"."] lastObject]

/**
 * Converts the given property into a string path to use for KVC.
 * @param _property The property to convert to string path.
 * @return A string containing the `property` path.
 */
#define JFKVCPropertyPath(_property) (@#_property)

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Constants
// =================================================================================================

/**
 * A constant empty string.
 */
FOUNDATION_EXPORT NSString* const JFEmptyString;

/**
 * A constant string containing `False`.
 */
FOUNDATION_EXPORT NSString* const JFFalseString;

/**
 * A constant string containing `No`.
 */
FOUNDATION_EXPORT NSString* const JFNoString;

/**
 * A constant string containing `True`.
 */
FOUNDATION_EXPORT NSString* const JFTrueString;

/**
 * A constant string containing `Yes`.
 */
FOUNDATION_EXPORT NSString* const JFYesString;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Functions - Comparisons
// =================================================================================================

/**
 * Check whether `string` is an empty string.
 * @param string The string to check.
 * @return `YES` if the string exists and is empty, `NO` otherwise.
 */
FOUNDATION_EXPORT BOOL JFStringIsEmpty(NSString* __nullable string);

/**
 * Check whether `string` contains only characters from `characters`.
 * @param string The string to check.
 @param characters A string containing all the characters that can be used to check `string`.
 * @return `YES` if the string contains only characters from `characters`, `NO` otherwise.
 */
FOUNDATION_EXPORT BOOL JFStringIsMadeOfCharacters(NSString* string, NSString* characters);

/**
 * Check whether `string` is `nil` or an empty string.
 * @param string The string to check.
 * @return `YES` if the string does not exists or exists but is empty, `NO` otherwise.
 */
FOUNDATION_EXPORT BOOL JFStringIsNullOrEmpty(NSString* __nullable string);

// =================================================================================================
// MARK: Functions - Creation (Objects conversion)
// =================================================================================================

/**
 * Creates a string using the class of the given object.
 * @param object The object to use.
 * @return A string containing the class of the given object. If `object` does not exists, returns `nil`.
 */
FOUNDATION_EXPORT NSString* __nullable JFStringFromClassOfObject(id<NSObject> __nullable object);

/**
 * Creates a string using the given C pointer.
 * @param pointer The C pointer to use.
 * @return A string containing the given pointer value. If `pointer` does not exists, returns `nil`.
 */
FOUNDATION_EXPORT NSString* __nullable JFStringFromCPointer(void* __nullable pointer);

/**
 * Creates a string using the given C string and the UTF-8 encoding.
 * @param string The C string to use.
 * @return A string converted from the given C string using the UTF-8 encoding.
 */
FOUNDATION_EXPORT NSString* __nullable JFStringFromCString(const char* __nullable string);

/**
 * Creates a string using the given C string and the given encoding.
 * @param string The C string to use.
 * @param encoding The encoding to use.
 * @return A string converted from the given C string using the given encoding.
 */
FOUNDATION_EXPORT NSString* __nullable JFStringFromEncodedCString(const char* __nullable string, NSStringEncoding encoding);

/**
 * Creates a string using the given object.
 * @param object The object to use.
 * @return A string containing the given object class name and pointer value. If `object` does not exists, returns `nil`.
 */
FOUNDATION_EXPORT NSString* __nullable JFStringFromObject(id<NSObject> __nullable object);

/**
 * Creates a string using the given id pointer.
 * @param pointer The id pointer to use.
 * @return A string containing the given id pointer value. If `pointer` does not exists, returns `nil`.
 */
FOUNDATION_EXPORT NSString* __nullable JFStringFromPointer(id __nullable pointer);

/**
 * Creates a C string using the given string and the UTF-8 encoding.
 * @param string The string to use.
 * @return A C string converted from the given string using the UTF-8 encoding.
 */
FOUNDATION_EXPORT const char* __nullable JFStringToCString(NSString* __nullable string);

/**
 * Creates a C string using the given string and the given encoding.
 * @param string The string to use.
 * @param encoding The encoding to use.
 * @return A C string converted from the given string using the given encoding.
 */
FOUNDATION_EXPORT const char* __nullable JFStringToEncodedCString(NSString* __nullable string, NSStringEncoding encoding);

// =================================================================================================
// MARK: Functions - Creation (Randomization)
// =================================================================================================

/**
 * Creates a random string with the given length using characters from the following sets:
 * @code
 *   Numbers: from '0' to '9'
 *   Letters: from 'a' to 'z' and from 'A' to 'Z'
 * @endcode
 * @param length The number of characters of the returned string.
 @return A randomly created string. If `length` is `0`, returns the constant `JFEmptyString`.
 */
FOUNDATION_EXPORT NSString*	JFStringMakeRandom(NSUInteger length);

/**
 * Creates a random string with the given length using the given characters.
 * @param length The number of characters of the returned string.
 * @param characters A string containing the allowed characters.
 @return A randomly created string. If `length` is `0` or `characters` is empty, returns the constant `JFEmptyString`.
 */
FOUNDATION_EXPORT NSString*	JFStringMakeRandomWithCharacters(NSUInteger length, NSString* characters);

// =================================================================================================
// MARK: Functions - Creation (Scalars conversion)
// =================================================================================================

/**
 * Creates a string using the given value.
 * @param value A boolean value.
 * @return The constant `JFYesString` if `value` is `YES`, the constant `JFNoString` otherwise.
 */
FOUNDATION_EXPORT NSString*	JFStringFromBOOL(BOOL value);

/**
 * Creates a string using the given value.
 * @param value A macOS historic boolean value.
 * @return The constant `JFTrueString` if `value` is `YES`, the constant `JFFalseString` otherwise.
 */
FOUNDATION_EXPORT NSString*	JFStringFromBoolean(Boolean value);

/**
 * Creates a string using the given value.
 * @param value A core graphics float value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromCGFloat(CGFloat value);

/**
 * Creates a string using the given value.
 * @param value A double value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromDouble(double value);

/**
 * Creates a string using the given value.
 * @param value A float value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromFloat(float value);

/**
 * Creates a string using the given value.
 * @param value A 32-bit float value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromFloat32(Float32 value);

/**
 * Creates a string using the given value.
 * @param value A 64-bit float value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromFloat64(Float64 value);

/**
 * Creates a string using the given value and formatting it based on `decimalDigits` and `fixed`.
 * @param value A double value.
 * @param decimalDigits The number of printed decimal digits.
 * @param fixed Whether the format string should use fixed-point or general conversion.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromFormattedDouble(double value, UInt8 decimalDigits, BOOL fixed);

/**
 * Creates a string using the given value and formatting it based on `decimalDigits` and `fixed`.
 * @param value A float value.
 * @param decimalDigits The number of printed decimal digits.
 * @param fixed Whether the format string should use fixed-point or general conversion.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromFormattedFloat(float value, UInt8 decimalDigits, BOOL fixed);

/**
 * Creates a string using the given value.
 * @param value An hexadecimal value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromHex(unsigned int value);

/**
 * Creates a string using the given value.
 * @param value An int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromInt(int value);

/**
 * Creates a string using the given value.
 * @param value A long value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromLong(long value);

/**
 * Creates a string using the given value.
 * @param value A long long value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromLongLong(long long value);

/**
 * Creates a string using the given value.
 * @param value An integer value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromNSInteger(NSInteger value);

/**
 * Creates a string using the given value.
 * @param value A time interval value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromNSTimeInterval(NSTimeInterval value);

/**
 * Creates a string using the given value.
 * @param value An unsigned integer value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromNSUInteger(NSUInteger value);

/**
 * Creates a string using the given value.
 * @param value A signed 8-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromSInt8(SInt8 value);

/**
 * Creates a string using the given value.
 * @param value A signed 16-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromSInt16(SInt16 value);

/**
 * Creates a string using the given value.
 * @param value A signed 32-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromSInt32(SInt32 value);

/**
 * Creates a string using the given value.
 * @param value A signed 64-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromSInt64(SInt64 value);

/**
 * Creates a string using the given value.
 * @param value An unsigned 8-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromUInt8(UInt8 value);

/**
 * Creates a string using the given value.
 * @param value An unsigned 16-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromUInt16(UInt16 value);

/**
 * Creates a string using the given value.
 * @param value An unsigned 32-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromUInt32(UInt32 value);

/**
 * Creates a string using the given value.
 * @param value An unsigned 64-bit int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromUInt64(UInt64 value);

/**
 * Creates a string using the given value.
 * @param value An unsigned int value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedInt(unsigned int value);

/**
 * Creates a string using the given value.
 * @param value An unsigned long value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedLong(unsigned long value);

/**
 * Creates a string using the given value.
 * @param value An unsigned long long value.
 * @return A string containing the given value.
 */
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedLongLong(unsigned long long value);

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

