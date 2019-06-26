//
//	The MIT License (MIT)
//
//	Copyright © 2017-2019 Jacopo Filié
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

#import "JFOverlayController.h"

#import "JFObserversController.h"
#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFOverlayController ()

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (strong, nonatomic, readonly) JFObserversController<id<JFOverlayControllerObserver>>* observersController;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@property (assign, nonatomic, getter=isOverlayViewAnimating) BOOL overlayViewAnimating;
@property (assign, nonatomic, getter=hasOverlayViewAppeared) BOOL overlayViewAppeared;
@property (assign, nonatomic, getter=isOverlayViewAppearing) BOOL overlayViewAppearing;
@property (assign, nonatomic, getter=isOverlayViewDisappearing) BOOL overlayViewDisappearing;
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

@property (weak, nonatomic, nullable) UIView* overlayContainer;
@property (weak, nonatomic, nullable) UIView* rootContainer;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (void)initializeProperties:(JFOverlayController*)controller;

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

- (void)beginOverlayViewTransition:(BOOL)appearing animated:(BOOL)animated;
- (void)beginRootViewTransition:(BOOL)appearing animated:(BOOL)animated;
- (void)endOverlayViewTransition;
- (void)endRootViewTransition;
- (void)updateOverlayBackgroundColor;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFOverlayController

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize observersController = _observersController;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize overlayHidden = _overlayHidden;
@synthesize overlayOpaque = _overlayOpaque;
@synthesize overlayViewAnimating = _overlayViewAnimating;
@synthesize overlayViewAppeared = _overlayViewAppeared;
@synthesize overlayViewAppearing = _overlayViewAppearing;
@synthesize overlayViewDisappearing = _overlayViewDisappearing;
@synthesize rootViewAnimating = _rootViewAnimating;
@synthesize rootViewAppeared = _rootViewAppeared;
@synthesize rootViewAppearing = _rootViewAppearing;
@synthesize rootViewDisappearing = _rootViewDisappearing;
@synthesize viewAnimating = _viewAnimating;
@synthesize viewAppeared = _viewAppeared;
@synthesize viewAppearing = _viewAppearing;
@synthesize viewDisappearing = _viewDisappearing;

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

@synthesize overlayBackgroundColor = _overlayBackgroundColor;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@synthesize overlayContainer = _overlayContainer;
@synthesize overlayViewController = _overlayViewController;
@synthesize rootContainer = _rootContainer;
@synthesize rootViewController = _rootViewController;

// =================================================================================================
// MARK: Properties accessors - User interface
// =================================================================================================

- (void)setOverlayHidden:(BOOL)overlayHidden
{
	[self setOverlayHidden:overlayHidden animated:NO completion:nil];
}

- (void)setOverlayHidden:(BOOL)overlayHidden animated:(BOOL)animated
{
	[self setOverlayHidden:overlayHidden animated:animated completion:nil];
}

- (void)setOverlayHidden:(BOOL)overlayHidden animated:(BOOL)animated completion:(JFBlock __nullable)completion
{
	if(_overlayHidden == overlayHidden)
	{
		if(completion)
			[MainOperationQueue addOperationWithBlock:completion];
		return;
	}
	
	//NSLog(@" ");
	//NSLog(@"%@: %@ [hidden = %@] [animated = %@]", JFStringFromObject(self), NSStringFromSelector(_cmd), JFStringFromBOOL(overlayHidden), JFStringFromBOOL(animated));
	
	_overlayHidden = overlayHidden;
	
	if([self isViewLoaded])
	{
		BOOL opaque = [self isOverlayOpaque];
		
		if(opaque)
			[self endRootViewTransition];
		
		[self endOverlayViewTransition];
		
		BOOL overlayViewAppeared = [self hasOverlayViewAppeared];
		BOOL rootViewAppeared = [self hasRootViewAppeared];
		BOOL viewAppeared = [self hasViewAppeared];
		
		BOOL performOverlayAppearanceTransition = ((overlayViewAppeared || viewAppeared) && (overlayViewAppeared != !overlayHidden));
		BOOL performRootAppearanceTransition = (opaque && (rootViewAppeared || viewAppeared) && (rootViewAppeared != overlayHidden));
		
		if(performRootAppearanceTransition)
			[self beginRootViewTransition:overlayHidden animated:animated];
		
		if(performOverlayAppearanceTransition)
			[self beginOverlayViewTransition:!overlayHidden animated:animated];
		
		NSTimeInterval duration = (animated ? JFAnimationDuration : 0.0);
		UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve);
		UIView* view = self.overlayContainer;
		
		JFBlock animations = ^(void) {
			view.hidden = overlayHidden;
		};
		
		[UIView transitionWithView:view duration:duration options:options animations:animations completion:^(BOOL finished) {
			if(finished)
			{
				if(performRootAppearanceTransition)
					[self endRootViewTransition];
				
				if(performOverlayAppearanceTransition)
					[self endOverlayViewTransition];
			}
			
			if(completion)
				[MainOperationQueue addOperationWithBlock:completion];
		}];
	}
	else if(completion)
		[MainOperationQueue addOperationWithBlock:completion];
}

