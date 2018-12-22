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

@import UIKit;

#import "JFBlocks.h"

@protocol JFDrawerControllerDelegate;
@protocol JFDrawerControllerObserver;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef NS_ENUM(UInt8, JFDrawerControllerMode)
{
	JFDrawerControllerModeAbove,
	JFDrawerControllerModeBelow,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFDrawerController : UIViewController

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (weak, nonatomic, nullable) id<JFDrawerControllerDelegate> delegate;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@property (assign, nonatomic) NSTimeInterval appearAnimationDuration;
@property (assign, nonatomic) NSTimeInterval disappearAnimationDuration;
@property (assign, nonatomic, readonly, getter=isLeftDrawerHidden) BOOL leftDrawerHidden;
@property (assign, nonatomic) JFDrawerControllerMode leftDrawerMode;
@property (assign, nonatomic) CGFloat leftDrawerOffset;
@property (assign, nonatomic, readonly, getter=isRightDrawerHidden) BOOL rightDrawerHidden;
@property (assign, nonatomic) JFDrawerControllerMode rightDrawerMode;
@property (assign, nonatomic) CGFloat rightDrawerOffset;

// =================================================================================================
// MARK: Properties - User interface (Gestures)
// =================================================================================================

@property (strong, nonatomic, readonly)	UIPanGestureRecognizer*	panGestureRecognizer;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@property (weak, nonatomic, nullable, readonly) UIViewController* keyViewController;
@property (strong, nonatomic, nullable) UIViewController* leftViewController;
@property (strong, nonatomic, nullable) UIViewController* rightViewController;
@property (strong, nonatomic, nullable) UIViewController* rootViewController;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype __nullable)initWithCoder:(NSCoder*)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString* __nullable)nibNameOrNil bundle:(NSBundle* __nullable)nibBundleOrNil NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Observers management
// =================================================================================================

- (void)addObserver:(id<JFDrawerControllerObserver>)observer;
- (void)removeObserver:(id<JFDrawerControllerObserver>)observer;

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (void)dismissAllDrawers:(BOOL)animated completion:(JFBlock __nullable)completion;
- (void)presentLeftDrawer:(BOOL)animated completion:(JFBlock __nullable)completion;
- (void)presentRightDrawer:(BOOL)animated completion:(JFBlock __nullable)completion;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@protocol JFDrawerControllerDelegate <NSObject>

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

@optional

- (UIInterfaceOrientation)drawerControllerPreferredInterfaceOrientationForPresentation:(JFDrawerController*)sender;
- (UIInterfaceOrientationMask)drawerControllerSupportedInterfaceOrientations:(JFDrawerController*)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@protocol JFDrawerControllerObserver <NSObject>

// =================================================================================================
// MARK: Methods - User interface management (Layout)
// =================================================================================================

@optional

- (void)drawerController:(JFDrawerController*)sender leftDrawerDidAppear:(BOOL)animated;
- (void)drawerController:(JFDrawerController*)sender leftDrawerDidDisappear:(BOOL)animated;
- (void)drawerController:(JFDrawerController*)sender leftDrawerWillAppear:(BOOL)animated;
- (void)drawerController:(JFDrawerController*)sender leftDrawerWillDisappear:(BOOL)animated;
- (void)drawerController:(JFDrawerController*)sender rightDrawerDidAppear:(BOOL)animated;
- (void)drawerController:(JFDrawerController*)sender rightDrawerDidDisappear:(BOOL)animated;
- (void)drawerController:(JFDrawerController*)sender rightDrawerWillAppear:(BOOL)animated;
- (void)drawerController:(JFDrawerController*)sender rightDrawerWillDisappear:(BOOL)animated;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
