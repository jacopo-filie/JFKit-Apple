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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#import "JFGradientView.h"

@import JFKit;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFGradientView (/* Private */)

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (void)initializeProperties:(JFGradientView*)object;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFGradientView

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize endPoint = _endPoint;
@synthesize firstColor = _firstColor;
@synthesize lastColor = _lastColor;
@synthesize startPoint = _startPoint;

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

- (void)setEndPoint:(CGPoint)endPoint
{
	endPoint.x = MAX(0.0f, MIN(1.0f, endPoint.x));
	endPoint.y = MAX(0.0f, MIN(1.0f, endPoint.y));
	if(CGPointEqualToPoint(_endPoint, endPoint))
		return;
	
	_endPoint = endPoint;
	
	[self updateGradientLayer];
}

- (void)setFirstColor:(UIColor* __nullable)firstColor
{
	if(JFAreObjectsEqual(_firstColor, firstColor))
		return;
	
	_firstColor = firstColor;
	
	[self updateGradientLayer];
}

- (void)setLastColor:(UIColor* __nullable)lastColor
{
	if(JFAreObjectsEqual(_lastColor, lastColor))
		return;
	
	_lastColor = lastColor;
	
	[self updateGradientLayer];
}

- (void)setStartPoint:(CGPoint)startPoint
{
	startPoint.x = MAX(0.0f, MIN(1.0f, startPoint.x));
	startPoint.y = MAX(0.0f, MIN(1.0f, startPoint.y));
	if(CGPointEqualToPoint(_startPoint, startPoint))
		return;
	
	_startPoint = startPoint;
	
	[self updateGradientLayer];
}

// =================================================================================================
// MARK: Properties (Accessors) - User interface
// =================================================================================================

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (void)initializeProperties:(JFGradientView*)object
{
	object->_endPoint = CGPointMake(0.5, 1.0);
	object->_startPoint = CGPointMake(0.5, 0.0);
	
	[object updateGradientLayer];
}

- (instancetype __nullable)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[JFGradientView initializeProperties:self];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	[JFGradientView initializeProperties:self];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

- (void)updateGradientLayer
{
	UIColor* defaultColor = (self.backgroundColor ?: ([self isOpaque] ? [UIColor whiteColor] : [UIColor clearColor]));
	
	UIColor* firstColor = (self.firstColor ?: defaultColor);
	UIColor* lastColor = (self.lastColor ?: defaultColor);
	
	CAGradientLayer* layer = (CAGradientLayer*)self.layer;
	layer.colors = @[(id)firstColor.CGColor, (id)lastColor.CGColor];
	layer.startPoint = self.startPoint;
	layer.endPoint = self.endPoint;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
