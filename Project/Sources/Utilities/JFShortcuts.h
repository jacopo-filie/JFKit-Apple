//
//	The MIT License (MIT)
//
//	Copyright © 2015-2017 Jacopo Filié
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

#import	"JFPreprocessorMacros.h"
#import "JFString.h"
#import "JFTypes.h"
#import "JFUtilities.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@class AppDelegate;
@class JFVersion;

////////////////////////////////////////////////////////////////////////////////////////////////////

#if JF_SHORTCUTS_ENABLED

// MARK: Macros (Generic)
#define	ApplicationDelegate		JF.applicationDelegate
#define	ClassBundle				[NSBundle bundleForClass:[self class]]
#define	ClassName				NSStringFromClass([self class])
#define	LogMethod				NSLog(@"%@ (%@): executing '%@'.", ClassName, JFStringFromPointerOfObject(self), MethodName)
#define MainBundle				JF.mainBundle
#define MainNotificationCenter	JF.mainNotificationCenter
#define MainOperationQueue		JF.mainOperationQueue
#define MethodName				NSStringFromSelector(_cmd)
#define ProcessInfo				JF.processInfo
#define	SharedApplication		JF.sharedApplication

#if JF_IOS
// MARK: Macros (Generic - iOS)
#define CurrentDevice					JF.currentDevice
#define CurrentDeviceOrientation		JF.currentDeviceOrientation
#define CurrentInterfaceOrientation		JF.currentInterfaceOrientation
#define MainScreen						JF.mainScreen
#define ViewAutoresizingFlexibleMargins	JF.viewAutoresizingFlexibleMargins
#define ViewAutoresizingFlexibleSize	JF.viewAutoresizingFlexibleSize
#endif

#if JF_MACOS
// MARK: Macros (Generic - macOS)
#define SharedWorkspace	JF.sharedWorkspace
#endif

#if JF_TVOS
// MARK: Macros (Generic - tvOS)
#define CurrentDevice					JF.currentDevice
#define MainScreen						JF.mainScreen
#define ViewAutoresizingFlexibleMargins	JF.viewAutoresizingFlexibleMargins
#define ViewAutoresizingFlexibleSize	JF.viewAutoresizingFlexibleSize
#endif

// MARK: Macros (Info)
#define AppBuild			JF.appBuild
#define AppDetailedVersion	JF.appDetailedVersion
#define AppDisplayName		JF.appDisplayName
#define AppIdentifier		JF.appIdentifier
#define AppLaunchStoryboard	JF.appLaunchStoryboard
#define AppName				JF.appName
#define AppMainStoryboard	JF.appMainStoryboard
#define AppVersion			JF.appVersion

#if JF_IOS || JF_TVOS
// MARK: Macros (System)
#define AppleTV				JF.isAppleTV
#define CarPlay				JF.isCarPlay
#define iPad				JF.isIPad
#define iPhone				JF.isIPhone
#define SystemVersion		JF.systemVersion
#define UserInterfaceIdiom	JF.userInterfaceIdiom
#endif

#endif // JF_SHORTCUTS_ENABLED

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JF : NSObject

// MARK: Generic
+ (AppDelegate* __nullable)			applicationDelegate;
+ (NSBundle*)				mainBundle;
+ (NSNotificationCenter*)	mainNotificationCenter;
+ (NSOperationQueue*)		mainOperationQueue;
+ (NSProcessInfo*)			processInfo;
+ (JFApplication*)			sharedApplication;

#if JF_IOS
// MARK: Generic (iOS)
+ (UIDevice*)				currentDevice;
+ (UIDeviceOrientation)		currentDeviceOrientation;
+ (UIInterfaceOrientation)	currentInterfaceOrientation;
+ (UIScreen*)				mainScreen;
+ (UIViewAutoresizing)		viewAutoresizingFlexibleMargins;
+ (UIViewAutoresizing)		viewAutoresizingFlexibleSize;
#endif

#if JF_MACOS
// MARK: Generic (macOS)
+ (NSWorkspace*)	sharedWorkspace;
#endif

#if JF_TVOS
// MARK: Generic (tvOS)
+ (UIDevice*)			currentDevice;
+ (UIScreen*)			mainScreen;
+ (UIViewAutoresizing)	viewAutoresizingFlexibleMargins;
+ (UIViewAutoresizing)	viewAutoresizingFlexibleSize;
#endif

// MARK: Info
+ (NSString* __nullable)	appBuild;
+ (NSString* __nullable)	appDetailedVersion;
+ (NSString* __nullable)	appDisplayName;
+ (NSString* __nullable)	appIdentifier;
+ (NSString* __nullable)	appLaunchStoryboard;
+ (NSString* __nullable)	appName;
+ (NSString* __nullable)	appMainStoryboard;
+ (NSString* __nullable)	appVersion;

#if JF_IOS || JF_TVOS
// MARK: System
+ (BOOL)					isAppleTV;
+ (BOOL)					isCarPlay;
+ (BOOL)					isIPad;
+ (BOOL)					isIPhone;
+ (NSString*)				systemVersion;
+ (UIUserInterfaceIdiom)	userInterfaceIdiom;
#endif

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
