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

#import "JFBlocks.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Constants
// =================================================================================================

/**
 * A constant that represents the usual duration of system animations.
 */
FOUNDATION_EXPORT NSTimeInterval const JFAnimationDuration;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Macros
// =================================================================================================

/**
 * Checks whether the given `_optionMask` contains the given `_option`.
 * @param _optionMask The bitmask containing all the selected options.
 * @param _option The option to search in the bitmask.
 */
#define JFIsOptionSet(_optionMask, _option) ((_optionMask & _option) == _option)

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Functions - Comparison
// =================================================================================================

/**
 * Compares two objects and returns whether they are equal or not.
 * @param obj1 The first object to compare.
 * @param obj2 The second object to compare.
 * @return `YES` if the given objects are equal, `NO` otherwise. If both objects are `nil`, it returns `YES`.
 */
FOUNDATION_EXPORT BOOL JFAreObjectsEqual(id<NSObject> __nullable obj1, id<NSObject> __nullable obj2);

// =================================================================================================
// MARK: Functions - Resources
// =================================================================================================

/**
 * Returns the object paired with the given key in the `Info.plist` file.
 * @param key The key of the pair.
 * @return The object paired with the given key in the `Info.plist` file.
 */
FOUNDATION_EXPORT id __nullable JFApplicationInfoForKey(NSString* key);

/**
 * Returns the first URL found in the given bundle for the given filename.
 * @param bundle The bundle to scan.
 * @param filename The filename to search for.
 * @return the first URL found in the given bundle for the given filename.
 */
FOUNDATION_EXPORT NSURL* __nullable JFBundleResourceURLForFile(NSBundle* bundle, NSString* __nullable filename);

/**
 * Returns the first URL found in the given bundle for the given filename and type.
 * @param bundle The bundle to scan.
 * @param filename The filename to search for.
 * @param type The type of file to search for.
 * @return the first URL found in the given bundle for the given filename and type.
 */
FOUNDATION_EXPORT NSURL* __nullable JFBundleResourceURLForFileWithExtension(NSBundle* bundle, NSString* __nullable filename, NSString* __nullable type);

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
FOUNDATION_EXPORT void JFPerformSelector1(NSObject* target, SEL action, id __nullable object);

/**
 * Performs the given action on the given target.
 * @param target The object that can respond to the requested action.
 * @param action The action to perform.
 * @param obj1 An object to pass to the action as the first parameter.
 * @param obj2 An object to pass to the action as the second parameter.
 */
FOUNDATION_EXPORT void JFPerformSelector2(NSObject* target, SEL action, id __nullable obj1, id __nullable obj2);

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
