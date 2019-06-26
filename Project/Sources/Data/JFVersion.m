//
//	The MIT License (MIT)
//
//	Copyright © 2016-2019 Jacopo Filié
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
#import "JFStrings.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

#define RETURN_IS_MAJOR(_macro, _major) \
static BOOL retVal; static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ retVal = _macro([JFVersion versionWithMajorComponent:_major]); }); \
return retVal

#define RETURN_IS_MAJOR_MINOR(_macro, _major, _minor) \
static BOOL retVal; static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ retVal = _macro([JFVersion versionWithMajorComponent:_major minor:_minor]); }); \
return retVal

// =================================================================================================
// MARK: Macros - Shortcuts
// =================================================================================================

#define RETURN_IS_IOS(_major) RETURN_IS_MAJOR(iOS, _major)
#define RETURN_IS_IOS_PLUS(_major) RETURN_IS_MAJOR(iOSPlus, _major)
#define RETURN_IS_MACOS(_major, _minor) RETURN_IS_MAJOR_MINOR(macOS, _major, _minor)
#define RETURN_IS_MACOS_PLUS(_major, _minor) RETURN_IS_MAJOR_MINOR(macOSPlus, _major, _minor)

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Constants - Data
// =================================================================================================

NSInteger const JFVersionComponentNotValid = -1;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFVersion

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize build = _build;
@synthesize major = _major;
@synthesize minor = _minor;
@synthesize patch = _patch;
@synthesize string = _string;

// =================================================================================================
// MARK: Properties accessors - Data
// =================================================================================================

- (NSOperatingSystemVersion)operatingSystemVersion
{
	NSOperatingSystemVersion retVal;
	retVal.majorVersion = self.major;
	retVal.minorVersion = self.minor;
	retVal.patchVersion = self.patch;
	return retVal;
}

- (NSString*)string
{
	if(!_string)
	{
		NSMutableString* string = [NSMutableString new];
		
		[string appendString:JFStringFromNSInteger(MAX(0, self.major))];
		[string appendFormat:@".%@", JFStringFromNSInteger(MAX(0, self.minor))];
		
		NSInteger patch = self.patch;
		if(patch > 0)
			[string appendFormat:@".%@", JFStringFromNSInteger(patch)];
		
		NSString* build = self.build;
		if(!JFStringIsNullOrEmpty(build))
			[string appendFormat:@" (%@)", build];
		
		_string = [string copy];
	}
	return _string;
}

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (JFVersion*)currentOperatingSystemVersion
{
	static JFVersion* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if(@available(iOS 8.0, macOS 10.10, *))
			retObj = [[JFVersion alloc] initWithOperatingSystemVersion:ProcessInfo.operatingSystemVersion];
		else
		{
#if JF_MACOS
			SInt32 major, minor, patch;
			Gestalt(gestaltSystemVersionMajor, &major);
			Gestalt(gestaltSystemVersionMinor, &minor);
			Gestalt(gestaltSystemVersionBugFix, &patch);
			retObj = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:nil];
#else
			retObj = [[JFVersion alloc] initWithVersionString:SystemVersion];
#endif
		}
	});
	return retObj;
}

+ (instancetype)versionWithMajorComponent:(NSInteger)major
{
	return [[self alloc] initWithMajorComponent:major minor:JFVersionComponentNotValid patch:JFVersionComponentNotValid build:nil];
}

+ (instancetype)versionWithMajorComponent:(NSInteger)major minor:(NSInteger)minor
{
	return [[self alloc] initWithMajorComponent:major minor:minor patch:JFVersionComponentNotValid build:nil];
}

- (instancetype)initWithMajorComponent:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch build:(NSString* __nullable)build
{
	// Prevents an analyzer false positive.
	if(JFStringIsEmpty(build))
		build = nil;
	
	self = [super init];
	
	_build = (build ? [NSString stringWithString:build] : nil);
	_major = ((major >= 0) ? major : JFVersionComponentNotValid);
	_minor = ((minor >= 0) ? minor : JFVersionComponentNotValid);
	_patch = ((patch >= 0) ? patch : JFVersionComponentNotValid);
	
	return self;
}

- (instancetype)initWithOperatingSystemVersion:(NSOperatingSystemVersion)version
{
	return [self initWithMajorComponent:version.majorVersion minor:version.minorVersion patch:version.patchVersion build:nil];
}

