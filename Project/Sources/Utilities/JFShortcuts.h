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

#import "JFPreprocessorMacros.h"

@import Foundation;

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

#import "JFStrings.h"
#import "JFUtilities.h"

@class AppDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros - Compatibility aliases
// =================================================================================================

#if JF_IOS

/**
 * An alias for the `UIApplication` class.
 */
#	define JFApplication UIApplication

/**
 * An alias for the `UIApplicationDelegate` protocol.
 */
#	define JFApplicationDelegate UIApplicationDelegate

/**
 * An alias for the `UIWindow` class.
 */
#	define JFWindow UIWindow

#endif

#if JF_MACOS

/**
 * An alias for the `NSApplication` class.
 */
#	define JFApplication NSApplication

/**
 * An alias for the `NSApplicationDelegate` protocol.
 */
#	define JFApplicationDelegate NSApplicationDelegate

/**
 * An alias for the `NSWindow` class.
 */
#	define JFWindow NSWindow

#endif

// =================================================================================================
// MARK: Macros - Memory management
// =================================================================================================

#if JF_WEAK_ENABLED

/**
 * Creates a new strong reference variable of the same type of `_var`; the name of this variable is composed by appending the parameter `_suffix` to the word `strong`.
 * @param _var The variable to convert to a strong reference variable.
 * @param _suffix The suffix component of the new reference variable name.
 */
#	define JFStrongify(_var, _suffix) __typeof(_var) __strong strong ## _suffix = _var

/**
 * Creates a new strong reference variable of the same type of `weakSelf`, called `strongSelf`.
 * @warning You should use this macro only if you already used the macro `JFWeakifySelf` in the same scope.
 */
#	define JFStrongifySelf JFStrongify(weakSelf, Self)

/**
 * Creates a new weak reference variable of the same type of `_var`; the name of this variable is composed by appending the parameter `_suffix` to the word `weak`.
 * @param _var The variable to convert to a weak reference variable.
 * @param _suffix The suffix component of the new reference variable name.
 */
#	define JFWeakify(_var, _suffix) __typeof(_var) __weak weak ## _suffix = _var

/**
 * Creates a new weak reference variable of the same type of `self`, called `weakSelf`.
 * @warning You should always use this macro before using the macro `JFStrongifySelf` in the same scope.
 */
#	define JFWeakifySelf JFWeakify(self, Self)

#endif

// =================================================================================================
// MARK: Macros - Shortcuts
// =================================================================================================

#if JF_SHORTCUTS_ENABLED

/**
 * Returns the value associated with the `Info.plist` key `CFBundleVersion`.
 */
#	define AppInfoBuildVersion JFApplicationInfoForKey(@"CFBundleVersion")

/**
 * Returns the value associated with the `Info.plist` key `CFBundleDisplayName`.
 */
#	define AppInfoDisplayName JFApplicationInfoForKey(@"CFBundleDisplayName")

/**
 * Returns the value associated with the `Info.plist` key `CFBundleIdentifier`.
 */
#	define AppInfoIdentifier JFApplicationInfoForKey(@"CFBundleIdentifier")

/**
 * Returns the value associated with the `Info.plist` key `UILaunchStoryboardName`.
 */
#	define AppInfoLaunchStoryboardName JFApplicationInfoForKey(@"UILaunchStoryboardName")

/**
 * Returns the value associated with the `Info.plist` key `UIMainStoryboardFile`.
 */
#	define AppInfoMainStoryboardName JFApplicationInfoForKey(@"UIMainStoryboardFile")

/**
 * Returns the value associated with the `Info.plist` key `CFBundleName`.
 */
#	define AppInfoName JFApplicationInfoForKey(@"CFBundleName")

/**
 * Returns the value associated with the `Info.plist` key `CFBundleShortVersionString`.
 */
#	define AppInfoReleaseVersion JFApplicationInfoForKey(@"CFBundleShortVersionString")

/**
 * Returns the application version string.
 */
#	define AppInfoVersion [JFShortcuts appVersion]

/**
 * Returns whether the current device is an Apple TV.
 */
#	if JF_IOS
#		define AppleTV [JFShortcuts isAppleTVDevice]
#	endif

/**
 * Returns the application delegate object.
 */
#	define	ApplicationDelegate [JFShortcuts appDelegate]

/**
 * Returns whether the current device is a CarPlay.
 */
#	if JF_IOS
#		define CarPlay [JFShortcuts isCarPlayDevice]
#	endif

/**
 * Returns the bundle for the current class.
 */
#	define ClassBundle [NSBundle bundleForClass:[self class]]

/**
 * Returns the name of the current class.
 */
#	define ClassName NSStringFromClass([self class])

