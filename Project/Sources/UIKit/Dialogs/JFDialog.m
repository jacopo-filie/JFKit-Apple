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

#import "JFDialog.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFDialog (/* Private */)

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, readonly) JFObserversController<__kindof id<JFDialogObserver>>* observers;
@property (assign, nonatomic, readwrite, getter=isVisible) BOOL visible;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFDialog

// =================================================================================================
// MARK: Properties
// =================================================================================================

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
// MARK: Methods
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

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
