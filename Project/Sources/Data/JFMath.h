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

@import Foundation;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * An alias for double degrees values.
 */
typedef double JFDegrees;

/**
 * An alias for double radians values.
 */
typedef double JFRadians;

/**
 * An alias for unit prefixes.
 */
typedef UInt64 JFUnitPrefix;

/*
 * A list of available binary unit prefixes.
 */
typedef NS_ENUM(JFUnitPrefix, JFBinaryPrefixes) {
	
	/**
	 * The kibi prefix: 2^10.
	 */
	JFKibi	= 1024ULL,
	
	/**
	 * The mebi prefix: 2^20.
	 */
	JFMebi	= JFKibi * JFKibi,
	
	/**
	 * The gibi prefix: 2^30.
	 */
	JFGibi	= JFMebi * JFKibi,
	
	/**
	 * The tebi prefix: 2^40.
	 */
	JFTebi	= JFGibi * JFKibi,
	
	/**
	 * The pebi prefix: 2^50.
	 */
	JFPebi	= JFTebi * JFKibi,
	
	/**
	 * The pebi prefix: 2^60.
	 */
	JFExbi	= JFPebi * JFKibi,
};

/*
 * A list of available decimal unit prefixes.
 */
typedef NS_ENUM(JFUnitPrefix, JFDecimalPrefixes) {
	
	/**
	 * The kilo prefix: 10^3.
	 */
	JFKilo = 1000ULL,
	
	/**
	 * The mega prefix: 10^6.
	 */
	JFMega = JFKilo * JFKilo,
	
	/**
	 * The giga prefix: 10^9.
	 */
	JFGiga = JFMega * JFKilo,
	
	/**
	 * The tera prefix: 10^12.
	 */
	JFTera = JFGiga * JFKilo,
	
	/**
	 * The peta prefix: 10^15.
	 */
	JFPeta = JFTera * JFKilo,
	
	/**
	 * The exa prefix: 10^18.
	 */
	JFExa = JFPeta * JFKilo,
};

/**
 * A list of possible relations for a comparison between values.
 */
typedef NS_ENUM(UInt8, JFRelation) {
	
	/**
	 * The first value is less than the second value.
	 */
	JFRelationLessThan,
	
	/**
	 * The first value is less than or equal to the second value.
	 */
	JFRelationLessThanOrEqual,
	
	/**
	 * The first value is equal to the second value.
	 */
	JFRelationEqual,
	
	/**
	 * The first value is greater than or equal to the second value.
	 */
	JFRelationGreaterThanOrEqual,
	
	/**
	 * The first value is greater than the second value.
	 */
	JFRelationGreaterThan,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Functions
// =================================================================================================

/**
 * A convenient function to convert radians to degrees.
 * @param radians The value to convert.
 @return The converted value expressed in degrees.
 */
FOUNDATION_EXPORT JFDegrees	JFDegreesFromRadians(JFRadians radians);

/**
 * A convenient function to convert degrees to radians.
 * @param degrees The value to convert.
 @return The converted value expressed in radians.
 */
FOUNDATION_EXPORT JFRadians	JFRadiansFromDegrees(JFDegrees degrees);

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
