//
//	The MIT License (MIT)
//
//	Copyright © 2014-2017 Jacopo Filié
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



@class JFSliderController;



#pragma mark - Typedefs

typedef NS_ENUM(UInt8, JFSliderControllerPanel)
{
	JFSliderControllerPanelLeft,
	JFSliderControllerPanelRight,
	JFSliderControllerPanelRoot,
};

typedef NS_ENUM(UInt8, JFSliderControllerTransition)
{
	JFSliderControllerTransitionNone,
	JFSliderControllerTransitionLeftToRoot,
	JFSliderControllerTransitionRightToRoot,
	JFSliderControllerTransitionRootToLeft,
	JFSliderControllerTransitionRootToRight,
};



#pragma mark



@protocol JFSliderControllerDelegate <NSObject>

@optional

- (void)	sliderController:(JFSliderController*)sliderController didActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didCancelDeactivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didCancelActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didDeactivatePanel:(JFSliderControllerPanel)panel;
- (BOOL)	sliderController:(JFSliderController*)sliderController shouldActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController willActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController willDeactivatePanel:(JFSliderControllerPanel)panel;

- (UIInterfaceOrientation)		sliderControllerPreferredInterfaceOrientationForPresentation:(JFSliderController*)sliderController;
- (UIInterfaceOrientationMask)	sliderControllerSupportedInterfaceOrientations:(JFSliderController*)sliderController;

@end



#pragma mark



@interface JFSliderController : UIViewController

#pragma mark Properties

// Attributes
@property (assign, nonatomic)	NSTimeInterval	slideInDuration;
@property (assign, nonatomic)	UIEdgeInsets	slideInsets;
@property (assign, nonatomic)	NSTimeInterval	slideOutDuration;

// Flags
@property (assign, nonatomic, readonly)	JFSliderControllerPanel			currentActivePanel;
@property (assign, nonatomic, readonly)	JFSliderControllerTransition	currentTransition;

// Gestures
@property (strong, nonatomic, readonly)	UIPanGestureRecognizer*	panGestureRecognizer;

// Relationships
@property (weak, nonatomic)	id<JFSliderControllerDelegate>	delegate;

// User interface
@property (strong, nonatomic, readonly)	UIViewController*	activeViewController;
@property (strong, nonatomic)			UIViewController*	leftViewController;
@property (strong, nonatomic)			UIViewController*	rightViewController;
@property (strong, nonatomic)			UIViewController*	rootViewController;


#pragma mark Methods

// User interface management
- (BOOL)				activatePanel:(JFSliderControllerPanel)panel;
- (BOOL)				activatePanel:(JFSliderControllerPanel)panel animated:(BOOL)animated completion:(JFBlockWithBOOL)completion;
- (UIViewController*)	viewControllerForPanel:(JFSliderControllerPanel)panel;

// Utilities management (Debug)
+ (NSString*)	debugStringFromPanel:(JFSliderControllerPanel)panel;
+ (NSString*)	debugStringFromTransition:(JFSliderControllerTransition)transition;
- (NSString*)	debugStringFromPanel:(JFSliderControllerPanel)panel;
- (NSString*)	debugStringFromTransition:(JFSliderControllerTransition)transition;

@end
