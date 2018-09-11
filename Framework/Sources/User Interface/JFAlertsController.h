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

/*
#import "JFPreprocessorMacros.h"

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif


@class JFAlert;
@class JFAlertButton;



@interface JFAlertsController : NSObject

#pragma mark Methods

// User interface management (Action sheets)
#if JF_IOS
- (void)	presentActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetFromRect:(CGRect)rect inView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetFromTabBar:(UITabBar*)tabBar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetFromToolbar:(UIToolbar*)toolbar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetInView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
#elif JF_MACOS
- (void)	presentActionSheetForWindow:(NSWindow*)window style:(NSAlertStyle)style title:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
#endif

// User interface management (Alert views)
#if JF_IOS
- (void)	presentAlertViewForError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertViewForError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons timeout:(NSTimeInterval)timeout;
- (void)	presentAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons timeout:(NSTimeInterval)timeout;
#elif JF_MACOS
- (void)	presentAlertView:(NSAlertStyle)style forError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertView:(NSAlertStyle)style forError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons timeout:(NSTimeInterval)timeout;
- (void)	presentAlertView:(NSAlertStyle)style title:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertView:(NSAlertStyle)style title:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons timeout:(NSTimeInterval)timeout;
#endif

@end
*/