#	if JF_IOS

/**
 * Returns the current device object.
 */
#		define CurrentDevice [UIDevice currentDevice]

/**
 * Returns the current device orientation.
 */
#		define CurrentDeviceOrientation [CurrentDevice orientation]

/**
 * Returns the current interface orientation.
 */
#		define CurrentInterfaceOrientation [SharedApplication statusBarOrientation]

/**
 * Returns whether the current device is an iPad.
 */
#		define iPad [JFShortcuts isIPadDevice]

/**
 * Returns whether the current device is a iPhone.
 */
#		define iPhone [JFShortcuts isIPhoneDevice]

#	endif

/**
 * Returns whether the current method is overriding the implementation of the superclass.
 */
#	define IsOverridingSuperclassImplementation [self.class.superclass instancesRespondToSelector:_cmd]

/**
 * Logs to console the current class name, instance pointer and method name.
 */
#	define LogMethod NSLog(@"%@ (%@): executing '%@'.", ClassName, JFStringFromPointer(self), MethodName)

/**
 * Returns the main bundle object.
 */
#	define MainBundle [NSBundle mainBundle]

/**
 * Returns the default notification center.
 */
#	define MainNotificationCenter [NSNotificationCenter defaultCenter]

/**
 * Returns the operation queue associated with the main thread.
 */
#	define MainOperationQueue [NSOperationQueue mainQueue]

/**
 * Returns the main screen object.
 */
#	if JF_IOS
#		define MainScreen [UIScreen mainScreen]
#	endif

/**
 * Returns the current method name.
 */
#	define MethodName NSStringFromSelector(_cmd)

/**
 * Returns the current process info.
 */
#	define ProcessInfo [NSProcessInfo processInfo]

/**
 * Returns the singleton application object.
 */
#	define SharedApplication [JFApplication sharedApplication]

/**
 * Returns the singleton workspace object.
 */
#	if JF_MACOS
#		define SharedWorkspace [NSWorkspace sharedWorkspace]
#	endif

#	if JF_IOS

/**
 * Returns the current operating system version string.
 */
#		define SystemVersion [CurrentDevice systemVersion]

/**
 * Returns the current user interface idiom.
 */
#		define UserInterfaceIdiom [CurrentDevice userInterfaceIdiom]

/**
 * Returns a combination of view autoresizing flags to set all margins as flexible.
 */
#		define ViewAutoresizingFlexibleMargins [JFShortcuts viewAutoresizingFlexibleMargins]

/**
 * Returns a combination of view autoresizing flags to set both width and height as flexible.
 */
#		define ViewAutoresizingFlexibleSize [JFShortcuts viewAutoresizingFlexibleSize]

#	endif

#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * A container for all the shortcuts that need some work before returning the result.
 */
@interface JFShortcuts : NSObject

// =================================================================================================
// MARK: Properties - Application
// =================================================================================================

/**
 * Returns the application delegate: if it's not an instance of the class `AppDelegate`, or that class does not even exist, it returns `nil`.
 */
@property (class, assign, nonatomic, readonly, nullable) AppDelegate* appDelegate;

/**
 * Returns the application version string using the following format:
 * @code
 *    <release> (<build>)
 * @endcode
 * The `release` component is retrieved using the shortcut `AppInfoReleaseVersion`. The `build` component is retrieved using the shortcut `AppInfoBuildVersion`.
 */
@property (class, assign, nonatomic, readonly, nullable) NSString* appVersion;

// =================================================================================================
// MARK: Properties - System
// =================================================================================================

#if JF_IOS

/**
 * Returns whether the current device is an Apple TV.
 */
@property (class, assign, nonatomic, readonly, getter=isAppleTVDevice) BOOL appleTVDevice;

/**
 * Returns whether the current device is a CarPlay.
 */
@property (class, assign, nonatomic, readonly, getter=isCarPlayDevice) BOOL carPlayDevice;

/**
 * Returns whether the current device is an iPad.
 */
@property (class, assign, nonatomic, readonly, getter=isIPadDevice) BOOL iPadDevice;

/**
 * Returns whether the current device is an iPhone.
 */
@property (class, assign, nonatomic, readonly, getter=isIPhoneDevice) BOOL iPhoneDevice;

#endif

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

#if JF_IOS

/**
 * Returns a combination of view autoresizing flags to set all margins as flexible.
 */
@property (class, assign, nonatomic, readonly) UIViewAutoresizing viewAutoresizingFlexibleMargins;

/**
 * Returns a combination of view autoresizing flags to set both width and height as flexible.
 */
@property (class, assign, nonatomic, readonly) UIViewAutoresizing viewAutoresizingFlexibleSize;

#endif

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
