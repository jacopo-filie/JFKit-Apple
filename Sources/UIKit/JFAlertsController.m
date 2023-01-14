//
//	The MIT License (MIT)
//
//	Copyright © 2015-2023 Jacopo Filié
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

#import "JFAlertsController.h"

@import JFKit;

#import "JFAlert.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFAlertsController (/* Private */) <JFAlertDelegate>

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@property (strong, nonatomic, readonly) NSMutableSet<JFAlert*>* alerts;

// =================================================================================================
// MARK: Methods - Layout (Action sheets)
// =================================================================================================

#if JF_IOS
- (JFAlert*)createActionSheetWithTitle:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;
#elif JF_MACOS
- (JFAlert*)createActionSheet:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton* _Nullable)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFAlertsController

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize alerts = _alerts;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (void)dealloc
{
	for(JFAlert* alert in self.alerts)
		[alert dismiss:nil];
}

- (instancetype)init
{
	self = [super init];
	
	_alerts = [NSMutableSet<JFAlert*> new];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Layout (Action sheets)
// =================================================================================================

#if JF_IOS
- (JFAlert*)createActionSheetWithTitle:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
#elif JF_MACOS
- (JFAlert*)createActionSheet:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton* _Nullable)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
#endif
{
	JFAlert* retVal = [JFAlert new];
	retVal.delegate = self;
	retVal.title = title;
	
#if JF_MACOS
	retVal.message = message;
	retVal.style = style;
#endif
	
	retVal.cancelButton = cancelButton;
	retVal.otherButtons = otherButtons;
	
#if JF_IOS
	retVal.destructiveButton = destructiveButton;
#endif
	
	return retVal;
}

#if JF_IOS

- (void)presentActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromBarButtonItem:barButtonItem completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetFromRect:(CGRect)rect inView:(UIView*)view title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromRect:rect inView:view completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetFromTabBar:(UITabBar*)tabBar title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromTabBar:tabBar completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetFromToolbar:(UIToolbar*)toolbar title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromToolbar:toolbar completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetInView:(UIView*)view title:(NSString* _Nullable)title cancelButton:(JFAlertButton* _Nullable)cancelButton destructiveButton:(JFAlertButton* _Nullable)destructiveButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetInView:view completion:nil])
			[self.alerts addObject:alert];
	});
}

#elif JF_MACOS

- (void)presentActionSheetForWindow:(NSWindow*)window style:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton* _Nullable)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	JFAlert* alert = [self createActionSheet:style title:title message:message cancelButton:cancelButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetForWindow:window completion:nil])
			[self.alerts addObject:alert];
	});
}

#endif

// =================================================================================================
// MARK: Methods - Layout (Alert views)
// =================================================================================================

#if JF_IOS
- (void)presentAlertViewForError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	[self presentAlertViewForError:error cancelButton:cancelButton otherButtons:otherButtons timeout:0.0];
}
#elif JF_MACOS
- (void)presentAlertView:(NSAlertStyle)style forError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	[self presentAlertView:style forError:error cancelButton:cancelButton otherButtons:otherButtons timeout:0.0];
}
#endif

#if JF_IOS
- (void)presentAlertViewForError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout
#elif JF_MACOS
- (void)presentAlertView:(NSAlertStyle)style forError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout
#endif
{
	NSString* failureReason = [error localizedFailureReason];
	NSString* recoverySuggestion = [error localizedRecoverySuggestion];
	
	NSString* message = nil;
	if(failureReason || recoverySuggestion)
	{
		NSMutableArray* components = [NSMutableArray arrayWithCapacity:2];
		if(failureReason)
			[components addObject:failureReason];
		if(recoverySuggestion)
			[components addObject:recoverySuggestion];
		
		message = [components componentsJoinedByString:@" "];
		if(JFStringIsEmpty(message))
			message = nil;
	}
	
	NSString* title = [error localizedDescription];
	
#if JF_IOS
	[self presentAlertViewWithTitle:title message:message cancelButton:cancelButton otherButtons:otherButtons timeout:timeout];
#elif JF_MACOS
	[self presentAlertView:style title:title message:message cancelButton:cancelButton otherButtons:otherButtons timeout:timeout];
#endif
}

#if JF_IOS

- (void)presentAlertViewWithTitle:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	[self presentAlertViewWithTitle:title message:message cancelButton:cancelButton otherButtons:otherButtons timeout:0.0];
}

- (void)presentAlertViewWithTitle:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout
{
	JFAlert* alert = [JFAlert new];
	alert.delegate = self;
	alert.message = message;
	alert.title = title;
	
	alert.cancelButton = cancelButton;
	alert.otherButtons = otherButtons;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsAlertViewWithTimeout:timeout completion:nil])
			[self.alerts addObject:alert];
	});
}

#elif JF_MACOS

- (void)presentAlertView:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons
{
	[self presentAlertView:style title:title message:message cancelButton:cancelButton otherButtons:otherButtons timeout:0.0];
}

- (void)presentAlertView:(NSAlertStyle)style title:(NSString* _Nullable)title message:(NSString* _Nullable)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>* _Nullable)otherButtons timeout:(NSTimeInterval)timeout
{
	JFAlert* alert = [JFAlert new];
	alert.delegate = self;
	alert.message = message;
	alert.style = style;
	alert.title = title;
	
	alert.cancelButton = cancelButton;
	alert.otherButtons = otherButtons;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsAlertViewWithTimeout:timeout completion:nil])
			[self.alerts addObject:alert];
	});
}

#endif

// =================================================================================================
// MARK: Methods (JFAlertViewDelegate) - Layout
// =================================================================================================

- (void)alert:(JFAlert*)alert didDismissWithButton:(JFAlertButton* _Nullable)button
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.alerts removeObject:alert];
	});
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
