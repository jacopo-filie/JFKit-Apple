//
//	The MIT License (MIT)
//
//	Copyright © 2018-2022 Jacopo Filié
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

#import "JFJSONArray.h"

#import "JFJSONObject.h"
#import "JFJSONSerializer.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFJSONArray (/* Private */)

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly) NSMutableArray<id<JFJSONValue>>* list;

// =================================================================================================
// MARK: Properties - Serialization
// =================================================================================================

@property (class, strong, readonly, nullable) id<JFJSONSerializationAdapter> defaultSerializer;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (void)importFromArray:(NSArray<id<JFJSONConvertibleValue>>* _Nullable)array;

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

- (id<JFJSONValue> _Nullable)checkValue:(id _Nullable)value;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFJSONArray

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize list = _list;

// =================================================================================================
// MARK: Properties - Serialization
// =================================================================================================

@synthesize serializer = _serializer;

// =================================================================================================
// MARK: Properties (Accessors) - Serialization
// =================================================================================================

+ (id<JFJSONSerializationAdapter> _Nullable)defaultSerializer
{
	static id<JFJSONSerializationAdapter> retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if(@available(iOS 8.0, macOS 10.7, *))
			retObj = [JFJSONSerializer new];
	});
	return retObj;
}

- (id<JFJSONSerializationAdapter> _Nullable)serializer
{
	@synchronized(self)
	{
		return (_serializer ?: [[self class] defaultSerializer]);
	}
}

- (void)setSerializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	@synchronized(self)
	{
		_serializer = serializer;
	}
}

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

- (NSArray<id<JFJSONConvertibleValue>>*)arrayValue
{
	NSMutableArray<id<JFJSONConvertibleValue>>* retObj = [NSMutableArray<id<JFJSONConvertibleValue>> arrayWithArray:self.list];
	for(NSUInteger index = 0; index < retObj.count; index++)
	{
		id value = [retObj objectAtIndex:index];
		if([value isKindOfClass:[JFJSONArray class]])
			value = ((JFJSONArray*)value).arrayValue;
		else if([value isKindOfClass:[JFJSONObject class]])
			value = ((JFJSONObject*)value).dictionaryValue;
		else
			continue;
		[retObj replaceObjectAtIndex:index withObject:value];
	}
	return retObj;
}

- (NSUInteger)count
{
	return self.list.count;
}

- (NSData* _Nullable)dataValue
{
	return [self.serializer dataFromArray:self.arrayValue];
}

- (NSString* _Nullable)stringValue
{
	return [self.serializer stringFromArray:self.arrayValue];
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype _Nullable)arrayWithData:(NSData* _Nullable)data
{
	return [self arrayWithData:data serializer:nil];
}

+ (instancetype _Nullable)arrayWithData:(NSData* _Nullable)data serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	return (data ? [self arrayWithArray:[(serializer ?: self.defaultSerializer) arrayFromData:data] serializer:serializer] : nil);
}

+ (instancetype _Nullable)arrayWithArray:(NSArray<id<JFJSONConvertibleValue>>* _Nullable)array
{
	return [self arrayWithArray:array serializer:nil];
}

+ (instancetype _Nullable)arrayWithArray:(NSArray<id<JFJSONConvertibleValue>>* _Nullable)array serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	if(!array)
		return nil;
	
	JFJSONArray* retObj = [[self alloc] initWithArray:array];
	retObj.serializer = serializer;
	return retObj;
}

+ (instancetype _Nullable)arrayWithString:(NSString* _Nullable)string
{
	return [self arrayWithString:string serializer:nil];
}

+ (instancetype _Nullable)arrayWithString:(NSString* _Nullable)string serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	return (string ? [self arrayWithArray:[(serializer ?: self.defaultSerializer) arrayFromString:string] serializer:serializer] : nil);
}

- (instancetype)init
{
	self = [super init];
	
	_list = [NSMutableArray<id<JFJSONValue>> new];
	
	return self;
}

- (instancetype)initWithArray:(NSArray<id<JFJSONConvertibleValue>>*)array
{
	self = [self initWithCapacity:array.count];
	
	[self importFromArray:array];
	
	return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
	self = [super init];
	
	_list = [[NSMutableArray<id<JFJSONValue>> alloc] initWithCapacity:capacity];
	
	return self;
}

- (instancetype _Nullable)initWithData:(NSData*)data
{
	return [self initWithData:data serializer:nil];
}

- (instancetype _Nullable)initWithData:(NSData*)data serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	self = [self init];
	
	_serializer = serializer;
	
	NSArray<id<JFJSONConvertibleValue>>* array = [(serializer ?: self.serializer) arrayFromData:data];
	if(array)
		[self importFromArray:array];
	else
		self = nil;
	
	return self;
}

- (instancetype _Nullable)initWithString:(NSString*)string
{
	return [self initWithString:string serializer:nil];
}

- (instancetype _Nullable)initWithString:(NSString*)string serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	self = [self init];
	
	_serializer = serializer;
	
	NSArray<id<JFJSONConvertibleValue>>* array = [(serializer ?: self.serializer) arrayFromString:string];
	if(array)
		[self importFromArray:array];
	else
		self = nil;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (void)importFromArray:(NSArray<id<JFJSONConvertibleValue>>* _Nullable)array
{
	for(NSUInteger index = 0; index < array.count; index++)
	{
		id value = [array objectAtIndex:index];
		if([value isKindOfClass:[NSArray class]])
			value = [[JFJSONArray alloc] initWithArray:value];
		else if([value isKindOfClass:[NSDictionary class]])
			value = [[JFJSONObject alloc] initWithDictionary:value];
		[self addValue:value];
	}
}

