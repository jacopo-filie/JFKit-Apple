//
//	The MIT License (MIT)
//
//	Copyright © 2017-2019 Jacopo Filié
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

#import "JFMath.h"

#import "JFStrings.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Functions - Floating points
// =================================================================================================

NSComparisonResult JFCompareFloatValues(double value1, double value2, short scale)
{
	NSInteger int1 = (NSInteger)trunc(value1);
	NSInteger int2 = (NSInteger)trunc(value2);
	
	if(int1 != int2)
		return ((int1 > int2) ? NSOrderedDescending : NSOrderedAscending);
	
	if(scale == 0)
		return NSOrderedSame;
	
	NSDecimalNumber* dec1 = [[NSDecimalNumber alloc] initWithDouble:value1];
	NSDecimalNumber* dec2 = [[NSDecimalNumber alloc] initWithDouble:value2];
	
	if(scale != NSDecimalNoScale)
	{
		NSRoundingMode mode = (int1 < 0) ? NSRoundUp : NSRoundDown;
		NSDecimalNumberHandler* handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:scale raiseOnExactness:YES raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
		dec1 = [dec1 decimalNumberByRoundingAccordingToBehavior:handler];
		dec2 = [dec2 decimalNumberByRoundingAccordingToBehavior:handler];
	}
	
	return [dec1 compare:dec2];
}

BOOL JFIsFloatValueEqualToValue(double value1, double value2, short scale)
{
	return (JFCompareFloatValues(value1, value2, scale) == NSOrderedSame);
}

BOOL JFIsFloatValueGreaterThanValue(double value1, double value2, short scale)
{
	return (JFCompareFloatValues(value1, value2, scale) == NSOrderedDescending);
}

BOOL JFIsFloatValueLessThanValue(double value1, double value2, short scale)
{
	return (JFCompareFloatValues(value1, value2, scale) == NSOrderedAscending);
}

// =================================================================================================
// MARK: Functions - Trigonometry
// =================================================================================================

JFDegrees JFDegreesFromRadians(JFRadians radians)
{
	return radians * 180.0 / M_PI;
}

JFRadians JFRadiansFromDegrees(JFDegrees degrees)
{
	return degrees * M_PI / 180.0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
