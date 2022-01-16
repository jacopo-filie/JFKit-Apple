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
#import "JFDialog+Protected.h"
#import "JFPreprocessorMacros.h"

#if JF_IOS
#	import "JFAlertController.h"
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFSheetDialogImplementation : NSObject

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (weak, nonatomic, readonly, nullable) JFSheetDialog* owner;
@property (strong, nonatomic, nullable) NSTimer* timer;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOwner:(JFSheetDialog*)owner NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_MACOS
@interface JFSheetDialogAlertImplementation : JFSheetDialogImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) NSAlert* alert;
@property (strong, nonatomic, nullable) NSArray<JFSheetDialogButton*>* buttons;
@property (strong, nonatomic, nullable) JFClosure* dismissClosure;
@property (strong, nonatomic, nullable) JFClosure* presentClosure;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentOnWindow:(NSWindow*)window closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
@interface JFSheetDialogAlertControllerImplementation : JFSheetDialogImplementation <JFAlertControllerDelegate>

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) JFAlertController* alertController;
@property (strong, nonatomic, nullable) JFSheetDialogButton* clickedButton;
@property (strong, nonatomic, nullable) JFSheetDialogButton* preferredButton;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
API_DEPRECATED_WITH_REPLACEMENT("JFSheetDialogAlertControllerImplementation", ios(2.0, 8.3))
@interface JFSheetDialogActionSheetImplementation : JFSheetDialogImplementation <UIActionSheetDelegate>

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (strong, nonatomic, nullable) UIActionSheet* actionSheet;
@property (strong, nonatomic, nullable) NSArray<JFSheetDialogButton*>* buttons;
@property (strong, nonatomic, nullable) JFClosure* dismissClosure;
@property (strong, nonatomic, nullable) JFClosure* presentClosure;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem*)barButtonItem closure:(JFClosure* _Nullable)closure;
- (BOOL)presentFromRect:(CGRect)rect inView:(UIView*)view closure:(JFClosure* _Nullable)closure;
- (BOOL)presentFromTabBar:(UITabBar*)tabBar closure:(JFClosure* _Nullable)closure;
- (BOOL)presentFromToolbar:(UIToolbar*)toolbar closure:(JFClosure* _Nullable)closure;
- (BOOL)presentInView:(UIView*)view closure:(JFClosure* _Nullable)closure;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFSheetDialog (/* Private */)

// =================================================================================================
// MARK: Properties
// =================================================================================================

#if JF_MACOS
@property (strong, nonatomic) JFParameterizedLazy<JFSheetDialogAlertImplementation*, JFSheetDialog*>* alertImplementation;
#else
#	pragma GCC diagnostic push
#	pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic) JFParameterizedLazy<JFSheetDialogActionSheetImplementation*, JFSheetDialog*>* actionSheetImplementation;
#	pragma GCC diagnostic pop
@property (strong, nonatomic) JFParameterizedLazy<JFSheetDialogAlertControllerImplementation*, JFSheetDialog*>* alertControllerImplementation;
#endif
@property (strong, nonatomic, nullable) JFSheetDialogImplementation* currentImplementation;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFSheetDialog

// =================================================================================================
// MARK: Properties
// =================================================================================================

#if JF_MACOS
@synthesize alertImplementation = _alertImplementation;
#else
@synthesize actionSheetImplementation = _actionSheetImplementation;
@synthesize alertControllerImplementation = _alertControllerImplementation;
#endif
@synthesize currentImplementation = _currentImplementation;
@synthesize destructiveButton = _destructiveButton;
#if JF_IOS
@synthesize popoverConfigurator = _popoverConfigurator;
#endif

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
#if JF_MACOS
	_alertImplementation = [JFParameterizedLazy<JFSheetDialogAlertImplementation*, JFSheetDialog*> newInstance:^JFSheetDialogAlertImplementation*(JFSheetDialog* owner) {
		return [[JFSheetDialogAlertImplementation alloc] initWithOwner:owner];
	}];
#else
#	pragma GCC diagnostic push
#	pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	_actionSheetImplementation = [JFParameterizedLazy<JFSheetDialogActionSheetImplementation*, JFSheetDialog*> newInstance:^JFSheetDialogActionSheetImplementation*(JFSheetDialog* owner) {
		return [[JFSheetDialogActionSheetImplementation alloc] initWithOwner:owner];
	}];
#	pragma GCC diagnostic pop
	_alertControllerImplementation = [JFParameterizedLazy<JFSheetDialogAlertControllerImplementation*, JFSheetDialog*> newInstance:^JFSheetDialogAlertControllerImplementation*(JFSheetDialog* owner) {
		return [[JFSheetDialogAlertControllerImplementation alloc] initWithOwner:owner];
	}];
#endif
	return self;
}

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
	if([self isDismissing] || ![self isVisible]) {
		return NO;
	}
	
	return [self.currentImplementation dismissWithTappedButton:button closure:closure];
}

#if JF_MACOS
// =================================================================================================
// MARK: Methods - Presentation (Alert)
// =================================================================================================

- (BOOL)presentOnWindow:(NSWindow*)window
{
	return [self presentOnWindow:window closure:nil];
}

- (BOOL)presentOnWindow:(NSWindow*)window closure:(JFClosure* _Nullable)closure
{
	return NO;
}

