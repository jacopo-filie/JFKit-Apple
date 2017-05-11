//
//	The MIT License (MIT)
//
//	Copyright © 2016-2017 Jacopo Filié
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

#import "JFOpenCloseMachine.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN
@implementation JFOpenCloseMachine

// =================================================================================================
// MARK: Properties accessors - State
// =================================================================================================

- (BOOL)isClosed
{
	return (self.currentState == JFOpenCloseStateClosed);
}

- (BOOL)isOpened
{
	return (self.currentState == JFOpenCloseStateOpened);
}

// =================================================================================================
// MARK: Properties accessors - State (Transitions)
// =================================================================================================

- (BOOL)isClosing
{
	return (self.currentTransition == JFOpenCloseTransitionClosing);
}

- (BOOL)isOpening
{
	return (self.currentTransition == JFOpenCloseTransitionOpening);
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate
{
	return [self initWithState:JFOpenCloseStateClosed delegate:delegate];
}

// =================================================================================================
// MARK: Methods - State management
// =================================================================================================

- (void)close
{
	[self close:nil];
}

- (void)close:(JFSimpleCompletionBlock __nullable)completion
{
	[self close:nil completion:completion];
}

- (void)close:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:JFOpenCloseTransitionClosing context:context completion:completion];
}

- (JFState)finalStateForFailedTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFOpenCloseTransitionClosing:	retVal = JFOpenCloseStateOpened;	break;
		case JFOpenCloseTransitionOpening:	retVal = JFOpenCloseStateClosed;	break;
		default:
		{
			retVal = [super finalStateForFailedTransition:transition];
			break;
		}
	}
	return retVal;
}

- (JFState)finalStateForSucceededTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFOpenCloseTransitionClosing:	retVal = JFOpenCloseStateClosed;	break;
		case JFOpenCloseTransitionOpening:	retVal = JFOpenCloseStateOpened;	break;
		default:
		{
			retVal = [super finalStateForSucceededTransition:transition];
			break;
		}
	}
	return retVal;
}

- (NSArray<NSNumber*>*)initialStatesForTransition:(JFStateTransition)transition
{
	NSArray<NSNumber*>* retObj;
	switch(transition)
	{
		case JFOpenCloseTransitionClosing:	retObj = @[@(JFOpenCloseStateOpened)];	break;
		case JFOpenCloseTransitionOpening:	retObj = @[@(JFOpenCloseStateClosed)];	break;
		default:
		{
			retObj = [super initialStatesForTransition:transition];
			break;
		}
	}
	return retObj;
}

- (void)open
{
	[self open:nil];
}

- (void)open:(JFSimpleCompletionBlock __nullable)completion
{
	[self open:nil completion:completion];
}

- (void)open:(id __nullable)context completion:(JFSimpleCompletionBlock __nullable)completion
{
	[self performTransition:JFOpenCloseTransitionOpening context:context completion:completion];
}

// =================================================================================================
// MARK: Methods - Utilities management
// =================================================================================================

- (NSString* __nullable)debugStringForState:(JFState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFOpenCloseStateClosed:	retObj = @"Closed";	break;
		case JFOpenCloseStateOpened:	retObj = @"Opened";	break;
		default:
		{
			retObj = [super debugStringForState:state];
			break;
		}
	}
	return retObj;
}

- (NSString* __nullable)debugStringForTransition:(JFStateTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFOpenCloseTransitionClosing:	retObj = @"Closing";	break;
		case JFOpenCloseTransitionOpening:	retObj = @"Opening";	break;
		default:
		{
			retObj = [super debugStringForTransition:transition];
			break;
		}
	}
	return retObj;
}

@end
NS_ASSUME_NONNULL_END
