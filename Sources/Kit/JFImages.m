//
//	The MIT License (MIT)
//
//	Copyright © 2017-2023 Jacopo Filié
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

#import "JFImages.h"

#import "JFShortcuts.h"
#import "JFVersion.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Functions - Bundle
// =================================================================================================

#if JF_IOS

NSString* _Nullable JFLaunchImageName(void)
{
	return JFLaunchImageNameForOrientation(CurrentInterfaceOrientation);
}

NSString* _Nullable JFLaunchImageNameForOrientation(UIInterfaceOrientation orientation)
{
	static NSString* landscapeRetObj = nil;
	static NSString* portraitRetObj = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString* const launchImagesKey = @"UILaunchImages";
		NSString* const minOSVersionKey = @"UILaunchImageMinimumOSVersion";
		NSString* const nameKey = @"UILaunchImageName";
		NSString* const orientationKey = @"UILaunchImageOrientation";
		NSString* const sizeKey = @"UILaunchImageSize";
		
		NSMutableArray<NSDictionary<NSString*, NSString*>*>* launchScreens = [NSMutableArray<NSDictionary<NSString*, NSString*>*> array];
		@autoreleasepool
		{
			// Retrieves the main screen size in portrait-up orientation.
			UIScreen* screen = MainScreen;
			CGSize screenSize = [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace].size;
			
			// Retrieves the info of all the available launch images inside the bundle.
			NSArray<NSDictionary<NSString*, NSString*>*>* dicts = JFApplicationInfoForKey(launchImagesKey);
			for(NSDictionary<NSString*, NSString*>* dict in dicts)
			{
				// Filters by size.
				NSString* sizeString = dict[sizeKey];
				if(!JFStringIsNullOrEmpty(sizeString) && !CGSizeEqualToSize(CGSizeFromString(sizeString), screenSize))
					continue;
				
				// Filters by minimum OS version.
				NSString* minOSVersionString = dict[minOSVersionKey];
				if(!JFStringIsNullOrEmpty(minOSVersionString))
				{
					JFVersion* minOSVersion = [[JFVersion alloc] initWithVersionString:minOSVersionString];
					if(!iOSPlus(minOSVersion))
						continue;
				}
				
				// All filters passed: adds it to the array.
				[launchScreens addObject:dict];
			}
		}
		
		JFVersion* landscapeRetObjVersion = nil;
		JFVersion* portraitRetObjVersion = nil;
		for(NSDictionary<NSString*, NSString*>* dict in launchScreens)
		{
			NSString* name = dict[nameKey];
			if(JFStringIsNullOrEmpty(name))
				continue;
			
			NSString* orientationString = dict[orientationKey];
			if(!orientationString)
				continue;
			
			NSString* versionString = dict[minOSVersionKey];
			if(!versionString)
				continue;
			
			// Retrieves the variables to use based on the current launch screen orientation.
			NSString* __strong* retObj;
			JFVersion* __strong* retObjVersion;
			if([orientationString isEqualToString:@"Portrait"])
			{
				retObj = &portraitRetObj;
				retObjVersion = &portraitRetObjVersion;
			}
			else if([orientationString isEqualToString:@"Landscape"])
			{
				retObj = &landscapeRetObj;
				retObjVersion = &landscapeRetObjVersion;
			}
			else
				continue;
			
			// Retrieves the current launch screen version.
			JFVersion* version = [[JFVersion alloc] initWithVersionString:versionString];
			if(!version)
				continue;
			
			// Checks if the last saved version is greater than the current version.
			if([*retObjVersion isGreaterThanVersion:version])
				continue;
			
			*retObj = name;
			*retObjVersion = version;
		}
	});
	
	if(UIInterfaceOrientationIsPortrait(orientation))
		return portraitRetObj;
	
	if(UIInterfaceOrientationIsLandscape(orientation))
		return landscapeRetObj;
	
	return nil;
}

#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
