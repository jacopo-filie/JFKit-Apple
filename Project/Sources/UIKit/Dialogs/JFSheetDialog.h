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

@import JFKit;

@class JFSheetDialog;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

typedef JFBlock JFSheetDialogButtonAction;
#if JF_IOS
typedef void (^JFSheetDialogPopoverConfigurator)(UIPopoverPresentationController* popover);
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFSheetDialogButton : JFDialogButton

@property (strong, nonatomic, readonly, nullable) JFSheetDialogButtonAction action;

+ (instancetype)newWithTitle:(NSString*)title action:(JFSheetDialogButtonAction _Nullable)action;
- (instancetype)initWithTitle:(NSString*)title action:(JFSheetDialogButtonAction _Nullable)action NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@protocol JFSheetDialogObserver <JFDialogObserver>

@optional

- (void)sheetDialog:(JFSheetDialog*)sender didDismissWithButton:(JFSheetDialogButton* _Nullable)button;
- (void)sheetDialog:(JFSheetDialog*)sender willDismissWithButton:(JFSheetDialogButton* _Nullable)button;
- (void)sheetDialogDidPresent:(JFSheetDialog*)sender;
- (void)sheetDialogWillPresent:(JFSheetDialog*)sender;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFSheetDialog : JFDialog <JFSheetDialogButton*, id<JFSheetDialogObserver>>

@property (strong, nonatomic, nullable) JFSheetDialogButton* destructiveButton;
#if JF_IOS
@property (strong, nonatomic, nullable) JFSheetDialogPopoverConfigurator popoverConfigurator;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
