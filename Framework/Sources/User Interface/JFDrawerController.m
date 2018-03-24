//
//	The MIT License (MIT)
//
//	Copyright © 2014-2018 Jacopo Filié
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

#import "JFDrawerController.h"

#import "JFObserversController.h"
#import "JFShortcuts.h"
#import "JFUtilities.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFDrawerController ()

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (strong, nonatomic, readonly)	JFObserversController<id<JFDrawerControllerObserver>>*	observersController;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@property (weak, nonatomic, nullable) UIButton* dismissButton;
@property (weak, nonatomic, nullable) UIView* leftContainer;
@property (weak, nonatomic, nullable) UIView* rightContainer;
@property (weak, nonatomic, nullable) UIView* rootContainer;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (void)initializeProperties:(JFDrawerController*)controller;

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (void)updateContainersZOrder;

// =================================================================================================
// MARK: Methods - User interface management (Layout)
// =================================================================================================

- (void)installDismissButton;
- (void)uninstallDismissButton;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFDrawerController

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize delegate = _delegate;
@synthesize observersController = _observersController;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize appearAnimationDuration = _appearAnimationDuration;
@synthesize disappearAnimationDuration = _disappearAnimationDuration;
@synthesize leftDrawerHidden = _leftDrawerHidden;
@synthesize leftDrawerMode = _leftDrawerMode;
@synthesize leftDrawerOffset = _leftDrawerOffset;
@synthesize rightDrawerHidden = _rightDrawerHidden;
@synthesize rightDrawerMode = _rightDrawerMode;
@synthesize rightDrawerOffset = _rightDrawerOffset;

// =================================================================================================
// MARK: Properties - User interface (Gestures)
// =================================================================================================

@synthesize panGestureRecognizer = _panGestureRecognizer;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@synthesize dismissButton = _dismissButton;
@synthesize keyViewController = _keyViewController;
@synthesize leftContainer = _leftContainer;
@synthesize leftViewController = _leftViewController;
@synthesize rightContainer = _rightContainer;
@synthesize rightViewController = _rightViewController;
@synthesize rootContainer = _rootContainer;
@synthesize rootViewController = _rootViewController;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

- (void)setLeftDrawerMode:(JFDrawerControllerMode)leftDrawerMode
{
	if(_leftDrawerMode == leftDrawerMode)
		return;
	
	_leftDrawerMode = leftDrawerMode;
	
	if([self isViewLoaded])
		[self updateContainersZOrder];
}

- (void)setRightDrawerMode:(JFDrawerControllerMode)rightDrawerMode
{
	if(_rightDrawerMode == rightDrawerMode)
		return;
	
	_rightDrawerMode = rightDrawerMode;
	
	if([self isViewLoaded])
		[self updateContainersZOrder];
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (void)initializeProperties:(JFDrawerController*)controller
{
	// Observers
	controller->_observersController = [JFObserversController<id<JFDrawerControllerObserver>> new];
	
	// User interface
	controller->_appearAnimationDuration = JFAnimationDuration;
	controller->_disappearAnimationDuration = JFAnimationDuration;
	controller->_leftDrawerHidden = YES;
	controller->_leftDrawerMode = JFDrawerControllerModeBelow;
	controller->_leftDrawerOffset = 44.0f;
	controller->_rightDrawerHidden = YES;
	controller->_rightDrawerMode = JFDrawerControllerModeBelow;
	controller->_rightDrawerOffset = 44.0f;
}

- (instancetype __nullable)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[JFDrawerController initializeProperties:self];
	}
	return self;
}

- (instancetype)initWithNibName:(NSString* __nullable)nibNameOrNil bundle:(NSBundle* __nullable)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	[JFDrawerController initializeProperties:self];
	return self;
}

// =================================================================================================
// MARK: Methods - Observers management
// =================================================================================================

- (void)addObserver:(id<JFDrawerControllerObserver>)observer
{
	[self.observersController addObserver:observer];
}

