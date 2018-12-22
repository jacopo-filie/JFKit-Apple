//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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

////////////////////////////////////////////////////////////////////////////////////////////////////

#import "JFAlert.h"

#import "JFShortcuts.h"
#import "JFVersion.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

#if JF_IOS
@interface JFAlert () <UIActionSheetDelegate, UIAlertViewDelegate>
#elif JF_MACOS
@interface JFAlert ()
#endif

// =================================================================================================
// MARK: Properties - Blocks
// =================================================================================================

@property (copy, nonatomic, nullable) JFBlock dismissCompletion;
@property (copy, nonatomic, nullable) JFBlock presentCompletion;

// =================================================================================================
// MARK: Properties - Flags
// =================================================================================================

#if JF_MACOS
@property (assign, nonatomic, getter=isApplicationModal) BOOL applicationModal;
#endif
@property (assign, nonatomic, readwrite, getter=isVisible) BOOL visible;

// =================================================================================================
// MARK: Properties - Timing
// =================================================================================================

@property (strong, nonatomic, nullable) NSTimer* timer;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

#if JF_IOS
@property (strong, nonatomic, nullable) UIActionSheet* actionSheet;
@property (strong, nonatomic, nullable) UIAlertView* alertView;
#elif JF_MACOS
@property (strong, nonatomic, nullable) NSAlert* alertView;
#endif
@property (strong, nonatomic, nullable) NSArray* currentButtons;

// =================================================================================================
// MARK: Methods - Data management
// =================================================================================================

- (JFAlertButton* __nullable)buttonAtIndex:(NSInteger)buttonIndex;

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

- (void)notifyDidDismissWithButton:(JFAlertButton* __nullable)button;
- (void)notifyDidPresent;
- (void)notifyWillDismissWithButton:(JFAlertButton* __nullable)button;
- (void)notifyWillPresent;

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

#if JF_IOS
- (BOOL)prepareActionSheet:(JFBlock __nullable)completion;
#endif
- (BOOL)prepareAlertView:(JFBlock __nullable)completion;

// =================================================================================================
// MARK: Methods - User interface management (Alerts)
// =================================================================================================

- (void)alert:(id)alert clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alert:(id)alert didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)alert:(id)alert willDismissWithButtonIndex:(NSInteger)buttonIndex;
#if JF_MACOS
- (void)alertDidEnd:(NSAlert*)alert returnCode:(NSModalResponse)returnCode contextInfo:(void* __nullable)contextInfo;
#endif
- (void)didPresentAlert:(id)alert;
- (void)willPresentAlert:(id)alert;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFAlert

// =================================================================================================
// MARK: Properties - Attributes
// =================================================================================================

#if JF_MACOS
@synthesize style = _style;
#endif

// =================================================================================================
// MARK: Properties - Blocks
// =================================================================================================

@synthesize dismissCompletion = _dismissCompletion;
@synthesize presentCompletion = _presentCompletion;

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize message = _message;
@synthesize title = _title;

// =================================================================================================
// MARK: Properties - Flags
// =================================================================================================

#if JF_MACOS
@synthesize applicationModal = _applicationModal;
#endif
@synthesize visible = _visible;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize delegate = _delegate;

// =================================================================================================
// MARK: Properties - Timing
// =================================================================================================

@synthesize timer = _timer;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

#if JF_IOS
@synthesize actionSheet = _actionSheet;
#endif
@synthesize alertView = _alertView;
@synthesize cancelButton = _cancelButton;
#if JF_IOS
@synthesize destructiveButton = _destructiveButton;
#endif
@synthesize currentButtons = _currentButtons;
@synthesize otherButtons = _otherButtons;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	
#if JF_MACOS
	_applicationModal = NO;
#endif
	_visible = NO;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data management
// =================================================================================================

- (JFAlertButton* __nullable)buttonAtIndex:(NSInteger)buttonIndex
{
	NSArray* buttons = self.currentButtons;
	if((buttonIndex < 0) || ((NSUInteger)buttonIndex >= [buttons count]))
		return nil;
	
	return [buttons objectAtIndex:(NSUInteger)buttonIndex];
}

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

