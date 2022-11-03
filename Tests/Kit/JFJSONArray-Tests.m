//
//	The MIT License (MIT)
//
//	Copyright © 2019-2022 Jacopo Filié
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

@import JFKit;
@import XCTest;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

API_AVAILABLE(ios(8.0), macos(10.7))
@interface JFJSONArray_Tests : XCTestCase

@property (strong, nonatomic, readonly) NSArray<id<JFJSONConvertibleValue>>* array;
@property (strong, nonatomic, readonly) NSData* data;
@property (strong, nonatomic, readonly) NSURL* fileURL;
@property (strong, nonatomic, readonly) NSString* string;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFJSONArray_Tests

@synthesize array = _array;
@synthesize data = _data;
@synthesize fileURL = _fileURL;
@synthesize string = _string;

- (NSArray<id<JFJSONConvertibleValue>>*)array
{
	NSArray<id<JFJSONConvertibleValue>>* retObj = _array;
	if(!retObj)
	{
		NSError* error;
		retObj = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
		XCTAssertNil(error);
		XCTAssertNotNil(retObj);
		_array = retObj;
	}
	return retObj;
}

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

- (NSURL*)fileURL
{
	NSURL* retObj = _fileURL;
	if(!retObj)
	{
		retObj = [[NSBundle bundleForClass:self.class] URLForResource:@"Array" withExtension:@"json"];
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
	JFJSONArray* jsonArray = [self newJSONArray];
	
	jsonArray = [JFJSONArray arrayWithArray:self.array];
	XCTAssertEqual(jsonArray.count, 2);
	
	jsonArray = [JFJSONArray arrayWithData:self.data];
	XCTAssertEqual(jsonArray.count, 2);
	
	jsonArray = [JFJSONArray arrayWithString:self.string];
	XCTAssertEqual(jsonArray.count, 2);
}

- (void)testDataValue
{
	XCTAssertEqualObjects([self newJSONArray].dataValue, [@"[]" dataUsingEncoding:NSUTF8StringEncoding]);
	
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:[JFJSONArray arrayWithArray:array].dataValue options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSArray.class]);
	
	XCTAssertEqualObjects(result, array);
}

- (void)testStringValue
{
	XCTAssertEqualObjects([self newJSONArray].stringValue, @"[]");
	
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	
	NSError* error;
	id result = [NSJSONSerialization JSONObjectWithData:[[JFJSONArray arrayWithArray:array].stringValue dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
	XCTAssertNil(error);
	XCTAssertNotNil(result);
	XCTAssertTrue([result isKindOfClass:NSArray.class]);
	
	XCTAssertEqualObjects(result, array);
}

- (void)testSerializer
{
	JFJSONArray* jsonArray = [self newJSONArray];
	
	id<JFJSONSerializationAdapter> defaultSerializer = jsonArray.serializer;
	XCTAssertNotNil(defaultSerializer);
	
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	jsonArray.serializer = serializer;
	
	id<JFJSONSerializationAdapter> returnedSerializer = jsonArray.serializer;
	XCTAssertNotNil(returnedSerializer);
	XCTAssertEqualObjects(returnedSerializer, serializer);
	
	jsonArray.serializer = nil;
	returnedSerializer = jsonArray.serializer;
	XCTAssertNotNil(returnedSerializer);
	XCTAssertEqualObjects(returnedSerializer, defaultSerializer);
}

- (void)testInitWithDataAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	JFJSONArray* jsonArray = [[JFJSONArray alloc] initWithData:self.data serializer:serializer];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, serializer);
}

- (void)testInitWithStringAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	JFJSONArray* jsonArray = [[JFJSONArray alloc] initWithString:self.string serializer:serializer];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, serializer);
}

- (void)testArrayValue
{
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	
	JFJSONArray* jsonArray = [[JFJSONArray alloc] initWithArray:array];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
	
	jsonArray = [[JFJSONArray alloc] initWithData:self.data];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
	
	jsonArray = [[JFJSONArray alloc] initWithString:self.string];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
}

- (void)testArrayWithData
{
	XCTAssertNil([JFJSONArray arrayWithData:nil]);
	
	JFJSONArray* jsonArray = [JFJSONArray arrayWithData:self.data];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, self.array);
}

- (void)testArrayWithDataAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	
	XCTAssertNil([JFJSONArray arrayWithData:nil serializer:nil]);
	XCTAssertNil([JFJSONArray arrayWithData:nil serializer:serializer]);
	
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	
	JFJSONArray* jsonArray = [JFJSONArray arrayWithData:self.data serializer:nil];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, [self newJSONArray].serializer);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
	
	jsonArray = [JFJSONArray arrayWithData:self.data serializer:serializer];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, serializer);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
}

