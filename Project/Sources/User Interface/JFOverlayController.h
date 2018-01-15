//
//	The MIT License (MIT)
//
//	Copyright © 2017-2018 Jacopo Filié
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

#import "JFTypes.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@class JFOverlayController;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN
@protocol JFOverlayControllerObserver <NSObject>

// MARK: Methods - User interface management
@optional - (void)	overlayControllerDidHideOverlay:(JFOverlayController*)sender;
@optional - (void)	overlayControllerDidShowOverlay:(JFOverlayController*)sender;
@optional - (void)	overlayControllerWillHideOverlay:(JFOverlayController*)sender;
@optional - (void)	overlayControllerWillShowOverlay:(JFOverlayController*)sender;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JFOverlayController : UIViewController

// MARK: Properties - User interface
@property (assign, nonatomic, getter=isOverlayOpaque)				BOOL				overlayOpaque;
@property (strong, nonatomic, nullable)								UIViewController*	overlayViewController;
@property (assign, nonatomic, readonly, getter=isOverlayVisible)	BOOL				overlayVisible;
@property (strong, nonatomic, nullable)								UIViewController*	rootViewController;

// MARK: Methods - Observers management
- (void)	addObserver:(id<JFOverlayControllerObserver>)observer;
- (void)	removeObserver:(id<JFOverlayControllerObserver>)observer;

// MARK: Methods - User interface management
- (void)	hideOverlay;
- (void)	hideOverlay:(BOOL)animated completion:(JFBlock __nullable)completion;
- (void)	showOverlay;
- (void)	showOverlay:(BOOL)animated completion:(JFBlock __nullable)completion;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
