//
//	The MIT License (MIT)
//
//	Copyright © 2015-2021 Jacopo Filié
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

#import "JFWindowController.h"

@import JFKit;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Constants
// =================================================================================================

static void* JFKVOContext = &JFKVOContext;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFWindowController (/* Private */)

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@property (assign, nonatomic, readwrite, getter=isWindowHidden) BOOL windowHidden;

// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

#if JF_IOS
- (void)notifiedWindowDidBecomeHidden:(NSNotification*)notification;
#endif
- (void)notifiedWindowDidBecomeKey:(NSNotification*)notification;
#if JF_MACOS
- (void)notifiedWindowDidBecomeMain:(NSNotification*)notification;
#endif
#if JF_IOS
- (void)notifiedWindowDidBecomeVisible:(NSNotification*)notification;
#endif
#if JF_MACOS
- (void)notifiedWindowDidChangeScreen:(NSNotification*)notification;
- (void)notifiedWindowDidChangeScreenProfile:(NSNotification*)notification;
- (void)notifiedWindowDidDeminiaturize:(NSNotification*)notification;
- (void)notifiedWindowDidEndLiveResize:(NSNotification*)notification;
- (void)notifiedWindowDidEndSheet:(NSNotification*)notification;
- (void)notifiedWindowDidExpose:(NSNotification*)notification;
- (void)notifiedWindowDidMiniaturize:(NSNotification*)notification;
- (void)notifiedWindowDidMove:(NSNotification*)notification;
#endif
- (void)notifiedWindowDidResignKey:(NSNotification*)notification;
#if JF_MACOS
- (void)notifiedWindowDidResignMain:(NSNotification*)notification;
- (void)notifiedWindowDidResize:(NSNotification*)notification;
- (void)notifiedWindowDidUpdate:(NSNotification*)notification;
- (void)notifiedWindowWillBeginSheet:(NSNotification*)notification;
- (void)notifiedWindowWillClose:(NSNotification*)notification;
- (void)notifiedWindowWillMiniaturize:(NSNotification*)notification;
- (void)notifiedWindowWillMove:(NSNotification*)notification;
- (void)notifiedWindowWillStartLiveResize:(NSNotification*)notification;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFWindowController

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize window = _window;
@synthesize windowHidden = _windowHidden;

// =================================================================================================
// MARK: Properties (Accessors) - User interface
// =================================================================================================

- (void)setWindowHidden:(BOOL)windowHidden
{
	if(_windowHidden == windowHidden)
		return;
	
	_windowHidden = windowHidden;
	
	if(windowHidden)
		[self windowDidBecomeHidden];
	else
		[self windowDidBecomeVisible];
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (void)dealloc
{
	[MainNotificationCenter removeObserver:self];
	
#if JF_MACOS
	if(@available(macOS 10.7, *))
		[self.window removeObserver:self forKeyPath:@"visible" context:JFKVOContext];
#endif
}

- (instancetype)initWithWindow:(JFWindow*)window
{
	self = [super init];
	
#if JF_MACOS
	BOOL windowHidden = ![window isVisible];
#else
	BOOL windowHidden = [window isHidden];
#endif
	
	_window = window;
	_windowHidden = windowHidden;
	
	NSNotificationCenter* center = MainNotificationCenter;
#if JF_MACOS
	[center addObserver:self selector:@selector(notifiedWindowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidBecomeMain:) name:NSWindowDidBecomeMainNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidChangeScreen:) name:NSWindowDidChangeScreenNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidChangeScreenProfile:) name:NSWindowDidChangeScreenProfileNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidDeminiaturize:) name:NSWindowDidDeminiaturizeNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidEndLiveResize:) name:NSWindowDidEndLiveResizeNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidEndSheet:) name:NSWindowDidEndSheetNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidExpose:) name:NSWindowDidExposeNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidMiniaturize:) name:NSWindowDidMiniaturizeNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidMove:) name:NSWindowDidMoveNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidResignKey:) name:NSWindowDidResignKeyNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidResignMain:) name:NSWindowDidResignMainNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidResize:) name:NSWindowDidResizeNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidUpdate:) name:NSWindowDidUpdateNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowWillBeginSheet:) name:NSWindowWillBeginSheetNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowWillClose:) name:NSWindowWillCloseNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowWillMiniaturize:) name:NSWindowWillMiniaturizeNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowWillMove:) name:NSWindowWillMoveNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowWillStartLiveResize:) name:NSWindowWillStartLiveResizeNotification object:window];
	if(@available(macOS 10.7, *))
		[window addObserver:self forKeyPath:@"visible" options:NSKeyValueObservingOptionNew context:JFKVOContext];
