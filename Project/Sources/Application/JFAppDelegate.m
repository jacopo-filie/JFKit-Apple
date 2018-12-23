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

#import "JFAppDelegate.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFAppDelegate ()

// =================================================================================================
// MARK: Properties - User interface (Outlets)
// =================================================================================================

@property (strong, nonatomic, readwrite, null_resettable) JFWindowController* windowController;

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (JFWindowController*)prepareWindowController;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFAppDelegate

// =================================================================================================
// MARK: Properties - User interface (Outlets)
// =================================================================================================

@synthesize alertsController = _alertsController;
@synthesize window = _window;
@synthesize windowController = _windowController;

// =================================================================================================
// MARK: Properties accessors - User interface
// =================================================================================================

- (JFAlertsController*)alertsController
{
	JFAlertsController* retObj = _alertsController;
	if(!retObj)
	{
		retObj = [JFAlertsController new];
		_alertsController = retObj;
	}
	return retObj;
}

- (JFWindow*)window
{
	JFWindow* retObj = _window;
	if(!retObj)
		retObj = [self prepareWindowController].window;
	return retObj;
}

- (void)setWindow:(JFWindow* __nullable)window
{
	if(_window == window)
		return;
	
	_window = window;
	_windowController = nil;
	
	[self prepareWindowController];
}

- (JFWindowController*)windowController
{
	JFWindowController* retObj = _windowController;
	if(!retObj)
		retObj = [self prepareWindowController];
	return retObj;
}

- (void)setWindowController:(JFWindowController* __nullable)windowController
{
	if(_windowController == windowController)
		return;
	
	_window = windowController.window;
	_windowController = windowController;
}

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (JFWindowController* __nullable)newControllerForWindow:(JFWindow*)window
{
	return nil;
}

- (JFWindowController*)prepareWindowController
{
	JFWindow* window = _window;
	JFWindowController* controller = _windowController;
	
	if(window && controller && (window == controller.window))
		return controller;
	
	if(!window)
	{
#if JF_MACOS
		window = [NSWindow new];
#else
		window = [[UIWindow alloc] initWithFrame:MainScreen.bounds];
#endif
	}
	
	if(!controller || (window != controller.window))
		controller = ([self newControllerForWindow:window] ?: [[JFWindowController alloc] initWithWindow:window]);
	
	_window = window;
	_windowController = controller;
	
	return controller;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
