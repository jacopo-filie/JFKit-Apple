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

@import Foundation;

#import <JFKit/JFJSONNode.h>

@class JFJSONArray;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Blocks
// =================================================================================================

/**
 * A block to operate on entries in the object.
 * @param key The key of the current entry.
 * @param value The value of the current entry.
 * @return Return `YES` to stop the enumeration, `NO` to continue with the next entry.
 */
typedef BOOL (^JFJSONObjectEnumerationBlock)(NSString* key, id<JFJSONValue> value);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * The `JFJSONObject` class is a kind of JSON node that associates string keys with JSON values.
 */
@interface JFJSONObject : NSObject <JFJSONNode, NSCopying, NSFastEnumeration>

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * Returns all keys currently stored in the collection.
 */
@property (copy, nonatomic, readonly) NSArray<NSString*>* allKeys;

/**
 * Returns all values currently stored in the collection.
 */
@property (copy, nonatomic, readonly) NSArray<id<JFJSONValue>>* allValues;

/**
 * Converts the collection to SDK native data objects and returns the result.
 */
@property (copy, nonatomic, readonly) NSDictionary<NSString*, id<JFJSONConvertibleValue>>* dictionaryValue;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON data.
 * @param data The JSON data.
 * @return A new instance of this class, or `nil` if `data` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)objectWithData:(NSData* _Nullable)data;

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON data using the given JSON serializer.
 * @param data The JSON data.
 * @param serializer The JSON serializer to use or `nil` to use the default one.
 * @return A new instance of this class, or `nil` if `data` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)objectWithData:(NSData* _Nullable)data serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

/**
 * A convenient constructor that initializes a new instance of this class with the given dictionary.
 * @param dictionary The dictionary containing the JSON values.
 * @return A new instance of this class, or `nil` if `dictionary` does not exist.
 */
+ (instancetype _Nullable)objectWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* _Nullable)dictionary;

/**
 * A convenient constructor that initializes a new instance of this class with the given dictionary.
 * @param dictionary The dictionary containing the JSON values.
 * @param serializer The JSON serializer to set after the instance creation.
 * @return A new instance of this class, or `nil` if `dictionary` does not exist.
 */
+ (instancetype _Nullable)objectWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* _Nullable)dictionary serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON string.
 * @param string The JSON string.
 * @return A new instance of this class, or `nil` if `string` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)objectWithString:(NSString* _Nullable)string;

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON string using the given JSON serializer.
 * @param string The JSON string.
 * @param serializer The JSON serializer to use or `nil` to use the default one.
 * @return A new instance of this class, or `nil` if `string` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)objectWithString:(NSString* _Nullable)string serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

/**
 * Initializes this instance.
 * @return This instance.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance by specifing the initial container capacity.
 * @param capacity The initial container capacity.
 * @return This instance.
 */
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with the given JSON data using the default JSON serializer.
 * @param data The JSON data.
 * @return This instance, or `nil` if `data` does not contain valid JSON content.
 */
- (instancetype _Nullable)initWithData:(NSData*)data;

/**
 * Initializes this instance with the given dictionary.
 * @param dictionary The dictionary containing the values to store in the JSON object.
 * @return This instance.
 */
- (instancetype)initWithDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>*)dictionary;

/**
 * Initializes this instance with the given JSON string using the default JSON serializer.
 * @param string The JSON string.
 * @return This instance, or `nil` if `string` does not contain valid JSON content.
 */
- (instancetype _Nullable)initWithString:(NSString*)string;

// =================================================================================================
// MARK: Methods - Comparison
// =================================================================================================

/**
 * Compares the receiving JSON object to another JSON object.
 * @discussion Two JSON objects have equal contents if they each hold the same number of entries and, for a given key, the corresponding values in each JSON object satisfy the `isEqual:` test.
 * @param other A JSON object to compare.
 * @return Returns `YES` if the JSON objects are equal, `NO` otherwise.
 */
- (BOOL)isEqualToJSONObject:(JFJSONObject*)other;

// =================================================================================================
// MARK: Methods - Data (Arrays)
// =================================================================================================

/**
 * Returns the array associated with the given key.
 * @param key The key of the association.
 * @return The array associated with the given key.
 * @warning If no value is associated with the given key, or it is not an array, this method returns `nil`.
 */
- (JFJSONArray* _Nullable)arrayForKey:(NSString*)key;

/**
 * Sets the given array as value associated with the given key.
 * @param value The array to associate with the given key, or `nil` to remove the currently stored value.
 * @param key The key to use to store the given value.
 */
- (void)setArray:(JFJSONArray* _Nullable)value forKey:(NSString*)key;

// =================================================================================================
// MARK: Methods - Data (Null)
// =================================================================================================

/**
 * Returns whether the value associated with the given key is `NSNull`.
 * @param key The key of the association.
 * @return `YES` if the associated value is `NSNull`, `NO` otherwise.
 */
