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

@class JFKeyboardInfo;

@protocol JFKeyboardHelperObserver;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * A keyboard helper observes changes to the system keyboard and notifies them to its own observers. It also helps managing a single view that should be resized when the keyboard appears or disappers.
 */
@interface JFKeyboardHelper : NSObject

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

/**
 * The distance between the resizable view bottom edge and the screen bottom edge when the keyboard is hidden.
 * Default value is `0.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat hiddenOffset;

/**
 * The distance between the resizable view bottom edge and the keyboard top edge when the keyboard is visible.
 * Default value is `0.0`.
 */
@property (assign, nonatomic) IBInspectable CGFloat visibleOffset;

// =================================================================================================
// MARK: Properties - User interface (Outlets)
// =================================================================================================

/**
 * The view to resize when the keyboard appears/disappears.
 */
@property (strong, nonatomic, nullable) IBOutlet UIView* resizableView;

/**
 * The bottom edge constraint of the view that needs to be resized when the keyboard appears/disappears.
 */
@property (strong, nonatomic, nullable) IBOutlet NSLayoutConstraint* resizableViewBottomConstraint;

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

/**
 * Registers the given observer. If the given observer is already registered, it does nothing.
 * @param observer The observer to register.
 */
- (void)addObserver:(id<JFKeyboardHelperObserver>)observer;

/**
 * Unregisters the given observer. If the given observer is not registered, it does nothing.
 * @param observer The observer to unregister.
 */
- (void)removeObserver:(id<JFKeyboardHelperObserver>)observer;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A keyboard helper observer is notified everytime the keyboard performs a transition, like becoming visible or hidden, or changing its frame.
 */
@protocol JFKeyboardHelperObserver <NSObject>

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

@optional

/**
 * Called when the keyboard frame has changed.
 * @param sender The keyboard helper.
 * @param info The data associated with the transition.
 */
- (void)keyboardHelper:(JFKeyboardHelper*)sender didChangeFrame:(JFKeyboardInfo*)info;

/**
 * Called when the keyboard did hide.
 * @param sender The keyboard helper.
 * @param info The data associated with the transition.
 */
- (void)keyboardHelper:(JFKeyboardHelper*)sender didHide:(JFKeyboardInfo*)info;

/**
 * Called when the keyboard did show.
 * @param sender The keyboard helper.
 * @param info The data associated with the transition.
 */
- (void)keyboardHelper:(JFKeyboardHelper*)sender didShow:(JFKeyboardInfo*)info;

/**
 * Called when the keyboard frame is about to change.
 * @param sender The keyboard helper.
 * @param info The data associated with the transition.
 */
- (void)keyboardHelper:(JFKeyboardHelper*)sender willChangeFrame:(JFKeyboardInfo*)info;

/**
 * Called when the keyboard is about to hide.
 * @param sender The keyboard helper.
 * @param info The data associated with the transition.
 */
- (void)keyboardHelper:(JFKeyboardHelper*)sender willHide:(JFKeyboardInfo*)info;

/**
 * Called when the keyboard is about to show.
 * @param sender The keyboard helper.
 * @param info The data associated with the transition.
 */
- (void)keyboardHelper:(JFKeyboardHelper*)sender willShow:(JFKeyboardInfo*)info;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * A data object containing the information associated with the current keyboard transition.
 */
@interface JFKeyboardInfo : NSObject <NSCopying>

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The animation curve used for the transition.
 */
@property (assign, nonatomic, readonly) UIViewAnimationCurve animationCurve;

/**
 * The duration of the transition.
 */
@property (assign, nonatomic, readonly) NSTimeInterval animationDuration;

/**
 * The frame of the keyboard when the transition begins.
 */
@property (assign, nonatomic, readonly) CGRect beginFrame;

/**
 * The frame of the keyboard when the transition ends.
 */
@property (assign, nonatomic, readonly) CGRect endFrame;

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
 * Initializes the instance with the given transition data.
 * @param beginFrame The frame of the keyboard when the transition begins.
 * @param endFrame The frame of the keyboard when the transition ends.
 * @param curve The animation curve used for the transition.
 * @param duration The duration of the transition.
 * @return The initialized instance.
 */
- (instancetype)initWithFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)curve duration:(NSTimeInterval)duration NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
