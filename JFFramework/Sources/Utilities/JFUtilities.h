//
//	The MIT License (MIT)
//
//	Copyright (c) 2015 Jacopo Filié
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



#import "JFTypes.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

FOUNDATION_EXPORT NSTimeInterval const	JFAnimationDuration;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

FOUNDATION_EXPORT id	JFApplicationInfoForKey(NSString* key);
FOUNDATION_EXPORT BOOL	JFAreObjectsEqual(id<NSObject> obj1, id<NSObject> obj2);


#pragma mark Functions (Images)

#if TARGET_OS_IPHONE
FOUNDATION_EXPORT NSString*	JFLaunchImageName();
FOUNDATION_EXPORT NSString*	JFLaunchImageNameForOrientation(UIInterfaceOrientation orientation);
#endif


#pragma mark Functions (Math)

FOUNDATION_EXPORT JFDegrees	JFDegreesFromRadians(JFRadians radians);
FOUNDATION_EXPORT JFRadians	JFRadiansFromDegrees(JFDegrees degrees);


#pragma mark Functions (Resources)

FOUNDATION_EXPORT NSURL*	JFBundleResourceURLForFile(NSBundle* bundle, NSString* filename);
FOUNDATION_EXPORT NSURL*	JFBundleResourceURLForFileWithType(NSBundle* bundle, NSString* filename, NSString* type);


#pragma mark Functions (Runtime)

FOUNDATION_EXPORT void	JFPerformSelector(NSObject* target, SEL action);
FOUNDATION_EXPORT void	JFPerformSelector1(NSObject* target, SEL action, id object);
FOUNDATION_EXPORT void	JFPerformSelector2(NSObject* target, SEL action, id obj1, id obj2);

#pragma mark Functions (Version)

FOUNDATION_EXPORT BOOL	JFCheckSystemVersion(NSString* version, JFRelation relation);

////////////////////////////////////////////////////////////////////////////////////////////////////
