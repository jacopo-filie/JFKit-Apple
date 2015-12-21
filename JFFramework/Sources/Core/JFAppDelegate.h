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



#import "JFPreprocessorMacros.h"



@class JFErrorsManager;



#if JF_TARGET_OS_OSX
@interface JFAppDelegate : NSObject <NSApplicationDelegate>
#else
@interface JFAppDelegate : UIResponder <UIApplicationDelegate>
#endif

#pragma mark Properties

// Errors
@property (strong)	JFErrorsManager*	errorsManager;

#pragma mark Properties

// User interface
#if JF_TARGET_OS_OSX
@property (strong, nonatomic)	IBOutlet	NSWindow*	window;
#else
@property (strong, nonatomic)	IBOutlet	UIWindow*	window;
#endif

@end



#pragma mark



#if JF_TARGET_OS_OSX
@interface JFAppDelegate (NSApplicationDelegate)

#pragma mark Methods

// Protocol implementation (NSApplicationDelegate)
- (void)	applicationDidBecomeActive:(NSNotification*)notification;
- (void)	applicationDidFinishLaunching:(NSNotification*)notification;
- (void)	applicationDidHide:(NSNotification*)notification;
- (void)	applicationDidResignActive:(NSNotification*)notification;
- (void)	applicationDidUnhide:(NSNotification*)notification;
- (void)	applicationWillBecomeActive:(NSNotification*)notification;
- (void)	applicationWillHide:(NSNotification*)notification;
- (void)	applicationWillResignActive:(NSNotification*)notification;
- (void)	applicationWillTerminate:(NSNotification *)notification;
- (void)	applicationWillUnhide:(NSNotification*)notification;

@end
#endif



#pragma mark



#if !JF_TARGET_OS_OSX
@interface JFAppDelegate (UIApplicationDelegate)

#pragma mark Methods

// Protocol implementation (UIApplicationDelegate)
- (BOOL)	application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
- (void)	applicationDidBecomeActive:(UIApplication*)application;
- (void)	applicationDidEnterBackground:(UIApplication*)application;
- (void)	applicationDidReceiveMemoryWarning:(UIApplication*)application;
- (void)	applicationWillEnterForeground:(UIApplication*)application;
- (void)	applicationWillResignActive:(UIApplication*)application;
- (void)	applicationWillTerminate:(UIApplication*)application;

@end
#endif
