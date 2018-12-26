//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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
typedef void (^JFBlockWithArray) (NSArray* array);

/**
 * A block of code to be executed with a parameter.
 * @param value A boolean value.
 */
typedef void (^JFBlockWithBOOL) (BOOL value);

/**
 * A block of code to be executed with a parameter.
 * @param data A data object.
 */
typedef void (^JFBlockWithData) (NSData* data);

/**
 * A block of code to be executed with a parameter.
 * @param date A date object.
 */
typedef void (^JFBlockWithDate) (NSDate* date);

/**
 * A block of code to be executed with a parameter.
 * @param dictionary A generic dictionary object.
 */
typedef void (^JFBlockWithDictionary) (NSDictionary* dictionary);

/**
 * A block of code to be executed with a parameter.
 * @param value A double value.
 */
typedef void (^JFBlockWithDouble) (double value);

/**
 * A block of code to be executed with a parameter.
 * @param error An error object.
 */
typedef void (^JFBlockWithError) (NSError* error);

/**
 * A block of code to be executed with a parameter.
 * @param value A float value.
 */
typedef void (^JFBlockWithFloat) (float value);

/**
 * A block of code to be executed with a parameter.
 * @param image An image object.
 */
typedef void (^JFBlockWithImage) (JFImage* image);

/**
 * A block of code to be executed with a parameter.
 * @param value An integer value.
 */
typedef void (^JFBlockWithInteger) (NSInteger value);

/**
 * A block of code to be executed with a parameter.
 * @param notification A notification object.
 */
typedef void (^JFBlockWithNotification) (NSNotification* notification);

/**
 * A block of code to be executed with a parameter.
 * @param number A number object.
 */
typedef void (^JFBlockWithNumber) (NSNumber* number);

/**
 * A block of code to be executed with a parameter.
 * @param object A generic object.
 */
typedef void (^JFBlockWithObject) (id<NSObject> object);

/**
 * A block of code to be executed with a parameter.
 * @param set A generic set object.
 */
typedef void (^JFBlockWithSet) (NSSet* set);

/**
 * A block of code to be executed with a parameter.
 * @param string A string object.
 */
typedef void (^JFBlockWithString) (NSString* string);

/**
 * A block of code to be executed with a parameter.
 * @param value A value object.
 */
typedef void (^JFBlockWithValue) (NSValue* value);

/**
 * A block of code to be executed as completion of an operation. Used in combination with the class `JFCompletion`.
 * @param succeeded `YES` if the completed operation succeeded, `NO` otherwise.
 * @param result The result of the succeeded completed operation; `nil` if the operation failed.
 * @param error The error of the failed completed operation; `nil` if the operation succeeded.
 */
typedef void (^JFCompletionBlock) (BOOL succeeded, id __nullable result, NSError* __nullable error);

/**
 * A block of code to be executed as completion of an operation. Used in combination with the class `JFSimpleCompletion`.
 * @param succeeded `YES` if the completed operation succeeded, `NO` otherwise.
 * @param error The error of the failed completed operation; `nil` if the operation succeeded.
 */
typedef void (^JFSimpleCompletionBlock) (BOOL succeeded, NSError* __nullable error);

/**
 * A block of code to be executed when a timer fires. Used in combination with the class `JFTimerHandler`.
 * @param timer The timer that fired.
 */
typedef void (^JFTimerHandlerBlock) (NSTimer* timer);

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * A wrapper for the `JFCompletionBlock` block with support for type generics and convenience methods to execute the block asynchronously, if needed.
 * `ResultType` defines the type of the parameter `result` of the wrapped `JFCompletionBlock` block.
 */
@interface JFCompletion<__covariant ResultType> : NSObject

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

/**
 * The block used to initialize this instance.
 */
@property (strong, nonatomic, readonly) void (^block)(BOOL succeeded, ResultType __nullable result, NSError* __nullable error);

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

/**
 * A convenient constructor that initializes a new instance of this class with the given block.
 * @param block The block to use.
 * @return A new instance of this class.
 */
+ (instancetype)completionWithBlock:(void (^)(BOOL succeeded, ResultType __nullable result, NSError* __nullable error))block;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given block.
 * @param block The block to use.
 * @return This instance.
 */
- (instancetype)initWithBlock:(void (^)(BOOL succeeded, ResultType __nullable result, NSError* __nullable error))block NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

/**
 * Synchronously executes the wrapped block using the following values:
 * @code
 *   `succeeded` = NO;
 *   `result`    = nil;
 *   `error`     = error;
 * @endcode
 * @param error The failure reason of the completed operation.
 */
