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
// MARK: Properties - User interface
// =================================================================================================

@property (assign, nonatomic, readonly) NSOperationQueue* animationQueue;
@property (assign, nonatomic, readwrite, getter=isLeftDrawerHidden) BOOL leftDrawerHidden;
@property (assign, nonatomic, getter=isLeftViewAnimating) BOOL leftViewAnimating;
@property (assign, nonatomic, getter=hasLeftViewAppeared) BOOL leftViewAppeared;
@property (assign, nonatomic, getter=isLeftViewAppearing) BOOL leftViewAppearing;
@property (assign, nonatomic, getter=isLeftViewDisappearing) BOOL leftViewDisappearing;
@property (assign, nonatomic, readwrite, getter=isRightDrawerHidden) BOOL rightDrawerHidden;
@property (assign, nonatomic, getter=isRightViewAnimating) BOOL rightViewAnimating;
@property (assign, nonatomic, getter=hasRightViewAppeared) BOOL rightViewAppeared;
@property (assign, nonatomic, getter=isRightViewAppearing) BOOL rightViewAppearing;
@property (assign, nonatomic, getter=isRightViewDisappearing) BOOL rightViewDisappearing;
@property (assign, nonatomic, getter=isRootViewAnimating) BOOL rootViewAnimating;
@property (assign, nonatomic, getter=hasRootViewAppeared) BOOL rootViewAppeared;
@property (assign, nonatomic, getter=isRootViewAppearing) BOOL rootViewAppearing;
@property (assign, nonatomic, getter=isRootViewDisappearing) BOOL rootViewDisappearing;
@property (assign, nonatomic, getter=isViewAnimating) BOOL viewAnimating;
@property (assign, nonatomic, getter=hasViewAppeared) BOOL viewAppeared;
@property (assign, nonatomic, getter=isViewAppearing) BOOL viewAppearing;
@property (assign, nonatomic, getter=isViewDisappearing) BOOL viewDisappearing;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@property (weak, nonatomic, nullable) UIButton* dismissButton;
@property (weak, nonatomic, nullable) UIView* leftContainer;
@property (weak, nonatomic, nullable) UIView* rightContainer;
@property (weak, nonatomic, nullable) UIView* rootContainer;

// =================================================================================================
// MARK: Properties - User interface (Layout constraints)
// =================================================================================================

@property (strong, nonatomic, nullable) NSArray<NSLayoutConstraint*>* customConstraints;
@property (strong, nonatomic, nullable) NSLayoutConstraint* leftContainerLeftToViewLeftConstraint;
@property (strong, nonatomic, nullable) NSLayoutConstraint* leftContainerWidthConstraint;
@property (strong, nonatomic, nullable) NSLayoutConstraint* rightContainerRightToViewRightConstraint;
@property (strong, nonatomic, nullable) NSLayoutConstraint* rightContainerWidthConstraint;
@property (strong, nonatomic, nullable) NSLayoutConstraint* rootContainerLeftToLeftContainerRightConstraint;
@property (strong, nonatomic, nullable) NSLayoutConstraint* rootContainerLeftToViewLeftConstraint;
@property (strong, nonatomic, nullable) NSLayoutConstraint* rootContainerRightToRightContainerLeftConstraint;
@property (strong, nonatomic, nullable) NSLayoutConstraint* rootContainerRightToViewRightConstraint;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (void)initializeProperties:(JFDrawerController*)controller;

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (void)beginLeftViewTransition:(BOOL)appearing animated:(BOOL)animated;
- (void)beginRightViewTransition:(BOOL)appearing animated:(BOOL)animated;
- (void)beginRootViewTransition:(BOOL)appearing animated:(BOOL)animated;
- (void)endLeftViewTransition;
- (void)endRightViewTransition;
- (void)endRootViewTransition;
- (void)updateContainersZOrder;

// =================================================================================================
// MARK: Methods - User interface management (Actions)
// =================================================================================================

- (IBAction)dismissButtonTapped:(UIButton*)sender;

