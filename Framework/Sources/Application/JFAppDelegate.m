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

/**
 * Called when a new window is set. It asks its subclasses to create a new controller for the main window. If `nil` is returned, a default controller of type `JFWindowController` will be created instead.
 */
- (JFWindowController* __nullable)newControllerForWindow:(JFWindow*)window;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFAppDelegate

// =================================================================================================
// MARK: Properties - User interface (Outlets)
// =================================================================================================

@synthesize window				= _window;
@synthesize windowController	= _windowController;

// =================================================================================================
// MARK: Properties accessors - User interface (Outlets)
// =================================================================================================

- (JFWindow*)window
{
	if(!_window)
	{
#if JF_MACOS
		_window = [NSWindow new];
#else
		_window = [[UIWindow alloc] initWithFrame:MainScreen.bounds];
#endif
	}
	return _window;
}

- (void)setWindow:(JFWindow* __nullable)window
{
	if(_window == window)
		return;
	
	_window = window;
	_windowController = nil;
}

- (JFWindowController*)windowController
{
	if(!_windowController)
	{
		JFWindow* window = self.window;
		_windowController = ([self newControllerForWindow:window] ?: [[JFWindowController alloc] initWithWindow:window]);
	}
	return _windowController;
}

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (JFWindowController* __nullable)newControllerForWindow:(JFWindow*)window
{
	return nil;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
