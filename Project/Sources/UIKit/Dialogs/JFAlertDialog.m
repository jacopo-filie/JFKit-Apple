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
#import "JFPreprocessorMacros.h"

#if JF_IOS
#	import "JFAlertController.h"
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFAlertDialogImplementation : NSObject

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (weak, nonatomic, readonly, nullable) JFAlertDialog* owner;
@property (strong, nonatomic, nullable) NSTimer* timer;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOwner:(JFAlertDialog*)owner NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_MACOS
@interface JFAlertDialogAlertImplementation : JFAlertDialogImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) NSAlert* alert;
@property (strong, nonatomic, nullable) NSArray<JFAlertDialogButton*>* buttons;
@property (strong, nonatomic, nullable) JFClosure* dismissClosure;
@property (strong, nonatomic, nullable) JFClosure* presentClosure;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
@interface JFAlertDialogAlertControllerImplementation : JFAlertDialogImplementation <JFAlertControllerDelegate>

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) JFAlertController* alertController;
@property (strong, nonatomic, nullable) JFAlertDialogButton* clickedButton;
@property (strong, nonatomic, nullable) JFAlertDialogButton* preferredButton;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
API_DEPRECATED_WITH_REPLACEMENT("JFAlertDialogAlertControllerImplementation", ios(2.0, 9.0))
@interface JFAlertDialogAlertViewImplementation : JFAlertDialogImplementation <UIAlertViewDelegate>

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) UIAlertView* alertView;
@property (strong, nonatomic, nullable) NSArray<JFAlertDialogButton*>* buttons;
@property (strong, nonatomic, nullable) JFClosure* dismissClosure;
@property (strong, nonatomic, nullable) JFClosure* presentClosure;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFAlertDialog (/* Private */)

// =================================================================================================
// MARK: Properties
// =================================================================================================

#if JF_MACOS
@property (strong, nonatomic) JFParameterizedLazy<JFAlertDialogAlertImplementation*, JFAlertDialog*>* alertImplementation;
#else
@property (strong, nonatomic) JFParameterizedLazy<JFAlertDialogAlertControllerImplementation*, JFAlertDialog*>* alertControllerImplementation;
#	pragma GCC diagnostic push
#	pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic) JFParameterizedLazy<JFAlertDialogAlertViewImplementation*, JFAlertDialog*>* alertViewImplementation;
#	pragma GCC diagnostic pop
#endif
@property (strong, nonatomic, nullable) JFAlertDialogImplementation* currentImplementation;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFAlertDialog

// =================================================================================================
// MARK: Properties
// =================================================================================================

#if JF_MACOS
@synthesize alertImplementation = _alertImplementation;
#else
@synthesize alertControllerImplementation = _alertControllerImplementation;
@synthesize alertViewImplementation = _alertViewImplementation;
#endif
@synthesize currentImplementation = _currentImplementation;
@synthesize message = _message;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
#if JF_MACOS
	_alertImplementation = [JFParameterizedLazy<JFAlertDialogAlertImplementation*, JFAlertDialog*> newInstance:^JFAlertDialogAlertImplementation*(JFAlertDialog* owner) {
		return [[JFAlertDialogAlertImplementation alloc] initWithOwner:owner];
	}];
#else
	_alertControllerImplementation = [JFParameterizedLazy<JFAlertDialogAlertControllerImplementation*, JFAlertDialog*> newInstance:^JFAlertDialogAlertControllerImplementation*(JFAlertDialog* owner) {
		return [[JFAlertDialogAlertControllerImplementation alloc] initWithOwner:owner];
	}];
#	pragma GCC diagnostic push
#	pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	_alertViewImplementation = [JFParameterizedLazy<JFAlertDialogAlertViewImplementation*, JFAlertDialog*> newInstance:^JFAlertDialogAlertViewImplementation*(JFAlertDialog* owner) {
		return [[JFAlertDialogAlertViewImplementation alloc] initWithOwner:owner];
	}];
#	pragma GCC diagnostic pop
#endif
	return self;
}

#if JF_IOS
// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismiss
{
	return [self dismissWithTappedButton:nil closure:nil];
}

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button
{
	return [self dismissWithTappedButton:button closure:nil];
}

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	if([self isDismissing] || ![self isVisible]) {
		return NO;
	}
	
	return [self.currentImplementation dismissWithTappedButton:button closure:closure];
}

