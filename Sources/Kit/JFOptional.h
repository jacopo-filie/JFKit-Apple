//
//	The MIT License (MIT)
//
//	Copyright © 2020-2024 Jacopo Filié
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Macros
// =================================================================================================

/**
 * A convenient macro that represents the template parameters of this class.
 */
#define JFOptionalTemplate __covariant ObjectType

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A useful wrapper for properties that are optional and should be discarded and recreated only when needed, improving memory usage in this way.
 */
@interface JFOptional<JFOptionalTemplate> : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The initialized object; the getter of this property forces the initialization of the object if it has not been done yet.
 */
@property (assign, nonatomic, readonly) ObjectType get;

/**
 * The initialized object or `nil` if the object has not been initialized yet.
 */
@property (weak, nonatomic, readonly, nullable) ObjectType opt;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * Creates and initializes a new optional with the given `builder`.
 * @param builder The block to use to create and initialize the optional object.
 * @return A new instance of this class.
 */
+ (instancetype)optionalWithBuilder:(ObjectType (^)(void))builder;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given `builder`.
 * @param builder The block to use to create and initialize the optional object.
 * @return This instance.
 */
- (instancetype)initWithBuilder:(ObjectType (^)(void))builder NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
