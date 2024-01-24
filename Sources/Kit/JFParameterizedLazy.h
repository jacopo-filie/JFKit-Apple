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
#define JFParameterizedLazyTemplate __covariant ObjectType, __covariant ParamType

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * This class can be used to simplify management of the lazy initialization of an object that requires a parameter to be initialized. You can force the initialization of the wrapped object by calling the method `get`, otherwise you can just query the wrapper content using the method `opt` that will return `nil` if the object has not been initialized yet. If you're sure about the thread-safety of the context you're going to use this class, you can use unsynchronized instances; using synchronized instances is recommended otherwise.
 */
@interface JFParameterizedLazy<JFParameterizedLazyTemplate> : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The lazy initialized object or `nil` if the object has not been initialized yet.
 */
@property (strong, nonatomic, readonly, nullable) ObjectType opt;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * Creates and initializes a new unsynchronized instance with the given `builder`.
 * @param builder The block to use to create and initialize the lazy object; this block must accept a `param` parameter that will be given when the method `get` is called.
 * @return A new instance of this class.
 */
+ (instancetype)newInstance:(ObjectType (^)(ParamType param))builder;

/**
 * Creates and initializes a new synchronized instance with the given `builder`.
 * @param builder The block to use to create and initialize the lazy object; this block must accept a `param` parameter that will be given when the method `get` is called.
 * @return A new instance of this class.
 */
+ (instancetype)newSynchronizedInstance:(ObjectType (^)(ParamType param))builder;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

/**
 * Returns the lazy initialized object if it has already been done, otherwise it forces the initialization of the object and returns it.
 * @param param The parameter that will be passed to the builder block during object initialization.
 * @return The lazy initialized object.
 */
- (ObjectType)get:(ParamType)param;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
