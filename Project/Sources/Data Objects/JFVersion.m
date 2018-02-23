//
//	The MIT License (MIT)
//
//	Copyright © 2016-2018 Jacopo Filié
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

#import "JFVersion.h"

#import "JFShortcuts.h"
#import "JFString.h"
#import "JFUtilities.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

#define RETURN_IS_MAJOR(_macro, _version)														\
static BOOL retVal; static dispatch_once_t onceToken;											\
dispatch_once(&onceToken, ^{ retVal = _macro([JFVersion versionWithMajorVersion:_version]); });	\
return retVal

#define RETURN_IS_MAJOR_MINOR(_macro, _majorVersion, _minorVersion)															\
static BOOL retVal; static dispatch_once_t onceToken;																		\
dispatch_once(&onceToken, ^{ retVal = _macro([JFVersion versionWithMajorVersion:_majorVersion minor:_minorVersion]); });	\
return retVal

// =================================================================================================
// MARK: Macros - Shortcuts
// =================================================================================================

#define RETURN_IS_IOS(_version)								RETURN_IS_MAJOR(iOS, _version)
#define RETURN_IS_IOS_PLUS(_version)						RETURN_IS_MAJOR(iOSPlus, _version)
#define RETURN_IS_MACOS(_majorVersion, _minorVersion)		RETURN_IS_MAJOR_MINOR(macOS, _majorVersion, _minorVersion)
#define RETURN_IS_MACOS_PLUS(_majorVersion, _minorVersion)	RETURN_IS_MAJOR_MINOR(macOSPlus, _majorVersion, _minorVersion)
#define RETURN_IS_TVOS(_version)							RETURN_IS_MAJOR(tvOS, _version)
#define RETURN_IS_TVOS_PLUS(_version)						RETURN_IS_MAJOR(tvOSPlus, _version)

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Constants - Data
// =================================================================================================

NSInteger const	JFVersionNotValid	= -1;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFVersion

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize	buildVersion	= _buildVersion;
@synthesize	majorVersion	= _majorVersion;
@synthesize	minorVersion	= _minorVersion;
@synthesize	patchVersion	= _patchVersion;

// =================================================================================================
// MARK: Properties - Info
// =================================================================================================

@synthesize versionString	= _versionString;

// =================================================================================================
// MARK: Properties accessors - Info
// =================================================================================================

- (NSOperatingSystemVersion)operatingSystemVersion JF_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0)
{
	NSOperatingSystemVersion retVal;
	retVal.majorVersion = self.majorVersion;
	retVal.minorVersion = self.minorVersion;
	retVal.patchVersion = self.patchVersion;
	return retVal;
}

- (NSString*)versionString
{
	if(!_versionString)
	{
		NSMutableString* versionString = [NSMutableString new];
		
		// It will add the major version only if it is a valid value (0 is valid).
		NSInteger version = self.majorVersion;
		if(version >= 0)
		{
			[versionString appendString:JFStringFromNSInteger(version)];
			
			// It will add the minor version only if it is a valid value (0 is valid) and a valid major version has already been added.
			version = self.minorVersion;
			if(version >= 0)
			{
				[versionString appendFormat:@".%@", JFStringFromNSInteger(version)];
				
				// It will add the patch version only if it is greater than 0 and a valid minor version has already been added.
				version = self.patchVersion;
				if(version > 0)
					[versionString appendFormat:@".%@", JFStringFromNSInteger(version)];
			}
			
			// It will add the build version only if it is a valid string and a valid major version has already been added.
			NSString* build = self.buildVersion;
			if(!JFStringIsNullOrEmpty(build))
				[versionString appendFormat:@" (%@)", build];
		}
		
		_versionString = [versionString copy];
	}
	return _versionString;
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (JFVersion*)currentOperatingSystemVersion
{
	static JFVersion* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if([NSProcessInfo instancesRespondToSelector:@selector(operatingSystemVersion)])
			retObj = [[JFVersion alloc] initWithOperatingSystemVersion:ProcessInfo.operatingSystemVersion];
		else
		{
#if JF_MACOS
			SInt32 majorVersion, minorVersion, patchVersion;
			Gestalt(gestaltSystemVersionMajor, &majorVersion);
			Gestalt(gestaltSystemVersionMinor, &minorVersion);
			Gestalt(gestaltSystemVersionBugFix, &patchVersion);
			retObj = [[JFVersion alloc] initWithMajorVersion:majorVersion minor:minorVersion patch:patchVersion];
#else
			retObj = [[JFVersion alloc] initWithVersionString:SystemVersion];
#endif
		}
	});
	return retObj;
}

+ (instancetype)versionWithMajorVersion:(NSInteger)major
{
	return [self versionWithMajorVersion:major minor:JFVersionNotValid];
}

+ (instancetype)versionWithMajorVersion:(NSInteger)major minor:(NSInteger)minor
{
	return [[self alloc] initWithMajorVersion:major minor:minor patch:JFVersionNotValid build:nil];
}

