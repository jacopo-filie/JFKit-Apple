//
//	The MIT License (MIT)
//
//	Copyright © 2019-2024 Jacopo Filié
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

#import "JFJSONSerializer.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

API_AVAILABLE(ios(8.0), macos(10.7))
@interface JFJSONSerializer_Tests : XCTestCase

@property (strong, nonatomic, readonly) NSArray<id<JFJSONConvertibleValue>>* jsonArray;
@property (strong, nonatomic, readonly) NSData* jsonArrayData;
@property (strong, nonatomic, readonly) NSURL* jsonArrayFileURL;
@property (strong, nonatomic, readonly) NSString* jsonArrayString;
@property (strong, nonatomic, readonly) NSDictionary<NSString*, id<JFJSONConvertibleValue>>* jsonObject;
@property (strong, nonatomic, readonly) NSData* jsonObjectData;
@property (strong, nonatomic, readonly) NSURL* jsonObjectFileURL;
@property (strong, nonatomic, readonly) NSString* jsonObjectString;
@property (strong, nonatomic, readonly) JFJSONSerializer* serializer;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFJSONSerializer_Tests

@synthesize jsonArray = _jsonArray;
@synthesize jsonArrayData = _jsonArrayData;
@synthesize jsonArrayFileURL = _jsonArrayFileURL;
@synthesize jsonArrayString = _jsonArrayString;
@synthesize jsonObject = _jsonObject;
@synthesize jsonObjectData = _jsonObjectData;
@synthesize jsonObjectFileURL = _jsonObjectFileURL;
@synthesize jsonObjectString = _jsonObjectString;
@synthesize serializer = _serializer;

- (NSArray<id<JFJSONConvertibleValue>>*)jsonArray
{
	NSArray<id<JFJSONConvertibleValue>>* retObj = _jsonArray;
	if(!retObj)
	{
		NSError* error;
		retObj = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:0 error:&error];
		XCTAssertNil(error);
		XCTAssertNotNil(retObj);
		_jsonArray = retObj;
	}
	return retObj;
}

- (NSData*)jsonArrayData
{
	NSData* retObj = _jsonArrayData;
	if(!retObj)
	{
		retObj = [[NSData alloc] initWithContentsOfURL:self.jsonArrayFileURL];
		XCTAssertNotNil(retObj);
		_jsonArrayData = retObj;
	}
	return retObj;
}

- (NSURL*)jsonArrayFileURL
{
	NSURL* retObj = _jsonArrayFileURL;
	if(!retObj)
	{
		retObj = [[NSBundle bundleForClass:self.class] URLForResource:@"Array" withExtension:@"json"];
		XCTAssertNotNil(retObj);
		_jsonArrayFileURL = retObj;
	}
	return retObj;
}

- (NSString*)jsonArrayString
{
	NSString* retObj = _jsonArrayString;
	if(!retObj)
	{
		NSError* error;
		retObj = [[NSString alloc] initWithContentsOfURL:self.jsonArrayFileURL encoding:NSUTF8StringEncoding error:&error];
		XCTAssertNil(error);
		XCTAssertNotNil(retObj);
		_jsonArrayString = retObj;
	}
	return retObj;
}

- (NSDictionary<NSString*, id<JFJSONConvertibleValue>>*)jsonObject
{
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* retObj = _jsonObject;
	if(!retObj)
	{
		NSError* error;
		retObj = [NSJSONSerialization JSONObjectWithData:self.jsonObjectData options:0 error:&error];
		XCTAssertNil(error);
		XCTAssertNotNil(retObj);
		_jsonObject = retObj;
	}
	return retObj;
}

- (NSData*)jsonObjectData
{
	NSData* retObj = _jsonObjectData;
	if(!retObj)
	{
		retObj = [[NSData alloc] initWithContentsOfURL:self.jsonObjectFileURL];
		XCTAssertNotNil(retObj);
		_jsonObjectData = retObj;
	}
	return retObj;
}

- (NSURL*)jsonObjectFileURL
{
	NSURL* retObj = _jsonObjectFileURL;
	if(!retObj)
	{
		retObj = [[NSBundle bundleForClass:self.class] URLForResource:@"Object" withExtension:@"json"];
		XCTAssertNotNil(retObj);
		_jsonObjectFileURL = retObj;
	}
	return retObj;
}

