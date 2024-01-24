//
//	The MIT License (MIT)
//
//	Copyright © 2015-2024 Jacopo Filié
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

#import <JFKit/JFPreprocessorMacros.h>

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Basic blocks
// =================================================================================================

/**
 * A block of code to be executed.
 */
typedef void (^JFBlock)(void);

/**
 * A block of code to be executed with a parameter.
 * @param param A boolean value.
 */
typedef void (^JFBooleanBlock)(BOOL param);

/**
 * A block of code to be executed with a parameter.
 * @param param A double value.
 */
typedef void (^JFDoubleBlock)(double param);

/**
 * A block of code to be executed with a parameter.
 * @param param A float value.
 */
typedef void (^JFFloatBlock)(float param);

/**
 * A block of code to be executed with a parameter.
 * @param param A signed integer value.
 */
typedef void (^JFIntegerBlock)(NSInteger param);

/**
 * A block of code to be executed with a parameter.
 * @param param A time interval value.
 */
typedef void (^JFTimeIntervalBlock)(NSTimeInterval param);

/**
 * A block of code to be executed with a parameter.
 * @param param An unsigned integer value.
 */
typedef void (^JFUnsignedIntegerBlock)(NSUInteger param);

// =================================================================================================
// MARK: Basic blocks (DEPRECATED)
// =================================================================================================

/**
 * A block of code to be executed with a parameter.
 * @param value A boolean value.
 * @deprecated Use 'JFBooleanBlock' instead."
 */
