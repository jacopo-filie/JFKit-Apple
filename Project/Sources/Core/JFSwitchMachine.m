//
//	The MIT License (MIT)
//
//	Copyright © 2016-2019 Jacopo Filié
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

#import "JFSwitchMachine.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation JFSwitchMachine

// =================================================================================================
// MARK: Properties accessors - State
// =================================================================================================

- (BOOL)isClosed
{
	return (self.state == JFSwitchStateClosed);
}

- (BOOL)isClosing
{
	return (self.transition == JFSwitchTransitionClosing);
}

- (BOOL)isOpen
{
	return (self.state == JFSwitchStateOpen);
}

- (BOOL)isOpening
{
	return (self.transition == JFSwitchTransitionOpening);
}

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate
{
	return [self initWithState:JFSwitchStateClosed delegate:delegate];
}

// =================================================================================================
// MARK: Methods - Execution
// =================================================================================================

- (void)close
{
	[self close:nil completion:nil];
}

- (void)close:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion
{
	[self perform:JFSwitchTransitionClosing context:context completion:completion];
}

- (void)open
{
	[self open:nil completion:nil];
}

- (void)open:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion
{
	[self perform:JFSwitchTransitionOpening context:context completion:completion];
}

// =================================================================================================
// MARK: Methods - State
// =================================================================================================

- (NSArray<NSNumber*>*)beginningStatesForTransition:(JFStateTransition)transition
{
	NSArray<NSNumber*>* retObj;
	switch(transition)
	{
		case JFSwitchTransitionClosing:	retObj = @[@(JFSwitchStateOpen)];	break;
		case JFSwitchTransitionOpening:	retObj = @[@(JFSwitchStateClosed)];	break;
		default:
		{
			retObj = [super beginningStatesForTransition:transition];
			break;
		}
	}
	return retObj;
}

- (JFState)endingStateForFailedTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFSwitchTransitionClosing:	retVal = JFSwitchStateOpen;		break;
		case JFSwitchTransitionOpening:	retVal = JFSwitchStateClosed;	break;
		default:
		{
			retVal = [super endingStateForFailedTransition:transition];
			break;
		}
	}
	return retVal;
}

- (JFState)endingStateForSucceededTransition:(JFStateTransition)transition
{
	JFState retVal;
	switch(transition)
	{
		case JFSwitchTransitionClosing:	retVal = JFSwitchStateClosed;	break;
		case JFSwitchTransitionOpening:	retVal = JFSwitchStateOpen;		break;
		default:
		{
			retVal = [super endingStateForSucceededTransition:transition];
			break;
		}
	}
	return retVal;
}

- (NSString* __nullable)stringFromState:(JFState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFSwitchStateClosed:	retObj = @"Closed";	break;
		case JFSwitchStateOpen:		retObj = @"Open";	break;
		default:
		{
			retObj = [super stringFromState:state];
			break;
		}
	}
	return retObj;
}

- (NSString* __nullable)stringFromTransition:(JFStateTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFSwitchTransitionClosing:	retObj = @"Closing";	break;
		case JFSwitchTransitionOpening:	retObj = @"Opening";	break;
		default:
		{
			retObj = [super stringFromTransition:transition];
			break;
		}
	}
	return retObj;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
