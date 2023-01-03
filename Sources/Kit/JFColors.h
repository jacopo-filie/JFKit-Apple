//
//	The MIT License (MIT)
//
//	Copyright © 2015-2023 Jacopo Filié
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

#import <JFKit/JFPreprocessorMacros.h>

@import Foundation;

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Macros
// =================================================================================================

/**
 * An alias for the `NSColor` class.
 */
#if JF_MACOS
#	define JFColor NSColor
#endif

/**
 * An alias for the `UIColor` class.
 */
#if JF_IOS
#	define JFColor UIColor
#endif

/**
 * Returns a black color object with the specified alpha value.
 * @param _val The alpha value in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorAlpha(_val) JFColorWithRGBA(0, 0, 0, _val)

/**
 * Returns an opaque blue color object with the specified blue value.
 * @param _val The blue value in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorBlue(_val) JFColorWithRGB(0, 0, _val)

/**
 * Returns an opaque cyan color object with the specified green and blue values.
 * @param _val The green and blue values in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorCyan(_val) JFColorWithRGB(0, _val, _val)

/**
 * Returns an opaque gray color object with the specified red, green and blue values.
 * @param _val The red, green and blue values in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorGray(_val) JFColorWithRGB(_val, _val, _val)

/**
 * Returns an opaque green color object with the specified green value.
 * @param _val The green value in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorGreen(_val) JFColorWithRGB(0, _val, 0)

/**
 * Returns an opaque magenta color object with the specified red and blue values.
 * @param _val The red and blue values in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorMagenta(_val) JFColorWithRGB(_val, 0, _val)

/**
 * Returns an opaque red color object with the specified red value.
 * @param _val The red value in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorRed(_val) JFColorWithRGB(_val, 0, 0)

/**
 * Returns an opaque yellow color object with the specified red and green values.
 * @param _val The red and green values in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
#define JFColorYellow(_val) JFColorWithRGB(_val, _val, 0)

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Types - Components
// =================================================================================================

/**
 * A container for a color composed with RGB components where each component is a value in the range between `0` and `JFColorRGB6ComponentMaxValue`.
 */
typedef struct {
	
	/**
	 * The red component value.
	 */
	UInt8 red : 2;
	
	/**
	 * The green component value.
	 */
	UInt8 green : 2;
	
	/**
	 * The blue component value.
	 */
	UInt8 blue : 2;
	
} JFColorRGB6Components;

/**
 * A container for a color composed with RGB components where each component is a value in the range between `0` and `JFColorRGB12ComponentMaxValue`.
 */
typedef struct {
	
	/**
	 * The red component value.
	 */
	UInt8 red : 4;
	
	/**
	 * The green component value.
	 */
	UInt8 green : 4;
	
	/**
	 * The blue component value.
	 */
	UInt8 blue : 4;
	
} JFColorRGB12Components;

/**
 * A container for a color composed with RGB components where each component is a value in the range between `0` and `JFColorRGB24ComponentMaxValue`.
 */
typedef struct {
	
	/**
	 * The red component value.
	 */
	UInt8 red : 8;
	
	/**
	 * The green component value.
	 */
	UInt8 green : 8;
	
	/**
	 * The blue component value.
	 */
	UInt8 blue : 8;
	
} JFColorRGB24Components;

/**
 * A container for a color composed with RGBA components where each component is a value in the range between `0` and `JFColorRGBA8ComponentMaxValue`.
 */
typedef struct {
	
	/**
	 * The red component value.
	 */
	UInt8 red : 2;
	
	/**
	 * The green component value.
	 */
	UInt8 green : 2;
	
	/**
	 * The blue component value.
	 */
	UInt8 blue : 2;
	
	/**
	 * The alpha component value.
	 */
	UInt8 alpha : 2;
	
} JFColorRGBA8Components;

/**
 * A container for a color composed with RGBA components where each component is a value in the range between `0` and `JFColorRGB16ComponentMaxValue`.
 */
