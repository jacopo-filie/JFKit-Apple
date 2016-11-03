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



#import "JFUtilities.h"



@class JFAlert;
@class JFAlertButton;



@protocol JFAlertDelegate <NSObject>

@optional

- (void)	alertDidPresent:(JFAlert*)alert;
- (void)	alertWillPresent:(JFAlert*)alert;

- (void)	alert:(JFAlert*)alert didDismissWithButton:(JFAlertButton*)button;
- (void)	alert:(JFAlert*)alert willDismissWithButton:(JFAlertButton*)button;

@end



#pragma mark



@interface JFAlert : NSObject

#pragma mark Properties

// Attributes
#if JF_MACOS
@property (assign, nonatomic)	NSAlertStyle	style;
#endif

// Data
@property (copy, nonatomic)	NSString*	message;	// Ignored by the iOS action sheet.
@property (copy, nonatomic)	NSString*	title;

// Flags
@property (assign, nonatomic, readonly, getter = isVisible)	BOOL	visible;

// Relationships
#if __has_feature(objc_arc_weak)
@property (weak, nonatomic)	id<JFAlertDelegate>	delegate;
#else
@property (unsafe_unretained, nonatomic)	id<JFAlertDelegate>	delegate;
#endif

// User interface
@property (strong, nonatomic)	JFAlertButton*	cancelButton;
#if JF_IOS
@property (strong, nonatomic)	JFAlertButton*	destructiveButton;	// Only used by the iOS action sheet.
#endif
@property (copy, nonatomic)		NSArray*		otherButtons;		// Array of "JFAlertButton" objects.


#pragma mark Methods

// User interface management
- (BOOL)	dismiss:(JFBlock)completion;
- (BOOL)	dismissWithClickedButton:(JFAlertButton*)button completion:(JFBlock)completion;
#if JF_IOS
- (BOOL)	presentAsActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem completion:(JFBlock)completion;	// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromRect:(CGRect)rect inView:(UIView*)view completion:(JFBlock)completion;			// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromTabBar:(UITabBar*)tabBar completion:(JFBlock)completion;						// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromToolbar:(UIToolbar*)toolbar completion:(JFBlock)completion;						// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetInView:(UIView*)view completion:(JFBlock)completion;								// Fails if there are no buttons.
#elif JF_MACOS
- (BOOL)	presentAsActionSheetForWindow:(NSWindow*)window completion:(JFBlock)completion;							// Fails if there are no buttons.
#endif
- (BOOL)	presentAsAlertView:(JFBlock)completion;																	// Fails if there is not the cancel button.
- (BOOL)	presentAsAlertViewWithTimeout:(NSTimeInterval)timeout completion:(JFBlock)completion;					// Fails if there is not the cancel button.

@end



#pragma mark



@interface JFAlertButton : NSObject

#pragma mark Properties

// Blocks
@property (copy, nonatomic, readonly)	JFBlock	action;

// Data
@property (copy, nonatomic, readonly)	NSString*	title;


#pragma mark Methods

// Memory management
+ (instancetype)	buttonWithTitle:(NSString*)title;
+ (instancetype)	buttonWithTitle:(NSString*)title action:(JFBlock)action;
- (instancetype)	initWithTitle:(NSString*)title action:(JFBlock)action;

@end
