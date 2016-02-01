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
#import "JFUtilities.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Macros

#define	ApplicationDelegate		((AppDelegate*)[SharedApplication delegate])
#define	ClassBundle				[NSBundle bundleForClass:[self class]]
#define	ClassName				NSStringFromClass([self class])
#define	LogMethod				NSLog(@"%@ (%@): executing '%@'.", ClassName, JFStringFromPointerOfObject(self), MethodName)
#define MainBundle				[NSBundle mainBundle]
#define MainNotificationCenter	[NSNotificationCenter defaultCenter]
#define MainOperationQueue		[NSOperationQueue mainQueue]
#define MethodName				NSStringFromSelector(_cmd)
#define ProcessInfo				[NSProcessInfo processInfo]

#if JF_TARGET_OS_OSX
#define	SharedApplication			NSApp
#define	SharedWorkspace				[NSWorkspace sharedWorkspace]
#else
#define CurrentDevice				[UIDevice currentDevice]
#if JF_TARGET_OS_IOS
#define CurrentDeviceOrientation	[CurrentDevice orientation]
#define CurrentStatusBarOrientation	[SharedApplication statusBarOrientation]
#endif
#define MainScreen					[UIScreen mainScreen]
#define	SharedApplication			[UIApplication sharedApplication]
#endif


#pragma mark Macros (Info)

#define AppBuild			JFApplicationInfoForKey(@"CFBundleVersion")
#define AppDetailedVersion	[NSString stringWithFormat:@"%@ (%@)", AppVersion, AppBuild]
#define AppDisplayName		JFApplicationInfoForKey(@"CFBundleDisplayName")
#define AppIdentifier		JFApplicationInfoForKey(@"CFBundleIdentifier")
#define AppLaunchStoryboard	JFApplicationInfoForKey(@"UILaunchStoryboardName")
#define AppName				JFApplicationInfoForKey(@"CFBundleName")
#define AppMainStoryboard	JFApplicationInfoForKey(@"UIMainStoryboardFile")
#define AppVersion			JFApplicationInfoForKey(@"CFBundleShortVersionString")


#pragma mark Macros (System)

#if !JF_TARGET_OS_OSX
#define AppleTV				(UserInterfaceIdiom == UIUserInterfaceIdiomTV)
#define iPad				(UserInterfaceIdiom == UIUserInterfaceIdiomPad)
#define iPhone				(UserInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define SystemVersion		[CurrentDevice systemVersion]
#define UserInterfaceIdiom	[CurrentDevice userInterfaceIdiom]
#endif


#pragma mark Macros (Version)

#if JF_TARGET_OS_IOS
#define iOS(_version)		JFCheckSystemVersion(_version, JFRelationEqual)
#define iOSPlus(_version)	JFCheckSystemVersion(_version, JFRelationGreaterThanOrEqual)
#define iOS6				iOS(@"6")
#define iOS6Plus			iOSPlus(@"6")
#define iOS7				iOS(@"7")
#define iOS7Plus			iOSPlus(@"7")
#define iOS8				iOS(@"8")
#define iOS8Plus			iOSPlus(@"8")
#define iOS9				iOS(@"9")
#define iOS9Plus			iOSPlus(@"9")
#endif

#if JF_TARGET_OS_OSX
#define OSX(_version)		JFCheckSystemVersion(_version, JFRelationEqual)
#define OSXPlus(_version)	JFCheckSystemVersion(_version, JFRelationGreaterThanOrEqual)
#define OSX10_6				OSX(@"10.6")
#define OSX10_6Plus			OSXPlus(@"10.6")
#define OSX10_7				OSX(@"10.7")
#define OSX10_7Plus			OSXPlus(@"10.7")
#define OSX10_8				OSX(@"10.8")
#define OSX10_8Plus			OSXPlus(@"10.8")
#define OSX10_9				OSX(@"10.9")
#define OSX10_9Plus			OSXPlus(@"10.9")
#define OSX10_10			OSX(@"10.10")
#define OSX10_10Plus		OSXPlus(@"10.10")
#define OSX10_11			OSX(@"10.11")
#define OSX10_11Plus		OSXPlus(@"10.11")
#endif

#if JF_TARGET_OS_TV
#define tvOS(_version)		JFCheckSystemVersion(_version, JFRelationEqual)
#define tvOSPlus(_version)	JFCheckSystemVersion(_version, JFRelationGreaterThanOrEqual)
#define tvOS9				tvOS(@"9")
#define tvOS9Plus			tvOSPlus(@"9")
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
