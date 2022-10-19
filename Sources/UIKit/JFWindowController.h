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

@import Foundation;
@import JFKit;

#import "JFPreprocessorMacros.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * A container for windows that automatically observes many of the changes in their states.
 */
@interface JFWindowController : NSObject

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

/**
 * The observed window object.
 */
@property (strong, nonatomic, readonly) JFWindow* window;

/**
 * Returns whether the observed window is hidden or not.
 */
@property (assign, nonatomic, readonly, getter=isWindowHidden) BOOL windowHidden;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the container with the given window object.
 * @param window The window object to observe.
 * @return The initialized container.
 */
- (instancetype)initWithWindow:(JFWindow*)window NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Events (Window)
// =================================================================================================

/**
 * Called when the observed window becomes hidden.
 * On iOS, see notification `UIWindowDidBecomeHiddenNotification`.
 * On macOS, this is observed using KVO notifications.
 */
- (void)windowDidBecomeHidden;

/**
 * Called when the observed window becomes the key window.
 * On iOS, see notification `UIWindowDidBecomeKeyNotification`.
 * On macOS, see notification `NSWindowDidBecomeKeyNotification`.
 */
- (void)windowDidBecomeKey;

#if JF_MACOS

/**
 * Called when the observed window becomes the main window.
 * See notification `NSWindowDidBecomeMainNotification`.
 */
- (void)windowDidBecomeMain;

#endif

/**
 * Called when the observed window becomes visible.
 * On iOS, see notification `UIWindowDidBecomeVisibleNotification`.
 * On macOS, this is observed using KVO notifications.
 */
- (void)windowDidBecomeVisible;

#if JF_MACOS

/**
 * Called when the observed window changes screen.
 * See notification `NSWindowDidBecomeMainNotification`.
 */
- (void)windowDidChangeScreen;

/**
 * Called when the observed window changes screen profile.
 * See notification `NSWindowDidChangeScreenProfileNotification`.
 */
- (void)windowDidChangeScreenProfile;

/**
 * Called when the observed window is deminimized.
 * See notification `NSWindowDidDeminiaturizeNotification`.
 */
- (void)windowDidDeminiaturize;

/**
 * Called when the observed window has been resized by the user.
 * See notification `NSWindowDidEndLiveResizeNotification`.
 */
- (void)windowDidEndLiveResize;

/**
 * Called when the observed window closes an attached sheet.
 * See notification `NSWindowDidEndSheetNotification`.
 */
- (void)windowDidEndSheet;

/**
 * Called when a portion of the observed window is exposed.
 * See notification `NSWindowDidExposeNotification`.
 * @param exposedRect The portion of the window that is exposed.
 */
- (void)windowDidExpose:(NSRect)exposedRect;

/**
 * Called when the observed window is minimized.
 * See notification `NSWindowDidMiniaturizeNotification`.
 */
- (void)windowDidMiniaturize;

/**
 * Called when the observed window is moved.
 * See notification `NSWindowDidMoveNotification`.
 */
- (void)windowDidMove;

#endif

/**
 * Called when the observed window stops being the key window.
 * On iOS, see notification `UIWindowDidResignKeyNotification`.
 * On macOS, see notification `NSWindowDidResignKeyNotification`.
 */
- (void)windowDidResignKey;

#if JF_MACOS

/**
 * Called when the observed window stops being the main window.
 * See notification `NSWindowDidResignMainNotification`.
 */
- (void)windowDidResignMain;

/**
 * Called when the observed window is being resized.
 * See notification `NSWindowDidResizeNotification`.
 */
- (void)windowDidResize;

/**
 * Called when the observed window receives an update message.
 * See notification `NSWindowDidUpdateNotification`.
 */
- (void)windowDidUpdate;

/**
 * Called when the observed window is about to open a sheet.
 * See notification `NSWindowWillBeginSheetNotification`.
 */
- (void)windowWillBeginSheet;

/**
 * Called when the observed window is about to close.
 * See notification `NSWindowWillCloseNotification`.
 */
- (void)windowWillClose;

/**
 * Called when the observed window is about to be minimized.
 * See notification `NSWindowWillMiniaturizeNotification`.
 */
- (void)windowWillMiniaturize;

/**
 * Called when the observed window is about to move.
 * See notification `NSWindowWillMoveNotification`.
 */
- (void)windowWillMove;

/**
 * Called when the observed window is about to be resized by the user.
 * See notification `NSWindowWillStartLiveResizeNotification`.
 */
- (void)windowWillStartLiveResize;

#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
