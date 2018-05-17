//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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



#import "JFKeyboardEventsHandler.h"

#import "JFShortcuts.h"



@interface JFKeyboardEventsHandler ()

#pragma mark Methods

// Notifications management (UIKeyboard)
- (void)	notifiedThatKeyboardDidChangeFrame:(NSNotification*)notification;
- (void)	notifiedThatKeyboardDidHide:(NSNotification*)notification;
- (void)	notifiedThatKeyboardDidShow:(NSNotification*)notification;
- (void)	notifiedThatKeyboardWillChangeFrame:(NSNotification*)notification;
- (void)	notifiedThatKeyboardWillHide:(NSNotification*)notification;
- (void)	notifiedThatKeyboardWillShow:(NSNotification*)notification;

// Utilities management
- (JFKeyboardInfo*)	createInfoFromDictionary:(NSDictionary*)dictionary;

@end



#pragma mark



@implementation JFKeyboardEventsHandler

#pragma mark Properties

// Attributes
@synthesize constant	= _constant;

// Constraints
@synthesize resizableViewBottomConstraint	= _resizableViewBottomConstraint;

// Relationships
@synthesize delegate	= _delegate;

// User interface
@synthesize resizableView	= _resizableView;


#pragma mark Memory management

- (void)dealloc
{
	[MainNotificationCenter removeObserver:self];
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_constant = 0.0f;
		
		// Begins to listen for interesting notifications.
		NSNotificationCenter* center = MainNotificationCenter;
		[center addObserver:self selector:@selector(notifiedThatKeyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	}
	return self;
}


#pragma mark Notifications management (UIKeyboard)

- (void)notifiedThatKeyboardDidChangeFrame:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:didChangeFrame:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self didChangeFrame:info];
	}
}

- (void)notifiedThatKeyboardDidHide:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:didHide:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self didHide:info];
	}
}

- (void)notifiedThatKeyboardDidShow:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:didShow:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self didShow:info];
	}
}

- (void)notifiedThatKeyboardWillChangeFrame:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:willChangeFrame:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self willChangeFrame:info];
	}
}

- (void)notifiedThatKeyboardWillHide:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
	
	if(self.resizableView && self.resizableViewBottomConstraint)
	{
		UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | (UIViewAnimationOptions)(info.animationCurve << 16));
		
		self.resizableViewBottomConstraint.constant = 0;
		[self.resizableView.superview setNeedsUpdateConstraints];
		
		JFBlock animations = ^()
		{
			[self.resizableView.superview layoutIfNeeded];
		};
		
		[UIView animateWithDuration:info.animationDuration delay:0.0 options:options animations:animations completion:nil];
	}
	
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:willHide:)])
		[delegate keyboardEventsHandler:self willHide:info];
}

- (void)notifiedThatKeyboardWillShow:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
	
	if(self.resizableView && self.resizableViewBottomConstraint)
	{
		UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | (UIViewAnimationOptions)(info.animationCurve << 16));
		CGFloat height = ((!iOS8Plus && UIInterfaceOrientationIsLandscape(CurrentInterfaceOrientation)) ? CGRectGetWidth(info.endingFrame) : CGRectGetHeight(info.endingFrame));
		
		self.resizableViewBottomConstraint.constant = height - self.constant;
		[self.resizableView.superview setNeedsUpdateConstraints];
		
		JFBlock animations = ^()
		{
			[self.resizableView.superview layoutIfNeeded];
		};
		
		[UIView animateWithDuration:info.animationDuration delay:0.0 options:options animations:animations completion:nil];
	}
	
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:willShow:)])
		[delegate keyboardEventsHandler:self willShow:info];
}


#pragma mark Utilities management

- (JFKeyboardInfo*)createInfoFromDictionary:(NSDictionary*)dictionary
{
	NSNumber* animationCurve	= [dictionary objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	NSNumber* animationDuration	= [dictionary objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSValue* beginningFrame		= [dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey];
	NSValue* endingFrame		= [dictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
	
	JFKeyboardInfo* retObj = [[JFKeyboardInfo alloc] init];
	
	retObj.animationCurve		= (UIViewAnimationCurve)[animationCurve unsignedIntegerValue];
	retObj.animationDuration	= [animationDuration doubleValue];
	retObj.beginningFrame		= [beginningFrame CGRectValue];
	retObj.endingFrame			= [endingFrame CGRectValue];
	
	return retObj;
}

@end



#pragma mark



@implementation JFKeyboardInfo

#pragma mark Properties

// Attributes
@synthesize animationCurve		= _animationCurve;
@synthesize animationDuration	= _animationDuration;
@synthesize beginningFrame		= _beginningFrame;
@synthesize endingFrame			= _endingFrame;


#pragma mark Protocol implementation (NSCopying)

- (instancetype)copyWithZone:(nullable NSZone*)zone
{
	typeof(self) retObj = [[[self class] alloc] init];
	
	// Attributes
	retObj->_animationCurve		= _animationCurve;
	retObj->_animationDuration	= _animationDuration;
	retObj->_beginningFrame		= _beginningFrame;
	retObj->_endingFrame		= _endingFrame;
	
	return retObj;
}

@end