- (BOOL)isNullForKey:(NSString*)key;

/**
 * Sets the value associated with the given key to `NSNull`.
 * @param key The key to associate to `NSNull`.
 */
- (void)setNullForKey:(NSString*)key;

// =================================================================================================
// MARK: Methods - Data (Numbers)
// =================================================================================================

/**
 * Returns the number associated with the given key.
 * @param key The key of the association.
 * @return The number associated with the given key.
 * @warning If no value is associated with the given key, or it is not a number, this method returns `nil`.
 */
- (NSNumber* _Nullable)numberForKey:(NSString*)key;

/**
 * Sets the given number as value associated with the given key.
 * @param value The number to associate with the given key, or `nil` to remove the currently stored value.
 * @param key The key to use to store the given value.
 */
- (void)setNumber:(NSNumber* _Nullable)value forKey:(NSString*)key;

// =================================================================================================
// MARK: Methods - Data (Objects)
// =================================================================================================

/**
 * Returns the object associated with the given key.
 * @param key The key of the association.
 * @return The object associated with the given key.
 * @warning If no value is associated with the given key, or it is not an object, this method returns `nil`.
 */
- (JFJSONObject* _Nullable)objectForKey:(NSString*)key NS_SWIFT_NAME(object(forKey:));

/**
 * Sets the given object as value associated with the given key.
 * @param value The object to associate with the given key, or `nil` to remove the currently stored value.
 * @param key The key to use to store the given value.
 */
- (void)setObject:(JFJSONObject* _Nullable)value forKey:(NSString*)key;

// =================================================================================================
// MARK: Methods - Data (Strings)
// =================================================================================================

/**
 * Sets the given string as value associated with the given key.
 * @param value The string to associate with the given key, or `nil` to remove the currently stored value.
 * @param key The key to use to store the given value.
 */
- (void)setString:(NSString* _Nullable)value forKey:(NSString*)key;

/**
 * Returns the string associated with the given key.
 * @param key The key of the association.
 * @return The string associated with the given key.
 * @warning If no value is associated with the given key, or it is not a string, this method returns `nil`.
 */
- (NSString* _Nullable)stringForKey:(NSString*)key;

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

/**
 * Returns whether a value associated with the given key exists.
 * @param key The key to check.
 * @return `YES` if the associated value exists, `NO` otherwise.
 */
- (BOOL)hasValueForKey:(NSString*)key;

/**
 * Removes all the stored values.
 */
- (void)removeAllValues;

/**
 * Removes the currently stored value for the given key; if no value is currently stored for the given key, it does nothing.
 * @param key The key of the association.
 */
- (void)removeValueForKey:(NSString*)key;

/**
 * Associates the given value with the given key.
 * @param value The value to associate with the given key, or `nil` to remove the currently stored value.
 * @param key The key to use to store the given value.
 */
- (void)setValue:(id<JFJSONValue> _Nullable)value forKey:(NSString*)key;

/**
 * Returns the value associated with the given key.
 * @param key The key of the association.
 * @return The value associated with the given key.
 */
- (id<JFJSONValue> _Nullable)valueForKey:(NSString*)key;

// =================================================================================================
// MARK: Methods - Enumeration
// =================================================================================================

/**
 * Applies a given block to the entries of the JSON object.
 * @param block A block to operate on entries in the JSON object.
 */
- (void)enumerateKeysAndValuesUsingBlock:(JFJSONObjectEnumerationBlock)block;

/**
 * Applies a given block to the entries of the JSON object, with options specifying how the enumeration is performed.
 * @param options Enumeration options.
 * @param block A block to operate on entries in the JSON object.
 */
- (void)enumerateKeysAndValuesWithOptions:(NSEnumerationOptions)options usingBlock:(JFJSONObjectEnumerationBlock)block;

/**
 * Provides an enumerator to access the keys in the JSON object.
 * @return An enumerator to access the keys in the JSON object.
 */
- (NSEnumerator<NSString*>*)keyEnumerator;

/**
 * Provides an enumerator to access the values in the JSON object.
 * @return An enumerator to access the values in the JSON object.
 */
- (NSEnumerator<id<JFJSONValue>>*)valueEnumerator;

// =================================================================================================
// MARK: Methods - Subscripting
// =================================================================================================

/**
 * Returns the value associated with the given key. Used to enable getting values using the subscripting notation.
 * @param key The key of the association.
 * @return The value associated with the given key.
 */
- (id<JFJSONValue> _Nullable)objectForKeyedSubscript:(NSString*)key API_AVAILABLE(ios(8.0), macos(10.8));

/**
 * Associates the given value with the given key. Used to enable setting values using the subscripting notation.
 * @param object The value to associate with the given key, or `nil` to remove the currently stored value.
 * @param key The key to use to store the given value.
 */
- (void)setObject:(id<JFJSONValue> _Nullable)object forKeyedSubscript:(NSString*)key API_AVAILABLE(ios(8.0), macos(10.8));

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