- (void)notifyDidDismissWithButton:(JFAlertButton* __nullable)button
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alert:didDismissWithButton:)])
		[delegate alert:self didDismissWithButton:button];
}

- (void)notifyDidPresent
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alertDidPresent:)])
		[delegate alertDidPresent:self];
}

- (void)notifyWillDismissWithButton:(JFAlertButton* __nullable)button
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alert:willDismissWithButton:)])
		[delegate alert:self willDismissWithButton:button];
}

- (void)notifyWillPresent
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alertWillPresent:)])
		[delegate alertWillPresent:self];
}

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (BOOL)dismiss:(JFBlock __nullable)completion
{
	return [self dismissWithClickedButton:nil completion:completion];
}

- (BOOL)dismissWithClickedButton:(JFAlertButton* __nullable)button completion:(JFBlock __nullable)completion
{
	BOOL shouldAbort = (![self isVisible] || !self.alertView);
	
#if JF_IOS
	if(shouldAbort && self.actionSheet)
		shouldAbort = NO;
#endif
	
	if(shouldAbort)
		return NO;
	
	NSInteger index = 0;
	if(button)
	{
		NSArray* buttons = self.currentButtons;
		if([buttons containsObject:button])
			index = (NSInteger)[buttons indexOfObject:button];
		else
			button = nil;
	}
	
	self.dismissCompletion = completion;
	
	if(self.alertView)
	{
#if JF_IOS
		UIAlertView* alertView = self.alertView;
		NSInteger buttonIndex = (button ? index : [alertView cancelButtonIndex]);
		[self alert:alertView clickedButtonAtIndex:buttonIndex];
		[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
#elif JF_MACOS
		NSWindow* sheet = self.alertView.window;
		if(button)
		{
			NSModalResponse returnCode = NSAlertFirstButtonReturn + index;
			
			if([self isApplicationModal])
				[NSApp stopModalWithCode:returnCode];
			else
			{
				if(@available(macOS 10.9, *))
					[sheet.sheetParent endSheet:sheet returnCode:returnCode];
				else
					[NSApp endSheet:sheet returnCode:returnCode];
			}
		}
		else
		{
			if([self isApplicationModal])
				[NSApp stopModal];
			else
			{
				if(@available(macOS 10.9, *))
					[sheet.sheetParent endSheet:sheet];
				else
					[NSApp endSheet:sheet];
			}
		}
#endif
	}
#if JF_IOS
	else if(self.actionSheet)
	{
		UIActionSheet* actionSheet = self.actionSheet;
		NSInteger buttonIndex = (button ? index : [actionSheet cancelButtonIndex]);
		[self alert:actionSheet clickedButtonAtIndex:buttonIndex];
		[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
	}
#endif
	
	return YES;
}

#if JF_IOS

- (BOOL)prepareActionSheet:(JFBlock __nullable)completion
{
	if([self isVisible] || self.actionSheet || self.alertView)
		return NO;
	
	JFAlertButton* cancelButton = self.cancelButton;
	JFAlertButton* destructiveButton = self.destructiveButton;
	NSArray* otherButtons = self.otherButtons;
	
	NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:([otherButtons count] + 2)];
	if(destructiveButton)	[buttons addObject:destructiveButton];
	if(cancelButton)		[buttons addObject:cancelButton];
	if(otherButtons)		[buttons addObjectsFromArray:otherButtons];
	
	if([buttons count] == 0)
		return NO;
	
	self.presentCompletion = completion;
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:cancelButton.title destructiveButtonTitle:destructiveButton.title otherButtonTitles:nil];
	
	for(NSUInteger i = 0; i < [otherButtons count]; i++)
	{
		JFAlertButton* button = [otherButtons objectAtIndex:i];
		[actionSheet addButtonWithTitle:button.title];
	}
	
	self.actionSheet = actionSheet;
	self.currentButtons = [buttons copy];
	
	return YES;
}

#endif

