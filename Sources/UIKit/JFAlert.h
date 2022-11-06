//
//	The MIT License (MIT)
//
//	Copyright © 2015-2022 Jacopo Filié
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

@class JFAlertButton;

@protocol JFAlertDelegate;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * This class is used to wrap up in a single interface all the alert types available both on iOS and macOS.
 */
@interface JFAlert : NSObject

// =================================================================================================
// MARK: Properties - Attributes
// =================================================================================================

#if JF_MACOS
/**
 * The style of the alert.
 */
@property (assign, nonatomic) NSAlertStyle style;
#endif

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The message that is displayed in the alert.
 * On iOS action sheets, this property is ignored.
 */
@property (copy, nonatomic, nullable) NSString* message;

/**
 * The title that is displayed in the alert.
 */
@property (copy, nonatomic, nullable) NSString* title;

// =================================================================================================
// MARK: Properties - Flags
// =================================================================================================

/**
 * Returns wheter the alert is displayed or not.
 */
@property (assign, nonatomic, readonly, getter=isVisible) BOOL visible;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

/**
 * The delegate of the alert.
 */
@property (weak, nonatomic, nullable) id<JFAlertDelegate> delegate;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

/**
 * The cancel button of the alert.
 */
@property (strong, nonatomic, nullable) JFAlertButton* cancelButton;

#if JF_IOS
/**
 * The destructive button of the alert.
 * On iOS alert views, this property is ignored.
 * On macOS, this property is ignored.
 */
@property (strong, nonatomic, nullable) JFAlertButton* destructiveButton;
#endif

/**
 * The list of additional buttons displayed in the alert.
 */
@property (copy, nonatomic, nullable) NSArray* otherButtons; // Array of "JFAlertButton" objects.

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

/**
 * Calls the action associated with the cancel button and dismissed the alert.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 */
- (BOOL)dismiss:(JFBlock _Nullable)completion;

/**
 * Calls the action associated with the given button and dismissed the alert.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 */
- (BOOL)dismissWithClickedButton:(JFAlertButton* _Nullable)button completion:(JFBlock _Nullable)completion;

#if JF_IOS
/**
 * Composes an action sheet using the properties set previously and presents it from the given bar button item.
 * @param barButtonItem The presenting bar button item.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no button has been set previously.
 */
- (BOOL)presentAsActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem completion:(JFBlock _Nullable)completion;

/**
 * Composes an action sheet using the properties set previously and presents it from the specified rect in the given view.
 * @param rect The presenting view rect.
 * @param view The presenting view.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no button has been set previously.
 */
- (BOOL)presentAsActionSheetFromRect:(CGRect)rect inView:(UIView*)view completion:(JFBlock _Nullable)completion;

/**
 * Composes the alert using the properties set previously and presents it from the given tab bar.
 * @param tabBar The presenting tab bar.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no button has been set previously.
 */
- (BOOL)presentAsActionSheetFromTabBar:(UITabBar*)tabBar completion:(JFBlock _Nullable)completion;

/**
 * Composes an action sheet using the properties set previously and presents it from the given toolbar.
 * @param toolbar The presenting toolbar.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no button has been set previously.
 */
- (BOOL)presentAsActionSheetFromToolbar:(UIToolbar*)toolbar completion:(JFBlock _Nullable)completion;

/**
 * Composes an action sheet using the properties set previously and presents it in the given view.
 * @param view The presenting view.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no button has been set previously.
 */
- (BOOL)presentAsActionSheetInView:(UIView*)view completion:(JFBlock _Nullable)completion;

#elif JF_MACOS
/**
 * Composes an action sheet using the properties set previously and presents it in the given window.
 * @param window The presenting window.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no button has been set previously.
 */
- (BOOL)presentAsActionSheetForWindow:(NSWindow*)window completion:(JFBlock _Nullable)completion;
#endif

/**
 * Composes an alert view using the properties set previously and presents it modally.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no cancel button has been set previously.
 */
- (BOOL)presentAsAlertView:(JFBlock _Nullable)completion;

/**
 * Composes an alert view using the properties set previously and presents it modally.
 * @param timeout The time after which the alert view is automatically cancelled.
 * @param completion The callback to be executed at the end of the operation.
 * @return `YES` if the operation succeeded, `NO` otherwise.
 * @warning It fails if no cancel button has been set previously.
 */
- (BOOL)presentAsAlertViewWithTimeout:(NSTimeInterval)timeout completion:(JFBlock _Nullable)completion;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A collection of methods that are used to notify the alert delegate when the alert itself is being presented or dismissed.
 */
@protocol JFAlertDelegate <NSObject>

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

@optional

/**
 * Called when the alert has been dismissed using the given button.
 * @param sender The alert.
 * @param button The button used to dismiss the alert.
 */
- (void)alert:(JFAlert*)sender didDismissWithButton:(JFAlertButton* _Nullable)button;

/**
 * Called when the alert is about to be dismissed using the given button.
 * @param sender The alert.
 * @param button The button used to dismiss the alert.
 */
- (void)alert:(JFAlert*)sender willDismissWithButton:(JFAlertButton* _Nullable)button;

/**
 * Called when the alert has been presented.
 * @param sender The alert.
 */
- (void)alertDidPresent:(JFAlert*)sender;

/**
 * Called when the alert is about to be presented.
 * @param sender The alert.
 */
- (void)alertWillPresent:(JFAlert*)sender;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * An object that associated the alert button title with an action to be executed when the button is clicked or tapped.
 */
@interface JFAlertButton : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The action to perform when the alert button is clicked or tapped.
 */
@property (strong, nonatomic, readonly, nullable) JFBlock action;

/**
 * The title to display on the alert button.
 */
@property (copy, nonatomic, readonly) NSString* title;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Returns a new alert button with the given title an no action set.
 * @param title The title of the alert button.
 * @return A new alert button with the given title an no action set.
 */
+ (instancetype)buttonWithTitle:(NSString*)title;

/**
 * Returns a new alert button with the given title and action set.
 * @param title The title of the alert button.
 * @param action The action of the alert button.
 * @return A new alert button with the given title and action set.
 */
+ (instancetype)buttonWithTitle:(NSString*)title action:(JFBlock _Nullable)action;

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the alert button setting the given title and action.
 * @param title The title of the alert button.
 * @param action The action of the alert button.
 * @return The initialized alert button.
 */
- (instancetype)initWithTitle:(NSString*)title action:(JFBlock _Nullable)action NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