typedef struct {
	
	/**
	 * The red component value.
	 */
	UInt8 red : 4;
	
	/**
	 * The green component value.
	 */
	UInt8 green : 4;
	
	/**
	 * The blue component value.
	 */
	UInt8 blue : 4;
	
	/**
	 * The alpha component value.
	 */
	UInt8 alpha : 4;
	
} JFColorRGBA16Components;

/**
 * A container for a color composed with RGBA components where each component is a value in the range between `0` and `JFColorRGB32ComponentMaxValue`.
 */
typedef struct {
	
	/**
	 * The red component value.
	 */
	UInt8 red : 8;
	
	/**
	 * The green component value.
	 */
	UInt8 green : 8;
	
	/**
	 * The blue component value.
	 */
	UInt8 blue : 8;
	
	/**
	 * The alpha component value.
	 */
	UInt8 alpha : 8;
	
} JFColorRGBA32Components;

// =================================================================================================
// MARK: Types - Unions
// =================================================================================================

/**
 * A union to easily switch between the color integer representation and its components (RGB6 version).
 */
typedef union {
	
	/**
	 * The RGB6 components of the color.
	 */
	JFColorRGB6Components components;
	
	/**
	 * The integer value of the color.
	 */
	UInt8 value;
	
} JFColorRGB6;

/**
 * A union to easily switch between the color integer representation and its components (RGB12 version).
 */
typedef union {
	
	/**
	 * The RGB12 components of the color.
	 */
	JFColorRGB12Components components;
	
	/**
	 * The integer value of the color.
	 */
	UInt16 value;
	
} JFColorRGB12;

/**
 * A union to easily switch between the color integer representation and its components (RGB24 version).
 */
typedef union {
	
	/**
	 * The RGB24 components of the color.
	 */
	JFColorRGB24Components components;
	
	/**
	 * The integer value of the color.
	 */
	UInt32 value;
	
} JFColorRGB24;

/**
 * A union to easily switch between the color integer representation and its components (RGBA8 version).
 */
typedef union {
	
	/**
	 * The RGBA8 components of the color.
	 */
	JFColorRGBA8Components components;
	
	/**
	 * The integer value of the color.
	 */
	UInt8 value;
	
} JFColorRGBA8;

/**
 * A union to easily switch between the color integer representation and its components (RGBA16 version).
 */
typedef union {
	
	/**
	 * The RGBA16 components of the color.
	 */
	JFColorRGBA16Components components;
	
	/**
	 * The integer value of the color.
	 */
	UInt16 value;
	
} JFColorRGBA16;

/**
 * A union to easily switch between the color integer representation and its components (RGBA32 version).
 */
typedef union {
	
	/**
	 * The RGBA32 components of the color.
	 */
	JFColorRGBA32Components components;
	
	/**
	 * The integer value of the color.
	 */
	UInt32 value;
	
} JFColorRGBA32;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Constants
// =================================================================================================

/**
 * The max value of a RGB6 color component.
 */
FOUNDATION_EXPORT UInt8 const JFColorRGB6ComponentMaxValue;

/**
 * The max value of a RGB12 color component.
 */
FOUNDATION_EXPORT UInt8 const JFColorRGB12ComponentMaxValue;

/**
 * The max value of a RGB24 color component.
 */
FOUNDATION_EXPORT UInt8 const JFColorRGB24ComponentMaxValue;

/**
 * The max value of a RGBA8 color component.
 */
FOUNDATION_EXPORT UInt8 const JFColorRGBA8ComponentMaxValue;

/**
 * The max value of a RGBA16 color component.
 */
FOUNDATION_EXPORT UInt8 const JFColorRGBA16ComponentMaxValue;

/**
 * The max value of a RGBA32 color component.
 */
FOUNDATION_EXPORT UInt8 const JFColorRGBA32ComponentMaxValue;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Functions
// =================================================================================================