- (void)testArrayWithArray
{
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	
	XCTAssertNil([JFJSONArray arrayWithArray:nil]);
	
	JFJSONArray* jsonArray = [JFJSONArray arrayWithArray:array];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
}

- (void)testArrayWithArrayAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	
	XCTAssertNil([JFJSONArray arrayWithArray:nil serializer:nil]);
	XCTAssertNil([JFJSONArray arrayWithArray:nil serializer:serializer]);
	
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	
	JFJSONArray* jsonArray = [JFJSONArray arrayWithArray:array serializer:nil];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, [self newJSONArray].serializer);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
	
	jsonArray = [JFJSONArray arrayWithArray:array serializer:serializer];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, serializer);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
}

- (void)testArrayWithString
{
	XCTAssertNil([JFJSONArray arrayWithString:nil]);
	
	JFJSONArray* jsonArray = [JFJSONArray arrayWithString:self.string];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, self.array);
}

- (void)testArrayWithStringAndSerializer
{
	id<JFJSONSerializationAdapter> serializer = [JFJSONSerializer new];
	
	XCTAssertNil([JFJSONArray arrayWithString:nil serializer:nil]);
	XCTAssertNil([JFJSONArray arrayWithString:nil serializer:serializer]);
	
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	NSString* string = self.string;
	
	JFJSONArray* jsonArray = [JFJSONArray arrayWithString:string serializer:nil];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, [self newJSONArray].serializer);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
	
	jsonArray = [JFJSONArray arrayWithString:string serializer:serializer];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqual(jsonArray.serializer, serializer);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
}

- (void)testInit
{
	XCTAssertNotNil([[JFJSONArray alloc] init]);
}

- (void)testInitWithArray
{
	NSArray<id<JFJSONConvertibleValue>>* array = self.array;
	
	JFJSONArray* jsonArray = [[JFJSONArray alloc] initWithArray:array];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, array);
}

- (void)testInitWithCapacity
{
	XCTAssertNotNil([[JFJSONArray alloc] initWithCapacity:10]);
}

- (void)testInitWithData
{
	XCTAssertNil([[JFJSONArray alloc] initWithData:[NSData new]]);
	
	JFJSONArray* jsonArray = [[JFJSONArray alloc] initWithData:self.data];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, self.array);
}

- (void)testInitWithString
{
	XCTAssertNil([[JFJSONArray alloc] initWithString:@""]);
	
	JFJSONArray* jsonArray = [[JFJSONArray alloc] initWithString:self.string];
	XCTAssertNotNil(jsonArray);
	XCTAssertEqualObjects(jsonArray.arrayValue, self.array);
}

- (void)testIsEqual
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONArray* jsonArray2 = [self newJSONArray];
	XCTAssertEqualObjects(jsonArray, jsonArray2);
	XCTAssertEqualObjects(jsonArray2, jsonArray);

	[jsonArray addNull];
	XCTAssertNotEqualObjects(jsonArray, jsonArray2);
	XCTAssertNotEqualObjects(jsonArray2, jsonArray);

	[jsonArray2 addNull];
	XCTAssertEqualObjects(jsonArray, jsonArray2);
	XCTAssertEqualObjects(jsonArray2, jsonArray);
}

- (void)testAddArray
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONArray* jsonArray2 = [self newJSONArray];
	
	[jsonArray addArray:jsonArray2];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], jsonArray2);
}

- (void)testArrayAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONArray* jsonArray2 = [self newJSONArray];
	
	[jsonArray addValue:jsonArray2];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray arrayAtIndex:0], jsonArray2);
}

- (void)testInsertArrayAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONArray* jsonArray2 = [self newJSONArray];
	
	[jsonArray insertArray:jsonArray2 atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], jsonArray2);
}

- (void)testReplaceWithArrayAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONArray* jsonArray2 = [self newJSONArray];
	
	[jsonArray addNull];
	[jsonArray replaceWithArray:jsonArray2 atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], jsonArray2);
}

- (void)testAddNull
{
	JFJSONArray* jsonArray = [self newJSONArray];
	
	[jsonArray addNull];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], [NSNull null]);
}

- (void)testInsertNullAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	
	[jsonArray insertNullAtIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], [NSNull null]);
}

- (void)testIsNullAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	
	[jsonArray addNull];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertTrue([jsonArray isNullAtIndex:0]);
}

- (void)testReplaceWithNullAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	
	[jsonArray addValue:[self newJSONArray]];
	[jsonArray replaceWithNullAtIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], [NSNull null]);
}

- (void)testAddNumber
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSNumber* number = @YES;
	
	[jsonArray addNumber:number];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], number);
}

- (void)testInsertNumberAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSNumber* number = @YES;
	
	[jsonArray insertNumber:number atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], number);
}

- (void)testNumberAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSNumber* number = @YES;
	
	[jsonArray addValue:number];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray numberAtIndex:0], number);
}

