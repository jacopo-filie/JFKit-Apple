//
//	The MIT License (MIT)
//
//	Copyright © 2015-2017 Jacopo Filié
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
#import "JFTypes.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

#if JF_IOS || JF_MACOS
@class JFAlertsController;
#endif
@class JFErrorsManager;
@class JFWindowController;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN
#if JF_MACOS
@interface JFAppDelegate : NSObject <NSApplicationDelegate>
#else
@interface JFAppDelegate : UIResponder <UIApplicationDelegate>
#endif

// MARK: Properties - Errors
@property (strong, nonatomic, readonly)	JFErrorsManager*	errorsManager;

// MARK: Properties - User interface
#if JF_IOS || JF_MACOS
@property (strong, nonatomic, readonly)				JFAlertsController*	alertsController;
#endif
@property (strong, nonatomic, readonly, nullable)	JFWindowController*	windowController;

// MARK: Properties - User interface (Outlets)
@property (strong, nonatomic, nullable)	IBOutlet	JFWindow*	window;

// MARK: Properties - Errors management
- (JFErrorsManager*)	createErrorsManager;

// MARK: Properties - User interface management
- (JFWindowController* __nullable)	createControllerForWindow:(JFWindow*)window;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
