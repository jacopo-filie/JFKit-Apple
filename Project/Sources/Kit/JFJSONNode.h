//
//	The MIT License (MIT)
//
//	Copyright © 2018-2021 Jacopo Filié
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

#import "JFJSONValue.h"

#import "JFJSONSerializationAdapter.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * Classes implementing the JSON node protocol can be used to group JSON values in a collection and convert them to JSON data/string and viceversa.
 */
@protocol JFJSONNode <JFJSONValue>

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The number of JSON values stored inside the node.
 */
@property (assign, nonatomic, readonly) NSUInteger count;

/**
 * Converts the node to JSON data and returns the result.
 */
@property (copy, nonatomic, readonly, nullable) NSData* dataValue;

/**
 * Converts the node to JSON string and returns the result.
 */
@property (copy, nonatomic, readonly, nullable) NSString* stringValue;

// =================================================================================================
// MARK: Methods - Serialization
// =================================================================================================

/**
 * The serializer to use while converting the node to JSON data/string and viceversa.
 * @warning Setting this property to `nil` resets the used serializer to the default class `JFJSONSerializer`, if available.
 */
@property (strong, nullable) id<JFJSONSerializationAdapter> serializer;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Initializes this instance with the given JSON data.
 * @param data The JSON data.
 * @param serializer The JSON serializer to use or `nil` to use the default one.
 * @return This instance, or `nil` if `data` does not contain valid JSON content.
 */
- (instancetype _Nullable)initWithData:(NSData*)data serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

/**
 * Initializes this instance with the given JSON string.
 * @param string The JSON string.
 * @param serializer The JSON serializer to use or `nil` to use the default one.
 * @return This instance, or `nil` if `string` does not contain valid JSON content.
 */
- (instancetype _Nullable)initWithString:(NSString*)string serializer:(id<JFJSONSerializationAdapter> _Nullable)serializer;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