- (void)executeWithError:(NSError*)error;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = NO;
 *   `result`    = nil;
 *   `error`     = error;
 * @endcode
 * @param error The failure reason of the completed operation.
 * @param async `YES` if the block should be executed asynchronously, `NO` otherwise.
 */
- (void)executeWithError:(NSError*)error async:(BOOL)async;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = NO;
 *   `result`    = nil;
 *   `error`     = error;
 * @endcode
 * @param error The failure reason of the completed operation.
 * @param queue The queue to use to execute the block.
 */
- (void)executeWithError:(NSError*)error queue:(NSOperationQueue*)queue;

/**
 * Synchronously executes the wrapped block using the following values:
 * @code
 *   `succeeded` = YES;
 *   `result`    = result;
 *   `error`     = nil;
 * @endcode
 * @param result The result object of the completed operation.
 */
- (void)executeWithResult:(ResultType)result;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = YES;
 *   `result`    = result;
 *   `error`     = nil;
 * @endcode
 * @param result The result object of the completed operation.
 * @param async `YES` if the block should be executed asynchronously, `NO` otherwise.
 */
- (void)executeWithResult:(ResultType)result async:(BOOL)async;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = YES;
 *   `result`    = result;
 *   `error`     = nil;
 * @endcode
 * @param result The result object of the completed operation.
 * @param queue The queue to use to execute the block.
 */
- (void)executeWithResult:(ResultType)result queue:(NSOperationQueue*)queue;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * A wrapper for the `JFSimpleCompletionBlock` block with convenience methods to execute the block asynchronously, if needed.
 */
@interface JFSimpleCompletion : NSObject

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

/**
 * The block used to initialize this instance.
 */
@property (strong, nonatomic, readonly) JFSimpleCompletionBlock block;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

/**
 * A convenient constructor that initializes a new instance of this class using the given block.
 * @param block The block to use.
 * @return A new instance of this class.
 */
+ (instancetype)completionWithBlock:(JFSimpleCompletionBlock)block;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given block.
 * @param block The block to use.
 * @return This instance.
 */
- (instancetype)initWithBlock:(JFSimpleCompletionBlock)block NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

/**
 * Synchronously executes the wrapped block using the following values:
 * @code
 *   `succeeded` = YES;
 *   `error`     = nil;
 * @endcode
 */
- (void)execute;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = YES;
 *   `error`     = nil;
 * @endcode
 * @param async `YES` if the block should be executed asynchronously, `NO` otherwise.
 */
- (void)execute:(BOOL)async;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = YES;
 *   `error`     = nil;
 * @endcode
 * @param queue The queue to use to execute the block.
 */
- (void)executeOnQueue:(NSOperationQueue*)queue;

/**
 * Synchronously executes the wrapped block using the following values:
 * @code
 *   `succeeded` = NO;
 *   `error`     = error;
 * @endcode
 * @param error The failure reason of the completed operation.
 */
- (void)executeWithError:(NSError*)error;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = NO;
 *   `error`     = error;
 * @endcode
 * @param error The failure reason of the completed operation.
 * @param async `YES` if the block should be executed asynchronously, `NO` otherwise.
 */
- (void)executeWithError:(NSError*)error async:(BOOL)async;

/**
 * Executes the wrapped block using the following values:
 * @code
 *   `succeeded` = NO;
 *   `error`     = error;
 * @endcode
 * @param error The failure reason of the completed operation.
 * @param queue The queue to use to execute the block.
 */
- (void)executeWithError:(NSError*)error queue:(NSOperationQueue*)queue;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * An handler that can be passed to instances of the class `NSTimer` that wraps a block to execute when that timer fires. This class is useful to prevent the timer from keeping a strong reference to the object that owns the timer itself (a timer keeps a strong reference to the object that should respond to the fire event until the timer itself is invalidated).
 */
@interface JFTimerHandler : NSObject

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

/**
 * The block used to initialize this instance.
 */
@property (strong, nonatomic, readonly) JFTimerHandlerBlock block;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

/**
 * A convenient constructor that initializes a new instance of this class using the given block.
 * @param block The block to use.
 * @return A new instance of this class.
 */
+ (instancetype)handlerWithBlock:(JFTimerHandlerBlock)block;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given block.
 * @param block The block to use.
 * @return This instance.
 */
- (instancetype)initWithBlock:(JFTimerHandlerBlock)block NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

/**
 * Called when the timer this instance is assigned to fires.
 * @param timer The timer that fired.
 */
- (void)timerDidFire:(NSTimer*)timer;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

