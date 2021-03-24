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

@import UIKit;

#import "UIButton+JFUIKit.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * A view that is used to modally block the user interface beneath it while presenting a running activity indicator. There are various properties that can be used to customize the view and its content, like the property `text` that is used to display a message, or the appearance properties. There is also the possibility to set a button with custom titles or images that will perform the `buttonBlock` when tapped.
 */
IB_DESIGNABLE
@interface JFActivityIndicatorView : UIView

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * An array of images that are used to create an additional animation beneath the default activity indicator view (if not hidden).
 */
@property (copy, nonatomic, nullable) NSArray<UIImage*>* animationImages;

/**
 * Title of the button when in state `UIControlStateNormal`.
 */
@property (copy, nonatomic, nullable) IBInspectable NSString* buttonTitle;

/**
 * A text message to be presented to the user.
 */
@property (copy, nonatomic, nullable) IBInspectable NSString* text;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

/**
 * Returns whether the alert container is hidden or visible.
 * The default value is `NO`.
 */
@property (assign, nonatomic, getter=isAlertHidden) IBInspectable BOOL alertHidden;

/**
 * The duration of the animation created using the images set in `animationImages`.
 * The default value is `0.0`.
 */
@property (assign, nonatomic) NSTimeInterval animationDuration;

/**
 * The size of the image view used to present the animation images.
 * The default value is `CGSizeZero`.
 */
@property (assign, nonatomic) CGSize animationImageSize;

/**
 * Returns whether the default activity indicator is hidden or visible.
 * The default value is `NO`.
 */
@property (assign, nonatomic, getter=isSpinnerHidden) IBInspectable BOOL spinnerHidden;

// =================================================================================================
// MARK: Properties - User interface (Actions)
// =================================================================================================

/**
 * The action to perform when the button is tapped.
 */
@property (strong, nonatomic, nullable) JFButtonBlock buttonBlock;

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

/**
 * The background color of the alert container.
 */
@property (strong, nonatomic, null_resettable) IBInspectable UIColor* alertBackgroundColor;

/**
 * The background image of the alert container.
 */
@property (strong, nonatomic, nullable) IBInspectable UIImage* alertBackgroundImage;

/**
 * The border color of the alert container.
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor* alertBorderColor;

/**
 * The border width of the alert container.
 * The default value is `0.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat alertBorderWidth;

/**
 * The corner radius of the alert container.
 * The default value is `8.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat alertCornerRadius;

/**
 * The minimum distance between the alert container and its superview.
 * The default value is `20.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat alertMargin;

/**
 * The maximum size of the alert container.
 * Set `0.0` or less to any dimension to disable that constraint.
 * The default value is `CGSizeZero`.
 */
@property (assign, nonatomic) IBInspectable CGSize alertMaxSize;

/**
 * The minimum size of the alert container.
 * Set `0.0` or less to any dimension to disable that constraint.
 * The default value is `CGSizeZero`.
 */
@property (assign, nonatomic) IBInspectable CGSize alertMinSize;

/**
 * The distance between the alert container and its subviews.
 * The default value is `15.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat alertPadding;

/**
 * The shadow color of the alert container.
 */
@property (assign, nonatomic, nullable) IBInspectable UIColor* alertShadowColor;

/**
 * The shadow offset of the alert container.
 * The default value is `{0.0, -3.0}}`.
 */
@property (assign, nonatomic) IBInspectable CGSize alertShadowOffset;

/**
 * The shadow opacity of the alert container.
 * The default value is `0.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat alertShadowOpacity;

/**
 * The shadow radius of the alert container.
 * The default value is `3.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat alertShadowRadius;

/**
 * The minimum distance between the alert container and its superview.
 * The default value is `20.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat alertSpacing;

/**
 * The background image of the button.
 */
@property (strong, nonatomic, nullable) IBInspectable UIImage* buttonBackgroundImage;

/**
 * The image of the button.
 */
@property (strong, nonatomic, nullable) IBInspectable UIImage* buttonImage;

/**
 * The title of the button.
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor* buttonTitleColor;

/**
 * The color of the default activity indicator view.
 */
@property (strong, nonatomic, null_resettable) IBInspectable UIColor* spinnerColor;

/**
 * The style of the default activity indicator view.
 * The default value is `UIActivityIndicatorViewStyleWhiteLarge`.
 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle spinnerStyle;

/**
 * The color of the text.
 */
@property (strong, nonatomic, null_resettable) IBInspectable UIColor* textColor;

/**
 * The font of the text.
 */
@property (strong, nonatomic, nullable) UIFont* textFont;

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

/**
 * Returns the button title for the given state.
 * @param state The control state of the button.
 * @return The button title for the given state.
 */
- (NSString* _Nullable)buttonTitleForState:(UIControlState)state;

/**
 * Sets the button title for the given state.
 * @param buttonTitle The title of the button.
 * @param state The state of the button.
 */
- (void)setButtonTitle:(NSString* _Nullable)buttonTitle forState:(UIControlState)state;

/**
 * Sets the text message.
 * @param text The text message to display in the alert container.
 * @param animated `YES` if the change must be animated.
 */
- (void)setText:(NSString* _Nullable)text animated:(BOOL)animated;

// =================================================================================================
// MARK: Properties (Accessors) - User interface (Appearance)
// =================================================================================================

/**
 * Returns the background image of the button for the given state.
 * @param state The state of the button.
 * @return The background image of the button for the given state.
 */
- (UIImage* _Nullable)buttonBackgroundImageForState:(UIControlState)state;

/**
 * Sets the background image of the button for the given state.
 * @param buttonBackgroundImage The background image of the button.
 * @param state The state of the button.
 */
- (void)setButtonBackgroundImage:(UIImage* _Nullable)buttonBackgroundImage forState:(UIControlState)state;

/**
 * Returns the image of the button for the given state.
 * @param state The state of the button.
 * @return The image of the button for the given state.
 */
- (UIImage* _Nullable)buttonImageForState:(UIControlState)state;

/**
 * Sets the image of the button for the given state.
 * @param buttonImage The image of the button.
 * @param state The state of the button.
 */
- (void)setButtonImage:(UIImage* _Nullable)buttonImage forState:(UIControlState)state;

/**
 * Returns the title color of the button for the given state.
 * @param state The state of the button.
 * @return The title color of the button for the given state.
 */
- (UIColor* _Nullable)buttonTitleColorForState:(UIControlState)state;

/**
 * Sets the title color of the button for the given state.
 * @param buttonTitleColor The title color of the button.
 * @param state The state of the button.
 */
- (void)setButtonTitleColor:(UIColor* _Nullable)buttonTitleColor forState:(UIControlState)state;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Initializes the instance with the given decoder.
 * @param aDecoder The decoder.
 * @return The initialized view.
 */
- (instancetype _Nullable)initWithCoder:(NSCoder*)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 * Initializes the instance using the given frame.
 * @param frame The frame of the view.
 * @return The initialized view.
 */
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
