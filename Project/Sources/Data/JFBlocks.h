//
//	The MIT License (MIT)
//
//	Copyright © 2015-2019 Jacopo Filié
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

#import "JFPreprocessorMacros.h"

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

#import "JFCompatibilityMacros.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * A block of code to be executed.
 */
typedef void (^JFBlock) (void);

/**
 * A block of code to be executed with a parameter.
 * @param array A generic array object.
 */
typedef void (^JFBlockWithArray) (NSArray* __nullable array);

/**
 * A block of code to be executed with a parameter.
 * @param value A boolean value.
 */
typedef void (^JFBlockWithBOOL) (BOOL value);

/**
 * A block of code to be executed with a parameter.
 * @param data A data object.
 */
typedef void (^JFBlockWithData) (NSData* __nullable data);

/**
 * A block of code to be executed with a parameter.
 * @param date A date object.
 */
typedef void (^JFBlockWithDate) (NSDate* __nullable date);

/**
 * A block of code to be executed with a parameter.
 * @param dictionary A generic dictionary object.
 */
typedef void (^JFBlockWithDictionary) (NSDictionary* __nullable dictionary);

/**
 * A block of code to be executed with a parameter.
 * @param value A double value.
 */
typedef void (^JFBlockWithDouble) (double value);

/**
 * A block of code to be executed with a parameter.
 * @param error An error object.
 */
typedef void (^JFBlockWithError) (NSError* __nullable error);

/**
 * A block of code to be executed with a parameter.
 * @param value A float value.
 */
typedef void (^JFBlockWithFloat) (float value);

/**
 * A block of code to be executed with a parameter.
 * @param image An image object.
 */
typedef void (^JFBlockWithImage) (JFImage* __nullable image);

/**
 * A block of code to be executed with a parameter.
 * @param value An integer value.
 */
typedef void (^JFBlockWithInteger) (NSInteger value);

/**
 * A block of code to be executed with a parameter.
 * @param notification A notification object.
 */
typedef void (^JFBlockWithNotification) (NSNotification* __nullable notification);

/**
 * A block of code to be executed with a parameter.
 * @param number A number object.
 */
typedef void (^JFBlockWithNumber) (NSNumber* __nullable number);

/**
 * A block of code to be executed with a parameter.
 * @param object A generic object.
 */
typedef void (^JFBlockWithObject) (id<NSObject> __nullable object);

/**
 * A block of code to be executed with a parameter.
 * @param set A generic set object.
 */
typedef void (^JFBlockWithSet) (NSSet* __nullable set);

/**
 * A block of code to be executed with a parameter.
 * @param string A string object.
 */
typedef void (^JFBlockWithString) (NSString* __nullable string);

/**
 * A block of code to be executed with a parameter.
 * @param value A value object.
 */
typedef void (^JFBlockWithValue) (NSValue* __nullable value);

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

