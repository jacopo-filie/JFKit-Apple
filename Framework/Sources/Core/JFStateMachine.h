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

@import Foundation;

#import "JFBlocks.h"
#import "JFPreprocessorMacros.h"

@class JFStateMachineTransition;

@protocol JFStateMachineDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

#define JFStateNotAvailable -1
#define JFStateTransitionNone 0
#define JFStateTransitionNotAvailable -1

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef NSInteger JFState;
typedef NSInteger JFStateTransition;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFStateMachine : NSObject

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

#if JF_WEAK_ENABLED
@property (weak, nonatomic, readonly, nullable) id<JFStateMachineDelegate> delegate;
#else
@property (unsafe_unretained, nonatomic, readonly, nullable) id<JFStateMachineDelegate> delegate;
#endif

// =================================================================================================
// MARK: Properties - State
// =================================================================================================

@property (assign, readonly) JFState state;
@property (assign, readonly) JFStateTransition transition;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

- (void)perform:(JFStateMachineTransition*)transition;
- (void)perform:(JFStateMachineTransition*)transition waitUntilFinished:(BOOL)waitUntilFinished;
- (void)waitUntilAllTransitionsAreFinished;
- (void)waitUntilCurrentTransitionIsFinished;

// =================================================================================================
// MARK: Methods - Execution management (Convenience)
// =================================================================================================

- (void)perform:(JFStateTransition)transition completion:(JFSimpleCompletion* __nullable)completion;
- (void)perform:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion;

// =================================================================================================
// MARK: Methods - Observers management
// =================================================================================================

- (void)clearDelegate;

// =================================================================================================
// MARK: Methods - State management
// =================================================================================================

- (NSArray<NSNumber*>*)beginningStatesForTransition:(JFStateTransition)transition;
- (JFState)endingStateForFailedTransition:(JFStateTransition)transition;
- (JFState)endingStateForSucceededTransition:(JFStateTransition)transition;
- (NSString* __nullable)stringFromState:(JFState)state;
- (NSString* __nullable)stringFromTransition:(JFStateTransition)transition;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@protocol JFStateMachineDelegate <NSObject>

// =================================================================================================
// MARK: Methods - Execution management
// =================================================================================================

@required

- (void)stateMachine:(JFStateMachine*)sender perform:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion*)completion;

@optional

- (void)stateMachine:(JFStateMachine*)sender didPerform:(JFStateTransition)transition context:(id __nullable)context;
- (void)stateMachine:(JFStateMachine*)sender willPerform:(JFStateTransition)transition context:(id __nullable)context;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFStateMachineTransition : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly, nullable) JFSimpleCompletion* completion;
@property (strong, nonatomic, readonly, nullable) id context;
@property (assign, nonatomic, readonly) JFStateTransition transition;

// =================================================================================================
// MARK: Properties - Execution
// =================================================================================================

@property (strong, nonatomic, nullable) JFStateMachineTransition* nextTransitionOnFailure;
@property (strong, nonatomic, nullable) JFStateMachineTransition* nextTransitionOnSuccess;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTransition:(JFStateTransition)transition context:(id __nullable)context completion:(JFSimpleCompletion* __nullable)completion NS_DESIGNATED_INITIALIZER;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
