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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFAlertDialogImplementation : NSObject

@property (copy, nonatomic, nullable) NSArray<JFAlertDialogButton*>* buttons;
@property (strong, nonatomic, nullable) JFClosure* dismissClosure;
@property (weak, nonatomic, readonly, nullable) JFAlertDialog* owner;
@property (strong, nonatomic, nullable) JFClosure* presentClosure;
@property (strong, nonatomic, nullable) NSTimer* timer;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOwner:(JFAlertDialog*)owner NS_DESIGNATED_INITIALIZER;

- (BOOL)dismissWithClickedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_MACOS
@interface JFAlertDialogAlertImplementation : JFAlertDialogImplementation

@property (strong, nonatomic, nullable) NSAlert* alert;

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
@interface JFAlertDialogAlertControllerImplementation : JFAlertDialogImplementation

@property (strong, nonatomic, nullable) UIAlertController* alertController;

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
API_DEPRECATED_WITH_REPLACEMENT("JFAlertDialogAlertControllerImplementation", ios(2.0, 9.0))
@interface JFAlertDialogAlertViewImplementation : JFAlertDialogImplementation <UIAlertViewDelegate>

@property (strong, nonatomic, nullable) UIAlertView* alertView;

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFAlertDialog (/* Private */)

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

#if JF_MACOS
@synthesize alertImplementation = _alertImplementation;
#else
@synthesize alertControllerImplementation = _alertControllerImplementation;
@synthesize alertViewImplementation = _alertViewImplementation;
#endif
@synthesize currentImplementation = _currentImplementation;
@synthesize message = _message;

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

- (BOOL)dismiss
{
	return [self dismissWithClickedButton:nil closure:nil];
}

- (BOOL)dismissWithClickedButton:(JFAlertDialogButton* _Nullable)button
{
	return [self dismissWithClickedButton:button closure:nil];
}

- (BOOL)dismissWithClickedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	if([self isDismissing] || ![self isVisible]) {
		return NO;
	}
	
	return [self.currentImplementation dismissWithClickedButton:button closure:closure];
}

- (BOOL)dismissWithClosure:(JFClosure* _Nullable)closure
{
	return [self dismissWithClickedButton:nil closure:closure];
}

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

- (void)notifyDidDismissWithButton:(JFAlertDialogButton* _Nullable)button
{
	[super notifyDidDismissWithButton:button];
	
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialog:didDismissWithButton:)]) {
			[observer alertDialog:self didDismissWithButton:button];
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

- (void)notifyWillDismissWithButton:(JFAlertDialogButton* _Nullable)button
{
	[super notifyWillDismissWithButton:button];
	
	[self.observers notifyObservers:^(id<JFAlertDialogObserver> observer) {
		if([observer respondsToSelector:@selector(alertDialog:willDismissWithButton:)]) {
			[observer alertDialog:self willDismissWithButton:button];
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

@synthesize buttons = _buttons;
@synthesize dismissClosure = _dismissClosure;
@synthesize owner = _owner;
@synthesize presentClosure = _presentClosure;
@synthesize timer = _timer;

- (instancetype)initWithOwner:(JFAlertDialog*)owner
{
	self = [super init];
	_owner = owner;
	return self;
}

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

- (BOOL)dismissWithClickedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (void)setUpTimerWithTimeout:(NSTimeInterval)timeout
{
	if(!JFIsFloatValueGreaterThanValue(timeout, 0.0, NSDecimalNoScale)) {
		return;
	}
	
	JFWeakifySelf;
	JFTimerHandlerBlock block = ^(NSTimer* timer) {
		[weakSelf dismissWithClickedButton:nil closure:nil];
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

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_MACOS
@implementation JFAlertDialogAlertImplementation

@synthesize alert = _alert;

- (BOOL)presentWithTimeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure
{
	return NO;
}

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
@implementation JFAlertDialogAlertControllerImplementation

@synthesize alertController = _alertController;

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController timeout:(NSTimeInterval)timeout closure:(JFClosure* _Nullable)closure
{
	return NO;
}

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
#	pragma GCC diagnostic push
#	pragma GCC diagnostic ignored "-Wdeprecated-implementations"
@implementation JFAlertDialogAlertViewImplementation

@synthesize alertView = _alertView;

- (BOOL)dismissWithClickedButton:(JFAlertDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	UIAlertView* alertView = self.alertView;
	if(!alertView) {
		return NO;
	}
	
	self.dismissClosure = closure;
	
	NSInteger buttonIndex = [self indexOfButton:button];
	if(buttonIndex < 0) {
		buttonIndex = alertView.cancelButtonIndex;
		button = [self buttonAtIndex:buttonIndex];
	}
	
	self.owner.dismissing = YES;
	
	// Dismissing the alert view in this way prevents the system from calling the delegate method
	// `alertView:clickedButtonAtIndex:`; we have to perform the button action ourselves.
	[self performAction:button.action];
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
	
	return YES;
}

- (void)performAction:(JFAlertDialogButtonAction _Nullable)action
{
	if(action) {
		action();
	}
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

- (BOOL)setUpAlertView
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
	if(![self setUpAlertView]) {
		return NO;
	}
	
	[self setUpTimerWithTimeout:timeout];
	
	self.owner.presenting = YES;
	
	self.presentClosure = closure;
	[self.alertView show];
	
	return YES;
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self performAction:[self buttonAtIndex:buttonIndex].action];
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	JFAlertDialogButton* button = [self buttonAtIndex:buttonIndex];
	
	self.alertView = nil;
	self.buttons = nil;
	
	JFAlertDialog* owner = self.owner;
	owner.dismissing = NO;
	owner.visible = NO;
	[owner notifyDidDismissWithButton:button];
	
	[self performDismissClosure];
}

- (void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self stopAndTearDownTimer];
	[self.owner notifyWillDismissWithButton:[self buttonAtIndex:buttonIndex]];
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
	owner.currentImplementation = self;
	owner.visible = YES;
	[owner notifyWillPresent];
}

@end
#	pragma GCC diagnostic pop
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFAlertDialogButton

@synthesize action = _action;

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
