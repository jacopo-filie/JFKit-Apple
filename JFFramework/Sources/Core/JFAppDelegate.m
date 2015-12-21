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



@interface JFAppDelegate ()

@end



#pragma mark



@implementation JFAppDelegate

#pragma mark Properties

// Errors
@synthesize errorsManager	= _errorsManager;

// User interface
@synthesize window	= _window;

@end



#pragma mark



#if JF_TARGET_OS_OSX
@implementation JFAppDelegate (NSApplicationDelegate)

#pragma mark Protocol implementation (NSApplicationDelegate)

- (void)applicationDidBecomeActive:(NSNotification*)notification
{
	if(self.jf_shouldLog)
		[self.jf_logger logMessage:@"Application did become active." priority:JFLogPriority6Info hashtags:JFLogHashtagDeveloper];
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

@end
#endif



#pragma mark



#if !JF_TARGET_OS_OSX
@implementation JFAppDelegate (UIApplicationDelegate)

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

@end
#endif
