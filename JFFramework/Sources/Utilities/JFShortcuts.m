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



#import "JFShortcuts.h"



@implementation JF

// =================================================================================================
// MARK: Generic
// =================================================================================================

+ (id<JFApplicationDelegate>)applicationDelegate
{
	Class class = NSClassFromString(@"AppDelegate");
	if(!class)
		return nil;
	
	id<JFApplicationDelegate> retObj = self.sharedApplication.delegate;
	if(!retObj || ![retObj isKindOfClass:class])
		return nil;
	
	return retObj;
}

#if JF_IOS || JF_TVOS
+ (UIDevice*)currentDevice
{
	return [UIDevice currentDevice];
}
#endif

#if JF_IOS
+ (UIDeviceOrientation)currentDeviceOrientation
{
	return self.currentDevice.orientation;
}
#endif

#if JF_IOS
+ (UIInterfaceOrientation)currentInterfaceOrientation
{
	return self.sharedApplication.statusBarOrientation;
}
#endif

+ (NSBundle*)mainBundle
{
	return [NSBundle mainBundle];
}

+ (NSNotificationCenter*)mainNotificationCenter
{
	return [NSNotificationCenter defaultCenter];
}

+ (NSOperationQueue*)mainOperationQueue
{
	return [NSOperationQueue mainQueue];
}

#if JF_IOS || JF_TVOS
+ (UIScreen*)mainScreen
{
	return [UIScreen mainScreen];
}
#endif

+ (NSProcessInfo*)processInfo
{
	return [NSProcessInfo processInfo];
}

+ (JFApplication*)sharedApplication
{
	return [JFApplication sharedApplication];
}

#if JF_MACOS
+ (NSWorkspace*)sharedWorkspace
{
	return [NSWorkspace sharedWorkspace];
}
#endif


// =================================================================================================
// MARK: Info
// =================================================================================================

+ (NSString*)appBuild
{
	return JFApplicationInfoForKey(@"CFBundleVersion");
}

+ (NSString*)appDetailedVersion
{
	return [NSString stringWithFormat:@"%@ (%@)", self.appVersion, self.appBuild];
}

+ (NSString*)appDisplayName
{
	return JFApplicationInfoForKey(@"CFBundleDisplayName");
}

+ (NSString*)appIdentifier
{
	return JFApplicationInfoForKey(@"CFBundleIdentifier");
}

+ (NSString*)appLaunchStoryboard
{
	return JFApplicationInfoForKey(@"UILaunchStoryboardName");
}

+ (NSString*)appName
{
	return JFApplicationInfoForKey(@"CFBundleName");
}

+ (NSString*)appMainStoryboard
{
	return JFApplicationInfoForKey(@"UIMainStoryboardFile");
}

+ (NSString*)appVersion
{
	return JFApplicationInfoForKey(@"CFBundleShortVersionString");
}


// =================================================================================================
// MARK: System
// =================================================================================================

#if JF_IOS || JF_TVOS
+ (BOOL)isAppleTV
{
	return (self.userInterfaceIdiom == UIUserInterfaceIdiomTV);
}
#endif

#if JF_IOS || JF_TVOS
+ (BOOL)isCarPlay
{
	return (self.userInterfaceIdiom == UIUserInterfaceIdiomCarPlay);
}
#endif

#if JF_IOS || JF_TVOS
+ (BOOL)isIPad
{
	return (self.userInterfaceIdiom == UIUserInterfaceIdiomPad);
}
#endif

#if JF_IOS || JF_TVOS
+ (BOOL)isIPhone
{
	return (self.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}
#endif

#if JF_IOS || JF_TVOS
+ (NSString*)systemVersion
{
	return self.currentDevice.systemVersion;
}
#endif

#if JF_IOS || JF_TVOS
+ (UIUserInterfaceIdiom)userInterfaceIdiom
{
	return self.currentDevice.userInterfaceIdiom;
}
#endif


// =================================================================================================
// MARK: Version
// =================================================================================================

#if JF_IOS
+ (BOOL)isIOS:(NSString*)version
{
	return JFCheckSystemVersion(version, JFRelationEqual);
}
#endif

#if JF_IOS
+ (BOOL)isIOSPlus:(NSString*)version
{
	return JFCheckSystemVersion(version, JFRelationGreaterThanOrEqual);
}
#endif

#if JF_IOS
+ (BOOL)isIOS6
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOS(@"6");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS6Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOSPlus(@"6");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS7
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOS(@"7");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS7Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOSPlus(@"7");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS8
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOS(@"8");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS8Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOSPlus(@"8");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS9
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOS(@"9");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS9Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOSPlus(@"9");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS10
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOS(@"10");
	});
	return retVal;
}
#endif

#if JF_IOS
+ (BOOL)isIOS10Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = iOSPlus(@"10");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS:(NSString*)version
{
	return JFCheckSystemVersion(version, JFRelationEqual);
}
#endif

#if JF_MACOS
+ (BOOL)isMacOSPlus:(NSString*)version
{
	return JFCheckSystemVersion(version, JFRelationGreaterThanOrEqual);
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_6
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOS(@"10.6");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_6Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOSPlus(@"10.6");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_7
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOS(@"10.7");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_7Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOSPlus(@"10.7");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_8
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOS(@"10.8");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_8Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOSPlus(@"10.8");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_9
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOS(@"10.9");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_9Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOSPlus(@"10.9");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_10
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOS(@"10.10");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_10Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOSPlus(@"10.10");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_11
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOS(@"10.11");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_11Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOSPlus(@"10.11");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_12
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOS(@"10.12");
	});
	return retVal;
}
#endif

#if JF_MACOS
+ (BOOL)isMacOS10_12Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = macOSPlus(@"10.12");
	});
	return retVal;
}
#endif

#if JF_TVOS
+ (BOOL)isTVOS:(NSString*)version
{
	return JFCheckSystemVersion(version, JFRelationEqual);
}
#endif

#if JF_TVOS
+ (BOOL)isTVOSPlus:(NSString*)version
{
	return JFCheckSystemVersion(version, JFRelationGreaterThanOrEqual);
}
#endif

#if JF_TVOS
+ (BOOL)isTVOS9
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = tvOS(@"9");
	});
	return retVal;
}
#endif

#if JF_TVOS
+ (BOOL)isTVOS9Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = tvOSPlus(@"9");
	});
	return retVal;
}
#endif

#if JF_TVOS
+ (BOOL)isTVOS10
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = tvOS(@"10");
	});
	return retVal;
}
#endif

#if JF_TVOS
+ (BOOL)isTVOS10Plus
{
	static BOOL retVal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retVal = tvOSPlus(@"10");
	});
	return retVal;
}
#endif

@end
