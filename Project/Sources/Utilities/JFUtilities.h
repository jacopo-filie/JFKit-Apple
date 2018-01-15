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

#import	"JFPreprocessorMacros.h"
#import "JFTypes.h"
#import "JFVersion.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

// =================================================================================================
// MARK: Constants
// =================================================================================================

FOUNDATION_EXPORT NSTimeInterval const	JFAnimationDuration;

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

#define Strongify(_var, _suffix)	__typeof(_var) __strong strong ## _suffix = _var
#define StrongifySelf				Strongify(weakSelf, Self)
#if __has_feature(objc_arc_weak)
#define Weakify(_var, _suffix)		__typeof(_var) __weak weak ## _suffix = _var
#else
#define Weakify(_var, _suffix)		__typeof(_var) weak ## _suffix = _var
#endif
#define WeakifySelf					Weakify(self, Self)

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN

// =================================================================================================
// MARK: Functions - Application management
// =================================================================================================

FOUNDATION_EXPORT id __nullable	JFApplicationInfoForKey(NSString* key);

// =================================================================================================
// MARK: Functions - Equality management
// =================================================================================================

FOUNDATION_EXPORT BOOL	JFAreObjectsEqual(id<NSObject> __nullable obj1, id<NSObject> __nullable obj2);

// =================================================================================================
// MARK: Functions - Images management (iOS)
// =================================================================================================
#if JF_IOS

FOUNDATION_EXPORT NSString* __nullable	JFLaunchImageName(void);
FOUNDATION_EXPORT NSString* __nullable	JFLaunchImageNameForOrientation(UIInterfaceOrientation orientation);

#endif
// =================================================================================================
// MARK: Functions - Math management
// =================================================================================================

FOUNDATION_EXPORT JFDegrees	JFDegreesFromRadians(JFRadians radians);
FOUNDATION_EXPORT JFRadians	JFRadiansFromDegrees(JFDegrees degrees);

// =================================================================================================
// MARK: Functions - Resources management
// =================================================================================================

FOUNDATION_EXPORT NSURL* __nullable	JFBundleResourceURLForFile(NSBundle* bundle, NSString* __nullable filename);
FOUNDATION_EXPORT NSURL* __nullable	JFBundleResourceURLForFileWithExtension(NSBundle* bundle, NSString* __nullable filename, NSString* __nullable type);

// =================================================================================================
// MARK: Functions - Runtime management
// =================================================================================================

FOUNDATION_EXPORT void	JFPerformSelector(NSObject* target, SEL action);
FOUNDATION_EXPORT void	JFPerformSelector1(NSObject* target, SEL action, id object);
FOUNDATION_EXPORT void	JFPerformSelector2(NSObject* target, SEL action, id obj1, id obj2);

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
