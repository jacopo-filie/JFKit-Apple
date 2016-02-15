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



#import "UIButton+JFFramework.h"

#import <objc/runtime.h>



@interface UIButton (JFFramework_Private)

#pragma mark Methods

// User interface management (Actions)
- (void)	jf_buttonTapped:(UIButton*)button;

@end



#pragma mark



@implementation UIButton (JFFramework_Private)

#pragma mark User interface management (Actions)

- (void)jf_buttonTapped:(UIButton*)button
{
	JFButtonBlock block = self.jf_actionBlock;
	if(block)
		block(self);
}

@end



#pragma mark



@implementation UIButton (JFFramework)

#pragma mark Properties accessors (User interface)

- (JFButtonBlock)jf_actionBlock
{
	return objc_getAssociatedObject(self, @selector(jf_actionBlock));
}

- (void)jf_setActionBlock:(JFButtonBlock)block
{
	[self removeTarget:self action:@selector(jf_buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addTarget:self action:@selector(jf_buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	objc_setAssociatedObject(self, @selector(jf_actionBlock), block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
