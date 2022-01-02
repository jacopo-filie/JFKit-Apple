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

#import "JFImageWrapper.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFImageWrapper (/* Private */)

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (UIImage* _Nullable)loadImage:(JFImageLoader _Nullable)loader;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFImageWrapper

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize image = _image;
@synthesize imageLoader = _imageLoader;
@synthesize thumbnail = _thumbnail;
@synthesize thumbnailLoader = _thumbnailLoader;

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

- (UIImage* _Nullable)image
{
	UIImage* retObj = _image;
	if(!retObj)
	{
		@synchronized(self)
		{
			retObj = _image;
			if(!retObj)
			{
				retObj = [JFImageWrapper loadImage:self.imageLoader];
				_image = retObj;
			}
		}
	}
	return retObj;
}

- (UIImage* _Nullable)thumbnail
{
	UIImage* retObj = _thumbnail;
	if(!retObj)
	{
		@synchronized(self)
		{
			retObj = _thumbnail;
			if(!retObj)
			{
				retObj = [JFImageWrapper loadImage:self.thumbnailLoader];
				_thumbnail = retObj;
			}
		}
	}
	return retObj;
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithImageLoader:(JFImageLoader _Nullable)imageLoader thumbnailLoader:(JFImageLoader _Nullable)thumbnailLoader
{
	self = [super init];
	
	_imageLoader = imageLoader;
	_thumbnailLoader = thumbnailLoader;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (UIImage* _Nullable)loadImage:(JFImageLoader _Nullable)loader
{
	return (loader ? loader() : nil);
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
