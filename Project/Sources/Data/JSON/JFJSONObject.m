//
//	The MIT License (MIT)
//
//	Copyright © 2018-2020 Jacopo Filié
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

#import "JFJSONObject.h"

#import "JFJSONArray.h"
#import "JFJSONSerializer.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFJSONObject (/* Private */)

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly) NSMutableDictionary<NSString*, id<JFJSONValue>>* map;

// =================================================================================================
// MARK: Properties - Serialization
// =================================================================================================

@property (class, strong, readonly, nullable) id<JFJSONSerializationAdapter> defaultSerializer;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (void)importFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary;

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

- (id<JFJSONValue> __nullable)checkValue:(id __nullable)value;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFJSONObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize map = _map;

// =================================================================================================
// MARK: Properties - Serialization
// =================================================================================================

@synthesize serializer = _serializer;

// =================================================================================================
// MARK: Properties (Accessors) - Serialization
// =================================================================================================

+ (id<JFJSONSerializationAdapter> __nullable)defaultSerializer
{
	static id<JFJSONSerializationAdapter> retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if(@available(iOS 8.0, macOS 10.7, *))
			retObj = [JFJSONSerializer new];
	});
	return retObj;
}

- (id<JFJSONSerializationAdapter> __nullable)serializer
{
	@synchronized(self)
	{
		return (_serializer ?: [[self class] defaultSerializer]);
	}
}

- (void)setSerializer:(id<JFJSONSerializationAdapter> __nullable)serializer
{
	@synchronized(self)
	{
		_serializer = serializer;
	}
}

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

- (NSArray<NSString*>*)allKeys
{
	return self.map.allKeys;
}

- (NSArray<id<JFJSONValue>>*)allValues
{
	return self.map.allValues;
}

- (NSUInteger)count
{
	return self.map.count;
}

- (NSData* __nullable)dataValue
{
	return [self.serializer dataFromDictionary:self.dictionaryValue];
}

- (NSDictionary<NSString*, id<JFJSONConvertibleValue>>*)dictionaryValue
{
	NSMutableDictionary<NSString*, id<JFJSONConvertibleValue>>* retObj = [NSMutableDictionary<NSString*, id<JFJSONConvertibleValue>> dictionaryWithDictionary:self.map];
	for(NSString* key in retObj.allKeys)
	{
		id value = [retObj objectForKey:key];
		if([value isKindOfClass:[JFJSONArray class]])
			value = ((JFJSONArray*)value).arrayValue;
		else if([value isKindOfClass:[JFJSONObject class]])
			value = ((JFJSONObject*)value).dictionaryValue;
		else
			continue;
		[retObj setObject:value forKey:key];
	}
	return retObj;
}

- (NSString* __nullable)stringValue
{
	return [self.serializer stringFromDictionary:self.dictionaryValue];
}

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (instancetype __nullable)objectWithData:(NSData* __nullable)data
{
	return [self objectWithData:data serializer:nil];
}

+ (instancetype __nullable)objectWithData:(NSData* __nullable)data serializer:(id<JFJSONSerializationAdapter> __nullable)serializer
{
	return (data ? [self objectWithDictionary:[(serializer ?: self.defaultSerializer) dictionaryFromData:data] serializer:serializer] : nil);
}

+ (instancetype __nullable)objectWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary
{
	return [self objectWithDictionary:dictionary serializer:nil];
}

+ (instancetype __nullable)objectWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary serializer:(id<JFJSONSerializationAdapter> __nullable)serializer
{
	if(!dictionary)
		return nil;
	
	JFJSONObject* retObj = [[self alloc] initWithDictionary:dictionary];
	retObj.serializer = serializer;
	return retObj;
}

+ (instancetype __nullable)objectWithString:(NSString* __nullable)string
{
	return [self objectWithString:string serializer:nil];
}

+ (instancetype __nullable)objectWithString:(NSString* __nullable)string serializer:(id<JFJSONSerializationAdapter> __nullable)serializer
{
	return (string ? [self objectWithDictionary:[(serializer ?: self.defaultSerializer) dictionaryFromString:string] serializer:serializer] : nil);
}

- (instancetype)init
{
	self = [super init];
	
	_map = [NSMutableDictionary<NSString*, id<JFJSONValue>> new];
	
	return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
	self = [super init];
	
	_map = [[NSMutableDictionary<NSString*, id<JFJSONValue>> alloc] initWithCapacity:capacity];
	
	return self;
}

