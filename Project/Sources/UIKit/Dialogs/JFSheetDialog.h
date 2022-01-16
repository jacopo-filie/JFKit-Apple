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
#import "JFSheetDialogButton.h"
#import "JFSheetDialogObserver.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Types
// =================================================================================================

#if JF_IOS
typedef void (^JFSheetDialogPopoverConfigurator)(UIPopoverPresentationController* popover);
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFSheetDialog : JFDialog<JFSheetDialogButton*, id<JFSheetDialogObserver>>

#if JF_IOS
// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) JFSheetDialogPopoverConfigurator popoverConfigurator;

#endif
// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismiss;
- (BOOL)dismissWithClosure:(JFClosure* _Nullable)closure;
- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button;
- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

#if JF_IOS
- (BOOL)presentFromViewController:(UIViewController*)presenter;
- (BOOL)presentFromViewController:(UIViewController*)presenter closure:(JFClosure* _Nullable)closure;
#else
- (BOOL)present;
- (BOOL)presentWithClosure:(JFClosure* _Nullable)closure;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
