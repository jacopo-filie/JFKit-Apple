//
//	The MIT License (MIT)
//
//	Copyright © 2018-2024 Jacopo Filié
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

#import "JFJSONObject.h"

#import "JFJSONArray.h"
#import "JFJSONSerializer.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

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

- (void)importFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* _Nullable)dictionary;

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

- (id<JFJSONValue> _Nullable)checkValue:(id _Nullable)value;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

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

- (NSData* _Nullable)dataValue
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

- (NSString* _Nullable)stringValue
{
	return [self.serializer stringFromDictionary:self.dictionaryValue];
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype _Nullable)objectWithData:(NSData* _Nullable)data
{
	return [self objectWithData:data serializer:nil];
}

+ (instancetype _Nullable)objectWithData:(NSData* _Nullable)data serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	return (data ? [self objectWithDictionary:[(serializer ?: self.defaultSerializer) dictionaryFromData:data] serializer:serializer] : nil);
}

+ (instancetype _Nullable)objectWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* _Nullable)dictionary
{
	return [self objectWithDictionary:dictionary serializer:nil];
}

+ (instancetype _Nullable)objectWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* _Nullable)dictionary serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
{
	if(!dictionary)
		return nil;
	
	JFJSONObject* retObj = [[self alloc] initWithDictionary:dictionary];
	retObj.serializer = serializer;
	return retObj;
}

+ (instancetype _Nullable)objectWithString:(NSString* _Nullable)string
{
	return [self objectWithString:string serializer:nil];
}

+ (instancetype _Nullable)objectWithString:(NSString* _Nullable)string serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
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

- (instancetype _Nullable)initWithData:(NSData*)data
{
	return [self initWithData:data serializer:nil];
}

- (instancetype _Nullable)initWithData:(NSData*)data serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
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

- (instancetype _Nullable)initWithString:(NSString*)string
{
	return [self initWithString:string serializer:nil];
}

- (instancetype _Nullable)initWithString:(NSString*)string serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer
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
// MARK: Methods - Comparison
// =================================================================================================

- (NSUInteger)hash
{
	return self.map.hash;
}

- (BOOL)isEqual:(id _Nullable)object
{
	if(!object || ![object isKindOfClass:self.class])
		return NO;
	
	return [self isEqualToJSONObject:(JFJSONObject*)object];
}

- (BOOL)isEqualToJSONObject:(JFJSONObject*)other
{
	return [self.map isEqualToDictionary:other.map];
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (void)importFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* _Nullable)dictionary
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

- (JFJSONArray* _Nullable)arrayForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[JFJSONArray class]]) ? (JFJSONArray*)retVal : nil);
}

- (void)setArray:(JFJSONArray* _Nullable)value forKey:(NSString*)key
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

- (NSNumber* _Nullable)numberForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[NSNumber class]]) ? (NSNumber*)retVal : nil);
}

- (void)setNumber:(NSNumber* _Nullable)value forKey:(NSString*)key
{
	[self setValue:value forKey:key];
}

// =================================================================================================
// MARK: Methods - Data (Objects)
// =================================================================================================

- (JFJSONObject* _Nullable)objectForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[JFJSONObject class]]) ? (JFJSONObject*)retVal : nil);
}

- (void)setObject:(JFJSONObject* _Nullable)value forKey:(NSString*)key
{
	[self setValue:value forKey:key];
}

// =================================================================================================
// MARK: Methods - Data (Strings)
// =================================================================================================

- (void)setString:(NSString* _Nullable)value forKey:(NSString*)key
{
	[self setValue:value forKey:key];
}

- (NSString* _Nullable)stringForKey:(NSString*)key
{
	id<JFJSONValue> retVal = [self valueForKey:key];
	return ((retVal && [retVal isKindOfClass:[NSString class]]) ? (NSString*)retVal : nil);
}

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

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

- (BOOL)hasValueForKey:(NSString*)key
{
	return ([self valueForKey:key] != nil);
}

- (void)removeAllValues
{
	[self.map removeAllObjects];
}

- (void)removeValueForKey:(NSString*)key
{
	[self setValue:nil forKey:key];
}

- (void)setValue:(id<JFJSONValue> _Nullable)value forKey:(NSString*)key
{
	value = [self checkValue:value];
	if(value)
		[self.map setObject:value forKey:key];
	else
		[self.map removeObjectForKey:key];
}

- (id<JFJSONValue> _Nullable)valueForKey:(NSString*)key
{
	return [self.map objectForKey:key];
}

// =================================================================================================
// MARK: Methods - Enumeration
// =================================================================================================

- (void)enumerateKeysAndValuesUsingBlock:(JFJSONObjectEnumerationBlock)block
{
	[self.map enumerateKeysAndObjectsUsingBlock:^(NSString* key, id<JFJSONValue> value, BOOL* stop) {
		*stop = block(key, value);
	}];
}

- (void)enumerateKeysAndValuesWithOptions:(NSEnumerationOptions)options usingBlock:(JFJSONObjectEnumerationBlock)block
{
	[self.map enumerateKeysAndObjectsWithOptions:options usingBlock:^(NSString* key, id<JFJSONValue> value, BOOL* stop) {
		*stop = block(key, value);
	}];
}

- (NSEnumerator<NSString*>*)keyEnumerator
{
	return [self.map keyEnumerator];
}

- (NSEnumerator<id<JFJSONValue>>*)valueEnumerator
{
	return [self.map objectEnumerator];
}

// =================================================================================================
// MARK: Methods - Subscripting
// =================================================================================================

- (id<JFJSONValue> _Nullable)objectForKeyedSubscript:(NSString*)key API_AVAILABLE(ios(8.0), macos(10.8))
{
	return [self valueForKey:key];
}

- (void)setObject:(id<JFJSONValue> _Nullable)object forKeyedSubscript:(NSString*)key API_AVAILABLE(ios(8.0), macos(10.8))
{
	[self setValue:object forKey:key];
}

// =================================================================================================
// MARK: Methods (NSCopying)
// =================================================================================================

- (id)copyWithZone:(NSZone* _Nullable)zone
{
	JFJSONObject* retObj = [self.class new];
	NSMutableDictionary<NSString*, id<JFJSONValue>>* map = retObj.map;
	[self enumerateKeysAndValuesUsingBlock:^BOOL(NSString* key, id<JFJSONValue> value) {
		if([value isKindOfClass:JFJSONArray.class]) {
			[map setObject:[(JFJSONArray*)value copy] forKey:key];
		} else if([value isKindOfClass:JFJSONObject.class]) {
			[map setObject:[(JFJSONObject*)value copy] forKey:key];
		} else if([value isKindOfClass:NSNull.class]) {
			[map setObject:[(NSNull*)value copy] forKey:key];
		} else if([value isKindOfClass:NSNumber.class]) {
			[map setObject:[(NSNumber*)value copy] forKey:key];
		} else if([value isKindOfClass:NSString.class]) {
			[map setObject:[(NSString*)value copy] forKey:key];
		}
		return NO;
	}];
	return retObj;
}

// =================================================================================================
// MARK: Methods (NSFastEnumeration)
// =================================================================================================

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(__unsafe_unretained id _Nullable [])buffer count:(NSUInteger)len
{
	return [self.map countByEnumeratingWithState:state objects:buffer count:len];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
