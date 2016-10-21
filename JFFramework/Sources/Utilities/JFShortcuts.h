//
//	The MIT License (MIT)
//
//	Copyright © 2015-2016 Jacopo Filié
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



#import	"JFPreprocessorMacros.h"
#import "JFString.h"
#import "JFTypes.h"
#import "JFUtilities.h"



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
#define CurrentDevice				JF.currentDevice
#define CurrentDeviceOrientation	JF.currentDeviceOrientation
#define CurrentInterfaceOrientation	JF.currentInterfaceOrientation
#define MainScreen					JF.mainScreen
#endif

#if JF_MACOS
// MARK: Macros (Generic - macOS)
#define SharedWorkspace	JF.sharedWorkspace
#endif

#if JF_TVOS
// MARK: Macros (Generic - tvOS)
#define CurrentDevice	JF.currentDevice
#define MainScreen		JF.mainScreen
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


#if JF_IOS
// MARK: Macros (Version - iOS)
#define iOS(_version)		[JF isIOS:_version]
#define iOSPlus(_version)	[JF isIOSPlus:_version]
#define iOS6				JF.isIOS6
#define iOS6Plus			JF.isIOS6Plus
#define iOS7				JF.isIOS7
#define iOS7Plus			JF.isIOS7Plus
#define iOS8				JF.isIOS8
#define iOS8Plus			JF.isIOS8Plus
#define iOS9				JF.isIOS9
#define iOS9Plus			JF.isIOS9Plus
#define iOS10				JF.isIOS10
#define iOS10Plus			JF.isIOS10Plus
#endif

#if JF_MACOS
// MARK: Macros (Version - macOS)
#define macOS(_version)		[JF isMacOS:_version]
#define macOSPlus(_version)	[JF isMacOSPlus:_version]
#define macOS10_6			JF.isMacOS10_6
#define macOS10_6Plus		JF.isMacOS10_6Plus
#define macOS10_7			JF.isMacOS10_7
#define macOS10_7Plus		JF.isMacOS10_7Plus
#define macOS10_8			JF.isMacOS10_8
#define macOS10_8Plus		JF.isMacOS10_8Plus
#define macOS10_9			JF.isMacOS10_9
#define macOS10_9Plus		JF.isMacOS10_9Plus
#define macOS10_10			JF.isMacOS10_10
#define macOS10_10Plus		JF.isMacOS10_10Plus
#define macOS10_11			JF.isMacOS10_11
#define macOS10_11Plus		JF.isMacOS10_11Plus
#define macOS10_12			JF.isMacOS10_12
#define macOS10_12Plus		JF.isMacOS10_12Plus
#endif

#if JF_TVOS
// MARK: Macros (Version - tvOS)
#define tvOS(_version)		[JF isTVOS:_version]
#define tvOSPlus(_version)	[JF isTVOSPlus:_version]
#define tvOS9				JF.isTVOS9
#define tvOS9Plus			JF.isTVOS9Plus
#define tvOS10				JF.isTVOS10
#define tvOS10Plus			JF.isTVOS10Plus
#endif

#endif // JF_SHORTCUTS_ENABLED

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

@interface JF : NSObject

// MARK: Generic
+ (id<JFApplicationDelegate>)	applicationDelegate;
+ (NSBundle*)					mainBundle;
+ (NSNotificationCenter*)		mainNotificationCenter;
+ (NSOperationQueue*)			mainOperationQueue;
+ (NSProcessInfo*)				processInfo;
+ (JFApplication*)				sharedApplication;

#if JF_IOS
// MARK: Generic (iOS)
+ (UIDevice*)				currentDevice;
+ (UIDeviceOrientation)		currentDeviceOrientation;
+ (UIInterfaceOrientation)	currentInterfaceOrientation;
+ (UIScreen*)				mainScreen;
#endif

#if JF_MACOS
// MARK: Generic (macOS)
+ (NSWorkspace*)	sharedWorkspace;
#endif

#if JF_TVOS
// MARK: Generic (tvOS)
+ (UIDevice*)	currentDevice;
+ (UIScreen*)	mainScreen;
#endif

// MARK: Info
+ (NSString*)	appBuild;
+ (NSString*)	appDetailedVersion;
+ (NSString*)	appDisplayName;
+ (NSString*)	appIdentifier;
+ (NSString*)	appLaunchStoryboard;
+ (NSString*)	appName;
+ (NSString*)	appMainStoryboard;
+ (NSString*)	appVersion;

#if JF_IOS || JF_TVOS
// MARK: System
+ (BOOL)					isAppleTV;
+ (BOOL)					isCarPlay;
+ (BOOL)					isIPad;
+ (BOOL)					isIPhone;
+ (NSString*)				systemVersion;
+ (UIUserInterfaceIdiom)	userInterfaceIdiom;
#endif

#if JF_IOS
// MARK: Version (iOS)
+ (BOOL)	isIOS:(JFVersion*)majorVersion;
+ (BOOL)	isIOSPlus:(JFVersion*)majorVersion;
+ (BOOL)	isIOS6;
+ (BOOL)	isIOS6Plus;
+ (BOOL)	isIOS7;
+ (BOOL)	isIOS7Plus;
+ (BOOL)	isIOS8;
+ (BOOL)	isIOS8Plus;
+ (BOOL)	isIOS9;
+ (BOOL)	isIOS9Plus;
+ (BOOL)	isIOS10;
+ (BOOL)	isIOS10Plus;
#endif

#if JF_MACOS
// MARK: Version (macOS)
+ (BOOL)	isMacOS:(JFVersion*)majorVersion;
+ (BOOL)	isMacOSPlus:(JFVersion*)majorVersion;
+ (BOOL)	isMacOS10_6;
+ (BOOL)	isMacOS10_6Plus;
+ (BOOL)	isMacOS10_7;
+ (BOOL)	isMacOS10_7Plus;
+ (BOOL)	isMacOS10_8;
+ (BOOL)	isMacOS10_8Plus;
+ (BOOL)	isMacOS10_9;
+ (BOOL)	isMacOS10_9Plus;
+ (BOOL)	isMacOS10_10;
+ (BOOL)	isMacOS10_10Plus;
+ (BOOL)	isMacOS10_11;
+ (BOOL)	isMacOS10_11Plus;
+ (BOOL)	isMacOS10_12;
+ (BOOL)	isMacOS10_12Plus;
#endif

#if JF_TVOS
// MARK: Version (tvOS)
+ (BOOL)	isTVOS:(JFVersion*)majorVersion;
+ (BOOL)	isTVOSPlus:(JFVersion*)majorVersion;
+ (BOOL)	isTVOS9;
+ (BOOL)	isTVOS9Plus;
+ (BOOL)	isTVOS10;
+ (BOOL)	isTVOS10Plus;
#endif

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
