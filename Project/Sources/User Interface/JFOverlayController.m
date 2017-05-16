//
//	The MIT License (MIT)
//
//	Copyright © 2017 Jacopo Filié
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

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN
@interface JFOverlayController ()

// MARK: Properties - Observers
@property (strong, nonatomic, readonly)	JFObserversController<id<JFOverlayControllerObserver>>*	observersController;

// MARK: Properties - User interface
@property (assign, nonatomic, readwrite, getter=isOverlayOpaque)	BOOL	overlayOpaque;
@property (strong, nonatomic, nullable)								UIView*	overlayViewContainer;
@property (assign, nonatomic, readwrite, getter=isOverlayVisible)	BOOL	overlayVisible;
@property (strong, nonatomic, nullable)								UIView*	rootViewContainer;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFOverlayController

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize observersController	= _observersController;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize overlayOpaque			= _overlayOpaque;
@synthesize overlayViewContainer	= _overlayViewContainer;
@synthesize overlayViewController	= _overlayViewController;
@synthesize overlayVisible			= _overlayVisible;
@synthesize rootViewContainer		= _rootViewContainer;
@synthesize rootViewController		= _rootViewController;

// =================================================================================================
// MARK: Properties accessors - User interface
// =================================================================================================

- (void)setOverlayOpaque:(BOOL)overlayOpaque
{
	if(_overlayOpaque == overlayOpaque)
		return;
	
	_overlayOpaque = overlayOpaque;
	
	if([self isViewLoaded] && [self isOverlayVisible])
	{
		UIViewController* controller = self.rootViewController;
		[controller beginAppearanceTransition:!overlayOpaque animated:NO];
		self.overlayViewContainer.opaque = overlayOpaque;
		[controller endAppearanceTransition];
	}
}

- (void)setOverlayViewController:(UIViewController* __nullable)overlayViewController
{
	if(_overlayViewController == overlayViewController)
		return;
	
	UIViewController* newController = overlayViewController;
	UIViewController* oldController = _overlayViewController;
	
	_overlayViewController = overlayViewController;
	
	if([self isViewLoaded])
	{
		BOOL isVisible = [self isOverlayVisible];
		
		if(oldController)
		{
			[oldController willMoveToParentViewController:nil];
			if(isVisible)
				[oldController beginAppearanceTransition:NO animated:NO];
			[oldController.view removeFromSuperview];
			if(isVisible)
				[oldController endAppearanceTransition];
			[oldController removeFromParentViewController];
		}
		
		if(newController)
		{
			UIView* container = self.overlayViewContainer;
			
			[self addChildViewController:newController];
			newController.view.frame = container.bounds;
			if(isVisible)
				[newController beginAppearanceTransition:YES animated:NO];
			[container addSubview:newController.view];
			[container sendSubviewToBack:newController.view];
			if(isVisible)
				[newController endAppearanceTransition];
			[newController didMoveToParentViewController:self];
		}
	}
}

- (void)setOverlayVisible:(BOOL)overlayVisible
{
	if(_overlayVisible == overlayVisible)
		return;
	
	_overlayVisible = overlayVisible;
}

- (void)setRootViewController:(UIViewController* __nullable)rootViewController
{
	if(_rootViewController == rootViewController)
		return;
	
	UIViewController* newController = rootViewController;
	UIViewController* oldController = _rootViewController;
	
	_rootViewController = rootViewController;
	
	if([self isViewLoaded])
	{
		BOOL isVisible = ![self isOverlayVisible];
		
		if(oldController)
		{
			[oldController willMoveToParentViewController:nil];
			if(isVisible)
				[oldController beginAppearanceTransition:NO animated:NO];
			[oldController.view removeFromSuperview];
			if(isVisible)
				[oldController endAppearanceTransition];
			[oldController removeFromParentViewController];
		}
		
		if(newController)
		{
			UIView* container = self.rootViewContainer;
			
			[self addChildViewController:newController];
			newController.view.frame = container.bounds;
			if(isVisible)
				[newController beginAppearanceTransition:YES animated:NO];
			[container addSubview:newController.view];
			[container sendSubviewToBack:newController.view];
			if(isVisible)
				[newController endAppearanceTransition];
			[newController didMoveToParentViewController:self];
		}
	}
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)initWithNibName:(NSString* __nullable)nibNameOrNil bundle:(NSBundle* __nullable)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{}
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

