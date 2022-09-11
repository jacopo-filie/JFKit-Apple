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

@import JFKit;

#import "JFDialog+Protected.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFDialog

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize beingDismissed = _beingDismissed;
@synthesize beingPresented = _beingPresented;
@synthesize cancelButton = _cancelButton;
@synthesize destructiveButton = _destructiveButton;
@synthesize message = _message;
@synthesize observers = _observers;
@synthesize otherButtons = _otherButtons;
@synthesize preferredButton = _preferredButton;
@synthesize timeout = _timeout;
@synthesize title = _title;
@synthesize visible = _visible;

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

- (BOOL)dismissWithTappedButton:(__kindof JFDialogButton* _Nullable)button
{
	return [self dismissWithTappedButton:button closure:nil];
}

- (BOOL)dismissWithTappedButton:(__kindof JFDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	return NO;
}

// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

- (void)notifyButtonTapped:(__kindof JFDialogButton*)button
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialog:buttonTapped:)]) {
			[observer dialog:self buttonTapped:button];
		}
	} async:NO];
}

- (void)notifyHasBeenDismissed
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogHasBeenDismissed:)]) {
			[observer dialogHasBeenDismissed:self];
		}
	} async:NO];
}

- (void)notifyHasBeenPresented
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogHasBeenPresented:)]) {
			[observer dialogHasBeenPresented:self];
		}
	} async:NO];
}

- (void)notifyWillBeDismissed
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogWillBeDismissed:)]) {
			[observer dialogWillBeDismissed:self];
		}
	} async:NO];
}

- (void)notifyWillBePresented
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogWillBePresented:)]) {
			[observer dialogWillBePresented:self];
		}
	} async:NO];
}

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)addObserver:(__kindof id<JFDialogObserver>)observer
{
	[self.observers addObserver:observer];
}

- (void)removeObserver:(__kindof id<JFDialogObserver>)observer
{
	[self.observers removeObserver:observer];
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
