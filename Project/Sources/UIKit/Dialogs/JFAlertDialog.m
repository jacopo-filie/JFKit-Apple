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

#import "JFAlertDialog.h"
#import "JFDialog+Protected.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFAlertDialog

#if JF_IOS
// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	return NO;
}

#endif
// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

- (void)notifyButtonTapped:(JFAlertDialogButton*)button
{
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialog:buttonTapped:)]) {
			[observer alertDialog:self buttonTapped:button];
		}
	} async:NO];
	
	[super notifyButtonTapped:button];
}

- (void)notifyHasBeenDismissed
{
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogHasBeenDismissed:)]) {
			[observer alertDialogHasBeenDismissed:self];
		}
	} async:NO];
	
	[super notifyHasBeenDismissed];
}

- (void)notifyHasBeenPresented
{
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogHasBeenPresented:)]) {
			[observer alertDialogHasBeenPresented:self];
		}
	} async:NO];
	
	[super notifyHasBeenPresented];
}

- (void)notifyWillBeDismissed
{
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogWillBeDismissed:)]) {
			[observer alertDialogWillBeDismissed:self];
		}
	} async:NO];
	
	[super notifyWillBeDismissed];
}

- (void)notifyWillBePresented
{
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogWillBePresented:)]) {
			[observer alertDialogWillBePresented:self];
		}
	} async:NO];
	
	[super notifyWillBePresented];
}

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

#if JF_IOS
- (BOOL)presentFromViewController:(UIViewController*)presenter closure:(JFClosure* _Nullable)closure
{
	return NO;
}
#else
- (BOOL)presentWithClosure:(JFClosure* _Nullable)closure
{
	return NO;
}
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