// =================================================================================================
// MARK: Methods - User interface management (Layout)
// =================================================================================================

- (void)installDismissButton;
- (void)rebuildConstraints;
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

@synthesize animationQueue = _animationQueue;
@synthesize appearAnimationDuration = _appearAnimationDuration;
@synthesize disappearAnimationDuration = _disappearAnimationDuration;
@synthesize leftDrawerHidden = _leftDrawerHidden;
@synthesize leftDrawerMode = _leftDrawerMode;
@synthesize leftDrawerOffset = _leftDrawerOffset;
@synthesize leftViewAnimating = _leftViewAnimating;
@synthesize leftViewAppeared = _leftViewAppeared;
@synthesize leftViewAppearing = _leftViewAppearing;
@synthesize leftViewDisappearing = _leftViewDisappearing;
@synthesize rightDrawerHidden = _rightDrawerHidden;
@synthesize rightDrawerMode = _rightDrawerMode;
@synthesize rightDrawerOffset = _rightDrawerOffset;
@synthesize rightViewAnimating = _rightViewAnimating;
@synthesize rightViewAppeared = _rightViewAppeared;
@synthesize rightViewAppearing = _rightViewAppearing;
@synthesize rightViewDisappearing = _rightViewDisappearing;
@synthesize rootViewAnimating = _rootViewAnimating;
@synthesize rootViewAppeared = _rootViewAppeared;
@synthesize rootViewAppearing = _rootViewAppearing;
@synthesize rootViewDisappearing = _rootViewDisappearing;
@synthesize viewAnimating = _viewAnimating;
@synthesize viewAppeared = _viewAppeared;
@synthesize viewAppearing = _viewAppearing;
@synthesize viewDisappearing = _viewDisappearing;

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
// MARK: Properties - User interface (Layout constraints)
// =================================================================================================

@synthesize customConstraints = _customConstraints;
@synthesize leftContainerLeftToViewLeftConstraint = _leftContainerLeftToViewLeftConstraint;
@synthesize leftContainerWidthConstraint = _leftContainerWidthConstraint;
@synthesize rightContainerRightToViewRightConstraint = _rightContainerRightToViewRightConstraint;
@synthesize rightContainerWidthConstraint = _rightContainerWidthConstraint;
@synthesize rootContainerLeftToLeftContainerRightConstraint = _rootContainerLeftToLeftContainerRightConstraint;
@synthesize rootContainerLeftToViewLeftConstraint = _rootContainerLeftToViewLeftConstraint;
@synthesize rootContainerRightToRightContainerLeftConstraint = _rootContainerRightToRightContainerLeftConstraint;
@synthesize rootContainerRightToViewRightConstraint = _rootContainerRightToViewRightConstraint;

// =================================================================================================
// MARK: Properties accessors - User interface
// =================================================================================================

- (void)setLeftDrawerMode:(JFDrawerControllerMode)leftDrawerMode
{
	if(_leftDrawerMode == leftDrawerMode)
		return;
	
	_leftDrawerMode = leftDrawerMode;
	
	if([self isViewLoaded])
	{
		if([self isLeftDrawerHidden])
			[self updateContainersZOrder];
		else
		{
			JFWeakifySelf;
			[self dismissAllDrawers:NO completion:^{
				[weakSelf updateContainersZOrder];
			}];
		}
	}
}

- (void)setRightDrawerMode:(JFDrawerControllerMode)rightDrawerMode
{
	if(_rightDrawerMode == rightDrawerMode)
		return;
	
	_rightDrawerMode = rightDrawerMode;
	
	if([self isViewLoaded])
	{
		if([self isRightDrawerHidden])
			[self updateContainersZOrder];
		else
		{
			JFWeakifySelf;
			[self dismissAllDrawers:NO completion:^{
				[weakSelf updateContainersZOrder];
			}];
		}
	}
}

// =================================================================================================
// MARK: Properties accessors - User interface (Layout)
// =================================================================================================

