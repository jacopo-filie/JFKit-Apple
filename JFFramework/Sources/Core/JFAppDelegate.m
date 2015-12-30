//
//	The MIT License (MIT)
//
//	Copyright (c) 2015 Jacopo Filié
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



#import "JFAppDelegate.h"

#import "JFErrorsManager.h"
#import "JFLogger.h"
#import "JFShortcuts.h"
#import "JFWindowController.h"



@interface JFAppDelegate ()

#pragma mark Properties

// Relationships
@property (strong, nonatomic, readwrite)	JFWindowController*	windowController;

@end



#pragma mark



@implementation JFAppDelegate

#pragma mark Properties

// Errors
@synthesize errorsManager	= _errorsManager;

// Relationships
@synthesize windowController	= _windowController;

// User interface
@synthesize window	= _window;


#pragma mark Properties accessors (User interface)

- (JFWindow*)window
{
	if(!_window)
#if JF_TARGET_OS_OSX
		self.window = [NSWindow new];
#else
		self.window = [[UIWindow alloc] initWithFrame:MainScreen.bounds];
#endif
	
	return _window;
}

- (void)setWindow:(JFWindow*)window
{
	if(_window == window)
		return;
	
	_window = window;
	
	// Loads the user interface.
	JFWindowController* controller = nil;
	if(_window)
	{
		controller = [self createControllerForWindow:_window];
		if(!controller)
			controller = [[JFWindowController alloc] initWithWindow:_window];
	}
	self.windowController = controller;
}


#pragma mark User interface management

- (JFWindowController*)createControllerForWindow:(JFWindow*)window
{
	return nil;
}


#if JF_TARGET_OS_OSX
#pragma mark Protocol implementation (NSApplicationDelegate)

- (void)applicationDidBecomeActive:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did become active." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
	
	[self.window makeKeyAndOrderFront:self];
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did finish launching." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidHide:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did hide." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidResignActive:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did resign active." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidUnhide:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did unhide." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillBecomeActive:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will become active." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillHide:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will hide." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillResignActive:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will resign active." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will terminate." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillUnhide:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will unhide." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

#endif


#if !JF_TARGET_OS_OSX
#pragma mark Protocol implementation (UIApplicationDelegate)

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did finish launching." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
	
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did become active." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did enter background." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did receive memory warning." priority:JFLogPriority4Warning hashtags:(JFLogHashtagAttention | JFLogHashtagDeveloper)];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will enter foreground." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillResignActive:(UIApplication*)application;
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will resign active." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application will terminate." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
}

#endif

@end