- (instancetype __nullable)initWithData:(NSData*)data
{
	return [self initWithData:data serializer:nil];
}

- (instancetype __nullable)initWithData:(NSData*)data serializer:(id<JFJSONSerializationAdapter> __nullable)serializer
{
	self = [self init];
	
	_serializer = serializer;
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = [(serializer ?: self.serializer) dictionaryFromData:data];
	if(dictionary)
		[self importFromDictionary:dictionary];
	else
		self = nil;
	
	return self;
}

- (instancetype)initWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>*)dictionary
{
	self = [self initWithCapacity:dictionary.count];
	
	[self importFromDictionary:dictionary];
	
	return self;
}

- (instancetype __nullable)initWithString:(NSString*)string
{
	return [self initWithString:string serializer:nil];
}

- (instancetype __nullable)initWithString:(NSString*)string serializer:(id<JFJSONSerializationAdapter> __nullable)serializer
{
	self = [self init];
	
	_serializer = serializer;
	
	NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionary = [(serializer ?: self.serializer) dictionaryFromString:string];
	if(dictionary)
		[self importFromDictionary:dictionary];
	else
		self = nil;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (void)importFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary
{
	for(NSString* key in dictionary)
	{
		id value = [dictionary objectForKey:key];
		if([value isKindOfClass:[NSArray class]])
			value = [[JFJSONArray alloc] initWithArray:value];
		else if([value isKindOfClass:[NSDictionary class]])
			value = [[JFJSONObject alloc] initWithDictionary:value];
		[self setValue:value forKey:key];
	}
}

// =================================================================================================
// MARK: Methods - Data (Arrays)
// =================================================================================================

- (JFJSONArray* __nullable)arrayForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[JFJSONArray class]]) ? (JFJSONArray*)retVal : nil);
}

- (void)setArray:(JFJSONArray* __nullable)value forKey:(NSString*)key
{
	[self setValue:value forKey:key];
}

// =================================================================================================
// MARK: Methods - Data (Null)
// =================================================================================================

- (BOOL)isNullForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return (retVal && [retVal isKindOfClass:[NSNull class]]);
}

- (void)setNullForKey:(NSString*)key
{
	[self setValue:[NSNull null] forKey:key];
}

// =================================================================================================
// MARK: Methods - Data (Numbers)
// =================================================================================================

- (NSNumber* __nullable)numberForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[NSNumber class]]) ? (NSNumber*)retVal : nil);
}

- (void)setNumber:(NSNumber* __nullable)value forKey:(NSString*)key
{
	[self setValue:value forKey:key];
}

// =================================================================================================
// MARK: Methods - Data (Objects)
// =================================================================================================

- (JFJSONObject* __nullable)objectForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[JFJSONObject class]]) ? (JFJSONObject*)retVal : nil);
}

- (void)setObject:(JFJSONObject* __nullable)value forKey:(NSString*)key
{
	[self setValue:value forKey:key];
}

// =================================================================================================
// MARK: Methods - Data (Strings)
// =================================================================================================

- (void)setString:(NSString* __nullable)value forKey:(NSString*)key
{
	[self setValue:value forKey:key];
}

- (NSString* __nullable)stringForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[NSString class]]) ? (NSString*)retVal : nil);
}

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

- (id<JFJSONValue> __nullable)checkValue:(id __nullable)value
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

- (BOOL)hasValueForKey:(NSString*)key
{
	return ([self valueForKey:key] != nil);
}

- (void)removeValueForKey:(NSString*)key
{
	[self setValue:nil forKey:key];
}

- (void)setValue:(id<JFJSONValue> __nullable)value forKey:(NSString*)key
{
	value = [self checkValue:value];
	if(value)
		[self.map setObject:value forKey:key];
	else
		[self.map removeObjectForKey:key];
}

- (id<JFJSONValue> __nullable)valueForKey:(NSString*)key
{
	return [self.map objectForKey:key];
}

// =================================================================================================
// MARK: Methods - Subscripting
// =================================================================================================

- (id<JFJSONValue> __nullable)objectForKeyedSubscript:(NSString*)key API_AVAILABLE(ios(8.0), macos(10.8))
{
	return [self valueForKey:key];
}

- (void)setObject:(id<JFJSONValue> __nullable)object forKeyedSubscript:(NSString*)key API_AVAILABLE(ios(8.0), macos(10.8))
{
	[self setValue:object forKey:key];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