- (BOOL)dismissWithClosure:(JFClosure* _Nullable)closure
{
	return [self dismissWithTappedButton:nil closure:closure];
}
#endif

// =================================================================================================
// MARK: Methods - Presentation (Alert & AlertView)
// =================================================================================================

- (BOOL)present
{
	return [self presentWithTimeout:0.0 closure:nil];
}

- (BOOL)presentWithClosure:(JFClosure* _Nullable)closure
{
	return [self presentWithTimeout:0.0 closure:closure];
}

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout
{
	return [self presentWithTimeout:timeout closure:nil];
}

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure
{
	if([self isPresenting] || [self isVisible]) {
		return NO;
	}
	
#if JF_MACOS
	return [[self.alertImplementation get:self] presentWithTimeout:timeout closure:closure];
#else
	return [[self.alertViewImplementation get:self] presentWithTimeout:timeout closure:closure];
#endif
}

#if JF_IOS
// =================================================================================================
// MARK: Methods - Presentation (AlertController)
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController
{
	return [self presentFromViewController:presentingViewController timeout:0.0 closure:nil];
}

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController closure:(JFClosure* _Nullable)closure
{
	return [self presentFromViewController:presentingViewController timeout:0.0 closure:closure];
}

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout
{
	return [self presentFromViewController:presentingViewController timeout:timeout closure:nil];
}

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure
{
	if([self isPresenting] || [self isVisible]) {
		return NO;
	}
	
	return [[self.alertControllerImplementation get:self] presentFromViewController:presentingViewController timeout:timeout closure:closure];
}
#endif

// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

- (void)notifyButtonTapped:(JFAlertDialogButton*)button
{
	[self.observers notifyObservers:^(__kindof id<JFDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialog:buttonTapped:)]) {
			[observer alertDialog:self buttonTapped:button];
		}
	} async:NO];
}

- (void)notifyDidDismiss
{
	[super notifyDidDismiss];
	
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogDidDismiss:)]) {
			[observer alertDialogDidDismiss:self];
		}
	} async:NO];
}

- (void)notifyDidPresent
{
	[super notifyDidPresent];
	
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogDidPresent:)]) {
			[observer alertDialogDidPresent:self];
		}
	} async:NO];
}

- (void)notifyWillDismiss
{
	[super notifyWillDismiss];
	
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogWillDismiss:)]) {
			[observer alertDialogWillDismiss:self];
		}
	} async:NO];
}

- (void)notifyWillPresent
{
	[super notifyWillPresent];
	
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialogWillPresent:)]) {
			[observer alertDialogWillPresent:self];
		}
	} async:NO];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFAlertDialogImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize owner = _owner;
@synthesize timer = _timer;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithOwner:(JFAlertDialog*)owner
{
	self = [super init];
	_owner = owner;
	return self;
}

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	return NO;
}

// =================================================================================================
// MARK: Methods - Timer
// =================================================================================================

- (void)setUpTimerWithTimeout:(NSTimeInterval)timeout
{
	if(!JFIsFloatValueGreaterThanValue(timeout, 0.0, NSDecimalNoScale)) {
		return;
	}
	
	JFWeakifySelf;
	JFTimerHandlerBlock block = ^(NSTimer* timer) {
		[weakSelf dismissWithTappedButton:nil closure:nil];
	};
	
	if(@available(iOS 10.0, macOS 12.0, *)) {
		self.timer = [NSTimer timerWithTimeInterval:timeout repeats:NO block:block];
	} else {
		self.timer = [NSTimer timerWithTimeInterval:timeout target:[JFTimerHandler handlerWithBlock:block] selector:@selector(timerDidFire:) userInfo:nil repeats:NO];
	}
}