- (BOOL)prepareAlertView:(JFBlock __nullable)completion
{
	if([self isVisible] || self.alertView)
		return NO;
	
#if JF_IOS
	if(self.actionSheet)
		return NO;
#endif
	
	JFAlertButton* cancelButton = self.cancelButton;
	if(!cancelButton)
		return NO;
	
	NSArray* otherButtons = self.otherButtons;
	
	NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:([otherButtons count] + 1)];
	[buttons addObject:cancelButton];
	if(otherButtons)
		[buttons addObjectsFromArray:otherButtons];
	
	self.presentCompletion = completion;
	
#if JF_IOS
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:cancelButton.title otherButtonTitles:nil];
#elif JF_MACOS
	NSAlert* alertView = [NSAlert new];
	alertView.informativeText = self.message;
	alertView.messageText = self.title;
	[alertView addButtonWithTitle:cancelButton.title];
#endif
	
	for(NSUInteger i = 0; i < [otherButtons count]; i++)
	{
		JFAlertButton* button = [otherButtons objectAtIndex:i];
		[alertView addButtonWithTitle:button.title];
	}
	
	self.alertView = alertView;
	self.currentButtons = [buttons copy];
	
	return YES;
}

#if JF_IOS

- (BOOL)presentAsActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem completion:(JFBlock __nullable)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromBarButtonItem:barButtonItem animated:YES];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromRect:(CGRect)rect inView:(UIView*)view completion:(JFBlock __nullable)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromRect:rect inView:view animated:YES];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromTabBar:(UITabBar*)tabBar completion:(JFBlock __nullable)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromTabBar:tabBar];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromToolbar:(UIToolbar*)toolbar completion:(JFBlock __nullable)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromToolbar:toolbar];
	
	return YES;
}

- (BOOL)presentAsActionSheetInView:(UIView*)view completion:(JFBlock __nullable)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showInView:view];
	
	return YES;
}

#elif JF_MACOS

- (BOOL)presentAsActionSheetForWindow:(NSWindow*)window completion:(JFBlock __nullable)completion
{
	if(![self prepareAlertView:completion])
		return NO;
	
	self.applicationModal = NO;
	
	NSAlert* alert = self.alertView;
	
	[self willPresentAlert:alert];
	
	if(@available(macOS 10.9, *))
	{
		void (^handler)(NSModalResponse) = ^(NSModalResponse returnCode)
		{
			[self alertDidEnd:alert returnCode:returnCode contextInfo:NULL];
		};
		
		[alert beginSheetModalForWindow:window completionHandler:handler];
	}
	else
	{
		SEL selector = @selector(alertDidEnd:returnCode:contextInfo:);
		
		[alert beginSheetModalForWindow:window modalDelegate:self didEndSelector:selector contextInfo:NULL];
	}
	
	[self didPresentAlert:alert];
	
	return YES;
}

#endif

- (BOOL)presentAsAlertView:(JFBlock __nullable)completion
{
	return [self presentAsAlertViewWithTimeout:0.0 completion:completion];
}

- (BOOL)presentAsAlertViewWithTimeout:(NSTimeInterval)timeout completion:(JFBlock __nullable)completion
{
	if(![self prepareAlertView:completion])
		return NO;
	
	if(timeout > 0.0)
	{
		SEL selector = @selector(dismiss:);
		
		NSMethodSignature* signature = [self methodSignatureForSelector:selector];
		NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
		invocation.selector = selector;
		invocation.target = self;
		
		self.timer = [NSTimer timerWithTimeInterval:timeout invocation:invocation repeats:NO];
	}
	
#if JF_IOS
	[self.alertView show];
#elif JF_MACOS
	self.applicationModal = YES;
	[MainOperationQueue addOperationWithBlock:^{
		NSAlert* alert = self.alertView;
		[self willPresentAlert:alert];
		[self didPresentAlert:alert];
		NSModalResponse returnCode = [alert runModal];
		[self alertDidEnd:alert returnCode:returnCode contextInfo:NULL];
	}];
#endif
	
	return YES;
}

// =================================================================================================
// MARK: Methods - User interface management (Alerts)
// =================================================================================================

