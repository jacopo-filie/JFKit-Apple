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



#import <XCTest/XCTest.h>

#import	"JFPreprocessorMacros.h"
#import "JFShortcuts.h"



@class AppDelegate;



@interface JFShortcuts_Tests : XCTestCase

@end



#pragma mark



@implementation JFShortcuts_Tests

#pragma mark Tests

- (void)testMacros
{
	// ApplicationDelegate
	id value = ApplicationDelegate;
	id result = SharedApplication.delegate;
	XCTAssert((value == result), @"The 'ApplicationDelegate' value is '%@'; it should be '%@'.", value, result);
	
	// ClassBundle
	value = ClassBundle;
	result = [NSBundle bundleForClass:[self class]];
	XCTAssert((value == result), @"The 'ClassBundle' value is '%@'; it should be '%@'.", value, result);
	
	// ClassName
	value = ClassName;
	result = NSStringFromClass([self class]);
	XCTAssert([value isEqualToString:result], @"The 'ClassName' value is '%@'; it should be '%@'.", value, result);
	
	// MainBundle
	value = MainBundle;
	result = [NSBundle mainBundle];
	XCTAssert((value == result), @"The 'MainBundle' value is '%@'; it should be '%@'.", value, result);
	
	// MainNotificationCenter
	value = MainNotificationCenter;
	result = [NSNotificationCenter defaultCenter];
	XCTAssert((value == result), @"The 'MainNotificationCenter' value is '%@'; it should be '%@'.", value, result);
	
	// MainOperationQueue
	value = MainOperationQueue;
	result = [NSOperationQueue mainQueue];
	XCTAssert((value == result), @"The 'MainOperationQueue' value is '%@'; it should be '%@'.", value, result);
	
	// MethodName
	value = MethodName;
	result = NSStringFromSelector(_cmd);
	XCTAssert([value isEqualToString:result], @"The 'MethodName' value is '%@'; it should be '%@'.", value, result);
	
	// ProcessInfo
	value = ProcessInfo;
	result = [NSProcessInfo processInfo];
	XCTAssert((value == result), @"The 'ProcessInfo' value is '%@'; it should be '%@'.", value, result);
	
#if JF_TARGET_OS_OSX
	
	// SharedApplication
	value = SharedApplication;
	result = NSApp;
	XCTAssert((value == result), @"The 'SharedApplication' value is '%@'; it should be '%@'.", value, result);
	
	// SharedWorkspace
	value = SharedWorkspace;
	result = [NSWorkspace sharedWorkspace];
	XCTAssert((value == result), @"The 'SharedWorkspace' value is '%@'; it should be '%@'.", value, result);
	
#else
	
	// CurrentDevice
	value = CurrentDevice;
	result = [UIDevice currentDevice];
	XCTAssert((value == result), @"The 'CurrentDevice' value is '%@'; it should be '%@'.", value, result);
	
#if JF_TARGET_OS_IOS
	
	// CurrentDeviceOrientation
	UIDeviceOrientation deviceOrientationValue = CurrentDeviceOrientation;
	UIDeviceOrientation deviceOrientationResult = [UIDevice currentDevice].orientation;
	XCTAssert((deviceOrientationValue == deviceOrientationResult), @"The 'CurrentDeviceOrientation' value is '%@'; it should be '%@'.", JFStringFromNSInteger(deviceOrientationValue), JFStringFromNSInteger(deviceOrientationResult));
	
	// CurrentStatusBarOrientation
	UIInterfaceOrientation interfaceOrientationValue = CurrentStatusBarOrientation;
	UIInterfaceOrientation interfaceOrientationResult = [UIApplication sharedApplication].statusBarOrientation;
	XCTAssert((interfaceOrientationValue == interfaceOrientationResult), @"The 'CurrentDeviceOrientation' value is '%@'; it should be '%@'.", JFStringFromNSInteger(interfaceOrientationValue), JFStringFromNSInteger(interfaceOrientationResult));
	
#endif
	
	// MainScreen
	value = MainScreen;
	result = [UIScreen mainScreen];
	XCTAssert((value == result), @"The 'MainScreen' value is '%@'; it should be '%@'.", value, result);
	
	// SharedApplication
	value = SharedApplication;
	result = [UIApplication sharedApplication];
	XCTAssert((value == result), @"The 'SharedApplication' value is '%@'; it should be '%@'.", value, result);
	
#endif
}

- (void)testMacrosSystem
{
#if !JF_TARGET_OS_OSX
	
	UIDevice* device = [UIDevice currentDevice];
	
	// iPad
	BOOL boolValue = iPad;
	BOOL boolResult = (device.userInterfaceIdiom == UIUserInterfaceIdiomPad);
	XCTAssert((boolValue == boolResult), @"The 'iPad' value is '%@'; it should be '%@'.", JFStringFromBool(boolValue), JFStringFromBool(boolResult));
	
	// iPhone
	boolValue = iPhone;
	boolResult = (device.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
	XCTAssert((boolValue == boolResult), @"The 'iPhone' value is '%@'; it should be '%@'.", JFStringFromBool(boolValue), JFStringFromBool(boolResult));
	
	// SystemVersion
	NSString* value = SystemVersion;
	NSString* result = device.systemVersion;
	XCTAssert([value isEqualToString:result], @"The 'SystemVersion' value is '%@'; it should be '%@'.", value, result);
	
	// UserInterfaceIdiom
	UIUserInterfaceIdiom idiomValue = UserInterfaceIdiom;
	UIUserInterfaceIdiom idiomResult = device.userInterfaceIdiom;
	XCTAssert((idiomValue == idiomResult), @"The 'UserInterfaceIdiom' value is '%@'; it should be '%@'.", JFStringFromNSInteger(idiomValue), JFStringFromNSInteger(idiomResult));
	
#endif
}

@end
