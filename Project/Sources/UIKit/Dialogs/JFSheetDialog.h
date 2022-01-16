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

@class JFSheetDialog;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef JFBlock JFSheetDialogButtonAction;
#if JF_IOS
typedef void (^JFSheetDialogPopoverConfigurator)(UIPopoverPresentationController* popover);
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFSheetDialogButton : JFDialogButton

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) JFSheetDialogButtonAction action;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)newWithTitle:(NSString*)title action:(JFSheetDialogButtonAction _Nullable)action;
- (instancetype)initWithTitle:(NSString*)title action:(JFSheetDialogButtonAction _Nullable)action NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@protocol JFSheetDialogObserver <JFDialogObserver>

@optional

- (void)sheetDialog:(JFSheetDialog*)sender buttonTapped:(JFSheetDialogButton*)button;
- (void)sheetDialogDidDismiss:(JFSheetDialog*)sender;
- (void)sheetDialogDidPresent:(JFSheetDialog*)sender;
- (void)sheetDialogWillDismiss:(JFSheetDialog*)sender;
- (void)sheetDialogWillPresent:(JFSheetDialog*)sender;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFSheetDialog : JFDialog <JFSheetDialogButton*, id<JFSheetDialogObserver>>

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) JFSheetDialogButton* destructiveButton;
#if JF_IOS
@property (strong, nonatomic, nullable) JFSheetDialogPopoverConfigurator popoverConfigurator;
#endif

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismiss;
- (BOOL)dismissWithClosure:(JFClosure* _Nullable)closure;
- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button;
- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure;

#if JF_MACOS
// =================================================================================================
// MARK: Methods - Presentation (Alert)
// =================================================================================================

- (BOOL)presentOnWindow:(NSWindow*)window;
- (BOOL)presentOnWindow:(NSWindow*)window closure:(JFClosure* _Nullable)closure;

#else
// =================================================================================================
// MARK: Methods - Presentation (ActionSheet)
// =================================================================================================

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem*)barButtonItem API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:", ios(2.0, 8.3));
- (BOOL)presentFromBarButtonItem:(UIBarButtonItem*)barButtonItem closure:(JFClosure* _Nullable)closure API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:closure:", ios(2.0, 8.3));
- (BOOL)presentFromRect:(CGRect)rect inView:(UIView*)view API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:", ios(2.0, 8.3));
- (BOOL)presentFromRect:(CGRect)rect inView:(UIView*)view closure:(JFClosure* _Nullable)closure API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:closure:", ios(2.0, 8.3));
- (BOOL)presentFromTabBar:(UITabBar*)tabBar API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:", ios(2.0, 8.3));
- (BOOL)presentFromTabBar:(UITabBar*)tabBar closure:(JFClosure* _Nullable)closure API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:closure:", ios(2.0, 8.3));
- (BOOL)presentFromToolbar:(UIToolbar*)toolbar API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:", ios(2.0, 8.3));
- (BOOL)presentFromToolbar:(UIToolbar*)toolbar closure:(JFClosure* _Nullable)closure API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:closure:", ios(2.0, 8.3));
- (BOOL)presentInView:(UIView*)view API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:", ios(2.0, 8.3));
- (BOOL)presentInView:(UIView*)view closure:(JFClosure* _Nullable)closure API_DEPRECATED_WITH_REPLACEMENT("-presentFromViewController:closure:", ios(2.0, 8.3));

// =================================================================================================
// MARK: Methods - Presentation (AlertController)
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController;
- (BOOL)presentFromViewController:(UIViewController*)presentingViewController closure:(JFClosure* _Nullable)closure;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