- (void)setLeftViewController:(UIViewController* __nullable)leftViewController
{
	if(_leftViewController == leftViewController)
		return;
	
	UIViewController* oldViewController = _leftViewController;
	UIViewController* newViewController = leftViewController;
	
	NSLog(@" ");
	NSLog(@"%@: %@ [old = %@] [new = %@]", JFStringFromObject(self), NSStringFromSelector(_cmd), JFStringFromObject(oldViewController), JFStringFromObject(newViewController));
	
	if([self isViewLoaded])
		[self endLeftViewTransition];
	
	_leftViewController = leftViewController;
	
	if([self isViewLoaded])
	{
		BOOL leftViewAppeared = [self hasLeftViewAppeared];
		
		[oldViewController willMoveToParentViewController:nil];
		[self addChildViewController:newViewController];
		
		if(leftViewAppeared)
		{
			[oldViewController beginAppearanceTransition:NO animated:NO];
			[newViewController beginAppearanceTransition:YES animated:NO];
		}
		
		UIView* container = self.leftContainer;
		UIView* view = newViewController.view;
		
		view.autoresizingMask = ViewAutoresizingFlexibleSize;
		view.frame = container.bounds;
		view.translatesAutoresizingMaskIntoConstraints = YES;
		[container addSubview:view];
		
		[oldViewController.view removeFromSuperview];
		
		if(leftViewAppeared)
		{
			[oldViewController endAppearanceTransition];
			[newViewController endAppearanceTransition];
		}
		
		[oldViewController removeFromParentViewController];
		[newViewController didMoveToParentViewController:self];
	}
}

- (void)setRightViewController:(UIViewController* __nullable)rightViewController
{
	if(_rightViewController == rightViewController)
		return;
	
	UIViewController* oldViewController = _rightViewController;
	UIViewController* newViewController = rightViewController;
	
	NSLog(@" ");
	NSLog(@"%@: %@ [old = %@] [new = %@]", JFStringFromObject(self), NSStringFromSelector(_cmd), JFStringFromObject(oldViewController), JFStringFromObject(newViewController));
	
	if([self isViewLoaded])
		[self endRightViewTransition];
	
	_rightViewController = rightViewController;
	
	if([self isViewLoaded])
	{
		BOOL rightViewAppeared = [self hasRightViewAppeared];
		
		[oldViewController willMoveToParentViewController:nil];
		[self addChildViewController:newViewController];
		
		if(rightViewAppeared)
		{
			[oldViewController beginAppearanceTransition:NO animated:NO];
			[newViewController beginAppearanceTransition:YES animated:NO];
		}
		
		UIView* container = self.rightContainer;
		UIView* view = newViewController.view;
		
		view.autoresizingMask = ViewAutoresizingFlexibleSize;
		view.frame = container.bounds;
		view.translatesAutoresizingMaskIntoConstraints = YES;
		[container addSubview:view];
		
		[oldViewController.view removeFromSuperview];
		
		if(rightViewAppeared)
		{
			[oldViewController endAppearanceTransition];
			[newViewController endAppearanceTransition];
		}
		
		[oldViewController removeFromParentViewController];
		[newViewController didMoveToParentViewController:self];
	}
}

