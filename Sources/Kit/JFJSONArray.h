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

@class JFJSONObject;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Blocks
// =================================================================================================

/**
 * A block to operate on values in the object.
 * @param index The index of the current value.
 * @param value The current value.
 * @return Return `YES` to stop the enumeration, `NO` to continue with the next value.
 */
typedef BOOL (^JFJSONArrayEnumerationBlock)(NSUInteger index, id<JFJSONValue> value);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * The `JFJSONArray` class is a kind of JSON node that associates sorted integer keys, called indexes, with JSON values.
 */
@interface JFJSONArray : NSObject <JFJSONNode, NSCopying, NSFastEnumeration>

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * Converts the collection to SDK native data objects and returns the result.
 */
@property (copy, nonatomic, readonly) NSArray<id<JFJSONConvertibleValue>>* arrayValue;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON data.
 * @param data The JSON data.
 * @return A new instance of this class, or `nil` if `data` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)arrayWithData:(NSData* _Nullable)data;

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON data using the given JSON serializer.
 * @param data The JSON data.
 * @param serializer The JSON serializer to use or `nil` to use the default one.
 * @return A new instance of this class, or `nil` if `data` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)arrayWithData:(NSData* _Nullable)data serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

/**
 * A convenient constructor that initializes a new instance of this class with the given array.
 * @param array The array containing the JSON values.
 * @return A new instance of this class, or `nil` if `array` does not exist.
 */
+ (instancetype _Nullable)arrayWithArray:(NSArray<id<JFJSONConvertibleValue>>* _Nullable)array;

/**
 * A convenient constructor that initializes a new instance of this class with the given array.
 * @param array The array containing the JSON values.
 * @param serializer The JSON serializer to set after the instance creation.
 * @return A new instance of this class, or `nil` if `array` does not exist.
 */
+ (instancetype _Nullable)arrayWithArray:(NSArray<id<JFJSONConvertibleValue>>* _Nullable)array serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON string.
 * @param string The JSON string.
 * @return A new instance of this class, or `nil` if `string` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)arrayWithString:(NSString* _Nullable)string;

/**
 * A convenient constructor that initializes a new instance of this class with the given JSON string using the given JSON serializer.
 * @param string The JSON string.
 * @param serializer The JSON serializer to use or `nil` to use the default one.
 * @return A new instance of this class, or `nil` if `string` does not exist or it does not contain valid JSON content.
 */
+ (instancetype _Nullable)arrayWithString:(NSString* _Nullable)string serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

/**
 * Initializes this instance.
 * @return This instance.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with the given array.
 * @param array The array containing the values to store in the JSON object.
 * @return This instance.
 */
- (instancetype)initWithArray:(NSArray<id<JFJSONConvertibleValue>>*)array;

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
 * Initializes this instance with the given JSON string using the default JSON serializer.
 * @param string The JSON string.
 * @return This instance, or `nil` if `string` does not contain valid JSON content.
 */
- (instancetype _Nullable)initWithString:(NSString*)string;

// =================================================================================================
// MARK: Methods - Comparison
// =================================================================================================

/**
 * Compares the receiving JSON array to another JSON array.
 * @discussion Two JSON arrays have equal contents if they each hold the same number of values and values at a given index in
 * each JSON array satisfy the `isEqual:` test.
 * @param other A JSON array to compare.
 * @return Returns `YES` if the JSON arrays are equal, `NO` otherwise.
 */
- (BOOL)isEqualToJSONArray:(JFJSONArray*)other;

// =================================================================================================
// MARK: Methods - Data (Arrays)
// =================================================================================================

/**
 * Appends the given array to the end of the collection.
 * @param value The array to append.
 */
- (void)addArray:(JFJSONArray*)value;

/**
 * Returns the array associated with the given index.
 * @param index The index of the association.
 * @return The array associated with the given index.
 * @warning If no value is associated with the given index, or it is not an array, this method returns `nil`.
 */
