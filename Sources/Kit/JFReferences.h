//
//	The MIT License (MIT)
//
//	Copyright © 2016-2022 Jacopo Filié
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

@import Foundation;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#if JF_IOS
/**
 * A soft reference is a wrapper that holds in memory the contained object until a memory warning is fired from the operating system. When a memory warning is fired, the soft reference tries to hold a weak reference (if available) to the wrapped object until the next access to the property `object`, in which the strong reference is restored if the weak reference is still valid. `ObjectType` is the type of object that the reference can wrap.
 */
@interface JFSoftReference<__covariant ObjectType> : NSObject <NSCopying>

// =================================================================================================
// MARK: Properties - Memory
// =================================================================================================

/**
 * The wrapped object.
 */
@property (strong, nullable) ObjectType object;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Creates a new soft reference with the given object.
 * @param object The object to wrap.
 * @return A new soft reference containing the given object.
 */
+ (instancetype)referenceWithObject:(ObjectType _Nullable)object;

@end
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A weak reference is a wrapper that weakly holds in memory the contained object. If the wrapped object is released, the property `object` is automatically reset. `ObjectType` is the type of object that the reference can wrap.
 */
@interface JFWeakReference<__covariant ObjectType> : NSObject <NSCopying>

// =================================================================================================
// MARK: Properties - Memory
// =================================================================================================

/**
 * The wrapped object.
 */
@property (weak, nonatomic, nullable) ObjectType object;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Creates a new weak reference with the given object.
 * @param object The object to wrap.
 * @return A new weak reference containing the given object.
 */
+ (instancetype)referenceWithObject:(ObjectType _Nullable)object;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