#else
// =================================================================================================
// MARK: Methods - Presentation (ActionSheet)
// =================================================================================================

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem*)barButtonItem
{
	return [self presentFromBarButtonItem:barButtonItem closure:nil];
}

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem*)barButtonItem closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentFromRect:(CGRect)rect inView:(UIView*)view
{
	return [self presentFromRect:rect inView:view closure:nil];
}

- (BOOL)presentFromRect:(CGRect)rect inView:(UIView*)view closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentFromTabBar:(UITabBar*)tabBar
{
	return [self presentFromTabBar:tabBar closure:nil];
}

- (BOOL)presentFromTabBar:(UITabBar*)tabBar closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentFromToolbar:(UIToolbar*)toolbar
{
	return [self presentFromToolbar:toolbar closure:nil];
}

- (BOOL)presentFromToolbar:(UIToolbar*)toolbar closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentInView:(UIView*)view
{
	return [self presentInView:view closure:nil];
}

- (BOOL)presentInView:(UIView*)view closure:(JFClosure* _Nullable)closure
{
	return NO;
}


// =================================================================================================
// MARK: Methods - Presentation (AlertController)
// =================================================================================================

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController
{
	return [self presentFromViewController:presentingViewController closure:nil];
}

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController closure:(JFClosure* _Nullable)closure
{
	return NO;
}

#endif
@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFSheetDialogImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize owner = _owner;
@synthesize timer = _timer;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithOwner:(JFSheetDialog*)owner
{
	self = [super init];
	_owner = owner;
	return self;
}

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
{
	return NO;
}

// =================================================================================================
// MARK: Methods - Timer
// =================================================================================================

- (void)setUpTimer
{
	NSTimeInterval timeout = self.owner.timeout;
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

+ (void)performAction:(JFSheetDialogButtonAction _Nullable)action
{
	if(action) {
		action();
	}
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_MACOS
@implementation JFSheetDialogAlertImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize alert = _alert;
@synthesize buttons = _buttons;
@synthesize dismissClosure = _dismissClosure;
@synthesize presentClosure = _presentClosure;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentOnWindow:(NSWindow*)window closure:(JFClosure* _Nullable)closure
{
	return NO;
}

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

#if JF_IOS
@implementation JFSheetDialogAlertControllerImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize alertController = _alertController;
@synthesize clickedButton = _clickedButton;
@synthesize preferredButton = _preferredButton;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismissWithTappedButton:(JFSheetDialogButton* _Nullable)button closure:(JFClosure* _Nullable)closure
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
			[JFSheetDialogImplementation performAction:button.action];
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

- (BOOL)presentFromViewController:(UIViewController*)presentingViewController closure:(JFClosure* _Nullable)closure
{
	if(presentingViewController.presentedViewController || ![self setUpAlertController]) {
		return NO;
	}
	
	[self setUpTimer];
	
	JFSheetDialog* owner = self.owner;
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

- (UIAlertAction*)newAlertActionForButton:(JFSheetDialogButton*)button style:(UIAlertActionStyle)style
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
	
	JFSheetDialog* owner = self.owner;
	
	JFSheetDialogButton* cancelButton = owner.cancelButton;
	if(!cancelButton) {
		return NO;
	}
	
	NSArray<JFSheetDialogButton*>* otherButtons = owner.otherButtons;
	
	JFAlertController* alertController = [JFAlertController alertControllerWithTitle:owner.title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	alertController.delegate = self;
	
	UIAlertAction* alertAction = [self newAlertActionForButton:cancelButton style:UIAlertActionStyleCancel];
	[alertController addAction:alertAction];
	
	JFSheetDialogButton* preferredButton = owner.preferredButton;
	UIAlertAction* preferredAction = (preferredButton == cancelButton) ? alertAction : nil;
	
	for(NSUInteger i = 0; i < otherButtons.count; i++) {
		JFSheetDialogButton* button = otherButtons[i];
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
	
	JFSheetDialog* owner = self.owner;
	owner.presenting = NO;
	[owner notifyDidPresent];
}

- (void)alertControllerDidDisappear:(JFAlertController*)sender
{
	JFSheetDialog* owner = self.owner;
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
	JFSheetDialog* owner = self.owner;
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
@implementation JFSheetDialogActionSheetImplementation

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize actionSheet = _actionSheet;
@synthesize buttons = _buttons;
@synthesize dismissClosure = _dismissClosure;
@synthesize presentClosure = _presentClosure;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem*)barButtonItem closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentFromRect:(CGRect)rect inView:(UIView*)view closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentFromTabBar:(UITabBar*)tabBar closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentFromToolbar:(UIToolbar*)toolbar closure:(JFClosure* _Nullable)closure
{
	return NO;
}

- (BOOL)presentInView:(UIView*)view closure:(JFClosure* _Nullable)closure
{
	return NO;
}

@end
#	pragma GCC diagnostic pop
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFSheetDialogButton

// =================================================================================================
// MARK: Properties
// =================================================================================================

@synthesize action = _action;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)newWithTitle:(NSString*)title action:(JFSheetDialogButtonAction _Nullable)action
{
	return [[self alloc] initWithTitle:title action:action];
}

- (instancetype)initWithTitle:(NSString*)title action:(JFSheetDialogButtonAction _Nullable)action
{
	self = [super initWithTitle:title];
	_action = action;
	return self;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
