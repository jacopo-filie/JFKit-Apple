//
//	The MIT License (MIT)
//
//	Copyright © 2022 Jacopo Filié
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

#import "JFDialog.h"

@class JFAlertDialog;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef JFBlock JFAlertDialogButtonAction;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFAlertDialogButton : JFDialogButton

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) JFAlertDialogButtonAction action;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)newWithTitle:(NSString*)title action:(JFAlertDialogButtonAction _Nullable)action;
- (instancetype)initWithTitle:(NSString*)title action:(JFAlertDialogButtonAction _Nullable)action NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@protocol JFAlertDialogObserver <JFDialogObserver>

@optional

- (void)alertDialog:(JFAlertDialog*)sender buttonTapped:(JFAlertDialogButton*)button;
- (void)alertDialogDidDismiss:(JFAlertDialog*)sender;
- (void)alertDialogDidPresent:(JFAlertDialog*)sender;
- (void)alertDialogWillDismiss:(JFAlertDialog*)sender;
- (void)alertDialogWillPresent:(JFAlertDialog*)sender;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFAlertDialog : JFDialog <JFAlertDialogButton*, id<JFAlertDialogObserver>>

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (copy, nonatomic, nullable) NSString* message;

#if JF_IOS
// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismiss;
- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button;
- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure;
- (BOOL)dismissWithClosure:(JFClosure* _Nullable)closure;
#endif

// =================================================================================================
// MARK: Methods - Presentation (Alert & AlertView)
// =================================================================================================

- (BOOL)present API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:", ios(2.0, 9.0));
- (BOOL)presentWithClosure:(JFClosure* _Nullable)closure API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:closure:", ios(2.0, 9.0));
- (BOOL)presentWithTimeout:(NSTimeInterval)timeout API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:timeout:", ios(2.0, 9.0));
- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:timeout:closure:", ios(2.0, 9.0));

#if JF_IOS
// =================================================================================================
// MARK: Methods - Presentation (AlertController)
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController;
- (BOOL)presentFromViewController:(UIViewController*)presentingViewController closure:(JFClosure* _Nullable)closure;
- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout;
- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
