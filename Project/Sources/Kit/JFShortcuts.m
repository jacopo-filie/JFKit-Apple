//
//	The MIT License (MIT)
//
//	Copyright © 2015-2022 Jacopo Filié
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

#import "JFShortcuts.h"

#import <sys/utsname.h>

#import "JFBlocks.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFShortcuts

// =================================================================================================
// MARK: Properties (Accessors) - Application
// =================================================================================================

+ (AppDelegate* _Nullable)appDelegate
{
	Class class = NSClassFromString(@"AppDelegate");
	if(!class)
		return nil;
	
	AppDelegate* __block retObj = nil;
	
	JFBlock block = ^(void) {
		id<JFApplicationDelegate> delegate = SharedApplication.delegate;
		if(delegate && [delegate isKindOfClass:class])
			retObj = (AppDelegate*)delegate;
	};
	
	if([NSThread isMainThread])
		block();
	else
	{
		NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:block];
		[MainOperationQueue addOperation:operation];
		[operation waitUntilFinished];
	}
	
	return retObj;
}

+ (NSString* _Nullable)appVersion
{
	NSString* build = AppInfoBuildVersion;
	NSString* release = AppInfoReleaseVersion;
	
	BOOL isBuildValid = !JFStringIsNullOrEmpty(build);
	BOOL isReleaseValid = !JFStringIsNullOrEmpty(release);
	
	if(isBuildValid)
		return [NSString stringWithFormat:@"%@ (%@)", (isReleaseValid ? release : @"0.0"), build];
	else if(isReleaseValid)
		return release;
	
	return nil;
}

// =================================================================================================
// MARK: Properties - Operation queues
// =================================================================================================

+ (NSOperationQueue*)backgroundOperationQueue
{
	static NSOperationQueue* retObj;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = JFCreateConcurrentOperationQueue(JF_KIT_DOMAIN);
	});
	return retObj;
}

// =================================================================================================
// MARK: Properties - System
// =================================================================================================

#if JF_IOS

+ (BOOL)isAppleTVDevice
{
	if(@available(iOS 9.0, *))
		return (UserInterfaceIdiom == UIUserInterfaceIdiomTV);
	
	return NO;
}

+ (BOOL)isCarPlayDevice
{
	if(@available(iOS 9.0, *))
		return (UserInterfaceIdiom == UIUserInterfaceIdiomCarPlay);
	
	return NO;
}

+ (NSString*)deviceModelID
{
	static NSString* retObj;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		struct utsname systemInfo;
		uname(&systemInfo);
		retObj = JFStringFromCString(systemInfo.machine) ?: JFEmptyString;
	});
	return retObj;
}

