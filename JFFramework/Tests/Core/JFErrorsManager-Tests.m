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



#import <XCTest/XCTest.h>

#import "JFErrorsManager.h"
#import "JFString.h"
#import "JFUtilities.h"



@class JFTestErrorsManager;



#pragma mark - Types

typedef NS_ENUM(JFErrorCode, JFTestErrorCode)
{
	JFTestErrorCode1	= 1,
	JFTestErrorCode2	= 2,
	JFTestErrorCode3	= 3,
};



#pragma mark



@interface JFTestErrorsManager : JFErrorsManager

@end



#pragma mark



@interface JFErrorsManager_Tests : XCTestCase

#pragma mark Properties

// Relationships
@property (strong, nonatomic)	JFTestErrorsManager*	manager;

@end



#pragma mark



@implementation JFErrorsManager_Tests

#pragma mark Properties

// Relationships
@synthesize manager	= _manager;


#pragma mark Tests

- (void)setUp
{
	[super setUp];
	
	// Creates the errors manager.
	NSString* domain = @"Tests";
	JFTestErrorsManager* manager = [[JFTestErrorsManager alloc] initWithDomain:domain];
	XCTAssert(manager, @"Failed to create the errors manager.");
	XCTAssert([manager.domain isEqualToString:domain], @"The manager domain ('%@') differs from the passed domain ('%@').", manager.domain, domain);
	self.manager = manager;
}

- (void)tearDown
{
	// Destroys the errors management.
	self.manager = nil;
	
	[super tearDown];
}

- (void)testDataManagement
{
	JFTestErrorsManager* manager = self.manager;
	
	// -debugStringForErrorCode:
	NSString* result = [manager debugStringForErrorCode:JFTestErrorCode2];
	NSString* expectedResult = @"Error 2";
	XCTAssert(JFAreObjectsEqual(result, expectedResult), @"The result is '%@'; it should be '%@'.", result, expectedResult);
	
	// -localizedDescriptionForErrorCode:
	result = [manager localizedDescriptionForErrorCode:JFTestErrorCode1];
	expectedResult = @"Something failed.";
	XCTAssert(JFAreObjectsEqual(result, expectedResult), @"The result is '%@'; it should be '%@'.", result, expectedResult);
	
	// -localizedFailureReasonForErrorCode:
	result = [manager localizedFailureReasonForErrorCode:JFTestErrorCode3];
	expectedResult = @"Error 3 happened.";
	XCTAssert(JFAreObjectsEqual(result, expectedResult), @"The result is '%@'; it should be '%@'.", result, expectedResult);
	
	// -localizedRecoverySuggestionForErrorCode:
	result = [manager localizedRecoverySuggestionForErrorCode:JFTestErrorCode3];
	expectedResult = @"Have a meal and relax.";
	XCTAssert(JFAreObjectsEqual(result, expectedResult), @"The result is '%@'; it should be '%@'.", result, expectedResult);
	
	// -userInfoForErrorCode:
	NSDictionary* dict = [manager userInfoForErrorCode:JFTestErrorCode1];
	NSDictionary* expectedDict = @{NSLocalizedDescriptionKey:@"Something failed.", NSLocalizedFailureReasonErrorKey:@"Error 1 happened.", NSLocalizedRecoverySuggestionErrorKey:@"Restart your device."};
	XCTAssert(JFAreObjectsEqual(dict, expectedDict), @"The result is '%@'; it should be '%@'.", dict, expectedDict);
	
	// -userInfoForErrorCode:underlyingError:
	NSError* error = [NSError errorWithDomain:@"Tests2" code:NSIntegerMax userInfo:nil];
	dict = [manager userInfoForErrorCode:JFTestErrorCode2 underlyingError:error];
	expectedDict = @{NSLocalizedDescriptionKey:@"An error occurred.", NSLocalizedFailureReasonErrorKey:@"Error 2 happened.", NSLocalizedRecoverySuggestionErrorKey:@"Walk for 5 minutes and retry.", NSUnderlyingErrorKey:error};
	XCTAssert(JFAreObjectsEqual(dict, expectedDict), @"The result is '%@'; it should be '%@'.", dict, expectedDict);
}


- (void)testErrorsManagement
{
	JFTestErrorsManager* manager = self.manager;
	
	// -debugPlaceholderError
	NSError* error = [manager debugPlaceholderError];
	JFErrorCode expectedErrorCode = NSIntegerMax;
	XCTAssert((error.code == expectedErrorCode), @"The returned error code is '%@'; it should be '%@'.", JFStringFromNSInteger(error.code), JFStringFromNSInteger(expectedErrorCode));
	XCTAssert(JFAreObjectsEqual(error, [manager debugPlaceholderError]), @"The returned errors should be equal.");
	
	// -errorWithCode:
	JFErrorCode errorCode = JFTestErrorCode1;
	error = [manager errorWithCode:errorCode];
	NSError* expectedError = [NSError errorWithDomain:manager.domain code:errorCode userInfo:[manager userInfoForErrorCode:errorCode]];
	XCTAssert(JFAreObjectsEqual(error, expectedError), @"The returned error is '%@'; it should be '%@'.", error, expectedError);
	
	// -errorWithCode:userInfo:
	errorCode = JFTestErrorCode2;
	error = [manager errorWithCode:errorCode userInfo:nil];
	expectedError = [NSError errorWithDomain:manager.domain code:errorCode userInfo:nil];
	XCTAssert(JFAreObjectsEqual(error, expectedError), @"The returned error is '%@'; it should be '%@'.", error, expectedError);
}

@end



#pragma mark



@implementation JFTestErrorsManager

#pragma mark Data management

- (NSString*)debugStringForErrorCode:(JFErrorCode)errorCode
{
	NSString* retObj = nil;
	switch (errorCode)
	{
		case JFTestErrorCode1:	retObj	= @"Error 1";	break;
		case JFTestErrorCode2:	retObj	= @"Error 2";	break;
		case JFTestErrorCode3:	retObj	= @"Error 3";	break;
			
		default:
			break;
	}
	return retObj;
}

- (NSString*)localizedDescriptionForErrorCode:(JFErrorCode)errorCode
{
	NSString* retObj = nil;
	switch (errorCode)
	{
		case JFTestErrorCode1:	retObj	= @"Something failed.";		break;
		case JFTestErrorCode2:	retObj	= @"An error occurred.";	break;
		case JFTestErrorCode3:	retObj	= @"Failed operation.";		break;
			
		default:
			break;
	}
	return retObj;
}

- (NSString*)localizedFailureReasonForErrorCode:(JFErrorCode)errorCode
{
	NSString* retObj = nil;
	switch (errorCode)
	{
		case JFTestErrorCode1:	retObj	= @"Error 1 happened.";	break;
		case JFTestErrorCode2:	retObj	= @"Error 2 happened.";	break;
		case JFTestErrorCode3:	retObj	= @"Error 3 happened.";	break;
			
		default:
			break;
	}
	return retObj;
}

- (NSString*)localizedRecoverySuggestionForErrorCode:(JFErrorCode)errorCode
{
	NSString* retObj = nil;
	switch (errorCode)
	{
		case JFTestErrorCode1:	retObj	= @"Restart your device.";			break;
		case JFTestErrorCode2:	retObj	= @"Walk for 5 minutes and retry.";	break;
		case JFTestErrorCode3:	retObj	= @"Have a meal and relax.";		break;
			
		default:
			break;
	}
	return retObj;
}

@end