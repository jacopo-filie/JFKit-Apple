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

#import "JFDialog+Protected.h"
#import "JFFormDialog.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFFormDialog

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize fieldConfigurators = _fieldConfigurators;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFFormDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	return NO;
}

// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

- (void)notifyButtonTapped:(JFFormDialogButton*)button
{
	[self.observers notifyObservers:^(id<JFFormDialogObserver> observer) {
		if([observer respondsToSelector:@selector(formDialog:buttonTapped:)]) {
			[observer formDialog:self buttonTapped:button];
		}
	} async:NO];
	
	[super notifyButtonTapped:button];
}

- (void)notifyHasBeenDismissed
{
	[self.observers notifyObservers:^(id<JFFormDialogObserver> observer) {
		if([observer respondsToSelector:@selector(formDialogHasBeenDismissed:)]) {
			[observer formDialogHasBeenDismissed:self];
		}
	} async:NO];
	
	[super notifyHasBeenDismissed];
}

- (void)notifyHasBeenPresented
{
	[self.observers notifyObservers:^(id<JFFormDialogObserver> observer) {
		if([observer respondsToSelector:@selector(formDialogHasBeenPresented:)]) {
			[observer formDialogHasBeenPresented:self];
		}
	} async:NO];
	
	[super notifyHasBeenPresented];
}

- (void)notifyWillBeDismissed
{
	[self.observers notifyObservers:^(id<JFFormDialogObserver> observer) {
		if([observer respondsToSelector:@selector(formDialogWillBeDismissed:)]) {
			[observer formDialogWillBeDismissed:self];
		}
	} async:NO];
	
	[super notifyWillBeDismissed];
}

- (void)notifyWillBePresented
{
	[self.observers notifyObservers:^(id<JFFormDialogObserver> observer) {
		if([observer respondsToSelector:@selector(formDialogWillBePresented:)]) {
			[observer formDialogWillBePresented:self];
		}
	} async:NO];
	
	[super notifyWillBePresented];
}

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presenter closure:(JFClosure* _Nullable)closure
{
	return NO;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