- (void)setOverlayOpaque:(BOOL)overlayOpaque
{
	if(_overlayOpaque == overlayOpaque)
		return;
	
	//NSLog(@" ");
	//NSLog(@"%@: %@ [opaque = %@]", JFStringFromObject(self), NSStringFromSelector(_cmd), JFStringFromBOOL(overlayOpaque));
	
	_overlayOpaque = overlayOpaque;
	
	if([self isViewLoaded] && ![self isOverlayHidden])
	{
		[self endRootViewTransition];
		
		BOOL rootViewAppeared = [self hasRootViewAppeared];
		if((rootViewAppeared || [self hasViewAppeared]) && (rootViewAppeared != !overlayOpaque))
		{
			[self beginRootViewTransition:!overlayOpaque animated:NO];
			
			self.overlayContainer.opaque = overlayOpaque;
			[self updateOverlayBackgroundColor];
			
			[self endRootViewTransition];
		}
	}
}

// =================================================================================================
// MARK: Properties accessors - User interface (Appearance)
// =================================================================================================

- (void)setOverlayBackgroundColor:(UIColor* __nullable)overlayBackgroundColor
{
	if(JFAreObjectsEqual(_overlayBackgroundColor, overlayBackgroundColor))
		return;
	
	_overlayBackgroundColor = overlayBackgroundColor;
	
	if([self isViewLoaded])
		[self updateOverlayBackgroundColor];
}

// =================================================================================================
// MARK: Properties accessors - User interface (Layout)
// =================================================================================================

- (void)setOverlayViewController:(UIViewController* __nullable)overlayViewController
{
	if(_overlayViewController == overlayViewController)
		return;
	
	UIViewController* oldViewController = _overlayViewController;
	UIViewController* newViewController = overlayViewController;
	
	//NSLog(@" ");
	//NSLog(@"%@: %@ [old = %@] [new = %@]", JFStringFromObject(self), NSStringFromSelector(_cmd), JFStringFromObject(oldViewController), JFStringFromObject(newViewController));
	
	if([self isViewLoaded])
		[self endOverlayViewTransition];
	
	_overlayViewController = overlayViewController;
	
	if([self isViewLoaded])
	{
		BOOL overlayViewAppeared = [self hasOverlayViewAppeared];
		
		[oldViewController willMoveToParentViewController:nil];
		[self addChildViewController:newViewController];
		
		if(overlayViewAppeared)
		{
			[oldViewController beginAppearanceTransition:NO animated:NO];
			[newViewController beginAppearanceTransition:YES animated:NO];
		}
		
		UIView* container = self.overlayContainer;
		UIView* view = newViewController.view;
		
		view.autoresizingMask = ViewAutoresizingFlexibleSize;
		view.frame = container.bounds;
		view.translatesAutoresizingMaskIntoConstraints = YES;
		[container addSubview:view];
		
		[oldViewController.view removeFromSuperview];
		
		if(overlayViewAppeared)
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
	
	//NSLog(@" ");
	//NSLog(@"%@: %@ [old = %@] [new = %@]", JFStringFromObject(self), NSStringFromSelector(_cmd), JFStringFromObject(oldViewController), JFStringFromObject(newViewController));
	
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
// MARK: Methods - Memory
// =================================================================================================

+ (void)initializeProperties:(JFOverlayController*)controller
{
	// Observers
	controller->_observersController = [JFObserversController<id<JFOverlayControllerObserver>> new];
	
	// User interface
	controller->_overlayHidden = YES;
	controller->_overlayOpaque = YES;
}

- (instancetype __nullable)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[JFOverlayController initializeProperties:self];
	}
	return self;
}

- (instancetype)initWithNibName:(NSString* __nullable)nibNameOrNil bundle:(NSBundle* __nullable)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	[JFOverlayController initializeProperties:self];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)addObserver:(id<JFOverlayControllerObserver>)observer
{
	[self.observersController addObserver:observer];
}

- (void)removeObserver:(id<JFOverlayControllerObserver>)observer
{
	[self.observersController removeObserver:observer];
}

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

