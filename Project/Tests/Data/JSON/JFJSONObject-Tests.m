//
//	The MIT License (MIT)
//
//	Copyright © 2019-2021 Jacopo Filié
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

#import "JFJSONArray.h"
#import "JFJSONObject.h"
#import "JFJSONSerializer.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

API_AVAILABLE(ios(8.0), macos(10.7))
@interface JFJSONObject_Tests : XCTestCase

@property (strong, nonatomic, readonly) NSData* data;
@property (strong, nonatomic, readonly) NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary;
@property (strong, nonatomic, readonly) NSURL* fileURL;
@property (strong, nonatomic, readonly) NSString* string;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFJSONObject_Tests

@synthesize data = _data;
@synthesize dictionary = _dictionary;
@synthesize fileURL = _fileURL;
@synthesize string = _string;

- (NSData*)data
{
	NSData* retObj = _data;
	if(!retObj)
	{
		retObj = [[NSData alloc] initWithContentsOfURL:self.fileURL];
		XCTAssertNotNil(retObj);
		_data = retObj;
	}
	return retObj;
}

- (NSDictionary<NSString*, id<JFJSONConvertibleValue>>*)dictionary
{
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* retObj = _dictionary;
	if(!retObj)
	{
		NSError* error;
		retObj = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
		XCTAssertNil(error);
		XCTAssertNotNil(retObj);
		_dictionary = retObj;
	}
	return retObj;
}

- (NSURL*)fileURL
{
	NSURL* retObj = _fileURL;
	if(!retObj)
	{
		retObj = [[NSBundle bundleForClass:self.class] URLForResource:@"Object" withExtension:@"json"];
		XCTAssertNotNil(retObj);
		_fileURL = retObj;
	}
	return retObj;
}

- (NSString*)string
{
	NSString* retObj = _string;
	if(!retObj)
	{
		NSError* error;
		retObj = [[NSString alloc] initWithContentsOfURL:self.fileURL encoding:NSUTF8StringEncoding error:&error];
		XCTAssertNil(error);
		XCTAssertNotNil(retObj);
		_string = retObj;
	}
	return retObj;
}

- (void)testCount
{
	JFJSONObject* jsonObject = [self newJSONObject];
	
	jsonObject = [JFJSONObject objectWithDictionary:self.dictionary];
	XCTAssertEqual(jsonObject.count, 9);
	
	jsonObject = [JFJSONObject objectWithData:self.data];
	XCTAssertEqual(jsonObject.count, 9);
	
	jsonObject = [JFJSONObject objectWithString:self.string];
	XCTAssertEqual(jsonObject.count, 9);
}

- (void)testDataValue
{
	XCTAssertEqualObjects([self newJSONObject].dataValue, [@"{}" dataUsingEncoding:NSUTF8StringEncoding]);
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:[JFJSONObject objectWithDictionary:dictionary].dataValue options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSDictionary.class]);
	
	XCTAssertEqualObjects(result, dictionary);
}

- (void)testStringValue
{
	XCTAssertEqualObjects([self newJSONObject].stringValue, @"{}");
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:[[JFJSONObject objectWithDictionary:dictionary].stringValue dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSDictionary.class]);
	
	XCTAssertEqualObjects(result, dictionary);
}

- (void)testSerializer
{
	JFJSONObject* jsonObject = [self newJSONObject];
	
	id<JFJSONSerializationAdapter> defaultSerializer = jsonObject.serializer;
	XCTAssertNotNil(defaultSerializer);
	
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	jsonObject.serializer = serializer;
	
	id<JFJSONSerializationAdapter> returnedSerializer = jsonObject.serializer;
	XCTAssertNotNil(returnedSerializer);
	XCTAssertEqualObjects(returnedSerializer, serializer);
	
	jsonObject.serializer = nil;
	returnedSerializer = jsonObject.serializer;
	XCTAssertNotNil(returnedSerializer);
	XCTAssertEqualObjects(returnedSerializer, defaultSerializer);
}

- (void)testInitWithDataAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	JFJSONObject* jsonObject = [[JFJSONObject alloc] initWithData:self.data serializer:serializer];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, serializer);
}

- (void)testInitWithStringAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	JFJSONObject* jsonObject = [[JFJSONObject alloc] initWithString:self.string serializer:serializer];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, serializer);
}