- (void)startTimer
{
	NSTimer* timer = self.timer;
	if(!timer) {
		return;
	}
	
#if JF_MACOS
	[NSRunLoop.currentRunLoop addTimer:timer forMode:NSModalPanelRunLoopMode];
#else
	[NSRunLoop.currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
#endif
}

- (void)stopAndTearDownTimer
{
	NSTimer* timer = self.timer;
	if(!timer) {
		return;
	}
	
	[timer invalidate];
	self.timer = nil;
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (void)performAction:(JFAlertDialogButtonAction _Nullable)action
{
	if(action) {
		action();
	}
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_MACOS
@implementation JFAlertDialogAlertImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize alert = _alert;
@synthesize buttons = _buttons;
@synthesize dismissClosure = _dismissClosure;
@synthesize presentClosure = _presentClosure;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	[NSApp abortModal];
	return YES;
}

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)prepareAlert
{
	if(self.alert) {
		return NO;
	}
	
	JFAlertDialog* owner = self.owner;
	
	JFAlertDialogButton* cancelButton = owner.cancelButton;
	if(!cancelButton) {
		return NO;
	}
	
	NSArray<JFAlertDialogButton*>* otherButtons = owner.otherButtons;
	
	NSMutableArray<JFAlertDialogButton*>* buttons = [NSMutableArray<JFAlertDialogButton*> arrayWithCapacity:(otherButtons.count + 1)];
	[buttons addObject:cancelButton];
	if(otherButtons) {
		[buttons addObjectsFromArray:otherButtons];
	}
	
	NSAlert* alert = [NSAlert new];
	alert.informativeText = owner.message;
	alert.messageText = owner.title;

	for(NSUInteger i = 0; i < buttons.count; i++) {
		[alert addButtonWithTitle:buttons[i].title];
	}
	
	self.alert = alert;
	self.buttons = buttons;
	
	return YES;
}

- (void)presentAlert
{
	JFAlertDialog* owner = self.owner;
	owner.visible = YES;
	[owner notifyWillPresent];
	
	[self startTimer];
	[self performPresentClosure];
	
	owner.presenting = NO;
	[owner notifyDidPresent];
	
	NSAlert* alert = self.alert;
	NSModalResponse response = [alert runModal];
	if(response < 0)
		response = NSAlertFirstButtonReturn;
	
	NSInteger buttonIndex = response - NSAlertFirstButtonReturn;
	
	JFAlertDialogButton* button = [self buttonAtIndex:buttonIndex];
	
	[self stopAndTearDownTimer];
	[owner notifyWillDismiss];
	
	self.alert = nil;
	self.buttons = nil;
	
	owner.dismissing = NO;
	owner.visible = NO;
	[owner notifyDidDismiss];
	
	[self performDismissClosure];
	
	[owner notifyButtonTapped:button];
	[JFAlertDialogImplementation performAction:button.action];
}

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure
{
	if(![self prepareAlert]) {
		return NO;
	}
	
	[self setUpTimerWithTimeout:timeout];
	
	JFAlertDialog* owner = self.owner;
	owner.currentImplementation = self;
	owner.presenting = YES;
	
	self.presentClosure = closure;
	
	[MainOperationQueue addOperationWithBlock:^{
		[self presentAlert];
	}];
	
	return YES;
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (JFAlertDialogButton* _Nullable)buttonAtIndex:(NSInteger)buttonIndex
{
	NSArray<JFAlertDialogButton*>* buttons = self.buttons;
	if((buttonIndex < 0) || ((NSUInteger)buttonIndex >= buttons.count)) {
		return nil;
	}
	
	return [buttons objectAtIndex:(NSUInteger)buttonIndex];
}

- (NSInteger)indexOfButton:(JFAlertDialogButton* _Nullable)button
{
	if(!button) {
		return -1;
	}
	
	NSArray<JFAlertDialogButton*>* buttons = self.buttons;
	return [buttons containsObject:button] ? (NSInteger)[buttons indexOfObject:button] : -1;
}

- (void)performDismissClosure
{
	JFClosure* closure = self.dismissClosure;
	if(!closure) {
		return;
	}
	
	self.dismissClosure = nil;
	[closure execute];
}

- (void)performPresentClosure
{
	JFClosure* closure = self.presentClosure;
	if(!closure) {
		return;
	}
	
	self.presentClosure = nil;
	[closure execute];
}

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
@implementation JFAlertDialogAlertControllerImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize alertController = _alertController;
@synthesize clickedButton = _clickedButton;
@synthesize preferredButton = _preferredButton;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	if(self.clickedButton) {
		return NO;
	}
	
	if(!button) {
		button = self.preferredButton;
	}
	
	self.clickedButton = button;
	
	JFBlock block = ^{
		[closure execute];
		if(button) {
			[self.owner notifyButtonTapped:button];
			[JFAlertDialogImplementation performAction:button.action];
		}
	};
	
	JFAlertController* alertController = self.alertController;
	self.alertController = nil;
	
	UIViewController* presentingViewController = alertController.presentingViewController;
	if(presentingViewController && ![alertController isBeingDismissed]) {
		[presentingViewController dismissViewControllerAnimated:YES completion:block];
	} else {
		block();
	}
	
	return YES;
}

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure
{
	if(presentingViewController.presentedViewController || ![self setUpAlertController]) {
		return NO;
	}
	
	[self setUpTimerWithTimeout:timeout];
	
	JFAlertDialog* owner = self.owner;
	owner.currentImplementation = self;
	owner.presenting = YES;
	
	[presentingViewController presentViewController:self.alertController animated:YES completion:^{
		[closure execute];
	}];
	
	return YES;
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (UIAlertAction*)newAlertActionForButton:(JFAlertDialogButton*)button style:(UIAlertActionStyle)style
{
	JFWeakifySelf;
	return [UIAlertAction actionWithTitle:button.title style:style handler:^(UIAlertAction* action) {
		[weakSelf dismissWithTappedButton:button closure:nil];
	}];
}

- (BOOL)setUpAlertController
{
	if(self.alertController) {
		return NO;
	}
	
	JFAlertDialog* owner = self.owner;
	
	JFAlertDialogButton* cancelButton = owner.cancelButton;
	if(!cancelButton) {
		return NO;
	}
	
	NSArray<JFAlertDialogButton*>* otherButtons = owner.otherButtons;
	
	NSMutableArray<JFAlertDialogButton*>* buttons = [NSMutableArray<JFAlertDialogButton*> arrayWithCapacity:(otherButtons.count + 1)];
	[buttons addObject:cancelButton];
	if(otherButtons) {
		[buttons addObjectsFromArray:otherButtons];
	}
	
	JFAlertController* alertController = [JFAlertController alertControllerWithTitle:owner.title message:owner.message preferredStyle:UIAlertControllerStyleAlert];
	alertController.delegate = self;
	
	UIAlertAction* alertAction = [self newAlertActionForButton:cancelButton style:UIAlertActionStyleCancel];
	[alertController addAction:alertAction];
	
	JFAlertDialogButton* preferredButton = owner.preferredButton;
	UIAlertAction* preferredAction = (preferredButton == cancelButton) ? alertAction : nil;
	
	for(NSUInteger i = 0; i < otherButtons.count; i++) {
		JFAlertDialogButton* button = otherButtons[i];
		alertAction = [self newAlertActionForButton:button style:UIAlertActionStyleDefault];
		[alertController addAction:alertAction];
		if(!preferredAction && (preferredButton == button)) {
			preferredAction = alertAction;
		}
	}
	
	alertController.preferredAction = preferredAction;
	
	self.alertController = alertController;
	self.clickedButton = nil;
	self.preferredButton = (preferredAction ? preferredButton : cancelButton);

	return YES;
}

// =================================================================================================
// MARK: Methods (JFAlertControllerDelegate)
// =================================================================================================

- (void)alertControllerDidAppear:(JFAlertController*)sender
{
	[self startTimer];
	
	JFAlertDialog* owner = self.owner;
	owner.presenting = NO;
	[owner notifyDidPresent];
}

- (void)alertControllerDidDisappear:(JFAlertController*)sender
{
	JFAlertDialog* owner = self.owner;
	owner.dismissing = NO;
	owner.visible = NO;
	[owner notifyDidDismiss];
	
	JFWeakifySelf;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		// If the alert controller gets dismissed from outside, no default button gets clicked as a
		// result of the action. To work around this limitation, we can force a dismissal here to
		// reconnect this path with the default button handling path and let it simulate a tap on
		// the preferred button. We must postpone this for a while because the implementation of the
		// alert controller calls the clicked button action only after the dismissal of the view, so
		// we have no way to know, in this moment, if a button was clicked or the view controller
		// was forcefully dismissed from outside.
		[weakSelf dismissWithTappedButton:nil closure:nil];
	});
}