typedef void (^JFBlockWithBOOL)(BOOL value) DEPRECATED_MSG_ATTRIBUTE("Use 'JFBooleanBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param value A double value.
 * @deprecated Use 'JFDoubleBlock' instead."
 */
typedef void (^JFBlockWithDouble)(double value) DEPRECATED_MSG_ATTRIBUTE("Use 'JFDoubleBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param value A float value.
 * @deprecated Use 'JFFloatBlock' instead."
 */
typedef void (^JFBlockWithFloat)(float value) DEPRECATED_MSG_ATTRIBUTE("Use 'JFFloatBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param value An integer value.
 * @deprecated Use 'JFIntegerBlock' instead."
 */
typedef void (^JFBlockWithInteger)(NSInteger value) DEPRECATED_MSG_ATTRIBUTE("Use 'JFIntegerBlock' instead.");

// =================================================================================================
// MARK: Object blocks
// =================================================================================================

/**
 * A block of code to be executed with a parameter.
 * @param param A generic array object.
 */
typedef void (^JFArrayBlock)(NSArray* param);

/**
 * A block of code to be executed with a parameter.
 * @param param A data object.
 */
typedef void (^JFDataBlock)(NSData* param);

/**
 * A block of code to be executed with a parameter.
 * @param param A date object.
 */
typedef void (^JFDateBlock)(NSDate* param);

/**
 * A block of code to be executed with a parameter.
 * @param param A generic dictionary object.
 */
typedef void (^JFDictionaryBlock)(NSDictionary* param);

/**
 * A block of code to be executed with a parameter.
 * @param param An error object.
 */
typedef void (^JFErrorBlock)(NSError* param);

/**
 * A block of code to be executed with a parameter.
 * @param param An image object.
 */
#if JF_MACOS
typedef void (^JFImageBlock)(NSImage* param);
#else
typedef void (^JFImageBlock)(UIImage* param);
#endif

/**
 * A block of code to be executed with a parameter.
 * @param param A notification object.
 */
typedef void (^JFNotificationBlock)(NSNotification* param);

/**
 * A block of code to be executed with a parameter.
 * @param param A number object.
 */
typedef void (^JFNumberBlock)(NSNumber* param);

/**
 * A block of code to be executed with a parameter.
 * @param param A generic object.
 */
typedef void (^JFObjectBlock)(id param);

/**
 * A block of code to be executed with a parameter.
 * @param param A generic set object.
 */
typedef void (^JFSetBlock)(NSSet* param);

/**
 * A block of code to be executed with a parameter.
 * @param param A string object.
 */
typedef void (^JFStringBlock)(NSString* param);

/**
 * A block of code to be executed with a parameter.
 * @param param A value object.
 */
typedef void (^JFValueBlock)(NSValue* param);

// =================================================================================================
// MARK: Optional object blocks
// =================================================================================================

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A generic array object or `nil`.
 */
typedef void (^JFOptionalArrayBlock)(NSArray* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A data object or `nil`.
 */
typedef void (^JFOptionalDataBlock)(NSData* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A date object or `nil`.
 */
typedef void (^JFOptionalDateBlock)(NSDate* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A generic dictionary object or `nil`.
 */
typedef void (^JFOptionalDictionaryBlock)(NSDictionary* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param An error object or `nil`.
 */
typedef void (^JFOptionalErrorBlock)(NSError* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param An image object or `nil`.
 */
#if JF_MACOS
typedef void (^JFOptionalImageBlock)(NSImage* _Nullable param);
#else
typedef void (^JFOptionalImageBlock)(UIImage* _Nullable param);
#endif

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A notification object or `nil`.
 */
typedef void (^JFOptionalNotificationBlock)(NSNotification* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A number object or `nil`.
 */
typedef void (^JFOptionalNumberBlock)(NSNumber* _Nullable param);


/**
 * A block of code to be executed with a nullable parameter.
 * @param param A generic object or `nil`.
 */
typedef void (^JFOptionalObjectBlock)(id _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A generic set object or `nil`.
 */
typedef void (^JFOptionalSetBlock)(NSSet* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A string object or `nil`.
 */
typedef void (^JFOptionalStringBlock)(NSString* _Nullable param);

/**
 * A block of code to be executed with a nullable parameter.
 * @param param A value object or `nil`.
 */
typedef void (^JFOptionalValueBlock)(NSValue* _Nullable param);

// =================================================================================================
// MARK: Optional object blocks (DEPRECATED)
// =================================================================================================

/**
 * A block of code to be executed with a parameter.
 * @param array A generic array object.
 * @deprecated Use 'JFOptionalArrayBlock' instead."
 */
typedef void (^JFBlockWithArray)(NSArray* _Nullable array) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalArrayBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param data A data object.
 * @deprecated Use 'JFOptionalDataBlock' instead."
 */
typedef void (^JFBlockWithData)(NSData* _Nullable data) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalDataBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param date A date object.
 * @deprecated Use 'JFOptionalDateBlock' instead."
 */
typedef void (^JFBlockWithDate)(NSDate* _Nullable date) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalDateBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param dictionary A generic dictionary object.
 * @deprecated Use 'JFOptionalDictionaryBlock' instead."
 */
typedef void (^JFBlockWithDictionary)(NSDictionary* _Nullable dictionary) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalDictionaryBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param error An error object.
 * @deprecated Use 'JFOptionalErrorBlock' instead."
 */
typedef void (^JFBlockWithError)(NSError* _Nullable error) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalErrorBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param image An image object.
 * @deprecated Use 'JFOptionalImageBlock' instead."
 */
#if JF_MACOS
typedef void (^JFBlockWithImage)(NSImage* _Nullable image) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalImageBlock' instead.");
#else
typedef void (^JFBlockWithImage)(UIImage* _Nullable image) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalImageBlock' instead.");
#endif

/**
 * A block of code to be executed with a parameter.
 * @param notification A notification object.
 * @deprecated Use 'JFOptionalNotificationBlock' instead."
 */
typedef void (^JFBlockWithNotification)(NSNotification* _Nullable notification) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalNotificationBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param number A number object.
 * @deprecated Use 'JFOptionalNumberBlock' instead."
 */
typedef void (^JFBlockWithNumber)(NSNumber* _Nullable number) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalNumberBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param object A generic object.
 * @deprecated Use 'JFOptionalObjectBlock' instead."
 */
typedef void (^JFBlockWithObject)(__kindof id<NSObject> _Nullable object) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalObjectBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param set A generic set object.
 * @deprecated Use 'JFOptionalSetBlock' instead."
 */
typedef void (^JFBlockWithSet)(NSSet* _Nullable set) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalSetBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param string A string object.
 * @deprecated Use 'JFOptionalStringBlock' instead."
 */
typedef void (^JFBlockWithString)(NSString* _Nullable string) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalStringBlock' instead.");

/**
 * A block of code to be executed with a parameter.
 * @param value A value object.
 * @deprecated Use 'JFOptionalValueBlock' instead."
 */
typedef void (^JFBlockWithValue)(NSValue* _Nullable value) DEPRECATED_MSG_ATTRIBUTE("Use 'JFOptionalValueBlock' instead.");

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