- (void)testAllKeys
{
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithDictionary:dictionary];
	
	NSSet<NSString*>* keys1 = [NSSet<NSString*> setWithArray:dictionary.allKeys];
	NSSet<NSString*>* keys2 = [NSSet<NSString*> setWithArray:jsonObject.allKeys];
	
	XCTAssertEqualObjects(keys1, keys2);
}

- (void)testAllValues
{
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithDictionary:dictionary];
	
	NSCountedSet<id<JFJSONConvertibleValue>>* values1 = [NSCountedSet<id<JFJSONConvertibleValue>> setWithArray:dictionary.allValues];
	NSCountedSet<id<JFJSONValue>>* values2 = [NSCountedSet<id<JFJSONValue>> setWithArray:jsonObject.allValues];
	
	XCTAssertEqual(values1.count, values2.count);
	
	for(id<JFJSONValue> value2 in values2)
	{
		id<JFJSONConvertibleValue> value1;
		if([value2 isKindOfClass:JFJSONArray.class])
			value1 = ((JFJSONArray*)value2).arrayValue;
		else if([value2 isKindOfClass:JFJSONObject.class])
			value1 = ((JFJSONObject*)value2).dictionaryValue;
		else
			value1 = (id<JFJSONConvertibleValue>)value2;
		
		XCTAssertTrue([values1 containsObject:value1]);
		XCTAssertEqual([values1 countForObject:value1], [values2 countForObject:value2]);
	}
}

- (void)testDictionaryValue
{
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	JFJSONObject* jsonObject = [[JFJSONObject alloc] initWithDictionary:dictionary];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
	
	jsonObject = [[JFJSONObject alloc] initWithData:self.data];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
	
	jsonObject = [[JFJSONObject alloc] initWithString:self.string];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
}

- (void)testObjectWithData
{
	XCTAssertNil([JFJSONObject objectWithData:nil]);
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithData:self.data];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, self.dictionary);
}

- (void)testobjectWithDataAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	
	XCTAssertNil([JFJSONObject objectWithData:nil serializer:nil]);
	XCTAssertNil([JFJSONObject objectWithData:nil serializer:serializer]);
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithData:self.data serializer:nil];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, [self newJSONObject].serializer);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
	
	jsonObject = [JFJSONObject objectWithData:self.data serializer:serializer];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, serializer);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
}

- (void)testObjectWithDictionary
{
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	XCTAssertNil([JFJSONObject objectWithDictionary:nil]);
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithDictionary:dictionary];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
}

- (void)testObjectWithDictionaryAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	
	XCTAssertNil([JFJSONObject objectWithDictionary:nil serializer:nil]);
	XCTAssertNil([JFJSONObject objectWithDictionary:nil serializer:serializer]);
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithDictionary:dictionary serializer:nil];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, [self newJSONObject].serializer);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
	
	jsonObject = [JFJSONObject objectWithDictionary:dictionary serializer:serializer];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, serializer);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
}

- (void)testObjectWithString
{
	XCTAssertNil([JFJSONObject objectWithString:nil]);
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithString:self.string];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, self.dictionary);
}

- (void)testObjectWithStringAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	
	XCTAssertNil([JFJSONObject objectWithString:nil serializer:nil]);
	XCTAssertNil([JFJSONObject objectWithString:nil serializer:serializer]);
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	NSString* string = self.string;
	
	JFJSONObject* jsonObject = [JFJSONObject objectWithString:string serializer:nil];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, [self newJSONObject].serializer);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
	
	jsonObject = [JFJSONObject objectWithString:string serializer:serializer];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqual(jsonObject.serializer, serializer);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
}

- (void)testInit
{
	XCTAssertNotNil([[JFJSONObject alloc] init]);
}

- (void)testInitWithCapacity
{
	XCTAssertNotNil([[JFJSONObject alloc] initWithCapacity:10]);
}

- (void)testInitWithData
{
	XCTAssertNil([[JFJSONObject alloc] initWithData:[NSData new]]);
	
	JFJSONObject* jsonObject = [[JFJSONObject alloc] initWithData:self.data];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, self.dictionary);
}

- (void)testInitWithDictionary
{
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = self.dictionary;
	
	JFJSONObject* jsonObject = [[JFJSONObject alloc] initWithDictionary:dictionary];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, dictionary);
}

