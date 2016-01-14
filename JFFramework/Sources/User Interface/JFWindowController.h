//
//	The MIT License (MIT)
//
//	Copyright © 2015-2016 Jacopo Filié
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



@interface JFWindowController : NSObject

#pragma mark Properties

// Flags
@property (assign, nonatomic, readonly, getter = isWindowHidden)	BOOL	windowHidden;

// User interface
@property (strong, nonatomic, readonly)	JFWindow*	window;


#pragma mark Methods

// Memory management
- (instancetype)	initWithWindow:(JFWindow*)window NS_DESIGNATED_INITIALIZER;

// Window management
#if JF_TARGET_OS_OSX
- (void)	windowDidBecomeHidden;
- (void)	windowDidBecomeKey;
- (void)	windowDidBecomeMain;
- (void)	windowDidBecomeVisible;
- (void)	windowDidChangeScreen;
- (void)	windowDidChangeScreenProfile;
- (void)	windowDidDeminiaturize;
- (void)	windowDidEndLiveResize;
- (void)	windowDidEndSheet;
- (void)	windowDidExpose:(NSRect)exposedRect;
- (void)	windowDidMiniaturize;
- (void)	windowDidMove;
- (void)	windowDidResignKey;
- (void)	windowDidResignMain;
- (void)	windowDidResize;
- (void)	windowDidUpdate;
- (void)	windowWillBeginSheet;
- (void)	windowWillClose;
- (void)	windowWillMiniaturize;
- (void)	windowWillMove;
- (void)	windowWillStartLiveResize;
#else
- (void)	windowDidBecomeHidden;
- (void)	windowDidBecomeKey;
- (void)	windowDidBecomeVisible;
- (void)	windowDidResignKey;
#endif

@end
