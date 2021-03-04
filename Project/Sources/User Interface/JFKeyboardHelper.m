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

////////////////////////////////////////////////////////////////////////////////////////////////////

#import "JFKeyboardHelper.h"

#import "JFBlocks.h"
#import "JFObserversController.h"
#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFKeyboardHelper (/* Private */)

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (strong, nonatomic, readonly) JFObserversController<id<JFKeyboardHelperObserver>>* observersController;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (UIViewAnimationOptions)animationOptionFromCurve:(UIViewAnimationCurve)curve;
- (JFKeyboardInfo*)extractInfoFromNotification:(NSNotification*)notification;

// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

- (void)notifiedDidChangeFrame:(NSNotification*)notification;
- (void)notifiedDidHide:(NSNotification*)notification;
- (void)notifiedDidShow:(NSNotification*)notification;
- (void)notifiedWillChangeFrame:(NSNotification*)notification;
- (void)notifiedWillHide:(NSNotification*)notification;
- (void)notifiedWillShow:(NSNotification*)notification;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFKeyboardHelper

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize observersController = _observersController;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize hiddenOffset = _hiddenOffset;
@synthesize visibleOffset = _visibleOffset;

// =================================================================================================
// MARK: Properties - User interface (Outlets)
// =================================================================================================

@synthesize resizableView = _resizableView;
@synthesize resizableViewBottomConstraint = _resizableViewBottomConstraint;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

- (void)dealloc
{
	[MainNotificationCenter removeObserver:self];
}

