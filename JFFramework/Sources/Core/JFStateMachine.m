//
//	The MIT License (MIT)
//
//	Copyright © 2016 Jacopo Filié
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



#import "JFStateMachine.h"

#import "JFErrorsManager.h"
#import "JFShortcuts.h"
#import "JFString.h"



#pragma mark - Constants

JFState const		JFStateNotAvailable			= NSUIntegerMax;
JFTransition const	JFTransitionNone			= 0;
JFTransition const	JFTransitionNotAvailable	= NSUIntegerMax;



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@interface JFStateMachine ()

#pragma mark Properties

// State
@property (assign, readwrite)	JFState						currentState;
@property (assign, readwrite)	JFTransition				currentTransition;

@end
NS_ASSUME_NONNULL_END



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@implementation JFStateMachine

#pragma mark Properties

// State
@synthesize currentState		= _currentState;
@synthesize currentTransition	= _currentTransition;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark Memory management

- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate
{
	return [self initWithState:JFStateNotAvailable delegate:delegate];
}

- (instancetype)initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate
{
	self = [super init];
	if(self)
	{
		// Relationships
		_delegate	= delegate;
		
		// State
		_currentState		= state;
		_currentTransition	= JFTransitionNone;
	}
	return self;
}


#pragma mark State management

- (void)performTransition:(JFTransition)transition completion:(nullable JFSimpleCompletionBlock)completion
{
	LogMethod;
}

- (void)onTransitionCompleted:(BOOL)succeeded error:(nullable NSError*)error
{
	LogMethod;
}


#pragma mark Utilities management

- (nullable NSString*)debugStringForState:(JFState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFStateNotAvailable:	retObj = @"JFStateNotAvailable";	break;
		default:														break;
	}
	return retObj;
}

- (nullable NSString*)debugStringForTransition:(JFTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFTransitionNone:			retObj = @"JFTransitionNone";			break;
		case JFTransitionNotAvailable:	retObj = @"JFTransitionNotAvailable";	break;
		default:																break;
	}
	return retObj;
}

- (JFState)initialStateForTransition:(JFTransition)transition
{
	return JFStateNotAvailable;
}

- (JFState)finalStateForTransition:(JFTransition)transition
{
	return JFStateNotAvailable;
}

- (JFTransition)transitionFromState:(JFState)initialState toState:(JFState)finalState
{
	return JFTransitionNotAvailable;
}

@end
NS_ASSUME_NONNULL_END
