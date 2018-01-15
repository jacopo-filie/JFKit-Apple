//
//	The MIT License (MIT)
//
//	Copyright © 2016-2018 Jacopo Filié
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

#import "JFStateMachineErrorsManager.h"

#import "JFString.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Constants
// =================================================================================================

static	NSString*	const	JFDomain	= JFReversedDomain	@".errorsManager.stateMachine";

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFStateMachineErrorsManager

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)init
{
	return [self initWithDomain:JFDomain];
}

// =================================================================================================
// MARK: Methods - Data management
// =================================================================================================

- (NSString* __nullable)debugStringForErrorCode:(JFErrorCode)errorCode
{
	NSString* retObj = nil;
	switch(errorCode)
	{
		case JFStateMachineErrorDeallocated:				retObj = @"Deallocated";				break;
		case JFStateMachineErrorInvalidFinalStateOnFailure:	retObj = @"InvalidFinalStateOnFailure";	break;
		case JFStateMachineErrorInvalidFinalStateOnSuccess:	retObj = @"InvalidFinalStateOnSuccess";	break;
		case JFStateMachineErrorInvalidInitialState:		retObj = @"InvalidInitialState";		break;
		case JFStateMachineErrorInvalidTransition:			retObj = @"InvalidTransition";			break;
		case JFStateMachineErrorWrongInitialState:			retObj = @"WrongInitialState";			break;
			
		default:
			break;
	}
	return retObj;
}

- (NSString* __nullable)localizedDescriptionForErrorCode:(JFErrorCode)errorCode
{
	NSString* retObj = nil;
	switch(errorCode)
	{
		case JFStateMachineErrorDeallocated:				retObj = JFStateMachineErrorStringDeallocatedDescription;		break;
		case JFStateMachineErrorInvalidFinalStateOnFailure:
		case JFStateMachineErrorInvalidFinalStateOnSuccess:
		case JFStateMachineErrorInvalidInitialState:
		case JFStateMachineErrorInvalidTransition:
		case JFStateMachineErrorWrongInitialState:			retObj = JFStateMachineErrorStringTransitionFailedDescription;	break;
			
		default:
			break;
	}
	return retObj;
}

- (NSString* __nullable)localizedFailureReasonForErrorCode:(JFErrorCode)errorCode
{
	NSString* retObj = nil;
	switch(errorCode)
	{
		case JFStateMachineErrorDeallocated:				retObj = JFStateMachineErrorStringDeallocatedFailureReason;									break;
		case JFStateMachineErrorInvalidFinalStateOnFailure:	retObj = JFStateMachineErrorStringTransitionFailedFailureReasonInvalidFinalStateOnFailure;	break;
		case JFStateMachineErrorInvalidFinalStateOnSuccess:	retObj = JFStateMachineErrorStringTransitionFailedFailureReasonInvalidFinalStateOnSuccess;	break;
		case JFStateMachineErrorInvalidInitialState:		retObj = JFStateMachineErrorStringTransitionFailedFailureReasonInvalidInitialState;			break;
		case JFStateMachineErrorInvalidTransition:			retObj = JFStateMachineErrorStringTransitionFailedFailureReasonInvalidTransition;			break;
		case JFStateMachineErrorWrongInitialState:			retObj = JFStateMachineErrorStringTransitionFailedFailureReasonWrongInitialState;			break;
			
		default:
			break;
	}
	return retObj;
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
