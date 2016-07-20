//
//	The MIT License (MIT)
//
//	Copyright © 2016 Jacopo Filié
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



#import "UILabel+JFFramework.h"

#import "JFShortcuts.h"
#import "JRSwizzle.h"



@interface UILabel (JFFramework_Private)

#pragma mark Methods

// Properties accessors
- (void)	jf_swizzled_setText:(NSString*)text;

// User interface management
- (CGSize)	jf_swizzled_intrinsicContentSize;
- (void)	jf_swizzled_layoutSubviews;

@end



#pragma mark



@implementation UILabel (JFFramework)

#pragma mark Properties accessors (Data)

- (void)jf_swizzled_setText:(NSString*)text
{
#if JF_TARGET_OS_IOS
	if(!iOS7Plus)
	{
		// FIX: Whitespaces and newline characters may corrupt the text drawing up to iOS6.
		NSCharacterSet* set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		text = [text stringByTrimmingCharactersInSet:set];
	}
#endif
	
	[self jf_swizzled_setText:text];
}


#pragma mark Memory management

+ (void)load
{
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		
		// Prepares the swizzling block.
		void (^swizzleMethod)(SEL, SEL) = ^(SEL original, SEL swizzled)
		{
			NSError* error;
			[[self class] jr_swizzleMethod:original withMethod:swizzled error:&error];
			NSAssert(!error, @"Failed to swizzle '%@' for error '%@'.", NSStringFromSelector(original), error);
		};
		
		// Swizzle the properties accessors methods.
		swizzleMethod(@selector(setText:), @selector(jf_swizzled_setText:));
		
		// Swizzle the user interface management methods.
		swizzleMethod(@selector(intrinsicContentSize), @selector(jf_swizzled_intrinsicContentSize));
		swizzleMethod(@selector(layoutSubviews), @selector(jf_swizzled_layoutSubviews));
	});
}


#pragma mark User interface management

- (CGSize)jf_swizzled_intrinsicContentSize
{
	CGSize retVal = [self jf_swizzled_intrinsicContentSize];
 
#if JF_TARGET_OS_IOS
	if(!iOS7Plus)
	{
		// Applies the fix if this is a multiline label.
		if(self.numberOfLines != 1)
			retVal.height += 1; // FIX: sometimes the intrinsic content size is 1 point too short.
	}
#endif
	
	return retVal;
}

- (void)jf_swizzled_layoutSubviews
{
	[self jf_swizzled_layoutSubviews];
 
#if JF_TARGET_OS_IOS
	if(!iOS8Plus)
	{
		// Updates the 'preferredMaxLayoutWidth' property if this is a multiline label.
		if(self.numberOfLines != 1)
		{
			CGFloat width = CGRectGetWidth(self.frame);
			if(self.preferredMaxLayoutWidth != width)
			{
				self.preferredMaxLayoutWidth = width; // FIX: if the frame of the label changes, this property is not automatically updated.
				[self setNeedsUpdateConstraints];
			}
		}
	}
#endif
}

@end