- (void)beginOverlayViewTransition:(BOOL)appearing animated:(BOOL)animated
{
	JFObserversController<id<JFOverlayControllerObserver>>* observersController = self.observersController;
	
	self.overlayViewAnimating = animated;
	
	if(appearing)
	{
		self.overlayViewAppearing = YES;
		
		[observersController notifyObservers:^(id<JFOverlayControllerObserver> observer) {
			if([observer respondsToSelector:@selector(overlayController:overlayWillAppear:)])
				[observer overlayController:self overlayWillAppear:animated];
		} async:NO];
	}
	else
	{
		self.overlayViewDisappearing = YES;
		
		[observersController notifyObservers:^(id<JFOverlayControllerObserver> observer) {
			if([observer respondsToSelector:@selector(overlayController:overlayWillDisappear:)])
				[observer overlayController:self overlayWillDisappear:animated];
		} async:NO];
	}
	
	[self.overlayViewController beginAppearanceTransition:appearing animated:animated];
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

- (void)endOverlayViewTransition
{
	JFObserversController<id<JFOverlayControllerObserver>>* observersController = self.observersController;
	UIViewController* viewController = self.overlayViewController;
	
	if([self isOverlayViewAppearing])
	{
		BOOL animated = [self isOverlayViewAnimating];
		
		[viewController endAppearanceTransition];
		self.overlayViewAnimating = NO;
		self.overlayViewAppearing = NO;
		self.overlayViewAppeared = YES;
		
		[observersController notifyObservers:^(id<JFOverlayControllerObserver> observer) {
			if([observer respondsToSelector:@selector(overlayController:overlayDidAppear:)])
				[observer overlayController:self overlayDidAppear:animated];
		} async:NO];
	}
	
	if([self isOverlayViewDisappearing])
	{
		BOOL animated = [self isOverlayViewAnimating];
		
		[viewController endAppearanceTransition];
		self.overlayViewAnimating = NO;
		self.overlayViewDisappearing = NO;
		self.overlayViewAppeared = NO;
		
		[observersController notifyObservers:^(id<JFOverlayControllerObserver> observer) {
			if([observer respondsToSelector:@selector(overlayController:overlayDidDisappear:)])
				[observer overlayController:self overlayDidDisappear:animated];
		} async:NO];
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

- (void)updateOverlayBackgroundColor
{
	UIColor* color = self.overlayBackgroundColor;
	self.overlayContainer.backgroundColor = ([self isOverlayOpaque] ? [color colorWithAlphaComponent:1.0] : color);
}

// =================================================================================================
// MARK: Methods - Layout (View lifecycle)
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
	[self endOverlayViewTransition];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	self.viewAnimating = NO;
	self.viewDisappearing = NO;
	self.viewAppeared = NO;
	
	[self endRootViewTransition];
	[self endOverlayViewTransition];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIView* view = self.view;
	
	UIViewAutoresizing autoresizingMask = ViewAutoresizingFlexibleSize;
	CGRect bounds = view.bounds;
	
	UIView* rootContainer = [[UIView alloc] initWithFrame:bounds];
	rootContainer.autoresizingMask = autoresizingMask;
	rootContainer.backgroundColor = [UIColor clearColor];
	rootContainer.opaque = NO;
	self.rootContainer = rootContainer;
	
	BOOL overlayHidden = [self isOverlayHidden];
	BOOL overlayOpaque = [self isOverlayOpaque];
	
	UIView* overlayContainer = [[UIView alloc] initWithFrame:bounds];
	overlayContainer.autoresizingMask = autoresizingMask;
	overlayContainer.hidden = overlayHidden;
	overlayContainer.opaque = overlayOpaque;
	self.overlayContainer = overlayContainer;
	
	[view addSubview:rootContainer];
	[view addSubview:overlayContainer];
	
	[self updateOverlayBackgroundColor];
	
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
	
	UIViewController* overlayViewController = self.overlayViewController;
	if(overlayViewController)
	{
		[self addChildViewController:overlayViewController];
		overlayViewController.view.autoresizingMask = autoresizingMask;
		overlayViewController.view.frame = overlayContainer.bounds;
		overlayViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
		[overlayContainer addSubview:overlayViewController.view];
		[overlayViewController didMoveToParentViewController:self];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.viewAnimating = animated;
	self.viewAppearing = YES;
	
	BOOL overlayHidden = [self isOverlayHidden];
	BOOL overlayOpaque = [self isOverlayOpaque];
	
	if(overlayHidden || !overlayOpaque)
		[self beginRootViewTransition:YES animated:animated];
	
	if(!overlayHidden)
		[self beginOverlayViewTransition:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	self.viewAnimating = animated;
	self.viewDisappearing = YES;
	
	BOOL overlayHidden = [self isOverlayHidden];
	BOOL overlayOpaque = [self isOverlayOpaque];
	
	if(overlayHidden || !overlayOpaque)
		[self beginRootViewTransition:NO animated:animated];
	
	if(!overlayHidden)
		[self beginOverlayViewTransition:NO animated:animated];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