- (void)removeObserver:(id<JFDrawerControllerObserver>)observer
{
	[self.observersController removeObserver:observer];
}

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (void)dismissAllDrawers:(BOOL)animated completion:(JFBlock __nullable)completion
{}

- (void)presentLeftDrawer:(BOOL)animated completion:(JFBlock __nullable)completion
{}

- (void)presentRightDrawer:(BOOL)animated completion:(JFBlock __nullable)completion
{}

- (void)updateContainersZOrder
{
	UIView* left = self.leftContainer;
	UIView* right = self.rightContainer;
	UIView* view = self.view;
	
	if(self.leftDrawerMode == JFDrawerControllerModeAbove)
		[view bringSubviewToFront:left];
	else
		[view sendSubviewToBack:left];
	
	if(self.rightDrawerMode == JFDrawerControllerModeAbove)
		[view bringSubviewToFront:right];
	else
		[view sendSubviewToBack:right];
}

// =================================================================================================
// MARK: Methods - User interface management (Layout)
// =================================================================================================

- (void)installDismissButton
{}

- (void)uninstallDismissButton
{}

// =================================================================================================
// MARK: Methods - User interface management (View lifecycle)
// =================================================================================================

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIView* view = self.view;
	
	UIViewAutoresizing autoresizingMask = ViewAutoresizingFlexibleSize;
	CGRect bounds = view.bounds;
	
	CGFloat leftOffset = self.leftDrawerOffset;
	CGFloat rightOffset = self.rightDrawerOffset;
	
	CGRect leftFrame = bounds;
	leftFrame.size.width -= leftOffset;
	
	CGRect rightFrame = bounds;
	rightFrame.origin.x += rightOffset;
	rightFrame.size.width -= rightOffset;
	
	UIView* leftContainer = [[UIView alloc] initWithFrame:leftFrame];
	leftContainer.autoresizingMask = autoresizingMask;
	leftContainer.backgroundColor = [UIColor blackColor];
	leftContainer.opaque = YES;
	self.leftContainer = leftContainer;
	
	UIView* rightContainer = [[UIView alloc] initWithFrame:rightFrame];
	rightContainer.autoresizingMask = autoresizingMask;
	rightContainer.backgroundColor = [UIColor blackColor];
	rightContainer.opaque = YES;
	self.rightContainer = rightContainer;
	
	UIView* rootContainer = [[UIView alloc] initWithFrame:bounds];
	rootContainer.autoresizingMask = autoresizingMask;
	rootContainer.backgroundColor = [UIColor blackColor];
	rootContainer.opaque = YES;
	self.rootContainer = rootContainer;
	
	[view addSubview:leftContainer];
	[view addSubview:rightContainer];
	[view addSubview:rootContainer];
	
	[self updateContainersZOrder];
	
	UIViewController* rootViewController = self.rootViewController;
	if(rootViewController)
	{
		[self addChildViewController:rootViewController];
		rootViewController.view.autoresizingMask = autoresizingMask;
		rootViewController.view.frame = rootContainer.bounds;
		rootViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
		[rootContainer addSubview:rootViewController.view];
		[rootViewController didMoveToParentViewController:self];
	}
	
	UIViewController* leftViewController = self.leftViewController;
	if(leftViewController)
	{
		[self addChildViewController:leftViewController];
		leftViewController.view.autoresizingMask = autoresizingMask;
		leftViewController.view.frame = leftContainer.bounds;
		leftViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
		[leftContainer addSubview:leftViewController.view];
		[leftViewController didMoveToParentViewController:self];
	}
	
	UIViewController* rightViewController = self.rightViewController;
	if(rightViewController)
	{
		[self addChildViewController:rightViewController];
		rightViewController.view.autoresizingMask = autoresizingMask;
		rightViewController.view.frame = rightContainer.bounds;
		rightViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
		[rightContainer addSubview:rightViewController.view];
		[rightViewController didMoveToParentViewController:self];
	}
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
