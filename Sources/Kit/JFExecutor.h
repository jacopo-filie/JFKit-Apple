//
//	The MIT License (MIT)
//
//	Copyright © 2019-2022 Jacopo Filié
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

#import <JFKit/JFCompletions.h>
#import <JFKit/JFPreprocessorMacros.h>

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Macros
// =================================================================================================

/**
 * A convenient macro that represents a block used as a `JFExecutor` method parameter type.
 */
#define JFExecutorBlockParameter void (^)(OwnerType owner)

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * An executor can be used to garantee existence of the owner object when the enqueued blocks are executed.
 * `OwnerType` defines the type of the parameter `owner` of the executor block.
 */
@interface JFExecutor<__covariant OwnerType> : NSObject

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

#if JF_WEAK_ENABLED
/**
 * The owner of the executor.
 */
@property (weak, nonatomic, readonly, nullable) OwnerType owner;
#else
/**
 * The owner of the executor.
 * @warning Remember to use `-clearOwner` to unset the owner when it is not available anymore because it may become a dangling pointer otherwise.
 */
@property (unsafe_unretained, nonatomic, readonly, nullable) OwnerType owner;
#endif

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the executor with the given owner; a private background queue will be used to enqueue blocks.
 * @param owner The owner of the executor.
 * @return The initialized executor.
 */
- (instancetype)initWithOwner:(OwnerType)owner;

/**
 * Initializes the executor with the given owner and queue.
 * @param owner The owner of the executor.
 * @param queue The queue that will be used by the executor.
 * @return The initialized executor.
 */
- (instancetype)initWithOwner:(OwnerType)owner queue:(NSOperationQueue*)queue NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

/**
 * Cancels all enqueued blocks and unsets the owner of the executor.
 * @warning On systems where the `weak` keyword is not available, you can use this method to prevent the risk of a dangling pointer creation.
 */
- (void)clearOwner;

// =================================================================================================
// MARK: Methods - Service
// =================================================================================================

/**
 * Cancels all currently enqueued blocks calling the `failureBlock` of each request, when available.
 */
- (void)cancelEnqueuedBlocks;

/**
 * Enqueues the given executor block; `block` will not be executed in case of internal error.
 * @param block The block to enqueue.
 */
- (void)enqueue:(JFExecutorBlockParameter)block;

/**
 * Enqueues the given executor block; `failureBlock` will be executed instead of `block` in case of internal error.
 * @param block The block to enqueue.
 * @param failureBlock The block to execute in case of internal error.
 */
- (void)enqueue:(JFExecutorBlockParameter)block failureBlock:(JFFailureBlock _Nullable)failureBlock;

/**
 * Enqueues the given executor block; `failureBlock` will be executed instead of `block` in case of internal error.
 * @param block The block to enqueue.
 * @param failureBlock The block to execute in case of internal error.
 * @param waitUntilFinished `YES` if the calling thread should wait until `block` or `failureBlock` are executed, `NO` otherwise.
 */
- (void)enqueue:(JFExecutorBlockParameter)block failureBlock:(JFFailureBlock _Nullable)failureBlock waitUntilFinished:(BOOL)waitUntilFinished;

/**
 * Enqueues the given executor block; `block` will not be executed in case of internal error.
 * @param block The block to enqueue.
 * @param waitUntilFinished `YES` if the calling thread should wait until `block` is executed, `NO` otherwise.
 */
- (void)enqueue:(JFExecutorBlockParameter)block waitUntilFinished:(BOOL)waitUntilFinished;

/**
 * Executes the given executor block as soon as possible; `block` will not be executed in case of internal error.
 * @param block The block to execute or enqueue.
 * @warning If the current thread queue is not the internal executor queue, `block` will be enqueued on the internal executor queue.
 */
- (void)execute:(JFExecutorBlockParameter)block;

/**
 * Executes the given executor block as soon as possible; `failureBlock` will be executed instead of `block` in case of internal error.
 * @param block The block to execute or enqueue.
 * @param failureBlock The block to execute in case of internal error.
 * @warning If the current thread queue is not the internal executor queue, `block` will be enqueued on the internal executor queue.
 */
- (void)execute:(JFExecutorBlockParameter)block failureBlock:(JFFailureBlock _Nullable)failureBlock;

/**
 * Executes the given executor block as soon as possible; `failureBlock` will be executed instead of `block` in case of internal error.
 * @param block The block to execute or enqueue.
 * @param failureBlock The block to execute in case of internal error.
 * @param waitUntilFinished `YES` if the calling thread should wait until `block` or `failureBlock` are executed, `NO` otherwise.
 * @warning If the current thread queue is not the internal executor queue, `block` will be enqueued on the internal executor queue.
 */
- (void)execute:(JFExecutorBlockParameter)block failureBlock:(JFFailureBlock _Nullable)failureBlock waitUntilFinished:(BOOL)waitUntilFinished;

/**
 * Executes the given executor block as soon as possible; `block` will not be executed in case of internal error.
 * @param block The block to execute or enqueue.
 * @param waitUntilFinished `YES` if the calling thread should wait until `block` is executed, `NO` otherwise.
 * @warning If the current thread queue is not the internal executor queue, `block` will be enqueued on the internal executor queue.
 */
- (void)execute:(JFExecutorBlockParameter)block waitUntilFinished:(BOOL)waitUntilFinished;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
