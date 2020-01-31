//
//	The MIT License (MIT)
//
//	Copyright © 2015-2020 Jacopo Filié
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

#import "JFPreprocessorMacros.h"

@import Foundation;

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

#import "JFAlertsController.h"
#import "JFShortcuts.h"
#import "JFWindowController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

#if JF_MACOS
/**
 * The superclass and protocol of the macOS application delegate.
 */
#define JFAppDelegateSuperclass NSObject <NSApplicationDelegate>
#else
/**
 * The superclass and protocol of the iOS application delegate.
 */
#define JFAppDelegateSuperclass UIResponder <UIApplicationDelegate>
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A unified application delegate base class for both iOS and macOS. It exposes the useful property `window` (required for iOS and optional for macOS) that references the main window of the application.
 */
@interface JFAppDelegate : JFAppDelegateSuperclass

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

/**
 * The main alerts controller for the application.
 */
@property (strong, nonatomic, readonly) JFAlertsController* alertsController;

/**
 * The main window of the application.
 * @warning Changing the value of this property also resets the property `windowController`.
 */
@property (strong, nonatomic, null_resettable) IBOutlet JFWindow* window;

/**
 * The main window controller.
 */
@property (strong, nonatomic, readonly) JFWindowController* windowController;

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

/**
 * Called when a new window is set. It asks its subclasses to create a new controller for the main window. If `nil` is returned, a default controller of type `JFWindowController` will be created instead.
 */
- (JFWindowController* __nullable)newControllerForWindow:(JFWindow*)window;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
