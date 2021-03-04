//
//	The MIT License (MIT)
//
//	Copyright © 2015-2021 Jacopo Filié
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

@import UIKit;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A simple view that uses a gradient layer instead of the default one.
 */
IB_DESIGNABLE
@interface JFGradientView : UIView

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The end point of the gradient layer.
 */
@property (assign, nonatomic) IBInspectable CGPoint endPoint;

/**
 * The first color used for the gradient.
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor* firstColor;

/**
 * The last color used for the gradient.
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor* lastColor;

/**
 * The start point of the gradient layer.
 */
@property (assign, nonatomic) IBInspectable CGPoint startPoint;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
