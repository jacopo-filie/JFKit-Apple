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

#import "JFSheetDialog.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFSheetDialog

// =================================================================================================
// MARK: Properties
// =================================================================================================

#if JF_IOS
@synthesize popoverConfigurator = _popoverConfigurator;
#endif

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismiss
{
	return [self dismissWithTappedButton:nil closure:nil];
}

- (BOOL)dismissWithClosure:(JFClosure* _Nullable)closure
{
	return [self dismissWithTappedButton:nil closure:closure];
}

- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button
{
	return [self dismissWithTappedButton:button closure:nil];
}

- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	return NO;
}

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

#if JF_IOS
- (BOOL)presentFromViewController:(UIViewController*)presenter
{
	return [self presentFromViewController:presenter closure:nil];
}

- (BOOL)presentFromViewController:(UIViewController*)presenter closure:(JFClosure* _Nullable)closure
{
	return NO;
}
#else
- (BOOL)present
{
	return [self presentWithClosure:nil];
}

- (BOOL)presentWithClosure:(JFClosure* _Nullable)closure
{
	return NO;
}
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
