//
//	The MIT License (MIT)
//
//	Copyright © 2016-2023 Jacopo Filié
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

#import <XCTest/XCTest.h>

#import "JFVersion.h"

#import "JFPreprocessorMacros.h"
#import "JFShortcuts.h"
#import "JFStrings.h"
#import "JFUtilities.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFVersion_Tests : XCTestCase

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testCreateWithCurrentOperatingSystemVersion;
- (void)testCreateWithString;
- (void)testCreateWithValues;
- (void)testEquality;
- (void)testVersionString;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFVersion_Tests

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)testCreateWithCurrentOperatingSystemVersion
{
	JFVersion* version = [JFVersion currentOperatingSystemVersion];
	NSString* string = [NSString stringWithFormat:@"%@.%@.%@", JFStringFromNSInteger(version.major), JFStringFromNSInteger(version.minor), JFStringFromNSInteger(version.patch)];
	
	NSString* result = nil;
#if JF_MACOS
	SInt32 major, minor, patch;
#	pragma GCC diagnostic push
#	pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	Gestalt(gestaltSystemVersionMajor, &major);
	Gestalt(gestaltSystemVersionMinor, &minor);
	Gestalt(gestaltSystemVersionBugFix, &patch);
#	pragma GCC diagnostic pop
	result = [NSString stringWithFormat:@"%@.%@.%@", JFStringFromSInt32(major), JFStringFromSInt32(minor), JFStringFromSInt32(patch)];
#else
	result = SystemVersion;
	while([result componentsSeparatedByString:@"."].count < 3)
		result = [result stringByAppendingString:@".0"];
#endif
	XCTAssert(JFAreObjectsEqual(string, result), @"The string value is '%@'; it should be '%@'.", string, result);
}

