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
#import "JFPreprocessorMacros.h"

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

@class JFFormDialog;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#if JF_MACOS
typedef void (^JFFormDialogButtonAction)(NSArray<NSTextField*>* fields);
typedef void (^JFFormDialogFieldConfigurator)(NSTextField* field);
#else
typedef void (^JFFormDialogButtonAction)(NSArray<UITextField*>* fields);
typedef void (^JFFormDialogFieldConfigurator)(UITextField* field);
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFFormDialogButton : JFDialogButton

@property (strong, nonatomic, readonly, nullable) JFFormDialogButtonAction action;

+ (instancetype)newWithTitle:(NSString*)title action:(JFFormDialogButtonAction _Nullable)action;
- (instancetype)initWithTitle:(NSString*)title action:(JFFormDialogButtonAction _Nullable)action NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@protocol JFFormDialogObserver <JFDialogObserver>

@optional

- (void)formDialog:(JFFormDialog*)sender didDismissWithButton:(JFFormDialogButton* _Nullable)button;
- (void)formDialog:(JFFormDialog*)sender willDismissWithButton:(JFFormDialogButton* _Nullable)button;
- (void)formDialogDidPresent:(JFFormDialog*)sender;
- (void)formDialogWillPresent:(JFFormDialog*)sender;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFFormDialog : JFDialog <JFFormDialogButton*, id<JFFormDialogObserver>>

@property (copy, nonatomic, nullable) NSArray<JFFormDialogFieldConfigurator>* fieldConfigurators;
@property (copy, nonatomic, nullable) NSString* message;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
