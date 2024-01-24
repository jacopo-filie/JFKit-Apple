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

/**
 * A hook only keeps a strong reference to the object given during initialization and does nothing else. You may use this class to have a memory area ready to hold an object that will be available in the future, or to pass the result of an asynchronous method to another asynchronous method.
 */
@interface JFHook<__covariant ObjectType> : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The object that has been given during initialization.
 */
@property (strong, nullable) ObjectType object;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Creates and initializes a new instance with the given `object`.
 * @param object The object to hold.
 * @return A new instance of this class.
 */
+ (instancetype)newWithObject:(ObjectType _Nullable)object;

/**
 * Initializes this instance with the given `object`.
 * @param object The object to hold.
 * @return This instance.
 */
- (instancetype)initWithObject:(ObjectType _Nullable)object;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
