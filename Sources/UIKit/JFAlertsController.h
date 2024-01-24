//
//	The MIT License (MIT)
//
//	Copyright © 2015-2024 Jacopo Filié
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

@import JFKit;

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

@class JFAlert;
@class JFAlertButton;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * A container for alerts that exposes some convenience methods to create them when needed. If the controller is destroyed, all handled pending alerts are automatically cancelled.
 */
@interface JFAlertsController : NSObject

// =================================================================================================
// MARK: Methods - Layout (Action sheets)
// =================================================================================================

#if JF_IOS
/**
 * Composes an action sheet using with the given values and presents it from the given bar button item. If no button is provided, the operation is aborted.
 * @param barButtonItem The presenting bar button item.
 * @param title The title of the action sheet.
 * @param cancelButton The cancel button of the action sheet.
 * @param destructiveButton The destructive button of the action sheet.
 * @param otherButtons The additional buttons of the action sheet.
 */
- (void)presentActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an action sheet using with the given values and presents it from the specified rect in the given view. If no button is provided, the operation is aborted.
 * @param rect The presenting view rect.
 * @param view The presenting view.
 * @param title The title of the action sheet.
 * @param cancelButton The cancel button of the action sheet.
 * @param destructiveButton The destructive button of the action sheet.
 * @param otherButtons The additional buttons of the action sheet.
 */
- (void)presentActionSheetFromRect:(CGRect)rect inView:(UIView*)view title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an action sheet using with the given values and presents it from the given tab bar. If no button is provided, the operation is aborted.
 * @param tabBar The presenting tab bar.
 * @param title The title of the action sheet.
 * @param cancelButton The cancel button of the action sheet.
 * @param destructiveButton The destructive button of the action sheet.
 * @param otherButtons The additional buttons of the action sheet.
 */
- (void)presentActionSheetFromTabBar:(UITabBar*)tabBar title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an action sheet using with the given values and presents it from the given toolbar. If no button is provided, the operation is aborted.
 * @param toolbar The presenting toolbar.
 * @param title The title of the action sheet.
 * @param cancelButton The cancel button of the action sheet.
 * @param destructiveButton The destructive button of the action sheet.
 * @param otherButtons The additional buttons of the action sheet.
 */
- (void)presentActionSheetFromToolbar:(UIToolbar*)toolbar title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an action sheet using with the given values and presents it in the given view. If no button is provided, the operation is aborted.
 * @param view The presenting view.
 * @param title The title of the action sheet.
 * @param cancelButton The cancel button of the action sheet.
 * @param destructiveButton The destructive button of the action sheet.
 * @param otherButtons The additional buttons of the action sheet.
 */
- (void)presentActionSheetInView:(UIView*)view title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

#elif JF_MACOS
/**
 * Composes an action sheet using with the given values and presents it in the given window. If no button is provided, the operation is aborted.
 * @param window The presenting window.
 * @param style The style of the action sheet.
 * @param title The title of the action sheet.
 * @param cancelButton The cancel button of the action sheet.
 * @param otherButtons The additional buttons of the action sheet.
 */
- (void)presentActionSheetForWindow:(NSWindow*)window style:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton* _Nullable)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;
#endif

// =================================================================================================
// MARK: Methods - Layout (Alert views)
// =================================================================================================

#if JF_IOS
/**
 * Composes an alert view using with the given values and presents it modally.
 * @param error The error to display.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 */
- (void)presentAlertViewForError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an alert view using with the given values and presents it modally.
 * @param error The error to display.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 * @param timeout The time after which the alert view is automatically cancelled.
 */
- (void)presentAlertViewForError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout;

/**
 * Composes an alert view using with the given values and presents it modally.
 * @param title The title of the alert view.
 * @param message The message of the alert view.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 */
- (void)presentAlertViewWithTitle:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an alert view using with the given values and presents it modally.
 * @param title The title of the alert view.
 * @param message The message of the alert view.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 * @param timeout The time after which the alert view is automatically cancelled.
 */
- (void)presentAlertViewWithTitle:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout;

#elif JF_MACOS
/**
 * Composes an alert view using with the given values and presents it modally.
 * @param style The style of the alert view.
 * @param error The error to display.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 */
- (void)presentAlertView:(NSAlertStyle)style forError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an alert view using with the given values and presents it modally.
 * @param style The style of the alert view.
 * @param error The error to display.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 * @param timeout The time after which the alert view is automatically cancelled.
 */
- (void)presentAlertView:(NSAlertStyle)style forError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout;

/**
 * Composes an alert view using with the given values and presents it modally.
 * @param style The style of the alert view.
 * @param title The title of the alert view.
 * @param message The message of the alert view.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 */
- (void)presentAlertView:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;

/**
 * Composes an alert view using with the given values and presents it modally.
 * @param style The style of the alert view.
 * @param title The title of the alert view.
 * @param message The message of the alert view.
 * @param cancelButton The cancel button of the alert view.
 * @param otherButtons The additional buttons of the alert view.
 * @param timeout The time after which the alert view is automatically cancelled.
 */
- (void)presentAlertView:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