- (void)testReplaceWithNumberAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSNumber* number = @YES;
	
	[jsonArray addNull];
	[jsonArray replaceWithNumber:number atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], number);
}

- (void)testAddObject
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONObject* jsonObject = [self newJSONObject];
	
	[jsonArray addObject:jsonObject];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], jsonObject);
}

- (void)testInsertObjectAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONObject* jsonObject = [self newJSONObject];
	
	[jsonArray insertObject:jsonObject atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], jsonObject);
}

- (void)testObjectAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONObject* jsonObject = [self newJSONObject];
	
	[jsonArray addValue:jsonObject];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray objectAtIndex:0], jsonObject);
}

- (void)testReplaceWithObjectAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	JFJSONObject* jsonObject = [self newJSONObject];
	
	[jsonArray addNull];
	[jsonArray replaceWithObject:jsonObject atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], jsonObject);
}

- (void)testAddString
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSString* string = @"";
	
	[jsonArray addString:string];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], string);
}

- (void)testInsertStringAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSString* string = @"";
	
	[jsonArray insertString:string atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], string);
}

- (void)testReplaceWithStringAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSString* string = @"";
	
	[jsonArray addNull];
	[jsonArray replaceWithString:string atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], string);
}

- (void)testStringAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	NSString* string = @"";
	
	[jsonArray addValue:string];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray stringAtIndex:0], string);
}

- (void)testAddValue
{
	JFJSONArray* jsonArray = [self newJSONArray];
	id<JFJSONValue> value = @"";
	
	[jsonArray addValue:value];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], value);
}

- (void)testInsertValueAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	id<JFJSONValue> value = @"";
	
	[jsonArray insertValue:value atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], value);
}

- (void)testRemoveValueAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	
	[jsonArray addNull];
	[jsonArray removeValueAtIndex:0];
	XCTAssertEqual(jsonArray.count, 0);
}

- (void)testReplaceWithValueAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	id<JFJSONValue> value = @"";
	
	[jsonArray addNull];
	[jsonArray replaceWithValue:value atIndex:0];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], value);
}

- (void)testValueAtIndex
{
	JFJSONArray* jsonArray = [self newJSONArray];
	id<JFJSONValue> value = @"";
	
	[jsonArray addValue:value];
	XCTAssertEqual(jsonArray.count, 1);
	XCTAssertEqual([jsonArray valueAtIndex:0], value);
}

- (void)testFastEnumeration
{
	NSUInteger count = 10;
	NSUInteger sum = 0;
	
	JFJSONArray* jsonArray = [self newJSONArray];
	for(NSUInteger index = 0; index < count; index++)
	{
		NSUInteger value = arc4random() % 100;
		[jsonArray addNumber:@(value)];
		sum += value;
	}
	
	XCTAssertEqual(jsonArray.count, count);
	
	NSUInteger enumeratedSum = 0;
	NSMutableArray<NSNumber*>* enumeratedObjects = [NSMutableArray<NSNumber*> arrayWithCapacity:count];
	for(id<JFJSONValue> object in jsonArray)
	{
		[enumeratedObjects addObject:(NSNumber*)object];
		enumeratedSum += [(NSNumber*)object unsignedIntegerValue];
	}
	
	XCTAssertEqual(enumeratedSum, sum);
	
	for(NSUInteger index = 0; index < count; index++)
	{
		XCTAssertEqual([enumeratedObjects objectAtIndex:index], [jsonArray valueAtIndex:index]);
	}
}

- (void)testEnumerateValuesAtIndexes
{
	NSUInteger count = 10;
	NSRange range = NSMakeRange(3, 5);
	NSUInteger sum = 0;
	
	JFJSONArray* jsonArray = [self newJSONArray];
	for(NSUInteger index = 0; index < count; index++)
	{
		if(!NSLocationInRange(index, range))
		{
			[jsonArray addNull];
			continue;
		}
		
		NSUInteger value = arc4random() % 100;
		[jsonArray addNumber:@(value)];
		sum += value;
	}
	
	XCTAssertEqual(jsonArray.count, count);
	
	NSUInteger __block enumeratedSum = 0;
	NSIndexSet* indexes = [NSIndexSet indexSetWithIndexesInRange:range];
	[jsonArray enumerateValuesAtIndexes:indexes options:0 usingBlock:^BOOL (NSUInteger index, id<JFJSONValue> value) {
		XCTAssertTrue(NSLocationInRange(index, range));
		XCTAssertTrue([value isKindOfClass:NSNumber.class]);
		enumeratedSum += [(NSNumber*)value unsignedIntegerValue];
		return NO;
	}];
	
	XCTAssertEqual(enumeratedSum, sum);
}

