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

@property (strong, nonatomic, readonly)	JFObserversController<id<JFOverlayControllerObserver>>*	observersController;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@property (assign, nonatomic, getter=hasOverlayViewAppeared) BOOL overlayViewAppeared;
@property (assign, nonatomic, getter=hasRootViewAppeared) BOOL rootViewAppeared;
@property (assign, nonatomic) BOOL shouldEndOverlayAppearanceTransitionOnDidAppear;
@property (assign, nonatomic) BOOL shouldEndOverlayAppearanceTransitionOnDidDisappear;
@property (assign, nonatomic) BOOL shouldEndRootAppearanceTransitionOnDidAppear;
@property (assign, nonatomic) BOOL shouldEndRootAppearanceTransitionOnDidDisappear;
@property (assign, nonatomic, getter=hasViewAppeared) BOOL viewAppeared;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@property (strong, nonatomic, nullable) UIView* overlayContainer;
@property (strong, nonatomic, nullable) UIView* rootContainer;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (void)initializeProperties:(JFOverlayController*)controller;

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

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

@synthesize overlayBackgroundColor = _overlayBackgroundColor;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@synthesize overlayViewController = _overlayViewController;
@synthesize rootViewController = _rootViewController;

// =================================================================================================
// MARK: Properties accessors - User interface
// =================================================================================================

- (void)setOverlayHidden:(BOOL)overlayHidden
{
	if(_overlayHidden == overlayHidden)
		return;
	
	JFObserversController* observersController = self.observersController;
	
	[observersController notifyObservers:^(id<JFOverlayControllerObserver> observer) {
		if(overlayHidden && [observer respondsToSelector:@selector(overlayControllerOverlayWillDisappear:)])
			[observer overlayControllerOverlayWillDisappear:self];
		else if(!overlayHidden && [observer respondsToSelector:@selector(overlayControllerOverlayWillAppear:)])
			[observer overlayControllerOverlayWillAppear:self];
	} async:NO];

	_overlayHidden = overlayHidden;
	
	if([self isViewLoaded])
	{
		BOOL opaque = [self isOverlayOpaque];
		UIViewController* overlayViewController = self.overlayViewController;
		UIViewController* rootViewController = self.rootViewController;

		if(opaque)
		{
			if([self shouldEndRootAppearanceTransitionOnDidAppear])
			{
				self.shouldEndRootAppearanceTransitionOnDidAppear = NO;
				[rootViewController endAppearanceTransition];
				self.rootViewAppeared = YES;
			}
			
			if([self shouldEndRootAppearanceTransitionOnDidDisappear])
			{
				self.shouldEndRootAppearanceTransitionOnDidDisappear = NO;
				[rootViewController endAppearanceTransition];
				self.rootViewAppeared = NO;
			}
		}
		
		if([self shouldEndOverlayAppearanceTransitionOnDidAppear])
		{
			self.shouldEndOverlayAppearanceTransitionOnDidAppear = NO;
			[overlayViewController endAppearanceTransition];
			self.overlayViewAppeared = YES;
		}
		
		if([self shouldEndOverlayAppearanceTransitionOnDidDisappear])
		{
			self.shouldEndOverlayAppearanceTransitionOnDidDisappear = NO;
			[overlayViewController endAppearanceTransition];
			self.overlayViewAppeared = NO;
		}
		
		BOOL overlayViewAppeared = [self hasOverlayViewAppeared];
		BOOL rootViewAppeared = [self hasRootViewAppeared];
		BOOL viewAppeared = [self hasViewAppeared];

		BOOL performOverlayAppearanceTransition = ((overlayViewAppeared || viewAppeared) && (overlayViewAppeared != !overlayHidden));
		BOOL performRootAppearanceTransition = (opaque && (rootViewAppeared || viewAppeared) && (rootViewAppeared != overlayHidden));

		if(performRootAppearanceTransition)
			[rootViewController beginAppearanceTransition:overlayHidden animated:NO];
		
		if(performOverlayAppearanceTransition)
			[overlayViewController beginAppearanceTransition:!overlayHidden animated:NO];
		
		self.overlayContainer.hidden = overlayHidden;
		
		if(performRootAppearanceTransition)
		{
			[rootViewController endAppearanceTransition];
			self.rootViewAppeared = overlayHidden;
		}
		
		if(performOverlayAppearanceTransition)
		{
			[overlayViewController endAppearanceTransition];
			self.overlayViewAppeared = !overlayHidden;
		}
	}
	
	[observersController notifyObservers:^(id<JFOverlayControllerObserver> observer) {
		if(overlayHidden && [observer respondsToSelector:@selector(overlayControllerOverlayDidDisappear:)])
			[observer overlayControllerOverlayDidDisappear:self];
		else if(!overlayHidden && [observer respondsToSelector:@selector(overlayControllerOverlayDidAppear:)])
			[observer overlayControllerOverlayDidAppear:self];
	} async:NO];
}

