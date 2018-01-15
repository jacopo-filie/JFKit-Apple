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



#import "JFWindowController.h"

#import "JFShortcuts.h"



#pragma mark - Constants

static void*	JFKVOContext	= &JFKVOContext;



#pragma mark



@interface JFWindowController ()

#pragma mark Properties

// Flags
@property (assign, nonatomic, readwrite, getter = isWindowHidden)	BOOL	windowHidden;


#pragma mark Methods

// Notifications management (Window)
#if !JF_MACOS
- (void)	notifiedWindowDidBecomeHidden:(NSNotification*)notification;
#endif
- (void)	notifiedWindowDidBecomeKey:(NSNotification*)notification;
#if JF_MACOS
- (void)	notifiedWindowDidBecomeMain:(NSNotification*)notification;
#else
- (void)	notifiedWindowDidBecomeVisible:(NSNotification*)notification;
#endif
#if JF_MACOS
- (void)	notifiedWindowDidChangeScreen:(NSNotification*)notification;
- (void)	notifiedWindowDidChangeScreenProfile:(NSNotification*)notification;
- (void)	notifiedWindowDidDeminiaturize:(NSNotification*)notification;
- (void)	notifiedWindowDidEndLiveResize:(NSNotification*)notification;
- (void)	notifiedWindowDidEndSheet:(NSNotification*)notification;
- (void)	notifiedWindowDidExpose:(NSNotification*)notification;
- (void)	notifiedWindowDidMiniaturize:(NSNotification*)notification;
- (void)	notifiedWindowDidMove:(NSNotification*)notification;
#endif
- (void)	notifiedWindowDidResignKey:(NSNotification*)notification;
#if JF_MACOS
- (void)	notifiedWindowDidResignMain:(NSNotification*)notification;
- (void)	notifiedWindowDidResize:(NSNotification*)notification;
- (void)	notifiedWindowDidUpdate:(NSNotification*)notification;
- (void)	notifiedWindowWillBeginSheet:(NSNotification*)notification;
- (void)	notifiedWindowWillClose:(NSNotification*)notification;
- (void)	notifiedWindowWillMiniaturize:(NSNotification*)notification;
- (void)	notifiedWindowWillMove:(NSNotification*)notification;
- (void)	notifiedWindowWillStartLiveResize:(NSNotification*)notification;
#endif

@end



#pragma mark



@implementation JFWindowController

#pragma mark Properties

// Flags
@synthesize windowHidden	= _windowHidden;

// User interface
@synthesize window	= _window;


#pragma mark Properties accessors (Flags)

- (void)setWindowHidden:(BOOL)windowHidden
{
	if(_windowHidden == windowHidden)
		return;
	
	_windowHidden = windowHidden;
	
	if(_windowHidden)
		[self windowDidBecomeHidden];
	else
		[self windowDidBecomeVisible];
}


#pragma mark Memory management

- (void)dealloc
{
	[MainNotificationCenter removeObserver:self];
	
#if JF_MACOS
	if(macOS10_7Plus)
		[self.window removeObserver:self forKeyPath:@"visible" context:JFKVOContext];
	else
		[self.window removeObserver:self forKeyPath:@"visible"];
#endif
}

- (instancetype)init
{
	return [self initWithWindow:nil];
}

- (instancetype)initWithWindow:(JFWindow*)window
{
	self = (window ? [super init] : nil);
	if(self)
	{
#if JF_MACOS
		BOOL windowHidden = ![window isVisible];
#else
		BOOL windowHidden = [window isHidden];
#endif
		
		// Flags
		_windowHidden = windowHidden;
		
		// User interface
		_window = window;
		
		// Notifications observing
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
		[window addObserver:self forKeyPath:@"visible" options:NSKeyValueObservingOptionNew context:JFKVOContext];
#else
		[center addObserver:self selector:@selector(notifiedWindowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:window];
		[center addObserver:self selector:@selector(notifiedWindowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:window];
		[center addObserver:self selector:@selector(notifiedWindowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:window];
		[center addObserver:self selector:@selector(notifiedWindowDidResignKey:) name:UIWindowDidResignKeyNotification object:window];
#endif
	}
	return self;
}


#pragma mark Notifications management (Window)

#if JF_MACOS

- (void)notifiedWindowDidBecomeKey:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidBecomeKey];
}

- (void)notifiedWindowDidBecomeMain:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidBecomeMain];
}

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
	
	NSRect exposedRect = [(NSValue*)notification.userInfo[@"NSExposedRect"] rectValue];
	
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

- (void)notifiedWindowDidResignKey:(NSNotification*)notification
{
	if(macOS10_6)
		self.windowHidden = ![self.window isVisible];
	
	[self windowDidResignKey];
}

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

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*,id>*)change context:(void*)context
{
	if(context == JFKVOContext)
	{
		if((object == self.window) && [keyPath isEqualToString:@"visible"])
			self.windowHidden = ![change[NSKeyValueChangeNewKey] boolValue];
	}
	else
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#else

- (void)notifiedWindowDidBecomeHidden:(NSNotification*)notification
{
	self.windowHidden = YES;
}

- (void)notifiedWindowDidBecomeKey:(NSNotification*)notification
{
	[self windowDidBecomeKey];
}

- (void)notifiedWindowDidBecomeVisible:(NSNotification*)notification
{
	self.windowHidden = NO;
}

- (void)notifiedWindowDidResignKey:(NSNotification*)notification
{
	[self windowDidResignKey];
}

#endif


#pragma mark Window management

#if JF_MACOS

- (void)windowDidBecomeHidden
{}

- (void)windowDidBecomeKey
{}

- (void)windowDidBecomeMain
{}

- (void)windowDidBecomeVisible
{}

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

- (void)windowDidResignKey
{}

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

#else

- (void)windowDidBecomeHidden
{}

- (void)windowDidBecomeKey
{}

- (void)windowDidBecomeVisible
{}

- (void)windowDidResignKey
{}

#endif

@end
