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

@import Foundation;

#import "JFBlocks.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Constants
// =================================================================================================

/**
 * A constant that represents the usual duration of system animations.
 */
FOUNDATION_EXPORT NSTimeInterval const JFAnimationDuration;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Macros
// =================================================================================================

/**
 * Checks whether the given `_optionMask` contains the given `_option`.
 * @param _optionMask The bitmask containing all the selected options.
 * @param _option The option to search in the bitmask.
 */
#define JFIsOptionSet(_optionMask, _option) ((_optionMask & _option) == _option)

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Functions - Comparison
// =================================================================================================

/**
 * Compares two objects and returns whether they are equal or not.
 * @param obj1 The first object to compare.
 * @param obj2 The second object to compare.
 * @return `YES` if the given objects are equal, `NO` otherwise. If both objects are `nil`, it returns `YES`.
 */
FOUNDATION_EXPORT BOOL JFAreObjectsEqual(id<NSObject> _Nullable obj1, id<NSObject> _Nullable obj2);

// =================================================================================================
// MARK: Functions - Operation queues
// =================================================================================================

/**
 * Creates an operation queue with the given `name` and the default maximum number of concurrent operations.
 * @param name The name of the queue.
 * @return An initialized operation queue.
 */
FOUNDATION_EXPORT NSOperationQueue* JFCreateConcurrentOperationQueue(NSString* _Nullable name);

/**
 * Creates an operation queue with the given `name` and limits the maximum number of concurrent operations to `1`.
 * @param name The name of the queue.
 * @return An initialized operation queue.
 */
FOUNDATION_EXPORT NSOperationQueue* JFCreateSerialOperationQueue(NSString* _Nullable name);

// =================================================================================================
// MARK: Functions - Resources
// =================================================================================================

/**
 * Returns the object paired with the given key in the `Info.plist` file.
 * @param key The key of the pair.
 * @return The object paired with the given key in the `Info.plist` file.
 */
FOUNDATION_EXPORT id _Nullable JFApplicationInfoForKey(NSString* key);

/**
 * Returns the first URL found in the given bundle for the given filename.
 * @param bundle The bundle to scan.
 * @param filename The filename to search for.
 * @return the first URL found in the given bundle for the given filename.
 */
FOUNDATION_EXPORT NSURL* _Nullable JFBundleResourceURLForFile(NSBundle* bundle, NSString* _Nullable filename);

/**
 * Returns the first URL found in the given bundle for the given filename and type.
 * @param bundle The bundle to scan.
 * @param filename The filename to search for.
 * @param type The type of file to search for.
 * @return the first URL found in the given bundle for the given filename and type.
 */
FOUNDATION_EXPORT NSURL* _Nullable JFBundleResourceURLForFileWithExtension(NSBundle* bundle, NSString* _Nullable filename, NSString* _Nullable type);

// =================================================================================================
// MARK: Functions - Runtime
// =================================================================================================

/**
 * Performs the given block on the main thread. If the current thread is the main thread, the block is executed synchronously.
 * @param block The block to execute.
 */
FOUNDATION_EXPORT void JFPerformOnMainThread(JFBlock block);

/**
 * Performs the given block on the main thread and waits until it is finished.
 * @param block The block to execute.
 */
FOUNDATION_EXPORT void JFPerformOnMainThreadAndWait(JFBlock block);

/**
 * Performs the given action on the given target.
 * @param target The object that can respond to the requested action.
 * @param action The action to perform.
 */
FOUNDATION_EXPORT void JFPerformSelector(NSObject* target, SEL action);

/**
 * Performs the given action on the given target.
 * @param target The object that can respond to the requested action.
 * @param action The action to perform.
 * @param object An object to pass to the action as the first parameter.
 */
FOUNDATION_EXPORT void JFPerformSelector1(NSObject* target, SEL action, id _Nullable object);

/**
 * Performs the given action on the given target.
 * @param target The object that can respond to the requested action.
 * @param action The action to perform.
 * @param obj1 An object to pass to the action as the first parameter.
 * @param obj2 An object to pass to the action as the second parameter.
 */
FOUNDATION_EXPORT void JFPerformSelector2(NSObject* target, SEL action, id _Nullable obj1, id _Nullable obj2);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
