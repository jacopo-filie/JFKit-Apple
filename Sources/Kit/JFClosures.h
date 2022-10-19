//
//	The MIT License (MIT)
//
//	Copyright © 2015-2022 Jacopo Filié
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

#import "JFPreprocessorMacros.h"

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

#import "JFBlocks.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Basic blocks
// =================================================================================================

/**
 * An alias for a block of code to be executed when the operation has completed with a failure.
 */
typedef JFErrorBlock JFFailureBlock;

/**
 * A block of code to be executed when the operation has completed successfully.
 * @param result The result of the operation.
 */
typedef void (^JFSuccessBlock)(id result);

// =================================================================================================
// MARK: Closure blocks
// =================================================================================================

/**
 * A block of code to be executed when the operation has completed. Used in combination with the class `JFFailableClosure`.
 * @param succeeded `YES` if the completed operation succeeded, `NO` otherwise.
 * @param error The error of the failed completed operation; `nil` if the operation succeeded.
 */
typedef void (^JFFailableClosureBlock)(BOOL succeeded, NSError* _Nullable error);

/**
 * A block of code to be executed when the operation has completed. Used in combination with the class `JFFetchingClosure`.
 * @param succeeded `YES` if the completed operation succeeded, `NO` otherwise.
 * @param result The result of the succeeded completed operation; `nil` if the operation failed.
 * @param error The error of the failed completed operation; `nil` if the operation succeeded.
 */
typedef void (^JFFetchingClosureBlock)(BOOL succeeded, id _Nullable result, NSError* _Nullable error);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Protocols
// =================================================================================================

/**
 * An empty protocol, useful for marking closure objects, that can be used as parameter type when any closure type would be acceptable.
 */
@protocol JFClosure

/**
 * EMPTY
 */

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A wrapper for a plain `JFBlock` block with convenience methods to execute the block asynchronously, if needed.
 */
@interface JFClosure : NSObject <JFClosure>

// =================================================================================================
// MARK: Properties
// =================================================================================================

/**
 * The block used to initialize this instance.
 */
@property (strong, nonatomic, readonly) JFBlock block;

// =================================================================================================
// MARK: Lifetime
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * A convenient constructor that initializes a new instance of this class using the given block.
 * @param block The block to use.
 * @return A new instance of this class.
 */
+ (instancetype)newWithBlock:(JFBlock)block;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given block.
 * @param block The block to use.
 * @return This instance.
 */
- (instancetype)initWithBlock:(JFBlock)block NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods
// =================================================================================================

/**
 * Synchronously executes the wrapped block.
 */
- (void)execute;

/**
 * Executes the wrapped block.
 * @param async `YES` if the block should be executed asynchronously, `NO` otherwise.
 */
- (void)executeAsync:(BOOL)async;

/**
 * Executes the wrapped block.
 * @param queue The queue to use to execute the block.
 */
- (void)executeOnQueue:(NSOperationQueue*)queue;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A wrapper for the `JFFailableClosureBlock` block with convenience methods to execute the block asynchronously, if needed.
 */
@interface JFFailableClosure : NSObject <JFClosure>

// =================================================================================================
// MARK: Properties
// =================================================================================================

/**
 * The block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) JFFailableClosureBlock block;

/**
 * The failure block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) JFFailureBlock failureBlock;

/**
 * The finally block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) JFBlock finallyBlock;

/**
 * The success block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) JFBlock successBlock;

// =================================================================================================
// MARK: Lifetime
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * A convenient constructor that initializes a new instance of this class using the given block.
 * @param block The block to use.
 * @return A new instance of this class.
 */
+ (instancetype)newWithBlock:(JFFailableClosureBlock)block;

/**
 * A convenient constructor that initializes a new instance of this class with the given failure block.
 * @param failureBlock The block to use on failure.
 * @return A new instance of this class.
 */
+ (instancetype)newWithFailureBlock:(JFFailureBlock)failureBlock;

/**
 * A convenient constructor that initializes a new instance of this class with the given success block.
 * @param successBlock The block to use on success.
 * @return A new instance of this class.
 */
+ (instancetype)newWithSuccessBlock:(JFBlock)successBlock;

/**
 * A convenient constructor that initializes a new instance of this class with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @return A new instance of this class.
 */