- (instancetype)initWithMajorVersion:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch
{
	return [self initWithMajorVersion:major minor:minor patch:patch build:nil];
}

- (instancetype)initWithMajorVersion:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch build:(NSString* __nullable)build
{
	self = [super init];
	if(self)
	{
		// Initializes the datamembers.
		_buildVersion	= [build copy];
		_majorVersion	= ((major >= 0) ? major : JFVersionNotValid);
		_minorVersion	= ((minor >= 0) ? minor : JFVersionNotValid);
		_patchVersion	= ((patch >= 0) ? patch : JFVersionNotValid);
	}
	return self;
}

- (instancetype)initWithOperatingSystemVersion:(NSOperatingSystemVersion)version JF_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0)
{
	return [self initWithOperatingSystemVersion:version build:nil];
}

- (instancetype)initWithOperatingSystemVersion:(NSOperatingSystemVersion)version build:(NSString* __nullable)build JF_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0)
{
	return [self initWithMajorVersion:version.majorVersion minor:version.minorVersion patch:version.patchVersion build:build];
}

- (instancetype)initWithVersionString:(NSString*)versionString
{
	NSString* build = nil;
	NSInteger major = JFVersionNotValid;
	NSInteger minor = JFVersionNotValid;
	NSInteger patch = JFVersionNotValid;
	
	if(!JFStringIsEmpty(versionString))
	{
		BOOL buildVersionComponentParsed = NO;
		BOOL releaseVersionComponentParsed = NO;
		NSArray<NSString*>* components = [versionString componentsSeparatedByString:@" "];
		for(NSUInteger i = 0; (i < components.count) && (i < 2); i++)
		{
			NSString* component = components[i];
			if(!buildVersionComponentParsed && [component hasPrefix:@"("] && [component hasSuffix:@")"])
			{
				// This is the build version component.
				build = [component substringWithRange:NSMakeRange(1, (component.length - 2))];
				buildVersionComponentParsed = YES;
			}
			else if(!releaseVersionComponentParsed)
			{
				// This is the release version component.
				NSScanner* scanner = [NSScanner scannerWithString:component];
				scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"."];
				[scanner scanInteger:&major];
				[scanner scanInteger:&minor];
				[scanner scanInteger:&patch];
				releaseVersionComponentParsed = YES;
			}
		}
	}
	
	return [self initWithMajorVersion:major minor:minor patch:patch build:build];
}

// =================================================================================================
// MARK: Methods - Equality management
// =================================================================================================

- (BOOL)compareToCurrentOperatingSystemVersion:(JFRelation)relation
{
	return [self compareToVersion:[JFVersion currentOperatingSystemVersion] relation:relation];
}

- (BOOL)compareToVersion:(JFVersion*)version relation:(JFRelation)relation
{
	NSInteger comps1[3] = {self.majorVersion, self.minorVersion, self.patchVersion};
	NSInteger comps2[3] = {version.majorVersion, version.minorVersion, version.patchVersion};
	
	NSComparisonResult result = NSOrderedSame;
	for(NSUInteger i = 0; (i < 3) && (result == NSOrderedSame); i++)
	{
		NSInteger comp1 = comps1[i];
		NSInteger comp2 = comps2[i];
		
		if((comp1 == JFVersionNotValid) || (comp2 == JFVersionNotValid))
			continue;
		
		if(comp1 == comp2)		result = NSOrderedSame;
		else if(comp1 < comp2)	result = NSOrderedAscending;
		else if(comp1 > comp2)	result = NSOrderedDescending;
	}
	
	BOOL ascending	= (result == NSOrderedAscending);
	BOOL descending	= (result == NSOrderedDescending);
	
	BOOL retVal = NO;
	
	switch(relation)
	{
		case JFRelationLessThan:			retVal = ascending;						break;
		case JFRelationLessThanOrEqual:		retVal = (ascending || !descending);	break;
		case JFRelationEqual:				retVal = (!ascending && !descending);	break;
		case JFRelationGreaterThanOrEqual:	retVal = (descending || !ascending);	break;
		case JFRelationGreaterThan:			retVal = descending;					break;
		default:
			break;
	}
	
	if(retVal && (relation == JFRelationEqual))
	{
		NSString* build1 = self.buildVersion;
		NSString* build2 = version.buildVersion;
		
		if(build1 && build2)
			retVal = JFAreObjectsEqual(build1, build2);
	}
	
	return retVal;
}

- (NSUInteger)hash
{
	return self.versionString.hash;
}

- (BOOL)isEqual:(id)object
{
	if(!object && ![object isKindOfClass:self.class])
		return NO;
	
	return [self isEqualToVersion:object];
}

- (BOOL)isEqualToVersion:(JFVersion*)version
{
	return [self compareToVersion:version relation:JFRelationEqual];
}

- (BOOL)isGreaterThanVersion:(JFVersion*)version
{
	return [self compareToVersion:version relation:JFRelationGreaterThan];
}

- (BOOL)isLessThanVersion:(JFVersion*)version
{
	return [self compareToVersion:version relation:JFRelationLessThan];
}

