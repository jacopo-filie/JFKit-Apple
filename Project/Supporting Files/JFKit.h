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

#import <JFKit/JFPreprocessorMacros.h>

////////////////////////////////////////////////////////////////////////////////////////////////////

#if JF_IOS
#	import <UIKit/UIKit.h>
#endif

#if JF_MACOS
#	import <Cocoa/Cocoa.h>
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

//! Project version number for JFKit.
FOUNDATION_EXPORT double JFKitVersionNumber;

//! Project version string for JFKit.
FOUNDATION_EXPORT const unsigned char JFKitVersionString[];

////////////////////////////////////////////////////////////////////////////////////////////////////

#import <JFKit/JFAlert.h>
#import <JFKit/JFAlertsController.h>
#import <JFKit/JFAppDelegate.h>
#import <JFKit/JFAsynchronousBlockOperation.h>
#import <JFKit/JFAsynchronousOperation.h>
#import <JFKit/JFBlocks.h>
#import <JFKit/JFByteStream.h>
#import <JFKit/JFColors.h>
#import <JFKit/JFCompatibilityMacros.h>
#import <JFKit/JFConnectionMachine.h>
#import <JFKit/JFError.h>
#import <JFKit/JFErrorFactory.h>
#import <JFKit/JFImages.h>
#import <JFKit/JFLogger.h>
#import <JFKit/JFMath.h>
#import <JFKit/JFObserversController.h>
#import <JFKit/JFPair.h>
#import <JFKit/JFPersistentContainer.h>
#import <JFKit/JFReferences.h>
#import <JFKit/JFShortcuts.h>
#import <JFKit/JFStateMachine.h>
#import <JFKit/JFStrings.h>
#import <JFKit/JFSwitchMachine.h>
#import <JFKit/JFUtilities.h>
#import <JFKit/JFVersion.h>
#import <JFKit/JFWindowController.h>

#if JF_IOS
#	import <JFKit/JFActivityIndicatorView.h>
#	import <JFKit/JFGradientView.h>
#	import <JFKit/JFKeyboardHelper.h>
#	import <JFKit/JFOverlayController.h>
#	import <JFKit/JFSliderController.h>
#	import <JFKit/JFTableViewCell.h>
#	import <JFKit/UIButton+JFKit.h>
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