- (instancetype)init
{
	self = [super init];
	
	_observersController = [JFObserversController<id<JFKeyboardHelperObserver>> new];
	
	NSNotificationCenter* center = MainNotificationCenter;
	[center addObserver:self selector:@selector(notifiedDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
	[center addObserver:self selector:@selector(notifiedDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[center addObserver:self selector:@selector(notifiedDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[center addObserver:self selector:@selector(notifiedWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
	[center addObserver:self selector:@selector(notifiedWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[center addObserver:self selector:@selector(notifiedWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (UIViewAnimationOptions)animationOptionFromCurve:(UIViewAnimationCurve)curve
{
	switch(curve)
	{
		case UIViewAnimationCurveEaseIn:
			return UIViewAnimationOptionCurveEaseIn;
		case UIViewAnimationCurveEaseInOut:
			return UIViewAnimationOptionCurveEaseInOut;
		case UIViewAnimationCurveEaseOut:
			return UIViewAnimationOptionCurveEaseOut;
		case UIViewAnimationCurveLinear:
			return UIViewAnimationOptionCurveLinear;
		default:
			return (curve << 16); // FIX: Sometimes undocumented values are received so this should cover those cases.
	}
}

- (JFKeyboardInfo*)extractInfoFromNotification:(NSNotification*)notification
{
	NSDictionary* userInfo = notification.userInfo;
	
	UIViewAnimationCurve animationCurve = [(NSNumber*)userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval animationDuration = [(NSNumber*)userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	CGRect beginFrame = [(NSValue*)userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	CGRect endFrame = [(NSValue*)userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	return [[JFKeyboardInfo alloc] initWithFrame:beginFrame endFrame:endFrame animationCurve:animationCurve duration:animationDuration];
}

// =================================================================================================
// MARK: Methods - Notifications
// =================================================================================================

- (void)notifiedDidChangeFrame:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self extractInfoFromNotification:notification];
	[self.observersController notifyObservers:^(id<JFKeyboardHelperObserver> observer) {
		if([observer respondsToSelector:@selector(keyboardHelper:didChangeFrame:)])
			[observer keyboardHelper:self didChangeFrame:info];
	} async:NO];
}

- (void)notifiedDidHide:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self extractInfoFromNotification:notification];
	[self.observersController notifyObservers:^(id<JFKeyboardHelperObserver> observer) {
		if([observer respondsToSelector:@selector(keyboardHelper:didHide:)])
			[observer keyboardHelper:self didHide:info];
	} async:NO];
}

- (void)notifiedDidShow:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self extractInfoFromNotification:notification];
	[self.observersController notifyObservers:^(id<JFKeyboardHelperObserver> observer) {
		if([observer respondsToSelector:@selector(keyboardHelper:didShow:)])
			[observer keyboardHelper:self didShow:info];
	} async:NO];
}

- (void)notifiedWillChangeFrame:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self extractInfoFromNotification:notification];
	[self.observersController notifyObservers:^(id<JFKeyboardHelperObserver> observer) {
		if([observer respondsToSelector:@selector(keyboardHelper:willChangeFrame:)])
			[observer keyboardHelper:self willChangeFrame:info];
	} async:NO];
}

- (void)notifiedWillHide:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self extractInfoFromNotification:notification];
	
	NSLayoutConstraint* constraint = self.resizableViewBottomConstraint;
	UIView* view = self.resizableView;
	
	if(constraint && view)
	{
		UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | [self animationOptionFromCurve:info.animationCurve]);
		
		constraint.constant = self.hiddenOffset;
		[view.superview setNeedsLayout];
		
		JFBlock animations = ^(void)
		{
			[view.superview layoutIfNeeded];
		};
		
		[UIView animateWithDuration:info.animationDuration delay:0.0 options:options animations:animations completion:nil];
	}
	
	[self.observersController notifyObservers:^(id<JFKeyboardHelperObserver> observer) {
		if([observer respondsToSelector:@selector(keyboardHelper:willHide:)])
			[observer keyboardHelper:self willHide:info];
	} async:NO];
}

- (void)notifiedWillShow:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self extractInfoFromNotification:notification];
	
	NSLayoutConstraint* constraint = self.resizableViewBottomConstraint;
	UIView* view = self.resizableView;
	
	if(constraint && view)
	{
		UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | [self animationOptionFromCurve:info.animationCurve]);
		
		CGFloat height = CGRectGetHeight(info.endFrame);
		
		constraint.constant = height + self.visibleOffset;
		[view.superview setNeedsLayout];
		
		JFBlock animations = ^(void)
		{
			[view.superview layoutIfNeeded];
		};
		
		[UIView animateWithDuration:info.animationDuration delay:0.0 options:options animations:animations completion:nil];
	}
	
	[self.observersController notifyObservers:^(id<JFKeyboardHelperObserver> observer) {
		if([observer respondsToSelector:@selector(keyboardHelper:willShow:)])
			[observer keyboardHelper:self willShow:info];
	} async:NO];
}

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)addObserver:(id<JFKeyboardHelperObserver>)observer
{
	[self.observersController addObserver:observer];
}

- (void)removeObserver:(id<JFKeyboardHelperObserver>)observer
{
	[self.observersController removeObserver:observer];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFKeyboardInfo

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize animationCurve = _animationCurve;
@synthesize animationDuration = _animationDuration;
@synthesize beginFrame = _beginFrame;
@synthesize endFrame = _endFrame;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

- (instancetype)initWithFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)curve duration:(NSTimeInterval)duration
{
	self = [super init];
	
	_animationCurve = curve;
	_animationDuration = duration;
	_beginFrame = beginFrame;
	_endFrame = endFrame;
	
	return self;
}

// =================================================================================================
// MARK: Methods (NSCopying)
// =================================================================================================

- (id)copyWithZone:(NSZone* __nullable)zone
{
	if([self isMemberOfClass:[JFKeyboardInfo class]])
		return self;
	
	__typeof(self) retObj = [[[self class] allocWithZone:zone] init];
	
	retObj->_animationCurve = _animationCurve;
	retObj->_animationDuration = _animationDuration;
	retObj->_beginFrame = _beginFrame;
	retObj->_endFrame = _endFrame;
	
	return retObj;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