#else
	[center addObserver:self selector:@selector(notifiedWindowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:window];
	[center addObserver:self selector:@selector(notifiedWindowDidResignKey:) name:UIWindowDidResignKeyNotification object:window];
#endif
	
	return self;
}

// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

#if JF_IOS
- (void)notifiedWindowDidBecomeHidden:(NSNotification*)notification
{
	self.windowHidden = YES;
}
#endif

- (void)notifiedWindowDidBecomeKey:(NSNotification*)notification
{
#if JF_MACOS
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
#endif
	
	[self windowDidBecomeKey];
}

#if JF_MACOS
- (void)notifiedWindowDidBecomeMain:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidBecomeMain];
}
#endif

#if JF_IOS
- (void)notifiedWindowDidBecomeVisible:(NSNotification*)notification
{
	self.windowHidden = NO;
}
#endif

#if JF_MACOS
- (void)notifiedWindowDidChangeScreen:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidChangeScreen];
}

- (void)notifiedWindowDidChangeScreenProfile:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidChangeScreenProfile];
}

- (void)notifiedWindowDidDeminiaturize:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidDeminiaturize];
}

- (void)notifiedWindowDidEndLiveResize:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidEndLiveResize];
}

- (void)notifiedWindowDidEndSheet:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidEndSheet];
}

- (void)notifiedWindowDidExpose:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	NSRect exposedRect = [(NSValue*)[notification.userInfo objectForKey:@"NSExposedRect"] rectValue];
	
	[self windowDidExpose:exposedRect];
}

- (void)notifiedWindowDidMiniaturize:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidMiniaturize];
}

- (void)notifiedWindowDidMove:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidMove];
}
#endif

- (void)notifiedWindowDidResignKey:(NSNotification*)notification
{
#if JF_MACOS
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
#endif
	
	[self windowDidResignKey];
}

#if JF_MACOS
- (void)notifiedWindowDidResignMain:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidResignMain];
}

- (void)notifiedWindowDidResize:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidResize];
}

- (void)notifiedWindowDidUpdate:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidUpdate];
}

- (void)notifiedWindowWillBeginSheet:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowWillBeginSheet];
}

- (void)notifiedWindowWillClose:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowWillClose];
}

- (void)notifiedWindowWillMiniaturize:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowWillMiniaturize];
}

- (void)notifiedWindowWillMove:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowWillMove];
}

- (void)notifiedWindowWillStartLiveResize:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowWillStartLiveResize];
}
#endif

#if JF_MACOS
- (void)observeValueForKeyPath:(NSString* __nullable)keyPath ofObject:(id __nullable)object change:(NSDictionary<NSKeyValueChangeKey, id>* __nullable)change context:(void* __nullable)context;
{
	if(context == JFKVOContext)
	{
		if((object == self.window) && [keyPath isEqualToString:@"visible"])
			self.windowHidden = ![(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
	}
	else
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
#endif

// =================================================================================================
// MARK: Methods - Events (Window)
// =================================================================================================

- (void)windowDidBecomeHidden
{}

- (void)windowDidBecomeKey
{}

#if JF_MACOS
- (void)windowDidBecomeMain
{}
#endif

- (void)windowDidBecomeVisible
{}

#if JF_MACOS
- (void)windowDidChangeScreen
{}

- (void)windowDidChangeScreenProfile
{}

- (void)windowDidDeminiaturize
{}

- (void)windowDidEndLiveResize
{}

- (void)windowDidEndSheet
{}

- (void)windowDidExpose:(NSRect)exposedRect
{}

- (void)windowDidMiniaturize
{}

- (void)windowDidMove
{}
#endif

- (void)windowDidResignKey
{}

#if JF_MACOS
- (void)windowDidResignMain
{}

- (void)windowDidResize
{}

- (void)windowDidUpdate
{}

- (void)windowWillBeginSheet
{}

- (void)windowWillClose
{}

- (void)windowWillMiniaturize
{}

- (void)windowWillMove
{}

- (void)windowWillStartLiveResize
{}
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