- (JFJSONArray* _Nullable)arrayAtIndex:(NSUInteger)index;

/**
 * Inserts the given array at the given index in the collection, incrementing all subsequent indexes.
 * @param value The array to insert.
 * @param index The index of the association.
 */
- (void)insertArray:(JFJSONArray*)value atIndex:(NSUInteger)index;

/**
 * Replaces the value stored at the given index in the collection with given array.
 * @param value The array to use for the replacement.
 * @param index The index of the association.
 */
- (void)replaceWithArray:(JFJSONArray*)value atIndex:(NSUInteger)index;

// =================================================================================================
// MARK: Methods - Data (Null)
// =================================================================================================

/**
 * Appends `NSNull` to the end of the collection.
 */
- (void)addNull;

/**
 * Inserts `NSNull` at the given index in the collection, incrementing all subsequent indexes.
 * @param index The index of the association.
 */
- (void)insertNullAtIndex:(NSUInteger)index;

/**
 * Returns whether the value associated with the given index is `NSNull`.
 * @param index The index of the association.
 * @return `YES` if the associated value is `NSNull`, `NO` otherwise.
 */
- (BOOL)isNullAtIndex:(NSUInteger)index;

/**
 * Replaces the value stored at the given index in the collection with `NSNull`.
 * @param index The index of the association.
 */
- (void)replaceWithNullAtIndex:(NSUInteger)index;

// =================================================================================================
// MARK: Methods - Data (Numbers)
// =================================================================================================

/**
 * Appends the given number to the end of the collection.
 * @param value The number to append.
 */
- (void)addNumber:(NSNumber*)value;

/**
 * Inserts the given number at the given index in the collection, incrementing all subsequent indexes.
 * @param value The number to insert.
 * @param index The index of the association.
 */
- (void)insertNumber:(NSNumber*)value atIndex:(NSUInteger)index;

/**
 * Returns the number associated with the given index.
 * @param index The index of the association.
 * @return The number associated with the given index.
 * @warning If no value is associated with the given index, or it is not a number, this method returns `nil`.
 */
- (NSNumber* _Nullable)numberAtIndex:(NSUInteger)index;

/**
 * Replaces the value stored at the given index in the collection with given number.
 * @param value The number to use for the replacement.
 * @param index The index of the association.
 */
- (void)replaceWithNumber:(NSNumber*)value atIndex:(NSUInteger)index;

// =================================================================================================
// MARK: Methods - Data (Objects)
// =================================================================================================

/**
 * Appends the given object to the end of the collection.
 * @param value The object to append.
 */
- (void)addObject:(JFJSONObject*)value;

/**
 * Inserts the given object at the given index in the collection, incrementing all subsequent indexes.
 * @param value The object to insert.
 * @param index The index of the association.
 */
- (void)insertObject:(JFJSONObject*)value atIndex:(NSUInteger)index;

/**
 * Returns the object associated with the given index.
 * @param index The index of the association.
 * @return The object associated with the given index.
 * @warning If no value is associated with the given index, or it is not an object, this method returns `nil`.
 */
- (JFJSONObject* _Nullable)objectAtIndex:(NSUInteger)index;

/**
 * Replaces the value stored at the given index in the collection with given object.
 * @param value The object to use for the replacement.
 * @param index The index of the association.
 */
- (void)replaceWithObject:(JFJSONObject*)value atIndex:(NSUInteger)index;

// =================================================================================================
// MARK: Methods - Data (Strings)
// =================================================================================================

/**
 * Appends the given string to the end of the collection.
 * @param value The string to append.
 */
- (void)addString:(NSString*)value;

/**
 * Inserts the given string at the given index in the collection, incrementing all subsequent indexes.
 * @param value The string to insert.
 * @param index The index of the association.
 */
- (void)insertString:(NSString*)value atIndex:(NSUInteger)index;

/**
 * Replaces the value stored at the given index in the collection with given string.
 * @param value The string to use for the replacement.
 * @param index The index of the association.
 */
