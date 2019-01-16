//
//	The MIT License (MIT)
//
//	Copyright © 2018-2019 Jacopo Filié
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

#import "JFJSONSerializer.h"

#import "JFJSONNode.h"
#import "JFKitLogger.h"
#import "JFShortcuts.h"
#import "JFStrings.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFJSONSerializer ()

// =================================================================================================
// MARK: Properties - Concurrency
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) NSLock* lock;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (NSData* __nullable)dataFromNode:(id __nullable)jsonNode;
- (NSData* __nullable)dataFromString:(NSString* __nullable)jsonString;
- (id __nullable)nodeFromData:(NSData* __nullable)jsonData class:(Class)class;
- (NSString* __nullable)stringFromData:(NSData* __nullable)jsonData;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFJSONSerializer

// =================================================================================================
// MARK: Properties - Concurrency
// =================================================================================================

@synthesize lock = _lock;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	
	if(@available(iOS 8.0, macOS 10.9, *))
		_lock = nil;
	else
		_lock = [NSLock new];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (NSData* __nullable)dataFromNode:(id __nullable)jsonNode
{
	if(!jsonNode)
		return nil;
	
	NSLock* lock = self.lock;

	[lock lock];
	if(![NSJSONSerialization isValidJSONObject:jsonNode])
	{
		[lock unlock];
		[JFKitLogger logError:[NSString stringWithFormat:@"%@<%@>: Not a valid JSON node. [node = '%@']", ClassName, JFStringFromPointer(self), jsonNode] tags:JFLoggerTagsError];
		return nil;
	}
	
	NSError* error = nil;
	NSData* retObj = [NSJSONSerialization dataWithJSONObject:jsonNode options:0 error:&error];
	[lock unlock];
	if(!retObj)
		[JFKitLogger logError:[NSString stringWithFormat:@"%@<%@>: Failed to convert JSON node to data. [node = '%@']", ClassName, JFStringFromPointer(self), jsonNode] tags:JFLoggerTagsError];
	return retObj;
}

- (NSData* __nullable)dataFromString:(NSString* __nullable)jsonString
{
	if(!jsonString)
		return nil;
	
	NSData* retObj = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	if(!retObj)
		[JFKitLogger logError:[NSString stringWithFormat:@"%@<%@>: Failed to convert JSON string to data. [string = '%@']", ClassName, JFStringFromPointer(self), jsonString] tags:JFLoggerTagsError];
	return retObj;
}

- (id __nullable)nodeFromData:(NSData* __nullable)jsonData class:(Class)class
{
	if(!jsonData)
		return nil;
	
	NSLock* lock = self.lock;
	
	NSError* error = nil;
	[lock lock];
	id retObj = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
	[lock unlock];
	if(!retObj)
		[JFKitLogger logError:[NSString stringWithFormat:@"%@<%@>: Failed to convert JSON data to node. [data = '%@']", ClassName, JFStringFromPointer(self), jsonData] tags:JFLoggerTagsError];
	else if(![retObj isKindOfClass:class])
		[JFKitLogger logError:[NSString stringWithFormat:@"%@<%@>: Converted JSON node class is not the requested one. [node = '%@'; class = '%@']", ClassName, JFStringFromPointer(self), retObj, NSStringFromClass(class)] tags:JFLoggerTagsError];
	return retObj;
}

- (NSString* __nullable)stringFromData:(NSData* __nullable)jsonData
{
	if(!jsonData)
		return nil;
	
	NSString* retObj = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	if(!retObj)
		[JFKitLogger logError:[NSString stringWithFormat:@"%@<%@>: Failed to convert JSON data to string. [data = '%@']", ClassName, JFStringFromPointer(self), jsonData] tags:JFLoggerTagsError];
	return retObj;
}

// =================================================================================================
// MARK: Methods - Data (Arrays)
// =================================================================================================

- (NSArray<id<JFJSONConvertibleValue>>* __nullable)arrayFromData:(NSData* __nullable)jsonData
{
	return (NSArray<id<JFJSONConvertibleValue>>*)[self nodeFromData:jsonData class:[NSArray class]];
}

- (NSArray<id<JFJSONConvertibleValue>>* __nullable)arrayFromString:(NSString* __nullable)jsonString
{
	return [self arrayFromData:[self dataFromString:jsonString]];
}

- (NSData* __nullable)dataFromArray:(NSArray<id<JFJSONConvertibleValue>>* __nullable)array
{
	return [self dataFromNode:array];
}

- (NSString* __nullable)stringFromArray:(NSArray<id<JFJSONConvertibleValue>>* __nullable)array
{
	return [self stringFromData:[self dataFromArray:array]];
}

// =================================================================================================
// MARK: Methods - Data (Dictionaries)
// =================================================================================================

- (NSData* __nullable)dataFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary
{
	return [self dataFromNode:dictionary];
}

- (NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionaryFromData:(NSData* __nullable)jsonData
{
	return (NSDictionary<NSString*, id>*)[self nodeFromData:jsonData class:[NSDictionary class]];
}

- (NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionaryFromString:(NSString* __nullable)jsonString
{
	return [self dictionaryFromData:[self dataFromString:jsonString]];
}

- (NSString* __nullable)stringFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary
{
	return [self stringFromData:[self dataFromDictionary:dictionary]];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
