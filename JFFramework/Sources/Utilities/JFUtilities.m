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



#import "JFUtilities.h"

#import "JFShortcuts.h"
#import "JFString.h"
#import "JFVersion.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

NSTimeInterval const	JFAnimationDuration	= 0.25;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

id JFApplicationInfoForKey(NSString* key)
{
	return MainBundle.infoDictionary[key];
}

BOOL JFAreObjectsEqual(id<NSObject> obj1, id<NSObject> obj2)
{
	// If both are 'nil', they are equal.
	if(!obj1 && !obj2)
		return YES;
	
	// If anyone is still equal to 'nil', they can't be equal.
	if(!obj1 || !obj2)
		return NO;
	
	BOOL (^checkClass)(Class) = ^BOOL(Class class)
	{
		if(![obj1 isKindOfClass:class])	return NO;
		if(![obj2 isKindOfClass:class])	return NO;
		return YES;
	};
	
	id o1 = obj1;
	id o2 = obj2;
	
	if(checkClass([NSArray class]))			return [o1 isEqualToArray:o2];
	if(checkClass([NSData class]))			return [o1 isEqualToData:o2];
	if(checkClass([NSDate class]))			return [o1 isEqualToDate:o2];
	if(checkClass([NSDictionary class]))	return [o1 isEqualToDictionary:o2];
	if(checkClass([NSNumber class]))		return [o1 isEqualToNumber:o2];
	if(checkClass([NSSet class]))			return [o1 isEqualToSet:o2];
	if(checkClass([NSString class]))		return [o1 isEqualToString:o2];
	
	return [obj1 isEqual:obj2];
}


#pragma mark Functions (Images)

#if JF_IOS

NSString* JFLaunchImageName(void)
{
	return JFLaunchImageNameForOrientation(CurrentInterfaceOrientation);
}

NSString* JFLaunchImageNameForOrientation(UIInterfaceOrientation orientation)
{
	static NSString* const NameKey				= @"UILaunchImageName";
	static NSString* const MinimumOSVersionKey	= @"UILaunchImageMinimumOSVersion";
	static NSString* const OrientationKey		= @"UILaunchImageOrientation";
	static NSString* const SizeKey				= @"UILaunchImageSize";
	
	static NSDictionary* LaunchScreens = nil;
	if(!LaunchScreens)
	{
		NSArray* dicts = JFApplicationInfoForKey(@"UILaunchImages");
		
		NSString* searchString = @"-700";
		
		NSMutableDictionary* mDicts = [NSMutableDictionary dictionaryWithCapacity:[dicts count]];
		for(NSDictionary* dict in dicts)
		{
			NSString* key = dict[NameKey];
			NSMutableDictionary* mDict = [dict mutableCopy];
			[mDict removeObjectForKey:NameKey];
			mDicts[key] = [mDict copy];
			
			NSRange range = [key rangeOfString:searchString];
			if(range.location != NSNotFound)
			{
				key = [key stringByReplacingOccurrencesOfString:searchString withString:JFEmptyString];
				[mDict removeObjectForKey:MinimumOSVersionKey];
				mDicts[key] = [mDict copy];
			}
		}
		LaunchScreens = [mDicts copy];
	}
	
	static CGSize screenSize = {0.0, 0.0};
	if(CGSizeEqualToSize(screenSize, CGSizeZero))
	{
		UIScreen* screen = MainScreen;
		CGRect screenBounds = (iOS8Plus ? [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace] : screen.bounds);
		screenSize = screenBounds.size;
	}
	
	static NSString* landscapeRetObj = nil;
	static NSString* portraitRetObj = nil;
	
	BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
	BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
	
	NSString* retObj = (isLandscape ? landscapeRetObj : (isPortrait ? portraitRetObj : nil));
	
	if(!retObj)
	{
		JFVersion* retObjVersion = nil;
		for(NSString* key in [LaunchScreens allKeys])
		{
			NSDictionary* dict = LaunchScreens[key];
			
			// Checks the orientation and skips to the next if not satisfied.
			NSString* orientationString = dict[OrientationKey];
			if([orientationString isEqualToString:@"Portrait"])
			{
				if(isLandscape)
					continue;
			}
			else if([orientationString isEqualToString:@"Landscape"])
			{
				if(isPortrait)
					continue;
			}
			else
				continue;
			
			// Checks the size and skips to the next if not satisfied.
			NSString* sizeString = dict[SizeKey];
			CGSize size = CGSizeFromString(sizeString);
			if(!CGSizeEqualToSize(size, screenSize))
				continue;
			
			// Checks the minimum iOS version and skips to the next if not satisfied.
			NSString* minVersionString = dict[MinimumOSVersionKey];
			JFVersion* minVersion = (minVersionString ? [[JFVersion alloc] initWithVersionString:minVersionString] : nil);
			if(minVersion)
			{
				if(!iOSPlus(minVersion))
					continue;
				
				// Checks if the current image minVersion is better than the last used image version.
				if(retObjVersion && [minVersion isLessThanVersion:retObjVersion])
					continue;
			}
			else if(retObjVersion)
				continue;
			
			if(isLandscape)	landscapeRetObj = key;
			if(isPortrait)	portraitRetObj = key;
			
			retObj = key;
			retObjVersion = minVersion;
			
			if(iOS(minVersion))
				break;
		}
	}
	
	return retObj;
}

#endif


#pragma mark Functions (Math)

JFDegrees JFDegreesFromRadians(JFRadians radians)
{
	return radians * 180.0 / M_PI;
}

JFRadians JFRadiansFromDegrees(JFDegrees degrees)
{
	return degrees * M_PI / 180.0;
}


#pragma mark Functions (Resources)

NSURL* JFBundleResourceURLForFile(NSBundle* bundle, NSString* filename)
{
	return JFBundleResourceURLForFileWithType(bundle, [filename stringByDeletingPathExtension], [filename pathExtension]);
}

NSURL* JFBundleResourceURLForFileWithType(NSBundle* bundle, NSString* filename, NSString* type)
{
	if(!bundle || JFStringIsNullOrEmpty(filename))
		return nil;
	
	return [bundle URLForResource:filename withExtension:type];
}


#pragma mark Functions (Runtime)

void JFPerformSelector(NSObject* target, SEL action)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL) = (void*)implementation;
	performMethod(target, action);
}

void JFPerformSelector1(NSObject* target, SEL action, id object)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id) = (void*)implementation;
	performMethod(target, action, object);
}

void JFPerformSelector2(NSObject* target, SEL action, id obj1, id obj2)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id, id) = (void*)implementation;
	performMethod(target, action, obj1, obj2);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