- (void)hideOverlay
{
	[self hideOverlay:NO completion:nil];
}

- (void)hideOverlay:(BOOL)animated completion:(JFBlock __nullable)completion
{}

- (void)showOverlay
{
	[self showOverlay:NO completion:nil];
}

- (void)showOverlay:(BOOL)animated completion:(JFBlock __nullable)completion
{}

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
	
	BOOL isOverlayOpaque = [self isOverlayOpaque];
	BOOL isOverlayVisible = ![self isOverlayVisible];
	
	if(!isOverlayVisible || !isOverlayOpaque)
		[self.rootViewController endAppearanceTransition];
	
	if(isOverlayVisible)
		[self.overlayViewController endAppearanceTransition];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	BOOL isOverlayOpaque = [self isOverlayOpaque];
	BOOL isOverlayVisible = ![self isOverlayVisible];
	
	if(!isOverlayVisible || !isOverlayOpaque)
		[self.rootViewController endAppearanceTransition];
	
	if(isOverlayVisible)
		[self.overlayViewController endAppearanceTransition];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIView* view = self.view;
	
	UIViewAutoresizing autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	CGRect frame = view.bounds;
	UIColor* backgroundColor = UIColor.clearColor;
	
	UIView* rootViewContainer = [[UIView alloc] initWithFrame:frame];
	rootViewContainer.autoresizingMask = autoresizingMask;
	rootViewContainer.backgroundColor = backgroundColor;
	self.rootViewContainer = rootViewContainer;
	[view addSubview:rootViewContainer];
	
	UIView* overlayViewContainer = [[UIView alloc] initWithFrame:frame];
	overlayViewContainer.autoresizingMask = autoresizingMask;
	overlayViewContainer.backgroundColor = backgroundColor;
	overlayViewContainer.hidden = ![self isOverlayVisible];
	overlayViewContainer.opaque = [self isOverlayOpaque];
	self.overlayViewContainer = overlayViewContainer;
	[view addSubview:overlayViewContainer];
	
	UIViewController* rootViewController = self.rootViewController;
	if(rootViewController)
	{
		[self addChildViewController:rootViewController];
		rootViewController.view.autoresizingMask = autoresizingMask;
		rootViewController.view.frame = rootViewContainer.bounds;
		[rootViewContainer addSubview:rootViewController.view];
		[rootViewController didMoveToParentViewController:self];
	}
	
	UIViewController* overlayViewController = self.overlayViewController;
	if(overlayViewController)
	{
		[self addChildViewController:overlayViewController];
		overlayViewController.view.autoresizingMask = autoresizingMask;
		overlayViewController.view.frame = overlayViewContainer.bounds;
		[overlayViewContainer addSubview:overlayViewController.view];
		[overlayViewController didMoveToParentViewController:self];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	BOOL isOverlayOpaque = [self isOverlayOpaque];
	BOOL isOverlayVisible = ![self isOverlayVisible];
	
	if(!isOverlayVisible || !isOverlayOpaque)
		[self.rootViewController beginAppearanceTransition:YES animated:animated];
	
	if(isOverlayVisible)
		[self.overlayViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	BOOL isOverlayOpaque = [self isOverlayOpaque];
	BOOL isOverlayVisible = ![self isOverlayVisible];
	
	if(!isOverlayVisible || !isOverlayOpaque)
		[self.rootViewController beginAppearanceTransition:NO animated:animated];
	
	if(isOverlayVisible)
		[self.overlayViewController beginAppearanceTransition:NO animated:animated];
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