- (void)setRootViewController:(UIViewController* __nullable)rootViewController
{
	if(_rootViewController == rootViewController)
		return;
	
	UIViewController* oldViewController = _rootViewController;
	UIViewController* newViewController = rootViewController;
	
	NSLog(@" ");
	NSLog(@"%@: %@ [old = %@] [new = %@]", JFStringFromObject(self), NSStringFromSelector(_cmd), JFStringFromObject(oldViewController), JFStringFromObject(newViewController));
	
	if([self isViewLoaded])
		[self endRootViewTransition];
	
	_rootViewController = rootViewController;
	
	if([self isViewLoaded])
	{
		BOOL rootViewAppeared = [self hasRootViewAppeared];
		
		[oldViewController willMoveToParentViewController:nil];
		[self addChildViewController:newViewController];
		
		if(rootViewAppeared)
		{
			[oldViewController beginAppearanceTransition:NO animated:NO];
			[newViewController beginAppearanceTransition:YES animated:NO];
		}
		
		UIView* container = self.rootContainer;
		UIView* view = newViewController.view;
		
		view.autoresizingMask = ViewAutoresizingFlexibleSize;
		view.frame = container.bounds;
		view.translatesAutoresizingMaskIntoConstraints = YES;
		[container addSubview:view];
		
		UIButton* dismissButton = self.dismissButton;
		if(dismissButton)
			[container bringSubviewToFront:dismissButton];
		
		[oldViewController.view removeFromSuperview];
		
		if(rootViewAppeared)
		{
			[oldViewController endAppearanceTransition];
			[newViewController endAppearanceTransition];
		}
		
		[oldViewController removeFromParentViewController];
		[newViewController didMoveToParentViewController:self];
	}
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (void)initializeProperties:(JFDrawerController*)controller
{
	NSOperationQueue* queue = [NSOperationQueue new];
	queue.maxConcurrentOperationCount = 1;
	
	// Observers
	controller->_observersController = [JFObserversController<id<JFDrawerControllerObserver>> new];
	
	// User interface
	controller->_animationQueue = queue;
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

- (void)beginLeftViewTransition:(BOOL)appearing animated:(BOOL)animated
{
	self.leftViewAnimating = animated;
	
	if(appearing)
		self.leftViewAppearing = YES;
	else
		self.leftViewDisappearing = YES;
	
	[self.leftViewController beginAppearanceTransition:appearing animated:animated];
}

- (void)beginRightViewTransition:(BOOL)appearing animated:(BOOL)animated
{
	self.rightViewAnimating = animated;
	
	if(appearing)
		self.rightViewAppearing = YES;
	else
		self.rightViewDisappearing = YES;
	
	[self.rightViewController beginAppearanceTransition:appearing animated:animated];
}

- (void)beginRootViewTransition:(BOOL)appearing animated:(BOOL)animated
{
	self.rootViewAnimating = animated;
	
	if(appearing)
		self.rootViewAppearing = YES;
	else
		self.rootViewDisappearing = YES;
	
	[self.rootViewController beginAppearanceTransition:appearing animated:animated];
}

- (void)dismissAllDrawers:(BOOL)animated completion:(JFBlock __nullable)completion
{
	if(![self hasLeftViewAppeared] && ![self hasRightViewAppeared])
	{
		if(completion)
			[MainOperationQueue addOperationWithBlock:completion];
		return;
	}
	
	BOOL leftDrawerAbove = (self.leftDrawerMode == JFDrawerControllerModeAbove);
	self.leftContainerLeftToViewLeftConstraint.active = !leftDrawerAbove;
	self.rootContainerLeftToLeftContainerRightConstraint.active = leftDrawerAbove;
	self.rootContainerLeftToViewLeftConstraint.active = YES;

	BOOL rightDrawerAbove = (self.rightDrawerMode == JFDrawerControllerModeAbove);
	self.rightContainerRightToViewRightConstraint.active = !rightDrawerAbove;
	self.rootContainerRightToRightContainerLeftConstraint.active = rightDrawerAbove;
	self.rootContainerRightToViewRightConstraint.active = YES;
	
	JFWeakifySelf;
	JFBlock animations = ^(void)
	{
		[weakSelf.view layoutIfNeeded];
	};
	
	[UIView animateWithDuration:(animated ? JFAnimationDuration : 0.0) animations:animations completion:^(BOOL finished) {
		if(completion)
			completion();
	}];
}

- (void)endLeftViewTransition
{
	UIViewController* viewController = self.leftViewController;
	
	if([self isLeftViewAppearing])
	{
		[viewController endAppearanceTransition];
		self.leftViewAnimating = NO;
		self.leftViewAppearing = NO;
		self.leftViewAppeared = YES;
	}
	
	if([self isLeftViewDisappearing])
	{
		[viewController endAppearanceTransition];
		self.leftViewAnimating = NO;
		self.leftViewDisappearing = NO;
		self.leftViewAppeared = NO;
	}
}

- (void)endRightViewTransition
{
	UIViewController* viewController = self.rightViewController;
	
	if([self isRightViewAppearing])
	{
		[viewController endAppearanceTransition];
		self.rightViewAnimating = NO;
		self.rightViewAppearing = NO;
		self.rightViewAppeared = YES;
	}
	
	if([self isRightViewDisappearing])
	{
		[viewController endAppearanceTransition];
		self.rightViewAnimating = NO;
		self.rightViewDisappearing = NO;
		self.rightViewAppeared = NO;
	}
}

- (void)endRootViewTransition
{
	UIViewController* viewController = self.rootViewController;
	
	if([self isRootViewAppearing])
	{
		[viewController endAppearanceTransition];
		self.rootViewAnimating = NO;
		self.rootViewAppearing = NO;
		self.rootViewAppeared = YES;
	}
	
	if([self isRootViewDisappearing])
	{
		[viewController endAppearanceTransition];
		self.rootViewAnimating = NO;
		self.rootViewDisappearing = NO;
		self.rootViewAppeared = NO;
	}
}

- (void)presentLeftDrawer:(BOOL)animated completion:(JFBlock __nullable)completion
{
	if([self hasLeftViewAppeared])
	{
		if(completion)
			[MainOperationQueue addOperationWithBlock:completion];
		return;
	}
	
	if([self hasRightViewAppeared])
	{
		JFWeakifySelf;
		[self dismissAllDrawers:animated completion:^{
			[weakSelf presentLeftDrawer:animated completion:completion];
		}];
		return;
	}
	
	BOOL leftDrawerAbove = (self.leftDrawerMode == JFDrawerControllerModeAbove);
	self.leftContainerLeftToViewLeftConstraint.active = YES;
	self.rootContainerLeftToLeftContainerRightConstraint.active = !leftDrawerAbove;
	self.rootContainerLeftToViewLeftConstraint.active = leftDrawerAbove;
	self.rootContainerRightToViewRightConstraint.active = leftDrawerAbove;

	JFWeakifySelf;
	JFBlock animations = ^(void)
	{
		[weakSelf.view layoutIfNeeded];
	};
	
	[UIView animateWithDuration:(animated ? JFAnimationDuration : 0.0) animations:animations completion:^(BOOL finished) {
		if(completion)
			completion();
	}];
}

- (void)presentRightDrawer:(BOOL)animated completion:(JFBlock __nullable)completion
{
	if([self hasRightViewAppeared])
	{
		if(completion)
			[MainOperationQueue addOperationWithBlock:completion];
		return;
	}
	
	if([self hasLeftViewAppeared])
	{
		JFWeakifySelf;
		[self dismissAllDrawers:animated completion:^{
			[weakSelf presentRightDrawer:animated completion:completion];
		}];
		return;
	}
	
	BOOL rightDrawerAbove = (self.rightDrawerMode == JFDrawerControllerModeAbove);
	self.rightContainerRightToViewRightConstraint.active = YES;
	self.rootContainerLeftToLeftContainerRightConstraint.active = !rightDrawerAbove;
	self.rootContainerLeftToViewLeftConstraint.active = rightDrawerAbove;
	self.rootContainerRightToViewRightConstraint.active = rightDrawerAbove;
	
	JFWeakifySelf;
	JFBlock animations = ^(void)
	{
		[weakSelf.view layoutIfNeeded];
	};
	
	[UIView animateWithDuration:(animated ? JFAnimationDuration : 0.0) animations:animations completion:^(BOOL finished) {
		if(completion)
			completion();
	}];
}

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
// MARK: Methods - User interface management (Actions)
// =================================================================================================

- (IBAction)dismissButtonTapped:(UIButton*)sender
{
	[self dismissAllDrawers:[self hasViewAppeared] completion:nil];
}

// =================================================================================================
// MARK: Methods - User interface management (Layout)
// =================================================================================================

- (void)installDismissButton
{
	UIButton* button = self.dismissButton;
	if(!button)
	{
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.autoresizingMask = ViewAutoresizingFlexibleSize;
		[button addTarget:self action:@selector(dismissButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		self.dismissButton = button;
	}
	
	UIView* rootContainer = self.rootContainer;
	button.frame = rootContainer.bounds;
	[rootContainer addSubview:button];
}

- (void)rebuildConstraints
{
	// Prepares some shortcuts.
	static __unused NSLayoutAttribute ab = NSLayoutAttributeBottom;
	static __unused NSLayoutAttribute al = NSLayoutAttributeLeft;
	static __unused NSLayoutAttribute ar = NSLayoutAttributeRight;
	static __unused NSLayoutAttribute at = NSLayoutAttributeTop;
	static __unused NSLayoutAttribute ah = NSLayoutAttributeHeight;
	static __unused NSLayoutAttribute aw = NSLayoutAttributeWidth;
	static __unused NSLayoutAttribute an = NSLayoutAttributeNotAnAttribute;
	static __unused NSLayoutAttribute ax = NSLayoutAttributeCenterX;
	static __unused NSLayoutAttribute ay = NSLayoutAttributeCenterY;
	static __unused NSLayoutRelation re = NSLayoutRelationEqual;
	static __unused NSLayoutRelation rg = NSLayoutRelationGreaterThanOrEqual;
	static __unused NSLayoutRelation rl = NSLayoutRelationLessThanOrEqual;
	
	UIView* left = self.leftContainer;
	UIView* right = self.rightContainer;
	UIView* root = self.rootContainer;
	UIView* view = self.view;
	
	CGFloat viewWidth = view.bounds.size.width;
	
	CGFloat leftWidth = viewWidth - self.leftDrawerOffset;
	CGFloat rightWidth = viewWidth - self.rightDrawerOffset;
	
	BOOL leftHidden = [self isLeftDrawerHidden];
	BOOL rightHidden = [self isRightDrawerHidden];
	
	BOOL leftAbove = (self.leftDrawerMode == JFDrawerControllerModeAbove);
	BOOL rightAbove = (self.rightDrawerMode == JFDrawerControllerModeAbove);
	
	NSDictionary* views = NSDictionaryOfVariableBindings(left, right, root);
	
	NSMutableArray<NSLayoutConstraint*>* constraints = ([self.customConstraints mutableCopy] ?: [NSMutableArray<NSLayoutConstraint*> array]);
	NSMutableArray<NSLayoutConstraint*>* disabledConstraints = [NSMutableArray<NSLayoutConstraint*> array];
	
	// Removes the old constraints.
	[view removeConstraints:constraints];
	[constraints removeAllObjects];
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[root]-|" options:0 metrics:nil views:views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[left]-|" options:0 metrics:nil views:views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[right]-|" options:0 metrics:nil views:views]];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:root attribute:aw relatedBy:re toItem:nil attribute:an multiplier:1.0f constant:viewWidth]];
	
	NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:left attribute:aw relatedBy:re toItem:nil attribute:an multiplier:1.0f constant:leftWidth];
	[constraints addObject:constraint];
	self.leftContainerWidthConstraint = constraint;
	
	constraint = [NSLayoutConstraint constraintWithItem:right attribute:aw relatedBy:re toItem:nil attribute:an multiplier:1.0f constant:rightWidth];
	[constraints addObject:constraint];
	self.rightContainerWidthConstraint = constraint;
	
	constraint = [NSLayoutConstraint constraintWithItem:root attribute:al relatedBy:re toItem:view attribute:al multiplier:1.0f constant:0.0f];
	[((leftAbove || leftHidden) ? constraints : disabledConstraints) addObject:constraint];
	self.rootContainerLeftToViewLeftConstraint = constraint;
	
	constraint = [NSLayoutConstraint constraintWithItem:root attribute:ar relatedBy:re toItem:view attribute:ar multiplier:1.0f constant:0.0f];
	[((rightAbove || rightHidden) ? constraints : disabledConstraints) addObject:constraint];
	self.rootContainerRightToViewRightConstraint = constraint;
	
	constraint = [NSLayoutConstraint constraintWithItem:left attribute:al relatedBy:re toItem:view attribute:al multiplier:1.0f constant:0.0f];
	[((leftAbove != leftHidden) ? constraints : disabledConstraints) addObject:constraint];
	self.leftContainerLeftToViewLeftConstraint = constraint;
	
	constraint = [NSLayoutConstraint constraintWithItem:right attribute:ar relatedBy:re toItem:view attribute:ar multiplier:1.0f constant:0.0f];
	[((rightAbove != rightHidden) ? constraints : disabledConstraints) addObject:constraint];
	self.rightContainerRightToViewRightConstraint = constraint;
	
	constraint = [NSLayoutConstraint constraintWithItem:root attribute:al relatedBy:re toItem:left attribute:ar multiplier:1.0f constant:0.0f];
	[((leftAbove == leftHidden) ? constraints : disabledConstraints) addObject:constraint];
	self.rootContainerLeftToLeftContainerRightConstraint = constraint;
	
	constraint = [NSLayoutConstraint constraintWithItem:root attribute:ar relatedBy:re toItem:right attribute:al multiplier:1.0f constant:0.0f];
	[((rightAbove == rightHidden) ? constraints : disabledConstraints) addObject:constraint];
	self.rootContainerRightToRightContainerLeftConstraint = constraint;
	
	// Saves the new constraints.
	[view addConstraints:constraints];
	[constraints addObjectsFromArray:disabledConstraints];
	self.customConstraints = [constraints copy];
}

- (void)uninstallDismissButton
{
	[self.dismissButton removeFromSuperview];
}

// =================================================================================================
// MARK: Methods - User interface management (View lifecycle)
// =================================================================================================

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
	return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.viewAnimating = NO;
	self.viewAppearing = NO;
	self.viewAppeared = YES;
	
	[self endRootViewTransition];
	[self endLeftViewTransition];
	[self endRightViewTransition];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	self.viewAnimating = NO;
	self.viewDisappearing = NO;
	self.viewAppeared = NO;
	
	[self endRootViewTransition];
	[self endLeftViewTransition];
	[self endRightViewTransition];
}

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
	leftContainer.hidden = [self isLeftDrawerHidden];
	leftContainer.opaque = YES;
	leftContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.leftContainer = leftContainer;
	
	UIView* rightContainer = [[UIView alloc] initWithFrame:rightFrame];
	rightContainer.autoresizingMask = autoresizingMask;
	rightContainer.backgroundColor = [UIColor blackColor];
	rightContainer.hidden = [self isRightDrawerHidden];
	rightContainer.opaque = YES;
	rightContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.rightContainer = rightContainer;
	
	UIView* rootContainer = [[UIView alloc] initWithFrame:bounds];
	rootContainer.autoresizingMask = autoresizingMask;
	rootContainer.backgroundColor = [UIColor blackColor];
	rootContainer.opaque = YES;
	rootContainer.translatesAutoresizingMaskIntoConstraints = NO;
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
	
	[self rebuildConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.viewAnimating = animated;
	self.viewAppearing = YES;
	
	[self beginRootViewTransition:YES animated:animated];
	
	if(![self isLeftDrawerHidden])
		[self beginLeftViewTransition:YES animated:animated];
	
	if(![self isRightDrawerHidden])
		[self beginRightViewTransition:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	self.viewAnimating = animated;
	self.viewDisappearing = YES;
	
	[self beginRootViewTransition:NO animated:animated];
	
	if(![self isLeftDrawerHidden])
		[self beginLeftViewTransition:NO animated:animated];
	
	if(![self isRightDrawerHidden])
		[self beginRightViewTransition:NO animated:animated];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
