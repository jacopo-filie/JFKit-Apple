//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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

#if JF_IOS || JF_TVOS
// MARK: Macros - Aliases (iOS / tvOS)
#define JFApplication			UIApplication
#define JFApplicationDelegate	UIApplicationDelegate
#define JFWindow				UIWindow
#endif

#if JF_MACOS
// MARK: Macros - Aliases (macOS)
#define JFApplication			NSApplication
#define JFApplicationDelegate	NSApplicationDelegate
#define JFWindow				NSWindow
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

// =================================================================================================
// MARK: Types - Blocks
// =================================================================================================

typedef void	(^JFBlock)					(void);
typedef void	(^JFBlockWithArray)			(NSArray* array);
typedef void	(^JFBlockWithBOOL)			(BOOL value);
typedef void	(^JFBlockWithDictionary)	(NSDictionary* dictionary);
typedef void	(^JFBlockWithError)			(NSError* error);
typedef void	(^JFBlockWithInteger)		(NSInteger value);
typedef void	(^JFBlockWithNotification)	(NSNotification* notification);
typedef void	(^JFBlockWithObject)		(id object);
typedef void	(^JFBlockWithSet)			(NSSet* set);
typedef void	(^JFCompletionBlock)		(BOOL succeeded, id object, NSError* error);
typedef void	(^JFSimpleCompletionBlock)	(BOOL succeeded, NSError* error);

// =================================================================================================
// MARK: Types - Enumerations
// =================================================================================================

typedef NS_ENUM(UInt8, JFRelation) {
	JFRelationLessThan,
	JFRelationLessThanOrEqual,
	JFRelationEqual,
	JFRelationGreaterThanOrEqual,
	JFRelationGreaterThan,
};

// =================================================================================================
// MARK: Types - Math
// =================================================================================================

typedef double	JFDegrees;
typedef double	JFRadians;

// =================================================================================================
// MARK: Types - Metrics
// =================================================================================================

typedef NS_ENUM(UInt64, JFMetrics) {
	
	// Binary
	JFKibi	= 1024ULL,
	JFMebi	= JFKibi * JFKibi,
	JFGibi	= JFMebi * JFKibi,
	JFTebi	= JFGibi * JFKibi,
	
	// Decimal
	JFKilo	= 1000ULL,
	JFMega	= JFKilo * JFKilo,
	JFGiga	= JFMega * JFKilo,
	JFTera	= JFGiga * JFKilo,
};

////////////////////////////////////////////////////////////////////////////////////////////////////
