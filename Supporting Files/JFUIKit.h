//
//	The MIT License (MIT)
//
//	Copyright © 2015-2022 Jacopo Filié
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

#import <JFUIKit/JFPreprocessorMacros.h>

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#if JF_IOS
#	import <Foundation/Foundation.h>
#endif

#if JF_MACOS
#	import <Cocoa/Cocoa.h>
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

//! Project version number for JFUIKit.
FOUNDATION_EXPORT double JFUIKitVersionNumber;

//! Project version string for JFUIKit.
FOUNDATION_EXPORT const unsigned char JFUIKitVersionString[];

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#import <JFUIKit/JFAlert.h>
#import <JFUIKit/JFAlertsController.h>
#import <JFUIKit/JFAppDelegate.h>
#import <JFUIKit/JFWindowController.h>

#if JF_IOS
#	import <JFUIKit/JFActivityIndicatorView.h>
#	import <JFUIKit/JFGradientView.h>
#	import <JFUIKit/JFKeyboardHelper.h>
#	import <JFUIKit/JFOverlayController.h>
#	import <JFUIKit/JFSliderController.h>
#	import <JFUIKit/JFTableViewCell.h>
#	import <JFUIKit/UIButton+JFUIKit.h>
#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