// =================================================================================================
// MARK: Methods - Equality management (iOS)
// =================================================================================================

#if JF_IOS
+ (BOOL)isIOS:(JFVersion*)version
{
	return [version compareToCurrentOperatingSystemVersion:JFRelationEqual];
}

+ (BOOL)isIOSPlus:(JFVersion*)version
{
	return [version compareToCurrentOperatingSystemVersion:JFRelationLessThanOrEqual];
}

+ (BOOL)isIOS6
{
	RETURN_IS_IOS(6);
}

+ (BOOL)isIOS6Plus
{
	RETURN_IS_IOS_PLUS(6);
}

+ (BOOL)isIOS7
{
	RETURN_IS_IOS(7);
}

+ (BOOL)isIOS7Plus
{
	RETURN_IS_IOS_PLUS(7);
}

+ (BOOL)isIOS8
{
	RETURN_IS_IOS(8);
}

+ (BOOL)isIOS8Plus
{
	RETURN_IS_IOS_PLUS(8);
}

+ (BOOL)isIOS9
{
	RETURN_IS_IOS(9);
}

+ (BOOL)isIOS9Plus
{
	RETURN_IS_IOS_PLUS(9);
}

+ (BOOL)isIOS10
{
	RETURN_IS_IOS(10);
}

+ (BOOL)isIOS10Plus
{
	RETURN_IS_IOS_PLUS(10);
}

+ (BOOL)isIOS11
{
	RETURN_IS_IOS(11);
}

+ (BOOL)isIOS11Plus
{
	RETURN_IS_IOS_PLUS(11);
}
#endif

// =================================================================================================
// MARK: Methods - Equality management (macOS)
// =================================================================================================

#if JF_MACOS
+ (BOOL)isMacOS:(JFVersion*)version
{
	return [version compareToCurrentOperatingSystemVersion:JFRelationEqual];
}

+ (BOOL)isMacOSPlus:(JFVersion*)version
{
	return [version compareToCurrentOperatingSystemVersion:JFRelationLessThanOrEqual];
}

+ (BOOL)isMacOS10_6
{
	RETURN_IS_MACOS(10, 6);
}

+ (BOOL)isMacOS10_6Plus
{
	RETURN_IS_MACOS_PLUS(10, 6);
}

+ (BOOL)isMacOS10_7
{
	RETURN_IS_MACOS(10, 7);
}

+ (BOOL)isMacOS10_7Plus
{
	RETURN_IS_MACOS_PLUS(10, 7);
}

+ (BOOL)isMacOS10_8
{
	RETURN_IS_MACOS(10, 8);
}

+ (BOOL)isMacOS10_8Plus
{
	RETURN_IS_MACOS_PLUS(10, 8);
}

+ (BOOL)isMacOS10_9
{
	RETURN_IS_MACOS(10, 9);
}

+ (BOOL)isMacOS10_9Plus
{
	RETURN_IS_MACOS_PLUS(10, 9);
}

+ (BOOL)isMacOS10_10
{
	RETURN_IS_MACOS(10, 10);
}

+ (BOOL)isMacOS10_10Plus
{
	RETURN_IS_MACOS_PLUS(10, 10);
}

+ (BOOL)isMacOS10_11
{
	RETURN_IS_MACOS(10, 11);
}

+ (BOOL)isMacOS10_11Plus
{
	RETURN_IS_MACOS_PLUS(10, 11);
}

+ (BOOL)isMacOS10_12
{
	RETURN_IS_MACOS(10, 12);
}

+ (BOOL)isMacOS10_12Plus
{
	RETURN_IS_MACOS_PLUS(10, 12);
}

+ (BOOL)isMacOS10_13
{
	RETURN_IS_MACOS(10, 13);
}

+ (BOOL)isMacOS10_13Plus
{
	RETURN_IS_MACOS_PLUS(10, 13);
}
#endif

// =================================================================================================
// MARK: Methods - Equality management (tvOS)
// =================================================================================================

#if JF_TVOS
+ (BOOL)isTVOS:(JFVersion*)version
{
	return [version compareToCurrentOperatingSystemVersion:JFRelationEqual];
}

+ (BOOL)isTVOSPlus:(JFVersion*)version
{
	return [version compareToCurrentOperatingSystemVersion:JFRelationLessThanOrEqual];
}

+ (BOOL)isTVOS9
{
	RETURN_IS_TVOS(9);
}

+ (BOOL)isTVOS9Plus
{
	RETURN_IS_TVOS_PLUS(9);
}

+ (BOOL)isTVOS10
{
	RETURN_IS_TVOS(10);
}

+ (BOOL)isTVOS10Plus
{
	RETURN_IS_TVOS_PLUS(10);
}
#endif

// =================================================================================================
// MARK: Protocols - NSCopying
// =================================================================================================

- (id)copyWithZone:(NSZone* __nullable)zone
{
	return [[JFVersion alloc] initWithMajorVersion:_majorVersion minor:_minorVersion patch:_patchVersion build:_buildVersion];
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
