//
//	The MIT License (MIT)
//
//	Copyright © 2015-2019 Jacopo Filié
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

#import "JFShortcuts.h"

#import "JFBlocks.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation JFShortcuts

// =================================================================================================
// MARK: Properties accessors - Application
// =================================================================================================

+ (AppDelegate* __nullable)appDelegate
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

+ (NSString* __nullable)appVersion
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

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
