//
//	The MIT License (MIT)
//
//	Copyright © 2017-2021 Jacopo Filié
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

@import JFKit;
@import UIKit;

@protocol JFOverlayControllerObserver;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * An overlay controller is a container that holds up to two child view controllers: one is used as root, while the other is used as an overlay that appears above the root when visible. If the overlay view controller is not opaque, the root view controller may appear where the overlay is totally or partially transparent.
 */
@interface JFOverlayController : UIViewController

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

/**
 * Returns whether the overlay container is hidden or visible.
 * The default value is `YES`.
 */
@property (assign, nonatomic, getter=isOverlayHidden) BOOL overlayHidden;

/**
 * Returns wheter the overlay container is opaque or not.
 * The default value is `YES`.
 */
@property (assign, nonatomic, getter=isOverlayOpaque) BOOL overlayOpaque;

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

/**
 * The background color of the overlay container. The alpha channel is forced to `1.0` if the property `overlayOpaque` is set to `YES`.
 */
@property (strong, nonatomic, nullable) UIColor* overlayBackgroundColor;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

/**
 * The view controller that is being displayed when the overlay is visible.
 */
@property (strong, nonatomic, nullable) UIViewController* overlayViewController;

/**
 * The view controller that is being displayed when the overlay is hidden. If the overlay is not opaque, the `rootViewController` may also be displayed underneath the `overlayViewController` if there are transparent areas.
 */
@property (strong, nonatomic, nullable) UIViewController* rootViewController;

// =================================================================================================
// MARK: Properties (Accessors) - User interface
// =================================================================================================

/**
 * Sets whether the overlay container is hidden or visible.
 * @param overlayHidden `YES` if the overlay is about to be hidden, `NO` otherwise.
 * @param animated `YES` if the transition is animated, `NO` otherwise.
 */
- (void)setOverlayHidden:(BOOL)overlayHidden animated:(BOOL)animated;

/**
 * Sets whether the overlay container is hidden or visible.
 * @param overlayHidden `YES` if the overlay is about to be hidden, `NO` otherwise.
 * @param animated `YES` if the transition is animated, `NO` otherwise.
 * @param completion The callback to be executed at the end of the transition.
 */
- (void)setOverlayHidden:(BOOL)overlayHidden animated:(BOOL)animated completion:(JFBlock __nullable)completion;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Initializes the instance with the given decoder.
 * @param aDecoder The decoder.
 * @return The initialized overlay controller.
 */
- (instancetype __nullable)initWithCoder:(NSCoder*)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 * Initializes the instance with the given nib name and bundle.
 * @param nibNameOrNil The name of the nib.
 * @param nibBundleOrNil The bundle of the nib.
 * @return The initialized overlay controller.
 */
- (instancetype)initWithNibName:(NSString* __nullable)nibNameOrNil bundle:(NSBundle* __nullable)nibBundleOrNil NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

/**
 * Registers the given observer. If the given observer is already registered, it does nothing.
 * @param observer The observer to register.
 */
- (void)addObserver:(id<JFOverlayControllerObserver>)observer;

/**
 * Unregisters the given observer. If the given observer is not registered, it does nothing.
 * @param observer The observer to unregister.
 */
- (void)removeObserver:(id<JFOverlayControllerObserver>)observer;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * An overlay controller observer is notified everytime the overlay performs an appearance transition.
 */
@protocol JFOverlayControllerObserver <NSObject>

// =================================================================================================
// MARK: Methods - Layout (Layout)
// =================================================================================================

@optional

/**
 * Called when the overlay view has appeared.
 * @param sender The overlay controller.
 * @param animated `YES` if the transition is animated, `NO` otherwise.
 */
- (void)overlayController:(JFOverlayController*)sender overlayDidAppear:(BOOL)animated;

/**
 * Called when the overlay view has disappeared.
 * @param sender The overlay controller.
 * @param animated `YES` if the transition is animated, `NO` otherwise.
 */
- (void)overlayController:(JFOverlayController*)sender overlayDidDisappear:(BOOL)animated;

/**
 * Called when the overlay view is about to appear.
 * @param sender The overlay controller.
 * @param animated `YES` if the transition is animated, `NO` otherwise.
 */
- (void)overlayController:(JFOverlayController*)sender overlayWillAppear:(BOOL)animated;

/**
 * Called when the overlay view is about to disappear.
 * @param sender The overlay controller.
 * @param animated `YES` if the transition is animated, `NO` otherwise.
 */
- (void)overlayController:(JFOverlayController*)sender overlayWillDisappear:(BOOL)animated;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