- (void)alert:(id)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	JFAlertButton* button = [self buttonAtIndex:buttonIndex];
	if(button && button.action)
		button.action();
}

- (void)alert:(id)alert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.visible = NO;
	
	JFAlertButton* button = [self buttonAtIndex:buttonIndex];
	
#if JF_IOS
	self.actionSheet = nil;
#elif JF_MACOS
	self.applicationModal = NO;
#endif
	
	self.alertView = nil;
	self.currentButtons = nil;
	
	[self notifyDidDismissWithButton:button];
	
	if(self.dismissCompletion)
	{
		JFBlock completion = self.dismissCompletion;
		self.dismissCompletion = nil;
		completion();
	}
}

- (void)alert:(id)alert willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(self.timer)
	{
		[self.timer invalidate];
		self.timer = nil;
	}
	
	JFAlertButton* button = [self buttonAtIndex:buttonIndex];
	
	[self notifyWillDismissWithButton:button];
}

#if JF_MACOS

- (void)alertDidEnd:(NSAlert*)alert returnCode:(NSModalResponse)returnCode contextInfo:(void* __nullable)contextInfo
{
	if(returnCode < 0)
		returnCode = NSAlertFirstButtonReturn;
	
	NSInteger buttonIndex = returnCode - NSAlertFirstButtonReturn;
	
	[self alert:alert clickedButtonAtIndex:buttonIndex];
	[self alert:alert willDismissWithButtonIndex:buttonIndex];
	if(!macOS10_9Plus && ![self isApplicationModal])
		[alert.window orderOut:alert];
	[self alert:alert didDismissWithButtonIndex:buttonIndex];
}

#endif

- (void)didPresentAlert:(id)alert
{
	NSTimer* timer = self.timer;
	if(timer)
	{
#if JF_IOS
		NSString* runLoopMode = NSDefaultRunLoopMode;
#elif JF_MACOS
		NSString* runLoopMode = NSModalPanelRunLoopMode;
#endif
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:runLoopMode];
	}
	
	[self notifyDidPresent];
	
	if(self.presentCompletion)
	{
		JFBlock completion = self.presentCompletion;
		self.presentCompletion = nil;
		completion();
	}
}

- (void)willPresentAlert:(id)alert
{
	self.visible = YES;
	
	[self notifyWillPresent];
}

#if JF_IOS

// =================================================================================================
// MARK: Methods (UIActionSheetDelegate)
// =================================================================================================

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self alert:actionSheet clickedButtonAtIndex:buttonIndex];
}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:actionSheet didDismissWithButtonIndex:buttonIndex];
}

- (void)actionSheet:(UIActionSheet*)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:actionSheet willDismissWithButtonIndex:buttonIndex];
}

- (void)didPresentActionSheet:(UIActionSheet*)actionSheet
{
	[self didPresentAlert:actionSheet];
}

- (void)willPresentActionSheet:(UIActionSheet*)actionSheet
{
	[self willPresentAlert:actionSheet];
}

// =================================================================================================
// MARK: Methods (UIAlertViewDelegate)
// =================================================================================================

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self alert:alertView clickedButtonAtIndex:buttonIndex];
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:alertView didDismissWithButtonIndex:buttonIndex];
}

- (void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:alertView willDismissWithButtonIndex:buttonIndex];
}

- (void)didPresentAlertView:(UIAlertView*)alertView
{
	[self didPresentAlert:alertView];
}

- (void)willPresentAlertView:(UIAlertView*)alertView
{
	[self willPresentAlert:alertView];
}

#endif

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFAlertButton

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize action = _action;
@synthesize title = _title;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)buttonWithTitle:(NSString*)title
{
	return [self buttonWithTitle:title action:nil];
}

+ (instancetype)buttonWithTitle:(NSString*)title action:(JFBlock __nullable)action
{
	return [[self alloc] initWithTitle:title action:action];
}

- (instancetype)initWithTitle:(NSString*)title action:(JFBlock __nullable)action
{
	self = [super init];
	
	_action = action;
	_title = [title copy];
	
	return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