- (NSString*)jsonObjectString
{
	NSString* retObj = _jsonObjectString;
	if(!retObj)
	{
		NSError* error;
		retObj = [[NSString alloc] initWithContentsOfURL:self.jsonObjectFileURL encoding:NSUTF8StringEncoding error:&error];
		XCTAssertNil(error);
		XCTAssertNotNil(retObj);
		_jsonObjectString = retObj;
	}
	return retObj;
}

- (JFJSONSerializer*)serializer
{
	JFJSONSerializer* retObj = _serializer;
	if(!retObj)
	{
		retObj = [JFJSONSerializer new];
		XCTAssertNotNil(retObj);
		_serializer = retObj;
	}
	return retObj;
}

- (void)testArrayFromData
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSArray<id<JFJSONConvertibleValue>>* result = [serializer arrayFromData:nil];
	XCTAssertNil(result);
	
	result = [serializer arrayFromData:[NSData new]];
	XCTAssertNil(result);
	
	result = [serializer arrayFromData:self.jsonObjectData];
	XCTAssertNil(result);
	
	result = [serializer arrayFromData:self.jsonArrayData];
	XCTAssertNotNil(result);
	XCTAssertEqualObjects(self.jsonArray, result);
}

- (void)testArrayFromString
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSArray<id<JFJSONConvertibleValue>>* result = [serializer arrayFromString:nil];
	XCTAssertNil(result);
	
	result = [serializer arrayFromString:@""];
	XCTAssertNil(result);
	
	result = [serializer arrayFromString:self.jsonObjectString];
	XCTAssertNil(result);
	
	result = [serializer arrayFromString:self.jsonArrayString];
	XCTAssertNotNil(result);
	XCTAssertEqualObjects(self.jsonArray, result);
}

- (void)testDataFromArray
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSData* data = [serializer dataFromArray:nil];
	XCTAssertNil(data);
	
	data = [serializer dataFromArray:@[@[[NSObject new]]]];
	XCTAssertNil(data);
	
	NSArray<id<JFJSONConvertibleValue>>* source = self.jsonArray;
	
	data = [serializer dataFromArray:source];
	XCTAssertNotNil(data);
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSArray.class]);
	
	XCTAssertEqualObjects(source, result);
}

- (void)testStringFromArray
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSString* string = [serializer stringFromArray:nil];
	XCTAssertNil(string);
	
	string = [serializer stringFromArray:@[@[[NSObject new]]]];
	XCTAssertNil(string);
	
	NSArray<id<JFJSONConvertibleValue>>* source = self.jsonArray;
	
	string = [serializer stringFromArray:source];
	XCTAssertNotNil(string);
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSArray.class]);
	
	XCTAssertEqualObjects(source, result);
}

- (void)testDataFromDictionary
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSData* data = [serializer dataFromDictionary:nil];
	XCTAssertNil(data);
	
	data = [serializer dataFromDictionary:@{@"":@[[NSObject new]]}];
	XCTAssertNil(data);
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* source = self.jsonObject;
	
	data = [serializer dataFromDictionary:source];
	XCTAssertNotNil(data);
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSDictionary.class]);
	
	XCTAssertEqualObjects(source, result);
}

- (void)testDictionaryFromData
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* result = [serializer dictionaryFromData:nil];
	XCTAssertNil(result);
	
	result = [serializer dictionaryFromData:[NSData new]];
	XCTAssertNil(result);
	
	result = [serializer dictionaryFromData:self.jsonArrayData];
	XCTAssertNil(result);
	
	result = [serializer dictionaryFromData:self.jsonObjectData];
	XCTAssertNotNil(result);
	XCTAssertEqualObjects(self.jsonObject, result);
}

- (void)testDictionaryFromString
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* result = [serializer dictionaryFromString:nil];
	XCTAssertNil(result);
	
	result = [serializer dictionaryFromString:@""];
	XCTAssertNil(result);
	
	result = [serializer dictionaryFromString:self.jsonArrayString];
	XCTAssertNil(result);
	
	result = [serializer dictionaryFromString:self.jsonObjectString];
	XCTAssertNotNil(result);
	XCTAssertEqualObjects(self.jsonObject, result);
}

- (void)testStringFromDictionary
{
	JFJSONSerializer* serializer = self.serializer;
	
	NSString* string = [serializer stringFromDictionary:nil];
	XCTAssertNil(string);
	
	string = [serializer stringFromDictionary:@{@"":@[[NSObject new]]}];
	XCTAssertNil(string);
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* source = self.jsonObject;
	
	string = [serializer stringFromDictionary:source];
	XCTAssertNotNil(string);
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSDictionary.class]);
	
	XCTAssertEqualObjects(source, result);
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
