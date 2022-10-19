//
//	The MIT License (MIT)
//
//	Copyright © 2020-2022 Jacopo Filié
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

@import UIKit;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef UIImage* _Nullable (^JFImageLoader)(void);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * This wrapper is useful to decouple the places where the image is loaded and where it is used. Instead of loading the image and pass it through all the intermediary methods until the image is used, this wrapper can delay the loading of the image until it is really needed. Obviously, the source of the image may change in the meantime, so you must know what you're doing when choosing this behaviour. If the image has an associated thumbnail, you can also load it in the same way. Mind that unused loaded images will be removed from memory and reloaded next time the image is needed.
 */
@interface JFImageWrapper : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The stored image or `nil` if the image could not be loaded.
 */
@property (weak, nonatomic, readonly, nullable) UIImage* image;

/**
 * The block that will be used to load the image or `nil` if no image loader has been given during initialization.
 */
@property (strong, nonatomic, readonly, nullable) JFImageLoader imageLoader;

/**
 * The stored thumbnail or `nil` if the thumbnail could not be loaded.
 */
@property (weak, nonatomic, readonly, nullable) UIImage* thumbnail;

/**
 * The block that will be used to load the thumbnail or `nil` if no thumbnail loader has been given during initialization.
 */
@property (strong, nonatomic, readonly, nullable) JFImageLoader thumbnailLoader;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given image loaders.
 * @param imageLoader The block to use to load the image.
 * @param thumbnailLoader The block to use to load the thumbnail.
 * @return This instance.
 */
- (instancetype)initWithImageLoader:(JFImageLoader _Nullable)imageLoader thumbnailLoader:(JFImageLoader _Nullable)thumbnailLoader NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