- (instancetype)initWithVersionString:(NSString*)versionString
{
	NSString* build = nil;
	NSInteger major = JFVersionComponentNotValid;
	NSInteger minor = JFVersionComponentNotValid;
	NSInteger patch = JFVersionComponentNotValid;
	
	if(!JFStringIsEmpty(versionString))
	{
		BOOL buildComponentParsed = NO;
		BOOL releaseComponentParsed = NO;
		
		NSArray<NSString*>* components = [versionString componentsSeparatedByString:@" "];
		for(NSUInteger i = 0; (i < components.count) && (i < 2); i++)
		{
			NSString* component = [components objectAtIndex:i];
			if(!buildComponentParsed && [component hasPrefix:@"("] && [component hasSuffix:@")"])
			{
				// This is the build version component.
				build = [component substringWithRange:NSMakeRange(1, (component.length - 2))];
				buildComponentParsed = YES;
			}
			else if(!releaseComponentParsed)
			{
				// This is the release version component.
				NSScanner* scanner = [NSScanner scannerWithString:component];
				scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"."];
				[scanner scanInteger:&major];
				[scanner scanInteger:&minor];
				[scanner scanInteger:&patch];
				releaseComponentParsed = YES;
			}
		}
	}
	
	return [self initWithMajorComponent:major minor:minor patch:patch build:build];
}

// =================================================================================================
// MARK: Methods - Comparison
// =================================================================================================

- (BOOL)compareToCurrentOperatingSystemVersion:(JFRelation)relation
{
	return [self compareToVersion:[JFVersion currentOperatingSystemVersion] relation:relation];
}

- (BOOL)compareToVersion:(JFVersion*)version relation:(JFRelation)relation
{
	return [self compareToVersion:version relation:relation buildComparatorBlock:^NSComparisonResult(NSString* build1, NSString* build2) {
		return [build1 compare:build2 options:NSNumericSearch];
	}];
}

- (BOOL)compareToVersion:(JFVersion*)version relation:(JFRelation)relation buildComparatorBlock:(NSComparisonResult (^)(NSString* build1, NSString* build2))comparatorBlock;
{
	NSInteger comps1[] = {self.major, self.minor, self.patch};
	NSInteger comps2[] = {version.major, version.minor, version.patch};
	
	NSComparisonResult result = NSOrderedSame;
	for(NSUInteger i = 0; (i < 3) && (result == NSOrderedSame); i++)
	{
		NSInteger comp1 = comps1[i];
		NSInteger comp2 = comps2[i];
		
		if((comp1 == JFVersionComponentNotValid) || (comp2 == JFVersionComponentNotValid))
			continue;
		
		if(comp1 == comp2)
			result = NSOrderedSame;
		else if(comp1 < comp2)
			result = NSOrderedAscending;
		else if(comp1 > comp2)
			result = NSOrderedDescending;
	}
	
	if(result == NSOrderedSame)
	{
		NSString* build1 = self.build;
		NSString* build2 = version.build;
		
		if(build1 && build2)
			result = comparatorBlock(build1, build2);
	}
	
	BOOL ascending = (result == NSOrderedAscending);
	BOOL descending = (result == NSOrderedDescending);
	
	BOOL retVal = NO;
	switch(relation)
	{
		case JFRelationLessThan:
		{
			retVal = ascending;
			break;
		}
		case JFRelationLessThanOrEqual:
		{
			retVal = (ascending || !descending);
			break;
		}
		case JFRelationEqual:
		{
			retVal = (!ascending && !descending);
			break;
		}
		case JFRelationGreaterThanOrEqual:
		{
			retVal = (descending || !ascending);
			break;
		}
		case JFRelationGreaterThan:
		{
			retVal = descending;
			break;
		}
		default:
			break;
	}
	return retVal;
}

- (NSUInteger)hash
{
	return self.string.hash;
}

- (BOOL)isEqual:(id)object
{
	if(!object || ![object isKindOfClass:self.class])
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
// MARK: Methods - Comparison (iOS)
// =================================================================================================

+ (BOOL)isIOS:(JFVersion*)version
{
#if JF_IOS
	return [version compareToCurrentOperatingSystemVersion:JFRelationEqual];
#else
	return NO;
#endif
}

+ (BOOL)isIOSPlus:(JFVersion*)version
{
#if JF_IOS
	return [version compareToCurrentOperatingSystemVersion:JFRelationLessThanOrEqual];
#else
	return NO;
#endif
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

// =================================================================================================
// MARK: Methods - Comparison (macOS)
// =================================================================================================

+ (BOOL)isMacOS:(JFVersion*)version
{
#if JF_MACOS
	return [version compareToCurrentOperatingSystemVersion:JFRelationEqual];
#else
	return NO;
#endif
}

+ (BOOL)isMacOSPlus:(JFVersion*)version
{
#if JF_MACOS
	return [version compareToCurrentOperatingSystemVersion:JFRelationLessThanOrEqual];
#else
	return NO;
#endif
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

// =================================================================================================
// MARK: Methods (NSCopying)
// =================================================================================================

- (id)copyWithZone:(NSZone* __nullable)zone
{
	return [[[self class] allocWithZone:zone] initWithMajorComponent:_major minor:_minor patch:_patch build:_build];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