- (void)alertControllerWillAppear:(JFAlertController*)sender
{
	JFAlertDialog* owner = self.owner;
	owner.visible = YES;
	[owner notifyWillPresent];
}

- (void)alertControllerWillDisappear:(JFAlertController*)sender
{
	[self stopAndTearDownTimer];
	[self.owner notifyWillDismiss];
}

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
#	pragma GCC diagnostic push
#	pragma GCC diagnostic ignored "-Wdeprecated-implementations"
@implementation JFAlertDialogAlertViewImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize alertView = _alertView;
@synthesize buttons = _buttons;
@synthesize dismissClosure = _dismissClosure;
@synthesize presentClosure = _presentClosure;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	UIAlertView* alertView = self.alertView;
	if(!alertView) {
		return NO;
	}
	
	self.dismissClosure = closure;
	
	NSInteger buttonIndex = [self indexOfButton:button];
	if(buttonIndex < 0) {
		buttonIndex = alertView.cancelButtonIndex;
	}
	
	self.owner.dismissing = YES;
	
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
	
	return YES;
}

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)prepareAlertView
{
	if(self.alertView) {
		return NO;
	}
	
	JFAlertDialog* owner = self.owner;
	
	JFAlertDialogButton* cancelButton = owner.cancelButton;
	if(!cancelButton) {
		return NO;
	}
	
	NSArray<JFAlertDialogButton*>* otherButtons = owner.otherButtons;
	
	NSMutableArray<JFAlertDialogButton*>* buttons = [NSMutableArray<JFAlertDialogButton*> arrayWithCapacity:(otherButtons.count + 1)];
	[buttons addObject:cancelButton];
	if(otherButtons) {
		[buttons addObjectsFromArray:otherButtons];
	}
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:owner.title message:owner.message delegate:self cancelButtonTitle:cancelButton.title otherButtonTitles:nil];
	
	for(NSUInteger i = 0; i < otherButtons.count; i++) {
		[alertView addButtonWithTitle:otherButtons[i].title];
	}
	
	self.alertView = alertView;
	self.buttons = buttons;
	
	return YES;
}

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure
{
	if(![self prepareAlertView]) {
		return NO;
	}
	
	[self setUpTimerWithTimeout:timeout];
	
	JFAlertDialog* owner = self.owner;
	owner.currentImplementation = self;
	owner.presenting = YES;

	self.presentClosure = closure;
	[self.alertView show];
	
	return YES;
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (JFAlertDialogButton* _Nullable)buttonAtIndex:(NSInteger)buttonIndex
{
	NSArray<JFAlertDialogButton*>* buttons = self.buttons;
	if((buttonIndex < 0) || ((NSUInteger)buttonIndex >= buttons.count)) {
		return nil;
	}
	
	return [buttons objectAtIndex:(NSUInteger)buttonIndex];
}

- (NSInteger)indexOfButton:(JFAlertDialogButton* _Nullable)button
{
	if(!button) {
		return -1;
	}
	
	NSArray<JFAlertDialogButton*>* buttons = self.buttons;
	return [buttons containsObject:button] ? (NSInteger)[buttons indexOfObject:button] : -1;
}

- (void)performDismissClosure
{
	JFClosure* closure = self.dismissClosure;
	if(!closure) {
		return;
	}
	
	self.dismissClosure = nil;
	[closure execute];
}

- (void)performPresentClosure
{
	JFClosure* closure = self.presentClosure;
	if(!closure) {
		return;
	}
	
	self.presentClosure = nil;
	[closure execute];
}

// =================================================================================================
// MARK: Methods (UIAlertViewDelegate)
// =================================================================================================

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	JFAlertDialogButton* button = [self buttonAtIndex:buttonIndex];
	
	self.alertView = nil;
	self.buttons = nil;
	
	JFAlertDialog* owner = self.owner;
	owner.dismissing = NO;
	owner.visible = NO;
	[owner notifyDidDismiss];
	
	[self performDismissClosure];
	
	if(button) {
		[owner notifyButtonTapped:button];
		[JFAlertDialogImplementation performAction:button.action];
	}
}

- (void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self stopAndTearDownTimer];
	[self.owner notifyWillDismiss];
}

- (void)didPresentAlertView:(UIAlertView*)alertView
{
	[self startTimer];
	[self performPresentClosure];
	
	JFAlertDialog* owner = self.owner;
	owner.presenting = NO;
	[owner notifyDidPresent];
}

- (void)willPresentAlertView:(UIAlertView*)alertView
{
	JFAlertDialog* owner = self.owner;
	owner.visible = YES;
	[owner notifyWillPresent];
}

@end
#	pragma GCC diagnostic pop
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFAlertDialogButton

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize action = _action;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)newWithTitle:(NSString*)title action:(JFAlertDialogButtonAction _Nullable)action
{
	return [[self alloc] initWithTitle:title action:action];
}

- (instancetype)initWithTitle:(NSString*)title action:(JFAlertDialogButtonAction _Nullable)action
{
	self = [super initWithTitle:title];
	_action = action;
	return self;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