+ (instancetype)newWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock;

/**
 * A convenient constructor that initializes a new instance of this class with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @param finallyBlock The block to execute at the end, in any case.
 * @return A new instance of this class.
 */
+ (instancetype)newWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given block.
 * @param block The block to use.
 * @return This instance.
 */
- (instancetype)initWithBlock:(JFFailableClosureBlock)block NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with the given failure block.
 * @param failureBlock The block to use on failure.
 * @return This instance.
 */
- (instancetype)initWithFailureBlock:(JFFailureBlock)failureBlock NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with the given success block.
 * @param successBlock The block to use on success.
 * @return This instance.
 */
- (instancetype)initWithSuccessBlock:(JFBlock)successBlock NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @return This instance.
 */
- (instancetype)initWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @param finallyBlock The block to execute at the end, in any case.
 * @return This instance.
 */
- (instancetype)initWithSuccessBlock:(JFBlock)successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods
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
- (void)executeAsync:(BOOL)async;

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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A wrapper for the `JFFetchingClosureBlock` block with support for type generics and convenience methods to execute the block asynchronously, if needed.
 * `ResultType` defines the type of the parameter `result` of the wrapped `JFFetchingClosureBlock` block.
 */
@interface JFFetchingClosure<__covariant ResultType> : NSObject <JFClosure>

// =================================================================================================
// MARK: Properties
// =================================================================================================

/**
 * The block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) void (^block)(BOOL succeeded, ResultType _Nullable result, NSError* _Nullable error);

/**
 * The failure block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) JFFailureBlock failureBlock;

/**
 * The finally block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) JFBlock finallyBlock;

/**
 * The success block used to initialize this instance.
 */
@property (strong, nonatomic, readonly, nullable) void (^successBlock)(ResultType result);

// =================================================================================================
// MARK: Lifetime
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * A convenient constructor that initializes a new instance of this class with the given block.
 * @param block The block to use.
 * @return A new instance of this class.
 */
+ (instancetype)newWithBlock:(void (^)(BOOL succeeded, ResultType _Nullable result, NSError* _Nullable error))block;

/**
 * A convenient constructor that initializes a new instance of this class with the given failure block.
 * @param failureBlock The block to use on failure.
 * @return A new instance of this class.
 */
+ (instancetype)newWithFailureBlock:(JFFailureBlock)failureBlock;

/**
 * A convenient constructor that initializes a new instance of this class with the given success block.
 * @param successBlock The block to use on success.
 * @return A new instance of this class.
 */
+ (instancetype)newWithSuccessBlock:(void (^)(ResultType result))successBlock;

/**
 * A convenient constructor that initializes a new instance of this class with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @return A new instance of this class.
 */
+ (instancetype)newWithSuccessBlock:(void (^)(ResultType result))successBlock failureBlock:(JFFailureBlock)failureBlock;

/**
 * A convenient constructor that initializes a new instance of this class with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @param finallyBlock The block to execute at the end, in any case.
 * @return A new instance of this class.
 */
+ (instancetype)newWithSuccessBlock:(void (^)(ResultType result))successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given block.
 * @param block The block to use.
 * @return This instance.
 */
- (instancetype)initWithBlock:(void (^)(BOOL succeeded, ResultType _Nullable result, NSError* _Nullable error))block NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with the given failure block.
 * @param failureBlock The block to use on failure.
 * @return This instance.
 */
- (instancetype)initWithFailureBlock:(JFFailureBlock)failureBlock NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with the given success block.
 * @param successBlock The block to use on success.
 * @return This instance.
 */
- (instancetype)initWithSuccessBlock:(void (^)(ResultType result))successBlock NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @return This instance.
 */
- (instancetype)initWithSuccessBlock:(void (^)(ResultType result))successBlock failureBlock:(JFFailureBlock)failureBlock NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this instance with both the given success and failure blocks.
 * @param successBlock The block to use on success.
 * @param failureBlock The block to use on failure.
 * @param finallyBlock The block to execute at the end, in any case.
 * @return This instance.
 */
- (instancetype)initWithSuccessBlock:(void (^)(ResultType result))successBlock failureBlock:(JFFailureBlock)failureBlock finallyBlock:(JFBlock)finallyBlock NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
