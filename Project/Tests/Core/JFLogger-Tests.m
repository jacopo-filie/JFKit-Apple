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

#import <XCTest/XCTest.h>

#import "JFLogger.h"

#import "JFShortcuts.h"
#import "JFStrings.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFLoggerSubclass : JFLogger

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFLogger_Tests : XCTestCase

// =================================================================================================
// MARK: Properties - Tests
// =================================================================================================

@property (strong, nonatomic, nullable) JFLoggerSubclass* logger;

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)setUp;
- (void)tearDown;
- (void)testHashtagsLogging;
- (void)testLowPriorityLogging;
- (void)testOnlyConsoleLogging;
- (void)testSimpleLogging;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (NSArray*)readTestLogFileLines;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFLogger_Tests

// =================================================================================================
// MARK: Properties - Tests
// =================================================================================================

@synthesize logger = _logger;

// =================================================================================================
// MARK: Methods - Tests
// =================================================================================================

- (void)setUp
{
	[super setUp];
	
	// Creates the logger with the test log file.
	JFLoggerSubclass* logger = [[JFLoggerSubclass alloc] init];
	XCTAssert(logger, @"Failed to create the test logger.");
	logger.fileName = @"Test.log";
	logger.severityFilter = JFLoggerSeverityInfo;
	self.logger = logger;
}

- (void)tearDown
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	// Checks if the test log file still exists and deletes it if necessary.
	NSURL* fileURL = [[[self.logger class] defaultDirectoryURL] URLByAppendingPathComponent:self.logger.fileName];
	if([fileManager fileExistsAtPath:fileURL.path])
	{
		NSError* error = nil;
		BOOL succeeded = [fileManager removeItemAtURL:fileURL error:&error];
		NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", [error description]] : JFEmptyString);
		XCTAssert(succeeded, @"Failed to delete the test file at URL '%@'%@.", [fileURL absoluteString], errorString);
	}
	
	// Destroys the logger.
	self.logger = nil;
	
	[super tearDown];
}

- (void)testHashtagsLogging
{
	NSString* logMessage = MethodName;
	[self.logger log:logMessage severity:JFLoggerSeverityEmergency tags:(JFLoggerTagsDeveloper | JFLoggerTagsMarker)];
	NSArray* lines = [self readTestLogFileLines];
	NSString* result = [lines firstObject];
	NSString* expectedMessage = [logMessage stringByAppendingString:@" #Developer #Marker"];
	NSRange range = [result rangeOfString:expectedMessage options:(NSStringCompareOptions)(NSAnchoredSearch | NSBackwardsSearch)];
	XCTAssert((range.location != NSNotFound), @"The logged text differs from the message passed to the logger.\n");
}

- (void)testLowPriorityLogging
{
	NSString* logMessage = MethodName;
	[self.logger log:logMessage severity:JFLoggerSeverityEmergency]; // Needed to create the file.
	[self.logger log:logMessage severity:JFLoggerSeverityDebug];
	NSArray* lines = [self readTestLogFileLines];
	XCTAssert(([lines count] == 1), @"The test log file should have 1 line because the message priority was too low.\n");
}

- (void)testOnlyConsoleLogging
{
	NSString* logMessage = MethodName;
	[self.logger log:logMessage output:JFLoggerOutputFile severity:JFLoggerSeverityEmergency]; // Needed to create the file.
	[self.logger log:logMessage output:JFLoggerOutputConsole severity:JFLoggerSeverityEmergency];
	NSArray* lines = [self readTestLogFileLines];
	XCTAssert(([lines count] == 1), @"The test log file should have 1 line because the destination was only the console.\n");
}

- (void)testSimpleLogging
{
	NSString* logMessage = MethodName;
	[self.logger log:logMessage severity:JFLoggerSeverityEmergency];
	NSArray* lines = [self readTestLogFileLines];
	NSString* result = [lines firstObject];
	NSRange range = [result rangeOfString:logMessage options:(NSStringCompareOptions)(NSAnchoredSearch | NSBackwardsSearch)];
	XCTAssert((range.location != NSNotFound), @"The logged text differs from the message passed to the logger.\n");
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (NSArray*)readTestLogFileLines
{
	NSError* error = nil;
	NSURL* fileURL = [[[self.logger class] defaultDirectoryURL] URLByAppendingPathComponent:self.logger.fileName];
	NSString* fileContent = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
	NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", [error description]] : JFEmptyString);
	XCTAssert(fileContent, @"Failed to read result from the test log file at URL '%@'%@.", [fileURL absoluteString], errorString);
	
	NSMutableArray* retObj = [[fileContent componentsSeparatedByString:@"\n"] mutableCopy];
	XCTAssert(retObj, @"Failed to get the lines of the test log file at URL '%@'%@.", [fileURL absoluteString], errorString);
	
	NSString* lastLine = [retObj lastObject];
	if(lastLine && [lastLine isEqualToString:JFEmptyString])
		[retObj removeLastObject];
	
	return retObj;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFLoggerSubclass

// =================================================================================================
// MARK: Properties accessors - Data
// =================================================================================================

+ (NSURL*)defaultDirectoryURL
{
	static NSURL* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError* error = nil;
		NSURL* url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
		NSAssert(url, @"Failed to load application support directory due to error '%@'.", error.description);
		
#if JF_MACOS
		NSString* domain = [ClassBundle.infoDictionary objectForKey:@"CFBundleIdentifier"];
		NSAssert(domain, @"Bundle identifier not found!");
		url = [url URLByAppendingPathComponent:domain];
#endif
		
		retObj = [url URLByAppendingPathComponent:@"Logs"];
	});
	return retObj;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