- (void)setOverlayOpaque:(BOOL)overlayOpaque
{
	if(_overlayOpaque == overlayOpaque)
		return;
	
	_overlayOpaque = overlayOpaque;
	
	if([self isViewLoaded] && ![self isOverlayHidden])
	{
		UIViewController* rootViewController = self.rootViewController;
		
		if([self shouldEndRootAppearanceTransitionOnDidAppear])
		{
			self.shouldEndRootAppearanceTransitionOnDidAppear = NO;
			[rootViewController endAppearanceTransition];
			self.rootViewAppeared = YES;
		}
		
		if([self shouldEndRootAppearanceTransitionOnDidDisappear])
		{
			self.shouldEndRootAppearanceTransitionOnDidDisappear = NO;
			[rootViewController endAppearanceTransition];
			self.rootViewAppeared = NO;
		}
		
		BOOL rootViewAppeared = [self hasRootViewAppeared];
		if((rootViewAppeared || [self hasViewAppeared]) && (rootViewAppeared != !overlayOpaque))
		{
			[rootViewController beginAppearanceTransition:!overlayOpaque animated:NO];
			
			self.overlayContainer.opaque = overlayOpaque;
			[self updateOverlayBackgroundColor];
			
			[rootViewController endAppearanceTransition];
			self.rootViewAppeared = !overlayOpaque;
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
	
	_overlayViewController = overlayViewController;
	
	if([self isViewLoaded])
	{
		if([self shouldEndOverlayAppearanceTransitionOnDidAppear])
		{
			self.shouldEndOverlayAppearanceTransitionOnDidAppear = NO;
			[oldViewController endAppearanceTransition];
			self.overlayViewAppeared = YES;
		}
		
		if([self shouldEndOverlayAppearanceTransitionOnDidDisappear])
		{
			self.shouldEndOverlayAppearanceTransitionOnDidDisappear = NO;
			[oldViewController endAppearanceTransition];
			self.overlayViewAppeared = NO;
		}
		
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
	
	_rootViewController = rootViewController;
	
	if([self isViewLoaded])
	{
		if([self shouldEndRootAppearanceTransitionOnDidAppear])
		{
			self.shouldEndRootAppearanceTransitionOnDidAppear = NO;
			[oldViewController endAppearanceTransition];
			self.rootViewAppeared = YES;
		}
		
		if([self shouldEndRootAppearanceTransitionOnDidDisappear])
		{
			self.shouldEndRootAppearanceTransitionOnDidDisappear = NO;
			[oldViewController endAppearanceTransition];
			self.rootViewAppeared = NO;
		}
		
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
// MARK: Methods - Memory management
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
// MARK: Methods - Observers management
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
// MARK: Methods - User interface management
// =================================================================================================

- (void)updateOverlayBackgroundColor
{
	UIColor* color = self.overlayBackgroundColor;
	self.overlayContainer.backgroundColor = ([self isOverlayOpaque] ? [color colorWithAlphaComponent:1.0] : color);
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
	
	self.viewAppeared = YES;
	
	if([self shouldEndRootAppearanceTransitionOnDidAppear])
	{
		self.shouldEndRootAppearanceTransitionOnDidAppear = NO;
		[self.rootViewController endAppearanceTransition];
		self.rootViewAppeared = YES;
	}
	
	if([self shouldEndOverlayAppearanceTransitionOnDidAppear])
	{
		self.shouldEndOverlayAppearanceTransitionOnDidAppear = NO;
		[self.overlayViewController endAppearanceTransition];
		self.overlayViewAppeared = YES;
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	self.viewAppeared = NO;
	
	if([self shouldEndRootAppearanceTransitionOnDidDisappear])
	{
		self.shouldEndRootAppearanceTransitionOnDidDisappear = NO;
		[self.rootViewController endAppearanceTransition];
		self.rootViewAppeared = NO;
	}

	if([self shouldEndOverlayAppearanceTransitionOnDidDisappear])
	{
		self.shouldEndOverlayAppearanceTransitionOnDidDisappear = NO;
		[self.overlayViewController endAppearanceTransition];
		self.overlayViewAppeared = NO;
	}
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
	
	BOOL overlayHidden = [self isOverlayHidden];
	BOOL overlayOpaque = [self isOverlayOpaque];
	
	if(overlayHidden || !overlayOpaque)
	{
		self.shouldEndRootAppearanceTransitionOnDidAppear = YES;
		[self.rootViewController beginAppearanceTransition:YES animated:animated];
	}
	
	if(!overlayHidden)
	{
		self.shouldEndOverlayAppearanceTransitionOnDidAppear = YES;
		[self.overlayViewController beginAppearanceTransition:YES animated:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	BOOL overlayHidden = [self isOverlayHidden];
	BOOL overlayOpaque = [self isOverlayOpaque];
	
	if(overlayHidden || !overlayOpaque)
	{
		self.shouldEndRootAppearanceTransitionOnDidDisappear = YES;
		[self.rootViewController beginAppearanceTransition:NO animated:animated];
	}
	
	if(!overlayHidden)
	{
		self.shouldEndOverlayAppearanceTransitionOnDidDisappear = YES;
		[self.overlayViewController beginAppearanceTransition:NO animated:animated];
	}
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
