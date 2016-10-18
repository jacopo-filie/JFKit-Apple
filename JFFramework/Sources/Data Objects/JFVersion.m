//
//	The MIT License (MIT)
//
//	Copyright © 2016 Jacopo Filié
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



#import "JFVersion.h"

#import "JFString.h"
#import "JFUtilities.h"



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

- (NSOperatingSystemVersion)operatingSystemVersion OBJC_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0)
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
		_majorVersion	= major;
		_minorVersion	= minor;
		_patchVersion	= patch;
	}
	return self;
}

- (instancetype)initWithOperatingSystemVersion:(NSOperatingSystemVersion)version OBJC_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0)
{
	return [self initWithOperatingSystemVersion:version build:nil];
}

- (instancetype)initWithOperatingSystemVersion:(NSOperatingSystemVersion)version build:(NSString* __nullable)build OBJC_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0)
{
	return [self initWithMajorVersion:version.majorVersion minor:version.minorVersion patch:version.patchVersion build:build];
}

- (instancetype)initWithVersionString:(NSString*)versionString
{
	NSString* build = nil;
	NSInteger major = -1;
	NSInteger minor = -1;
	NSInteger patch = -1;
	
	if(!JFStringIsEmpty(versionString))
	{
		BOOL buildVersionComponentParsed = NO;
		BOOL displayVersionComponentParsed = NO;
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
			else if(!displayVersionComponentParsed)
			{
				// This is the display version component.
				NSScanner* scanner = [NSScanner scannerWithString:component];
				scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"."];
				[scanner scanInteger:&major];
				[scanner scanInteger:&minor];
				[scanner scanInteger:&patch];
				displayVersionComponentParsed = YES;
			}
		}
	}
	
	return [self initWithMajorVersion:major minor:minor patch:patch build:build];
}

// =================================================================================================
// MARK: Protocols - NSCopying
// =================================================================================================

- (id)copyWithZone:(NSZone* __nullable)zone
{
	return [[JFVersion alloc] initWithMajorVersion:_majorVersion minor:_minorVersion patch:_patchVersion build:_buildVersion];
}

@end
NS_ASSUME_NONNULL_END