- (void)replaceWithString:(NSString*)value atIndex:(NSUInteger)index;

/**
 * Returns the string associated with the given index.
 * @param index The index of the association.
 * @return The string associated with the given index.
 * @warning If no value is associated with the given index, or it is not a string, this method returns `nil`.
 */
- (NSString* _Nullable)stringAtIndex:(NSUInteger)index;

// =================================================================================================
// MARK: Methods - Data (Values)
// =================================================================================================

/**
 * Appends the given value to the end of the collection.
 * @param value The value to append.
 */
- (void)addValue:(id<JFJSONValue>)value;

/**
 * Inserts the given value at the given index in the collection, incrementing all subsequent indexes.
 * @param value The value to insert.
 * @param index The index of the association.
 */
- (void)insertValue:(id<JFJSONValue>)value atIndex:(NSUInteger)index;

/**
 * Removes all the stored values.
 */
- (void)removeAllValues;

/**
 * Removes the stored value for the given index; if no value is currently stored for the given index, it does nothing.
 * @param index The index of the association.
 */
- (void)removeValueAtIndex:(NSUInteger)index;

/**
 * Replaces the value stored at the given index in the collection with given value.
 * @param value The value to use for the replacement.
 * @param index The index of the association.
 */
- (void)replaceWithValue:(id<JFJSONValue>)value atIndex:(NSUInteger)index;

/**
 * Returns the value associated with the given index.
 * @param index The index of the association.
 * @return The value associated with the given index.
 */
- (id<JFJSONValue> _Nullable)valueAtIndex:(NSUInteger)index;

// =================================================================================================
// MARK: Methods - Enumeration
// =================================================================================================

/**
 * Applies a given block to the values in the JSON array at the specified indexes, with options specifying how the enumeration is
 * performed.
 * @param indexes The indexes of the values over which to enumerate.
 * @param options Enumeration options.
 * @param block A block to operate on values in the JSON array.
 */
- (void)enumerateValuesAtIndexes:(NSIndexSet*)indexes options:(NSEnumerationOptions)options usingBlock:(JFJSONArrayEnumerationBlock)block;

/**
 * Applies a given block to the values in the JSON array.
 * @param block A block to operate on values in the JSON array.
 */
- (void)enumerateValuesUsingBlock:(JFJSONArrayEnumerationBlock)block;

/**
 * Applies a given block to the values in the JSON array, with options specifying how the enumeration is performed.
 * @param options Enumeration options.
 * @param block A block to operate on values in the JSON array.
 */
- (void)enumerateValuesWithOptions:(NSEnumerationOptions)options usingBlock:(JFJSONArrayEnumerationBlock)block;

/**
 * Returns an enumerator that lets you access each value in the JSON array, in reverse order.
 * @return An enumerator that lets you access each value in the JSON array, in reverse order.
 */
- (NSEnumerator<id<JFJSONValue>>*)reverseValueEnumerator;

/**
 * Returns an enumerator that lets you access each value in the JSON array.
 * @return An enumerator that lets you access each value in the JSON array, in order, starting with the element at index 0.
 */
- (NSEnumerator<id<JFJSONValue>>*)valueEnumerator;

// =================================================================================================
// MARK: Methods - Subscripting
// =================================================================================================

/**
 * Returns the value associated with the given index. Used to enable getting values using the subscripting notation.
 * @param index The index of the association.
 * @return The value associated with the given index.
 */
- (id<JFJSONValue> _Nullable)objectAtIndexedSubscript:(NSUInteger)index API_AVAILABLE(ios(8.0), macos(10.8));

/**
 * Associates the given value with the given index. Used to enable setting values using the subscripting notation.
 * @param object The value to associate with the given index, or `nil` to remove the currently stored value.
 * @param index The index to use to store the given value.
 */
- (void)setObject:(id<JFJSONValue>)object atIndexedSubscript:(NSUInteger)index API_AVAILABLE(ios(8.0), macos(10.8));

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