- (void)testCreateWithString
{
	NSString* string = @"1.0.9 (ABCDEF12)";
	JFVersion* version = [[JFVersion alloc] initWithVersionString:string];
	XCTAssert((version.major == 1), @"The major version is '%@'; it should be '1'.", JFStringFromNSInteger(version.major));
	XCTAssert((version.minor == 0), @"The minor version is '%@'; it should be '0'.", JFStringFromNSInteger(version.minor));
	XCTAssert((version.patch == 9), @"The patch version is '%@'; it should be '9'.", JFStringFromNSInteger(version.patch));
	XCTAssert(JFAreObjectsEqual(version.build, @"ABCDEF12"), @"The build version is '%@'; it should be 'ABCDEF12'.", version.build);
	
	string = @"1.0 (ABCDEF12)";
	version = [[JFVersion alloc] initWithVersionString:string];
	XCTAssert((version.major == 1), @"The major version is '%@'; it should be '1'.", JFStringFromNSInteger(version.major));
	XCTAssert((version.minor == 0), @"The minor version is '%@'; it should be '0'.", JFStringFromNSInteger(version.minor));
	XCTAssert((version.patch == -1), @"The patch version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.patch));
	XCTAssert(JFAreObjectsEqual(version.build, @"ABCDEF12"), @"The build version is '%@'; it should be 'ABCDEF12'.", version.build);
	
	string = @"0.8.9";
	version = [[JFVersion alloc] initWithVersionString:string];
	XCTAssert((version.major == 0), @"The major version is '%@'; it should be '0'.", JFStringFromNSInteger(version.major));
	XCTAssert((version.minor == 8), @"The minor version is '%@'; it should be '8'.", JFStringFromNSInteger(version.minor));
	XCTAssert((version.patch == 9), @"The patch version is '%@'; it should be '9'.", JFStringFromNSInteger(version.patch));
	XCTAssert(version.build == nil, @"The build version is '%@'; it should be nil.", version.build);
	
	string = @"(ABCDEF12)";
	version = [[JFVersion alloc] initWithVersionString:string];
	XCTAssert((version.major == -1), @"The major version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.major));
	XCTAssert((version.minor == -1), @"The minor version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.minor));
	XCTAssert((version.patch == -1), @"The patch version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.patch));
	XCTAssert(JFAreObjectsEqual(version.build, @"ABCDEF12"), @"The build version is '%@'; it should be 'ABCDEF12'.", version.build);
}

- (void)testCreateWithValues
{
	NSInteger major = 1;
	NSInteger minor = 0;
	NSInteger patch = 9;
	NSString* build = @"ABCDEF12";
	
	JFVersion* version = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:nil];
	XCTAssert((version.major == 1), @"The major version is '%@'; it should be '1'.", JFStringFromNSInteger(version.major));
	XCTAssert((version.minor == 0), @"The minor version is '%@'; it should be '0'.", JFStringFromNSInteger(version.minor));
	XCTAssert((version.patch == 9), @"The patch version is '%@'; it should be '9'.", JFStringFromNSInteger(version.patch));
	XCTAssert(version.build == nil, @"The build version is '%@'; it should be nil.", version.build);
	
	version = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:build];
	XCTAssert((version.major == 1), @"The major version is '%@'; it should be '1'.", JFStringFromNSInteger(version.major));
	XCTAssert((version.minor == 0), @"The minor version is '%@'; it should be '0'.", JFStringFromNSInteger(version.minor));
	XCTAssert((version.patch == 9), @"The patch version is '%@'; it should be '9'.", JFStringFromNSInteger(version.patch));
	XCTAssert(JFAreObjectsEqual(version.build, @"ABCDEF12"), @"The build version is '%@'; it should be 'ABCDEF12'.", version.build);
	
	if(@available(macOS 10.10, *))
	{
		NSOperatingSystemVersion systemVersion;
		systemVersion.majorVersion = major;
		systemVersion.minorVersion = minor;
		systemVersion.patchVersion = patch;
		
		version = [[JFVersion alloc] initWithOperatingSystemVersion:systemVersion];
		XCTAssert((version.major == 1), @"The major version is '%@'; it should be '1'.", JFStringFromNSInteger(version.major));
		XCTAssert((version.minor == 0), @"The minor version is '%@'; it should be '0'.", JFStringFromNSInteger(version.minor));
		XCTAssert((version.patch == 9), @"The patch version is '%@'; it should be '9'.", JFStringFromNSInteger(version.patch));
		XCTAssert(version.build == nil, @"The build version is '%@'; it should be nil.", version.build);
	}
}

- (void)testEquality
{
	NSInteger major = 1;
	NSInteger minor = 0;
	NSInteger patch = 9;
	NSString* build = @"ABCDEF12";
	
	JFVersion* version = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:build];
	JFVersion* equalVersion = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:build];
	JFVersion* almostEqualVersion = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:@"ABCDEF11"];
	JFVersion* greaterVersion = [[JFVersion alloc] initWithMajorComponent:(major + 1) minor:minor patch:patch build:build];
	JFVersion* lesserVersion = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:(patch - 1) build:build];
	
	XCTAssert([version isEqualToVersion:equalVersion], @"Version '%@' should be equal to version '%@'.", version.string, equalVersion.string);
	XCTAssert(![version isEqualToVersion:almostEqualVersion], @"Version '%@' should not be equal to version '%@'.", version.string, almostEqualVersion.string);
	XCTAssert([version isLessThanVersion:greaterVersion], @"Version '%@' should be less than version '%@'.", version.string, greaterVersion.string);
	XCTAssert([version isGreaterThanVersion:lesserVersion], @"Version '%@' should be greater than version '%@'.", version.string, lesserVersion.string);
}

- (void)testVersionString
{
	NSInteger major = 1;
	NSInteger minor = 0;
	NSInteger patch = 9;
	NSString* build = @"ABCDEF12";
	
	JFVersion* version = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:build];
	NSString* string = version.string;
	NSString* result = @"1.0.9 (ABCDEF12)";
	XCTAssert(JFAreObjectsEqual(string, result), @"The version string is '%@'; it should be '%@'.", string, result);
	
	version = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:patch build:nil];
	string = version.string;
	result = @"1.0.9";
	XCTAssert(JFAreObjectsEqual(string, result), @"The version string is '%@'; it should be '%@'.", string, result);
	
	version = [[JFVersion alloc] initWithMajorComponent:major minor:minor patch:0 build:build];
	string = version.string;
	result = @"1.0 (ABCDEF12)";
	XCTAssert(JFAreObjectsEqual(string, result), @"The version string is '%@'; it should be '%@'.", string, result);
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
