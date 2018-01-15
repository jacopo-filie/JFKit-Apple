//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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

#import "JFLogger.h"
#import "JFShortcuts.h"
#import "JFString.h"



@interface JFLogger_Tests : XCTestCase

#pragma mark Properties

// Relationships
@property (strong, nonatomic)	JFLogger*	logger;

@end



#pragma mark



@implementation JFLogger_Tests

#pragma mark Properties

// Relationships
@synthesize logger	= _logger;


#pragma mark Tests

- (void)setUp
{
	[super setUp];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	// Gets the caches folder.
	NSError* error = nil;
	NSURL* folderURL = [fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
	
	// Prepares a new random URL for the test log file.
	NSURL* fileURL = [folderURL URLByAppendingPathComponent:@"Test.log"];
	NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
	XCTAssert(fileURL, @"Failed to prepare an URL for the test log file%@.", errorString);
	
	// Creates the empty test log file.
	BOOL succeeded = [[NSData data] writeToURL:fileURL options:NSDataWritingAtomic error:&error];
	errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
	XCTAssert(succeeded, @"Failed to create an empty test log file at URL '%@'%@.", [fileURL absoluteString], errorString);
	
	// Creates the logger with the test log file.
	JFLogger* logger = [[JFLogger alloc] initWithFileURL:fileURL];
	XCTAssert(logger, @"Failed to create the test logger.");
	logger.priority = JFLogPriority6Info;
	self.logger = logger;
}

- (void)tearDown
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	// Checks if the test log file still exists and deletes it if necessary.
	NSURL* fileURL = self.logger.fileURL;
	if([fileManager fileExistsAtPath:(NSString*)fileURL.path])
	{
		NSError* error = nil;
		BOOL succeeded = [fileManager removeItemAtURL:fileURL error:&error];
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		XCTAssert(succeeded, @"Failed to delete the test file at URL '%@'%@.", [fileURL absoluteString], errorString);
	}
	
	// Destroys the logger.
	self.logger = nil;
	
	[super tearDown];
}

- (void)testCategory
{
	NSObject* object = [NSObject new];
	
	// jf_logger
	JFLogger* logger = object.jf_logger;
	XCTAssert((logger == [JFLogger sharedManager]), @"The default object logger is not the singleton.");
	
	// jf_shouldDebugLog
	BOOL flag = object.jf_shouldDebugLog;
#ifdef DEBUG
	BOOL expectedValue = YES;
#else
	BOOL expectedValue = NO;
#endif
	XCTAssert((flag == expectedValue), @"The \"shouldDebugLog\" flag value is '%@'; it should be '%@'.", JFStringFromBool(flag), JFStringFromBool(expectedValue));
	object.jf_shouldDebugLog = NO;
	flag = object.jf_shouldDebugLog;
	expectedValue = NO;
	XCTAssert((flag == expectedValue), @"The \"shouldDebugLog\" flag value is '%@'; it should be '%@'.", JFStringFromBool(flag), JFStringFromBool(expectedValue));
	
	// jf_shouldLog
	flag = object.jf_shouldLog;
	expectedValue = YES;
	XCTAssert((flag == expectedValue), @"The \"shouldLog\" flag value is '%@'; it should be '%@'.", JFStringFromBool(flag), JFStringFromBool(expectedValue));
	object.jf_shouldLog = NO;
	flag = object.jf_shouldLog;
	expectedValue = NO;
	XCTAssert((flag == expectedValue), @"The \"shouldLog\" flag value is '%@'; it should be '%@'.", JFStringFromBool(flag), JFStringFromBool(expectedValue));
}

- (void)testHashtagsLogging
{
	NSString* logMessage = MethodName;
	[self.logger logMessage:logMessage priority:JFLogPriority0Emergency hashtags:(JFLogHashtags)(JFLogHashtagDeveloper | JFLogHashtagMarker)];
	NSArray* lines = [self readTestLogFileLines];
	NSString* result = [lines firstObject];
	NSString* expectedMessage = [logMessage stringByAppendingString:@" #Developer #Marker"];
	NSRange range = [result rangeOfString:expectedMessage options:(NSStringCompareOptions)(NSAnchoredSearch | NSBackwardsSearch)];
	XCTAssert((range.location != NSNotFound), @"The logged text differs from the message passed to the logger.\n");
}

- (void)testLowPriorityLogging
{
	NSString* logMessage = MethodName;
	[self.logger logMessage:logMessage priority:JFLogPriority7Debug];
	NSArray* lines = [self readTestLogFileLines];
	XCTAssert(([lines count] == 0), @"The test log file should be empty because the message priority was too low.\n");
}

- (void)testOnlyConsoleLogging
{
	NSString* logMessage = MethodName;
	[self.logger logMessage:logMessage toDestinations:JFLogDestinationConsole priority:JFLogPriority0Emergency];
	NSArray* lines = [self readTestLogFileLines];
	XCTAssert(([lines count] == 0), @"The test log file should be empty because the destination was only the console.\n");
}

- (void)testSimpleLogging
{
	NSString* logMessage = MethodName;
	[self.logger logMessage:logMessage priority:JFLogPriority0Emergency];
	NSArray* lines = [self readTestLogFileLines];
	NSString* result = [lines firstObject];
	NSRange range = [result rangeOfString:logMessage options:(NSStringCompareOptions)(NSAnchoredSearch | NSBackwardsSearch)];
	XCTAssert((range.location != NSNotFound), @"The logged text differs from the message passed to the logger.\n");
}


#pragma mark Utilities management

- (NSArray*)readTestLogFileLines
{
	NSError* error = nil;
	NSURL* fileURL = self.logger.fileURL;
	NSString* fileContent = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
	NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
	XCTAssert(fileContent, @"Failed to read result from the test log file at URL '%@'%@.", [fileURL absoluteString], errorString);
	
	NSMutableArray* retObj = [[fileContent componentsSeparatedByString:@"\n"] mutableCopy];
	XCTAssert(retObj, @"Failed to get the lines of the test log file at URL '%@'%@.", [fileURL absoluteString], errorString);
	
	NSString* lastLine = [retObj lastObject];
	if(lastLine && [lastLine isEqualToString:JFEmptyString])
		[retObj removeLastObject];
	
	return retObj;
}

@end