/**
 * Returns an opaque color object with the specified values.
 * @param r The red value in the range between `0` and `UCHAR_MAX`.
 * @param g The green value in the range between `0` and `UCHAR_MAX`.
 * @param b The blue value in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGB(UInt8 r, UInt8 g, UInt8 b);

/**
 * Returns an opaque color object with the specified RGB6 components.
 * @param components The color RGB6 components.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGB6Components(JFColorRGB6Components components);
/**
 * Returns an opaque color object with the specified RGB12 components.
 * @param components The color RGB12 components.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGB12Components(JFColorRGB12Components components);
/**
 * Returns an opaque color object with the specified RGB24 components.
 * @param components The color RGB24 components.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGB24Components(JFColorRGB24Components components);

/**
 * Returns an opaque color object with the specified RGB hexadecimal integer value.
 * @param value The RGB hexadecimal integer value.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGBHex(unsigned int value);

/**
 * Returns an opaque color object with the specified RGB hexadecimal string value.
 * @param string The RGB hexadecimal string value.
 * @return The requested color object, or `nil` if the operation failed.
 */
FOUNDATION_EXPORT JFColor* _Nullable JFColorWithRGBHexString(NSString* _Nullable string);

/**
 * Returns a color object with the specified values.
 * @param r The red value in the range between `0` and `UCHAR_MAX`.
 * @param g The green value in the range between `0` and `UCHAR_MAX`.
 * @param b The blue value in the range between `0` and `UCHAR_MAX`.
 * @param a The alpha value in the range between `0` and `UCHAR_MAX`.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a);

/**
 * Returns a color object with the specified RGBA8 components.
 * @param components The color RGBA8 components.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGBA8Components(JFColorRGBA8Components components);

/**
 * Returns a color object with the specified RGBA16 components.
 * @param components The color RGBA16 components.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGBA16Components(JFColorRGBA16Components components);

/**
 * Returns a color object with the specified RGBA32 components.
 * @param components The color RGBA32 components.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGBA32Components(JFColorRGBA32Components components);

/**
 * Returns a color object with the specified RGBA hexadecimal integer value.
 * @param value The RGBA hexadecimal integer value.
 * @return The requested color object.
 */
FOUNDATION_EXPORT JFColor* JFColorWithRGBAHex(unsigned int value);

/**
 * Returns a color object with the specified RGBA hexadecimal string value.
 * @param string The RGBA hexadecimal string value.
 * @return The requested color object, or `nil` if the operation failed.
 */
FOUNDATION_EXPORT JFColor* _Nullable JFColorWithRGBAHexString(NSString* _Nullable string);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * An extension of the SDK-based color object that contains convenient methods to retrieve the color value in many formats.
 */
@interface JFColor (JFKit)

// =================================================================================================
// MARK: Properties - Components
// =================================================================================================

/**
 * The RGB6 components of the color.
 */
@property (assign, nonatomic, readonly) JFColorRGB6 jf_colorRGB6;

/**
 * The RGB12 components of the color.
 */
@property (assign, nonatomic, readonly) JFColorRGB12 jf_colorRGB12;

/**
 * The RGB24 components of the color.
 */
@property (assign, nonatomic, readonly) JFColorRGB24 jf_colorRGB24;

/**
 * The RGBA8 components of the color.
 */
@property (assign, nonatomic, readonly) JFColorRGBA8 jf_colorRGBA8;

/**
 * The RGBA16 components of the color.
 */
@property (assign, nonatomic, readonly) JFColorRGBA16 jf_colorRGBA16;

/**
 * The RGBA32 components of the color.
 */
@property (assign, nonatomic, readonly) JFColorRGBA32 jf_colorRGBA32;

// =================================================================================================
// MARK: Properties - Values
// =================================================================================================

/**
 * The RGB hexadecimal integer value of the color.
 */
@property (assign, nonatomic, readonly) unsigned int jf_colorRGBHex;

/**
 * The RGB hexadecimal string value of the color.
 */
@property (assign, nonatomic, readonly) NSString* jf_colorRGBHexString;

/**
 * The RGBA hexadecimal integer value of the color.
 */
@property (assign, nonatomic, readonly) unsigned int jf_colorRGBAHex;

/**
 * The RGBA hexadecimal string value of the color.
 */
@property (assign, nonatomic, readonly) NSString* jf_colorRGBAHexString;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

