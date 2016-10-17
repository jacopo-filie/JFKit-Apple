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



#import <XCTest/XCTest.h>

#import "JFString.h"
#import "JFUtilities.h"
#import "JFVersion.h"



@interface JFVersion_Tests : XCTestCase

@end



#pragma mark



@implementation JFVersion_Tests

// =================================================================================================
// MARK: Methods - Tests management
// =================================================================================================

- (void)testCreateWithString
{
	NSString* versionString = @"1.0.9 (ABCDEF12)";
	JFVersion* version = [[JFVersion alloc] initWithVersionString:versionString];
	XCTAssert((version.majorVersion == 1), @"The major version is '%@'; it should be '1'.", JFStringFromNSInteger(version.majorVersion));
	XCTAssert((version.minorVersion == 0), @"The minor version is '%@'; it should be '0'.", JFStringFromNSInteger(version.minorVersion));
	XCTAssert((version.patchVersion == 9), @"The patch version is '%@'; it should be '9'.", JFStringFromNSInteger(version.patchVersion));
	XCTAssert(JFAreObjectsEqual(version.buildVersion, @"ABCDEF12"), @"The build version is '%@'; it should be 'ABCDEF12'.", version.buildVersion);
	
	versionString = @"1.0 (ABCDEF12)";
	version = [[JFVersion alloc] initWithVersionString:versionString];
	XCTAssert((version.majorVersion == 1), @"The major version is '%@'; it should be '1'.", JFStringFromNSInteger(version.majorVersion));
	XCTAssert((version.minorVersion == 0), @"The minor version is '%@'; it should be '0'.", JFStringFromNSInteger(version.minorVersion));
	XCTAssert((version.patchVersion == -1), @"The patch version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.patchVersion));
	XCTAssert(JFAreObjectsEqual(version.buildVersion, @"ABCDEF12"), @"The build version is '%@'; it should be 'ABCDEF12'.", version.buildVersion);
	
	versionString = @"0.8.9";
	version = [[JFVersion alloc] initWithVersionString:versionString];
	XCTAssert((version.majorVersion == 0), @"The major version is '%@'; it should be '0'.", JFStringFromNSInteger(version.majorVersion));
	XCTAssert((version.minorVersion == 8), @"The minor version is '%@'; it should be '8'.", JFStringFromNSInteger(version.minorVersion));
	XCTAssert((version.patchVersion == 9), @"The patch version is '%@'; it should be '9'.", JFStringFromNSInteger(version.patchVersion));
	XCTAssert(version.buildVersion == nil, @"The build version is '%@'; it should be nil.", version.buildVersion);
	
	versionString = @"(ABCDEF12)";
	version = [[JFVersion alloc] initWithVersionString:versionString];
	XCTAssert((version.majorVersion == -1), @"The major version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.majorVersion));
	XCTAssert((version.minorVersion == -1), @"The minor version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.minorVersion));
	XCTAssert((version.patchVersion == -1), @"The patch version is '%@'; it should be '-1'.", JFStringFromNSInteger(version.patchVersion));
	XCTAssert(JFAreObjectsEqual(version.buildVersion, @"ABCDEF12"), @"The build version is '%@'; it should be 'ABCDEF12'.", version.buildVersion);
	
}

@end
