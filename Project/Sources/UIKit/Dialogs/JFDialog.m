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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

//  –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFDialog

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize cancelButton = _cancelButton;
@synthesize dismissing = _dismissing;
@synthesize observers = _observers;
@synthesize otherButtons = _otherButtons;
#if JF_IOS
@synthesize preferredButton = _preferredButton;
#endif
@synthesize presenting = _presenting;
@synthesize timeout = _timeout;
@synthesize title = _title;
@synthesize visible = _visible;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	_observers = [JFObserversController<__kindof id<JFDialogObserver>> new];
	return self;
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

- (void)notifyDidDismiss
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogDidDismiss:)]) {
			[observer dialogDidDismiss:self];
		}
	} async:NO];
}

- (void)notifyDidPresent
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogDidPresent:)]) {
			[observer dialogDidPresent:self];
		}
	} async:NO];
}

- (void)notifyWillDismiss
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogWillDismiss:)]) {
			[observer dialogWillDismiss:self];
		}
	} async:NO];
}

- (void)notifyWillPresent
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(dialogWillPresent:)]) {
			[observer dialogWillPresent:self];
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

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFDialogButton

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize title = _title;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)newWithTitle:(NSString*)title
{
	return [[self alloc] initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString*)title
{
	self = [super init];
	_title = [title copy];
	return self;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