+ (NSDictionary<NSString*, NSString*>*)deviceModelMap
{
	static NSDictionary<NSString*, NSString*>* retObj;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = @{
			// iPad
			@"iPad1,1":@"iPad",
			@"iPad1,2":@"iPad",
			@"iPad2,1":@"iPad 2",
			@"iPad2,2":@"iPad 2",
			@"iPad2,3":@"iPad 2",
			@"iPad2,4":@"iPad 2",
			@"iPad2,5":@"iPad Mini",
			@"iPad2,6":@"iPad Mini",
			@"iPad2,7":@"iPad Mini",
			@"iPad3,1":@"iPad 3",
			@"iPad3,2":@"iPad 3",
			@"iPad3,3":@"iPad 3",
			@"iPad3,4":@"iPad 4",
			@"iPad3,5":@"iPad 4",
			@"iPad3,6":@"iPad 4",
			@"iPad4,1":@"iPad Air",
			@"iPad4,2":@"iPad Air",
			@"iPad4,3":@"iPad Air",
			@"iPad4,4":@"iPad Mini 2",
			@"iPad4,5":@"iPad Mini 2",
			@"iPad4,6":@"iPad Mini 2",
			@"iPad4,7":@"iPad Mini 3",
			@"iPad4,8":@"iPad Mini 3",
			@"iPad4,9":@"iPad Mini 3",
			@"iPad5,1":@"iPad Mini 4",
			@"iPad5,2":@"iPad Mini 4",
			@"iPad5,3":@"iPad Air 2",
			@"iPad5,4":@"iPad Air 2",
			@"iPad6,3":@"iPad Pro 9.7 inch",
			@"iPad6,4":@"iPad Pro 9.7 inch",
			@"iPad6,7":@"iPad Pro 12.9 inch",
			@"iPad6,8":@"iPad Pro 12.9 inch",
			@"iPad6,11":@"iPad 5",
			@"iPad6,12":@"iPad 5",
			@"iPad7,1":@"iPad Pro 12.9 inch 2",
			@"iPad7,2":@"iPad Pro 12.9 inch 2",
			@"iPad7,3":@"iPad Pro 10.5 inch",
			@"iPad7,4":@"iPad Pro 10.5 inch",
			@"iPad7,5":@"iPad 6",
			@"iPad7,6":@"iPad 6",
			@"iPad7,11":@"iPad 7",
			@"iPad7,12":@"iPad 7",
			@"iPad8,1":@"iPad Pro 11 inch",
			@"iPad8,2":@"iPad Pro 11 inch",
			@"iPad8,3":@"iPad Pro 11 inch",
			@"iPad8,4":@"iPad Pro 11 inch",
			@"iPad8,5":@"iPad Pro 12.9 inch 3",
			@"iPad8,6":@"iPad Pro 12.9 inch 3",
			@"iPad8,7":@"iPad Pro 12.9 inch 3",
			@"iPad8,8":@"iPad Pro 12.9 inch 3",
			@"iPad8,9":@"iPad Pro 11 inch 2",
			@"iPad8,10":@"iPad Pro 11 inch 2",
			@"iPad8,11":@"iPad Pro 12.9 inch 4",
			@"iPad8,12":@"iPad Pro 12.9 inch 4",
			@"iPad11,1":@"iPad Mini 5",
			@"iPad11,2":@"iPad Mini 5",
			@"iPad11,3":@"iPad Air 3",
			@"iPad11,4":@"iPad Air 3",
			@"iPad11,6":@"iPad 8",
			@"iPad11,7":@"iPad 8",
			@"iPad13,1":@"iPad Air 4",
			@"iPad13,2":@"iPad Air 4",
			
			// iPhone
			@"iPhone1,1":@"iPhone",
			@"iPhone1,2":@"iPhone 3G",
			@"iPhone2,1":@"iPhone 3GS",
			@"iPhone3,1":@"iPhone 4",
			@"iPhone3,2":@"iPhone 4",
			@"iPhone3,3":@"iPhone 4",
			@"iPhone4,1":@"iPhone 4s",
			@"iPhone5,1":@"iPhone 5",
			@"iPhone5,2":@"iPhone 5",
			@"iPhone5,3":@"iPhone 5c",
			@"iPhone5,4":@"iPhone 5c",
			@"iPhone6,1":@"iPhone 5s",
			@"iPhone6,2":@"iPhone 5s",
			@"iPhone7,1":@"iPhone 6 Plus",
			@"iPhone7,2":@"iPhone 6",
			@"iPhone8,1":@"iPhone 6s",
			@"iPhone8,2":@"iPhone 6s Plus",
			@"iPhone8,4":@"iPhone SE",
			@"iPhone9,1":@"iPhone 7",
			@"iPhone9,2":@"iPhone 7 Plus",
			@"iPhone9,3":@"iPhone 7",
			@"iPhone9,4":@"iPhone 7 Plus",
			@"iPhone10,1":@"iPhone 8",
			@"iPhone10,2":@"iPhone 8 Plus",
			@"iPhone10,3":@"iPhone X",
			@"iPhone10,4":@"iPhone 8",
			@"iPhone10,5":@"iPhone 8 Plus",
			@"iPhone10,6":@"iPhone X",
			@"iPhone11,2":@"iPhone XS",
			@"iPhone11,4":@"iPhone XS Max",
			@"iPhone11,6":@"iPhone XS Max",
			@"iPhone11,8":@"iPhone XR",
			@"iPhone12,1":@"iPhone 11",
			@"iPhone12,3":@"iPhone 11 Pro",
			@"iPhone12,5":@"iPhone 11 Pro Max",
			@"iPhone12,8":@"iPhone SE 2",
			@"iPhone13,1":@"iPhone 12 Mini",
			@"iPhone13,2":@"iPhone 12",
			@"iPhone13,3":@"iPhone 12 Pro",
			@"iPhone13,4":@"iPhone 12 Pro Max",
			
			// iPod Touch
			@"iPod1,1":@"iPod Touch",
			@"iPod2,1":@"iPod Touch 2",
			@"iPod3,1":@"iPod Touch 3",
			@"iPod4,1":@"iPod Touch 4",
			@"iPod5,1":@"iPod Touch 5",
			@"iPod7,1":@"iPod Touch 6",
			@"iPod9,1":@"iPod Touch 7",
			
			// Simulator
			@"i386":@"Simulator (32-bit)",
			@"x86_64":@"Simulator (64-bit)"
		};
	});
	return retObj;
}

+ (NSString* _Nullable)deviceModelName
{
	static NSString* _Nullable retObj;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = JFShortcuts.deviceModelMap[JFShortcuts.deviceModelID];
	});
	return retObj;
}

+ (BOOL)isIPadDevice
{
	return (UserInterfaceIdiom == UIUserInterfaceIdiomPad);
}

+ (BOOL)isIPhoneDevice
{
	return (UserInterfaceIdiom == UIUserInterfaceIdiomPhone);
}

#endif

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

#if JF_IOS

+ (UIViewAutoresizing)viewAutoresizingFlexibleMargins
{
	return (UIViewAutoresizing)(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin);
}

+ (UIViewAutoresizing)viewAutoresizingFlexibleSize
{
	return (UIViewAutoresizing)(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
}

#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
