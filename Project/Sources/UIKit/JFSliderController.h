//
//	The MIT License (MIT)
//
//	Copyright © 2014-2021 Jacopo Filié
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

@import JFKit;
@import UIKit;

@protocol JFSliderControllerDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * A list with the usable slider controller panels.
 */
typedef NS_ENUM(UInt8, JFSliderControllerPanel)
{
	/**
	 * The left slider panel.
	 */
	JFSliderControllerPanelLeft,
	
	/**
	 * The right slider panel.
	 */
	JFSliderControllerPanelRight,
	
	/**
	 * The center slider panel.
	 */
	JFSliderControllerPanelRoot,
};

/**
 * A list with the available panel transitions.
 */
typedef NS_ENUM(UInt8, JFSliderControllerTransition)
{
	/**
	 * No panel is being moved.
	 */
	JFSliderControllerTransitionNone,
	
	/**
	 * The left panel is being hidden and the center panel is being shown.
	 */
	JFSliderControllerTransitionLeftToRoot,
	
	/**
	 * The right panel is being hidden and the center panel is being shown.
	 */
	JFSliderControllerTransitionRightToRoot,
	
	/**
	 * The left panel is being shown and the center panel is being partially hidden.
	 */
	JFSliderControllerTransitionRootToLeft,
	
	/**
	 * The right panel is being shown and the center panel is being partially hidden.
	 */
	JFSliderControllerTransitionRootToRight,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * A slider controller is a container that holds up to three child view controllers: one is used as root, while the other two are used as additional views, positioned on the sides of the root, that appear partially behind the root when they are shown. Its typical use may be to show a general application menu on the left panel and a contextual menu on the right panel while the rest of the app is shown in center.
 */
@interface JFSliderController : UIViewController

// =================================================================================================
// MARK: Properties - Attributes
// =================================================================================================

/**
 * Returns the duration of the transition of a side panel (left or right) when it is being shown.
 * The default value is `JFAnimationDuration`.
 */
@property (assign, nonatomic) NSTimeInterval slideInDuration;

/**
 * Returns the insets that are being used when a side panel (left or right) is being shown.
 * On iPad, the default value is `(0.0f, 80.0f, 0.0f, 80.0f)`.
 * On iPhone, the default value is `(0.0f, 40.0f, 0.0f, 40.0f)`.
 */
@property (assign, nonatomic) UIEdgeInsets slideInsets;

/**
 * Returns the duration of the transition of a side panel (left or right) when it is being hidden.
 * The default value is `JFAnimationDuration`.
 */
@property (assign, nonatomic) NSTimeInterval slideOutDuration;

// =================================================================================================
// MARK: Properties - Flags
// =================================================================================================

/**
 * Returns the currently active panel value.
 */
@property (assign, nonatomic, readonly) JFSliderControllerPanel currentActivePanel;

/**
 * Returns the currently performed panel transition.
 */
@property (assign, nonatomic, readonly) JFSliderControllerTransition currentTransition;

// =================================================================================================
// MARK: Properties - Gestures
// =================================================================================================

/**
 * Returns the pan gesture recognizer, if present.
 */
@property (strong, nonatomic, readonly, nullable) UIPanGestureRecognizer* panGestureRecognizer;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

#if JF_WEAK_ENABLED
/**
 * The delegate of the slider controller.
 */
@property (weak, nonatomic, nullable) id<JFSliderControllerDelegate> delegate;
#else
/**
 * The delegate of the slider controller.
 * @warning Remember to unset the delegate when it is not available anymore because it may become a dangling pointer otherwise.
 */
@property (unsafe_unretained, nonatomic, nullable) id<JFSliderControllerDelegate> delegate;
#endif

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

/**
 * The view controller that is being displayed.
 */
@property (strong, nonatomic, readonly, nullable) UIViewController* activeViewController;

/**
 * The view controller that is installed on the left panel.
 */
@property (strong, nonatomic, nullable) UIViewController* leftViewController;

/**
 * The view controller that is installed on the right panel.
 */
@property (strong, nonatomic, nullable) UIViewController* rightViewController;

/**
 * The view controller that is installed on the center panel.
 */
@property (strong, nonatomic, nullable) UIViewController* rootViewController;

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

/**
 * Calls the method `activatePanel:animated:completion:` with `animated` set to `YES` and `completion` set to `nil`.
 * @param panel The panel to show.
 * @return `YES` if the transition started, `NO` otherwise.
 */
- (BOOL)activatePanel:(JFSliderControllerPanel)panel;

/**
 * Requests the appropriate transition to hide the currently visible panel and show the requested panel. If the requested panel is already shown, it does nothing. If a transition is already being performed or the requested transition is trying to display a side panel while showing the other one (e.g.: trying to show the right panel while the left panel is visible), the request is aborted and the completion callback is never called.
 * @param panel The panel to show.
 * @param animated `YES` if the transition is animated, `NO` otherwise.
 * @param completion The callback to be executed at the end of the transition.
 * @return `YES` if the transition started, `NO` otherwise.
 */
- (BOOL)activatePanel:(JFSliderControllerPanel)panel animated:(BOOL)animated completion:(JFBlockWithBOOL __nullable)completion;

/**
 * Returns the view controller that is installed on the given panel.
 * @param panel The panel that is containing the requested view controller.
 * @return The view controller that is installed on the given panel.
 */
- (UIViewController* __nullable)viewControllerForPanel:(JFSliderControllerPanel)panel;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

/**
 * Returns a loggable string associated with the given panel.
 * @param panel The panel whose loggable string is being requested.
 * @return A loggable string associated with the given panel.
 */
+ (NSString*)debugStringFromPanel:(JFSliderControllerPanel)panel;

/**
 * Returns a loggable string associated with the given transition.
 * @param transition The transition whose loggable string is being requested.
 * @return A loggable string associated with the given transition.
 */
+ (NSString*)debugStringFromTransition:(JFSliderControllerTransition)transition;

/**
 * Returns a loggable string associated with the given panel. Calls the equivalent class method.
 * @param panel The panel whose loggable string is being requested.
 * @return A loggable string associated with the given panel.
 */
- (NSString*)debugStringFromPanel:(JFSliderControllerPanel)panel;

/**
 * Returns a loggable string associated with the given transition. Calls the equivalent class method.
 * @param transition The transition whose loggable string is being requested.
 * @return A loggable string associated with the given transition.
 */
- (NSString*)debugStringFromTransition:(JFSliderControllerTransition)transition;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -


/**
 * A collection of methods that are used to notify the slider controller delegate about changes in the user interface.
 */
@protocol JFSliderControllerDelegate <NSObject>

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

@optional

/**
 * Called when the given panel has been activated.
 * @param sliderController The slider controller.
 * @param panel The activated panel.
 */
- (void)sliderController:(JFSliderController*)sliderController didActivatePanel:(JFSliderControllerPanel)panel;

/**
 * Called when the given panel was being activated and the operation has been cancelled.
 * @param sliderController The slider controller.
 * @param panel The panel that was being activated.
 */
- (void)sliderController:(JFSliderController*)sliderController didCancelActivatePanel:(JFSliderControllerPanel)panel;

/**
 * Called when the given panel was being deactivated and the operation has been cancelled.
 * @param sliderController The slider controller.
 * @param panel The panel that was being deactivated.
 */
- (void)sliderController:(JFSliderController*)sliderController didCancelDeactivatePanel:(JFSliderControllerPanel)panel;

/**
 * Called when the given panel has been deactivated.
 * @param sliderController The slider controller.
 * @param panel The deactivated panel.
 */
- (void)sliderController:(JFSliderController*)sliderController didDeactivatePanel:(JFSliderControllerPanel)panel;

/**
 * Called when the slider controller is about to activate the given panel and requests a confirmation.
 * @param sliderController The slider controller.
 * @param panel The panel that should be activated.
 * @return `YES` if the given panel should be activated, `NO` otherwise.
 */
- (BOOL)sliderController:(JFSliderController*)sliderController shouldActivatePanel:(JFSliderControllerPanel)panel;

/**
 * Called when the given panel is about to be activated.
 * @param sliderController The slider controller.
 * @param panel The panel that is about to be activated.
 */
- (void)sliderController:(JFSliderController*)sliderController willActivatePanel:(JFSliderControllerPanel)panel;

/**
 * Called when the given panel is about to be deactivated.
 * @param sliderController The slider controller.
 * @param panel The panel that is about to be deactivated.
 */
- (void)sliderController:(JFSliderController*)sliderController willDeactivatePanel:(JFSliderControllerPanel)panel;

// =================================================================================================
// MARK: Methods - Layout (Rotation)
// =================================================================================================

@optional

/**
 * Called when the slider controller needs to know the preferred interface orientation for presentation.
 * @param sliderController The slider controller.
 * @return The preferred interface orientation for presentation.
 */
- (UIInterfaceOrientation)sliderControllerPreferredInterfaceOrientationForPresentation:(JFSliderController*)sliderController;

/**
 * Called when the slider controller needs to know the supported interface orientations.
 * @param sliderController The slider controller.
 * @return The supported interface orientations.
 */
- (UIInterfaceOrientationMask)sliderControllerSupportedInterfaceOrientations:(JFSliderController*)sliderController;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
