//
//	The MIT License (MIT)
//
//	Copyright © 2016-2021 Jacopo Filié
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

#import "UIButton+JFUIKit.h"

@import ObjectiveC;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface UIButton (JFUIKit_Private)

// =================================================================================================
// MARK: Methods - Layout (Actions)
// =================================================================================================

- (void)jf_buttonTapped:(UIButton*)button;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation UIButton (JFUIKit)

// =================================================================================================
// MARK: Properties - User interface (Actions)
// =================================================================================================

- (JFButtonBlock _Nullable)jf_actionBlock
{
	return objc_getAssociatedObject(self, _cmd);
}

// =================================================================================================
// MARK: Methods - Layout (Actions)
// =================================================================================================

- (void)jf_setActionBlock:(JFButtonBlock _Nullable)block
{
	SEL action = @selector(jf_buttonTapped:);
	UIControlEvents events = UIControlEventTouchUpInside;
	
	[self removeTarget:self action:action forControlEvents:events];
	
	if(block)
		[self addTarget:self action:action forControlEvents:events];
	
	objc_setAssociatedObject(self, @selector(jf_actionBlock), block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation UIButton (JFUIKit_Private)

// =================================================================================================
// MARK: Methods - Layout (Actions)
// =================================================================================================

- (void)jf_buttonTapped:(UIButton*)button
{
	JFButtonBlock block = self.jf_actionBlock;
	if(block)
		block(self);
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