- (void)testEnumerateValuesUsingBlock
{
	NSUInteger count = 10;
	NSUInteger sum = 0;
	
	JFJSONArray* jsonArray = [self newJSONArray];
	for(NSUInteger index = 0; index < count; index++)
	{
		NSUInteger value = arc4random() % 100;
		[jsonArray addNumber:@(value)];
		sum += value;
	}
	
	XCTAssertEqual(jsonArray.count, count);
	
	NSUInteger __block enumeratedSum = 0;
	[jsonArray enumerateValuesUsingBlock:^BOOL (NSUInteger index, id<JFJSONValue> value) {
		XCTAssertTrue(index < count);
		enumeratedSum += [(NSNumber*)value unsignedIntegerValue];
		return NO;
	}];
	
	XCTAssertEqual(enumeratedSum, sum);
}

- (void)testEnumerateValuesWithOptions
{
	NSUInteger count = 10;
	NSUInteger sum = 0;
	
	JFJSONArray* jsonArray = [self newJSONArray];
	for(NSUInteger index = 0; index < count; index++)
	{
		NSUInteger value = arc4random() % 100;
		[jsonArray addNumber:@(value)];
		sum += value;
	}
	
	XCTAssertEqual(jsonArray.count, count);
	
	NSUInteger __block enumeratedSum = 0;
	[jsonArray enumerateValuesWithOptions:0 usingBlock:^BOOL (NSUInteger index, id<JFJSONValue> value) {
		XCTAssertTrue(index < count);
		enumeratedSum += [(NSNumber*)value unsignedIntegerValue];
		return NO;
	}];
	
	XCTAssertEqual(enumeratedSum, sum);
}

- (void)testReverseValueEnumerator
{
	NSUInteger count = 10;
	NSUInteger sum = 0;
	
	JFJSONArray* jsonArray = [self newJSONArray];
	for(NSUInteger index = 0; index < count; index++)
	{
		NSUInteger value = arc4random() % 100;
		[jsonArray addNumber:@(value)];
		sum += value;
	}
	
	XCTAssertEqual(jsonArray.count, count);
	
	NSUInteger enumeratedSum = 0;
	NSMutableArray<NSNumber*>* enumeratedObjects = [NSMutableArray<NSNumber*> arrayWithCapacity:count];
	NSNumber* object;
	NSEnumerator<id<JFJSONValue>>* enumerator = jsonArray.reverseValueEnumerator;
	while(object = (NSNumber*)[enumerator nextObject])
	{
		[enumeratedObjects insertObject:object atIndex:0];
		enumeratedSum += [object unsignedIntegerValue];
	}
	
	XCTAssertEqual(enumeratedSum, sum);
	
	for(NSUInteger index = 0; index < count; index++)
	{
		XCTAssertEqual([enumeratedObjects objectAtIndex:index], [jsonArray valueAtIndex:index]);
	}
}

- (void)testValueEnumerator
{
	NSUInteger count = 10;
	NSUInteger sum = 0;
	
	JFJSONArray* jsonArray = [self newJSONArray];
	for(NSUInteger index = 0; index < count; index++)
	{
		NSUInteger value = arc4random() % 100;
		[jsonArray addNumber:@(value)];
		sum += value;
	}
	
	XCTAssertEqual(jsonArray.count, count);
	
	NSUInteger enumeratedSum = 0;
	NSMutableArray<NSNumber*>* enumeratedObjects = [NSMutableArray<NSNumber*> arrayWithCapacity:count];
	NSEnumerator<id<JFJSONValue>>* enumerator = jsonArray.valueEnumerator;
	NSNumber* value;
	while(value = (NSNumber*)[enumerator nextObject])
	{
		[enumeratedObjects addObject:value];
		enumeratedSum += [value unsignedIntegerValue];
	}
	
	XCTAssertEqual(enumeratedSum, sum);
	
	for(NSUInteger index = 0; index < count; index++)
	{
		XCTAssertEqual([enumeratedObjects objectAtIndex:index], [jsonArray valueAtIndex:index]);
	}
}

- (void)testObjectAtIndexedSubscript
{
	if(@available(macOS 10.8, *))
	{
		JFJSONArray* jsonArray = [self newJSONArray];
		id<JFJSONValue> value = @"";
		
		[jsonArray addValue:value];
		XCTAssertEqual(jsonArray.count, 1);
		XCTAssertEqual(jsonArray[0], value);
	}
}

- (void)testSetObjectAtIndexedSubscript
{
	if(@available(macOS 10.8, *))
	{
		JFJSONArray* jsonArray = [self newJSONArray];
		id<JFJSONValue> value = @"";
		
		[jsonArray addNull];
		jsonArray[0] = value;
		XCTAssertEqual(jsonArray.count, 1);
		XCTAssertEqual([jsonArray valueAtIndex:0], value);
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
