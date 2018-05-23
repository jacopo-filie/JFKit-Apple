//
//	The MIT License (MIT)
//
//	Copyright © 2017-2018 Jacopo Filié
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

/**
 * The `JFObserversController` manages the observers of its owner and dispatches notifications to them in many ways.
 * `ObserverType` defines the type of the object that is observing the owner and is expected to handle the dispatched notifications.
 * @warning On systems where the `weak` keyword is not available, to prevent the risk of a dangling pointer creation you must manually remove any observer before it gets deallocated.
 */
@interface JFObserversController<__covariant ObserverType> : NSObject

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

/**
 * The number of registered observers.
 */
@property (assign, readonly) NSUInteger count;

// =================================================================================================
// MARK: Methods - Notifications management
// =================================================================================================

/**
 * Asynchronously dispatch a notification block to each registered observer. Same as calling `-notifyObservers:async:` passing `YES` for the parameter `async`.
 * @param notificationBlock The notification block to execute against each registered observer.
 */
- (void)notifyObservers:(void(^)(ObserverType observer))notificationBlock;

/**
 * Dispatch a notification block to each registered observer.
 * @param notificationBlock The notification block to execute against each registered observer.
 * @param async `YES` if the block should be executed asynchronously, `NO` otherwise.
 */
- (void)notifyObservers:(void(^)(ObserverType observer))notificationBlock async:(BOOL)async;

/**
 * Dispatch a notification block to each registered observer.
 * @param notificationBlock The notification block to execute against each registered observer.
 * @param queue The queue to use to execute the notification block.
 * @param waitUntilFinished `YES` if the calling thread should wait until the operation is finished, `NO` otherwise.
 * @warning Calling this method passing `YES` to the parameter `waitUntilFinished` from the same queue passed to the parameter `queue` can block the thread endlessly.
 */
- (void)notifyObservers:(void(^)(ObserverType observer))notificationBlock queue:(NSOperationQueue*)queue waitUntilFinished:(BOOL)waitUntilFinished;

// =================================================================================================
// MARK: Methods - Observers management
// =================================================================================================

/**
 * Registers the given observer. If the given observer is already registered, it does nothing.
 * @param observer The observer to register.
 */
- (void)addObserver:(ObserverType)observer;

/**
 * Unregisters the given observer. If the given observer is not registered, it does nothing.
 * @param observer The observer to unregister.
 */
- (void)removeObserver:(ObserverType)observer;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
