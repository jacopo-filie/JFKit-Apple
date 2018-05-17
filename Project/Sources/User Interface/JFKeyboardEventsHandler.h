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



@class JFKeyboardEventsHandler;
@class JFKeyboardInfo;



@protocol JFKeyboardEventsHandlerDelegate <NSObject>

@optional

#pragma mark Events
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler didChangeFrame:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler didHide:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler didShow:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler willChangeFrame:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler willHide:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler willShow:(JFKeyboardInfo*)info;

@end



#pragma mark



@interface JFKeyboardEventsHandler : NSObject

#pragma mark Properties

// Attributes
@property (assign, nonatomic)	IBInspectable	CGFloat	constant;

// Constraints
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	resizableViewBottomConstraint;

// Relationships
@property (weak, nonatomic)	IBOutlet	id<JFKeyboardEventsHandlerDelegate>	delegate;

// User interface
@property (strong, nonatomic)	IBOutlet	UIView*	resizableView;

@end



#pragma mark



@interface JFKeyboardInfo : NSObject <NSCopying>

#pragma mark Properties

// Attributes
@property (assign, nonatomic) NSTimeInterval		animationDuration;
@property (assign, nonatomic) UIViewAnimationCurve	animationCurve;
@property (assign, nonatomic) CGRect				beginningFrame;
@property (assign, nonatomic) CGRect				endingFrame;

@end