// =================================================================================================
// MARK: Methods - Data (Arrays)
// =================================================================================================

- (void)addArray:(JFJSONArray*)value
{
	[self addValue:value];
}

- (JFJSONArray* _Nullable)arrayAtIndex:(NSUInteger)index
{
	id<JFJSONValue> retVal = [self valueAtIndex:index];
	return ((retVal && [retVal isKindOfClass:[JFJSONArray class]]) ? (JFJSONArray*)retVal : nil);
}

- (void)insertArray:(JFJSONArray*)value atIndex:(NSUInteger)index
{
	[self insertValue:value atIndex:index];
}

- (void)replaceWithArray:(JFJSONArray*)value atIndex:(NSUInteger)index
{
	[self replaceWithValue:value atIndex:index];
}

// =================================================================================================
// MARK: Methods - Data (Null)
// =================================================================================================

- (void)addNull
{
	[self addValue:[NSNull null]];
}

- (void)insertNullAtIndex:(NSUInteger)index
{
	[self insertValue:[NSNull null] atIndex:index];
}

- (BOOL)isNullAtIndex:(NSUInteger)index
{
	id<JFJSONValue> retVal = [self valueAtIndex:index];
	return (retVal && [retVal isKindOfClass:[NSNull class]]);
}

- (void)replaceWithNullAtIndex:(NSUInteger)index
{
	[self replaceWithValue:[NSNull null] atIndex:index];
}

// =================================================================================================
// MARK: Methods - Data (Numbers)
// =================================================================================================

- (void)addNumber:(NSNumber*)value
{
	[self addValue:value];
}

- (void)insertNumber:(NSNumber*)value atIndex:(NSUInteger)index
{
	[self insertValue:value atIndex:index];
}

- (NSNumber* _Nullable)numberAtIndex:(NSUInteger)index
{
	id<JFJSONValue> retVal = [self valueAtIndex:index];
	return ((retVal && [retVal isKindOfClass:[NSNumber class]]) ? (NSNumber*)retVal : nil);
}

- (void)replaceWithNumber:(NSNumber*)value atIndex:(NSUInteger)index
{
	[self replaceWithValue:value atIndex:index];
}

// =================================================================================================
// MARK: Methods - Data (Objects)
// =================================================================================================

- (void)addObject:(JFJSONObject*)value
{
	[self addValue:value];
}

- (void)insertObject:(JFJSONObject*)value atIndex:(NSUInteger)index
{
	[self insertValue:value atIndex:index];
}

- (JFJSONObject* _Nullable)objectAtIndex:(NSUInteger)index
{
	id<JFJSONValue> retVal = [self valueAtIndex:index];
	return ((retVal && [retVal isKindOfClass:[JFJSONObject class]]) ? (JFJSONObject*)retVal : nil);
}

- (void)replaceWithObject:(JFJSONObject*)value atIndex:(NSUInteger)index
{
	[self replaceWithValue:value atIndex:index];
}

// =================================================================================================
// MARK: Methods - Data (Strings)
// =================================================================================================

- (void)addString:(NSString*)value
{
	[self addValue:value];
}

- (void)insertString:(NSString*)value atIndex:(NSUInteger)index
{
	[self insertValue:value atIndex:index];
}

- (void)replaceWithString:(NSString*)value atIndex:(NSUInteger)index
{
	[self replaceWithValue:value atIndex:index];
}

- (NSString* _Nullable)stringAtIndex:(NSUInteger)index
{
	id<JFJSONValue> retVal = [self valueAtIndex:index];
	return ((retVal && [retVal isKindOfClass:[NSString class]]) ? (NSString*)retVal : nil);
}

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

- (void)addValue:(id<JFJSONValue>)value
{
	value = [self checkValue:value];
	if(value)
		[self.list addObject:value];
}

- (id<JFJSONValue> _Nullable)checkValue:(id _Nullable)value
{
	if(!value || [value conformsToProtocol:@protocol(JFJSONValue)])
		return value;
	
	// NB: sometimes the protocol check is not enough, maybe due to cluster classes.
	
	static NSArray<Class>* conformingClasses = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		conformingClasses = @[JFJSONArray.class, JFJSONObject.class, NSNull.class, NSNumber.class, NSString.class];
	});
	
	for(Class conformingClass in conformingClasses)
	{
		if([value isKindOfClass:conformingClass])
			return value;
	}
	
	return nil;
}

- (void)insertValue:(id<JFJSONValue>)value atIndex:(NSUInteger)index
{
	value = [self checkValue:value];
	if(value)
		[self.list insertObject:value atIndex:index];
}

- (void)removeValueAtIndex:(NSUInteger)index
{
	[self.list removeObjectAtIndex:index];
}

- (void)replaceWithValue:(id<JFJSONValue>)value atIndex:(NSUInteger)index
{
	value = [self checkValue:value];
	if(value)
		[self.list replaceObjectAtIndex:index withObject:value];
}

- (id<JFJSONValue> _Nullable)valueAtIndex:(NSUInteger)index
{
	return [self.list objectAtIndex:index];
}

// =================================================================================================
// MARK: Methods - Subscripting
// =================================================================================================

- (id<JFJSONValue> _Nullable)objectAtIndexedSubscript:(NSUInteger)index API_AVAILABLE(ios(8.0), macos(10.8))
{
	return [self valueAtIndex:index];
}

- (void)setObject:(id<JFJSONValue>)object atIndexedSubscript:(NSUInteger)index API_AVAILABLE(ios(8.0), macos(10.8))
{
	[self replaceWithValue:object atIndex:index];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
