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

#import "JFStateMachine.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef NS_ENUM(JFState, JFSwitchState)
{
	JFSwitchStateClosed,
	JFSwitchStateOpen,
};

typedef NS_ENUM(JFStateTransition, JFSwitchTransition)
{
	JFSwitchTransitionNone = JFStateTransitionNone,
	JFSwitchTransitionClosing,
	JFSwitchTransitionOpening,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFSwitchMachine : JFStateMachine

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@property (assign, readonly, getter=isClosed) BOOL closed;
@property (assign, readonly, getter=isClosing) BOOL closing;
@property (assign, readonly, getter=isOpen) BOOL open;
@property (assign, readonly, getter=isOpening) BOOL opening;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

// The starting state is "Closed".
- (instancetype)initWithDelegate:(id<JFStateMachineDelegate>)delegate;

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)close;
- (void)close:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;
- (void)open;
- (void)open:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
