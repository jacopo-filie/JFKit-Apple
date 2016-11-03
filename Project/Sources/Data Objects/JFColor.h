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

#define JFColorAlpha(_val)		JFColorWithRGBA(0, 0, 0, _val)
#define JFColorBlue(_val)		JFColorWithRGB(0, 0, _val)
#define JFColorCyan(_val)		JFColorWithRGB(0, _val, _val)
#define JFColorGray(_val)		JFColorWithRGB(_val, _val, _val)
#define JFColorGreen(_val)		JFColorWithRGB(0, _val, 0)
#define JFColorMagenta(_val)	JFColorWithRGB(_val, 0, _val)
#define JFColorRed(_val)		JFColorWithRGB(_val, 0, 0)
#define JFColorYellow(_val)		JFColorWithRGB(_val, _val, 0)

#if JF_MACOS
#define JFColor	NSColor
#else
#define JFColor	UIColor
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Types

typedef struct {
	UInt8	red		: 2;
	UInt8	green	: 2;
	UInt8	blue	: 2;
} JFColorRGB6Components;

typedef struct {
	UInt8	red		: 4;
	UInt8	green	: 4;
	UInt8	blue	: 4;
} JFColorRGB12Components;

typedef struct {
	UInt8	red		: 8;
	UInt8	green	: 8;
	UInt8	blue	: 8;
} JFColorRGB24Components;

typedef struct {
	UInt8	red		: 2;
	UInt8	green	: 2;
	UInt8	blue	: 2;
	UInt8	alpha	: 2;
} JFColorRGBA8Components;

typedef struct {
	UInt8	red		: 4;
	UInt8	green	: 4;
	UInt8	blue	: 4;
	UInt8	alpha	: 4;
} JFColorRGBA16Components;

typedef struct {
	UInt8	red		: 8;
	UInt8	green	: 8;
	UInt8	blue	: 8;
	UInt8	alpha	: 8;
} JFColorRGBA32Components;

typedef union {
	JFColorRGB6Components	components;
	UInt8					value;
} JFColorRGB6;

typedef union {
	JFColorRGB12Components	components;
	UInt16					value;
} JFColorRGB12;

typedef union {
	JFColorRGB24Components	components;
	UInt32					value;
} JFColorRGB24;

typedef union {
	JFColorRGBA8Components	components;
	UInt8					value;
} JFColorRGBA8;

typedef union {
	JFColorRGBA16Components	components;
	UInt16					value;
} JFColorRGBA16;

typedef union {
	JFColorRGBA32Components	components;
	UInt32					value;
} JFColorRGBA32;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

FOUNDATION_EXPORT UInt8 const JFColorRGB6ComponentMaxValue;
FOUNDATION_EXPORT UInt8 const JFColorRGB12ComponentMaxValue;
FOUNDATION_EXPORT UInt8 const JFColorRGB24ComponentMaxValue;
FOUNDATION_EXPORT UInt8 const JFColorRGBA8ComponentMaxValue;
FOUNDATION_EXPORT UInt8 const JFColorRGBA16ComponentMaxValue;
FOUNDATION_EXPORT UInt8 const JFColorRGBA32ComponentMaxValue;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

FOUNDATION_EXPORT JFColor*	JFColorWithRGB(UInt8 r, UInt8 g, UInt8 b);
FOUNDATION_EXPORT JFColor*	JFColorWithRGB6Components(JFColorRGB6Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithRGB12Components(JFColorRGB12Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithRGB24Components(JFColorRGB24Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBHex(unsigned int value);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBHexString(NSString* string);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBA8Components(JFColorRGBA8Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBA16Components(JFColorRGBA16Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBA32Components(JFColorRGBA32Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBAHex(unsigned int value);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBAHexString(NSString* string);

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

@interface JFColor (JFFramework)

#pragma mark Properties

// Data
@property (assign, nonatomic, readonly)	JFColorRGB6		jf_colorRGB6;
@property (assign, nonatomic, readonly)	JFColorRGB12	jf_colorRGB12;
@property (assign, nonatomic, readonly)	JFColorRGB24	jf_colorRGB24;
@property (assign, nonatomic, readonly)	unsigned int	jf_colorRGBHex;
@property (assign, nonatomic, readonly)	NSString*		jf_colorRGBHexString;
@property (assign, nonatomic, readonly)	JFColorRGBA8	jf_colorRGBA8;
@property (assign, nonatomic, readonly)	JFColorRGBA16	jf_colorRGBA16;
@property (assign, nonatomic, readonly)	JFColorRGBA32	jf_colorRGBA32;
@property (assign, nonatomic, readonly)	unsigned int	jf_colorRGBAHex;
@property (assign, nonatomic, readonly)	NSString*		jf_colorRGBAHexString;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
