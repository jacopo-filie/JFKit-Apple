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



#import "JFTypes.h"



@class JFStateMachine;



#pragma mark - Types

typedef NSUInteger JFState;
typedef NSUInteger JFTransition;



#pragma mark - Constants

FOUNDATION_EXPORT JFState const			JFStateNotAvailable;
FOUNDATION_EXPORT JFTransition const	JFTransitionNone;
FOUNDATION_EXPORT JFTransition const	JFTransitionNotAvailable;



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@protocol JFStateMachineDelegate <NSObject>

@required
#pragma mark Required methods

// State management
- (void)	stateMachine:(JFStateMachine*)machine performTransition:(JFTransition)transition;

@optional
#pragma mark Optional methods

// State management
- (void)	stateMachine:(JFStateMachine*)machine didPerformTransition:(JFTransition)transition;
- (void)	stateMachine:(JFStateMachine*)machine willPerformTransition:(JFTransition)transition;

@end
NS_ASSUME_NONNULL_END



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@interface JFStateMachine : NSObject

#pragma mark Properties

// Relationships
#if __has_feature(objc_arc_weak)
@property (weak, nonatomic, readonly)	id<JFStateMachineDelegate>	delegate;
#else
@property (unsafe_unretained, nonatomic, readonly)	id<JFStateMachineDelegate>	delegate;
#endif

// State
@property (assign, readonly)	JFState			currentState;
@property (assign, readonly)	JFTransition	currentTransition;


#pragma mark Methods

// Memory management
- (instancetype)	init NS_UNAVAILABLE;
- (instancetype)	initWithDelegate:(id<JFStateMachineDelegate>)delegate;
- (instancetype)	initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate NS_DESIGNATED_INITIALIZER;

// State management
- (void)	performTransition:(JFTransition)transition completion:(nullable JFSimpleCompletionBlock)completion;
- (void)	onTransitionCompleted:(BOOL)succeeded error:(nullable NSError*)error;

// Utilities management
- (nullable NSString*)	debugStringForState:(JFState)state;
- (nullable NSString*)	debugStringForTransition:(JFTransition)transition;
- (JFState)				initialStateForTransition:(JFTransition)transition;
- (JFState)				finalStateForTransition:(JFTransition)transition;
- (JFTransition)		transitionFromState:(JFState)initialState toState:(JFState)finalState;

@end
NS_ASSUME_NONNULL_END
