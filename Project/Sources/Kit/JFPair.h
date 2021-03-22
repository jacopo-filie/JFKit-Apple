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

@import Foundation;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * A handy container that allows a couple of values to be held together. This class is immutable.
 * `FirstType` defines the type of the property `firstValue`.
 * `SecondType` defines the type of the property `secondValue`.
 */
@interface JFPair<__covariant FirstType, __covariant SecondType> : NSObject <NSCopying, NSMutableCopying>

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The first value of the couple.
 */
@property (strong, nonatomic, readonly, nullable) FirstType firstValue;

/**
 * The second value of the couple.
 */
@property (strong, nonatomic, readonly, nullable) SecondType secondValue;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

/**
 * A convenient constructor that initializes a new instance of this class with the given values.
 * @param firstValue The first value of the pair.
 * @param secondValue The second value of the pair.
 * @return A new instance of this class.
 */
+ (instancetype)pairWithFirstValue:(FirstType __nullable)firstValue secondValue:(SecondType __nullable)secondValue;

/**
 * Initializes this instance with the given values.
 * @param firstValue The first value of the pair.
 * @param secondValue The second value of the pair.
 * @return This instance.
 */
- (instancetype)initWithFirstValue:(FirstType __nullable)firstValue secondValue:(SecondType __nullable)secondValue NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * Mutable version of the class `JFPair`.
 * `FirstType` defines the type of the property `firstValue`.
 * `SecondType` defines the type of the property `secondValue`.
 */
@interface JFMutablePair<__covariant FirstType, __covariant SecondType> : JFPair<FirstType, SecondType>

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The first value of the couple.
 */
@property (strong, nonatomic, readwrite, nullable) FirstType firstValue;

/**
 * The second value of the couple.
 */
@property (strong, nonatomic, readwrite, nullable) SecondType secondValue;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
