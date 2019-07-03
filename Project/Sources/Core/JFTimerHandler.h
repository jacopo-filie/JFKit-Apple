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

@import Foundation;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * A block of code to be executed when a timer fires. Used in combination with the class `JFTimerHandler`.
 * @param timer The timer that fired.
 */
typedef void (^JFTimerHandlerBlock) (NSTimer* timer);

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
// MARK: Methods - Memory
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
+ (instancetype)new NS_UNAVAILABLE;

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
// MARK: Methods - Execution
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