- (void)testInitWithString
{
	XCTAssertNil([[JFJSONObject alloc] initWithString:@""]);
	
	JFJSONObject* jsonObject = [[JFJSONObject alloc] initWithString:self.string];
	XCTAssertNotNil(jsonObject);
	XCTAssertEqualObjects(jsonObject.dictionaryValue, self.dictionary);
}

- (void)testArrayForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	JFJSONArray* jsonArray = [self newJSONArray];
	
	NSString* key = @"array";
	[jsonObject setValue:jsonArray forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject arrayForKey:key], jsonArray);
}

- (void)testSetArrayForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	JFJSONArray* jsonArray = [self newJSONArray];
	
	NSString* key = @"array";
	[jsonObject setArray:jsonArray forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject valueForKey:key], jsonArray);
}

- (void)testIsNullForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	
	NSString* key = @"null";
	[jsonObject setValue:[NSNull null] forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertTrue([jsonObject isNullForKey:key]);
}

- (void)testSetNullForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	
	NSString* key = @"null";
	[jsonObject setNullForKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject valueForKey:key], [NSNull null]);
}

- (void)testNumberForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	NSNumber* number = @YES;
	
	NSString* key = @"number";
	[jsonObject setValue:number forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject numberForKey:key], number);
}

- (void)testSetNumberForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	NSNumber* number = @YES;
	
	NSString* key = @"number";
	[jsonObject setNumber:number forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject valueForKey:key], number);
}

- (void)testObjectForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	JFJSONObject* jsonObject2 = [self newJSONObject];
	
	NSString* key = @"object";
	[jsonObject setValue:jsonObject2 forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject objectForKey:key], jsonObject2);
}

- (void)testSetObjectForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	JFJSONObject* jsonObject2 = [self newJSONObject];
	
	NSString* key = @"object";
	[jsonObject setObject:jsonObject2 forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject valueForKey:key], jsonObject2);
}

- (void)testSetStringForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	NSString* string = @"";
	
	NSString* key = @"string";
	[jsonObject setString:string forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject valueForKey:key], string);
}

- (void)testStringForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	NSString* string = @"";
	
	NSString* key = @"string";
	[jsonObject setValue:string forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject stringForKey:key], string);
}

- (void)testHasValueForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	
	NSString* key = @"key";
	XCTAssertFalse([jsonObject hasValueForKey:key]);
	
	[jsonObject setNullForKey:key];
	XCTAssertTrue([jsonObject hasValueForKey:key]);
}

- (void)testRemoveValueForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	
	NSString* key = @"key";
	[jsonObject setNullForKey:key];
	[jsonObject removeValueForKey:key];
	XCTAssertEqual(jsonObject.count, 0);
}

- (void)testSetValueForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	id<JFJSONValue> value = @"";
	
	NSString* key = @"key";
	[jsonObject setValue:value forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject valueForKey:key], value);
}

- (void)testValueForKey
{
	JFJSONObject* jsonObject = [self newJSONObject];
	id<JFJSONValue> value = @"";
	
	NSString* key = @"key";
	[jsonObject setValue:value forKey:key];
	XCTAssertEqual(jsonObject.count, 1);
	XCTAssertEqual([jsonObject valueForKey:key], value);
}

- (void)testObjectForKeyedSubscript
{
	if(@available(macOS 10.8, *))
	{
		JFJSONObject* jsonObject = [self newJSONObject];
		id<JFJSONValue> value = @"";
		
		NSString* key = @"key";
		[jsonObject setValue:value forKey:key];
		XCTAssertEqual(jsonObject.count, 1);
		XCTAssertEqual(jsonObject[key], value);
	}
}

- (void)testSetObjectForKeyedSubscript
{
	if(@available(macOS 10.8, *))
	{
		JFJSONObject* jsonObject = [self newJSONObject];
		id<JFJSONValue> value = @"";
		
		NSString* key = @"key";
		jsonObject[key] = value;
		XCTAssertEqual(jsonObject.count, 1);
		XCTAssertEqual([jsonObject valueForKey:key], value);
	}
}

- (JFJSONArray*)newJSONArray
{
	JFJSONArray* retObj = [JFJSONArray new];
	XCTAssertNotNil(retObj);
	XCTAssertEqual(retObj.count, 0);
	return retObj;
}

- (JFJSONObject*)newJSONObject
{
	JFJSONObject* retObj = [JFJSONObject new];
	XCTAssertNotNil(retObj);
	XCTAssertEqual(retObj.count, 0);
	return retObj;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
