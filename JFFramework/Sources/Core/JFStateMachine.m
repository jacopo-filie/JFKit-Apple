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



#pragma mark - Macros

#define JFStateMachineSerialQueueName	JFReversedDomain @".stateMachine.queue"



NS_ASSUME_NONNULL_BEGIN
@interface JFStateMachine ()

#pragma mark Properties

// Concurrency
@property (strong, nonatomic, nullable)	JFSimpleCompletionBlock	completion;
#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic, readonly)	dispatch_queue_t		serialQueue;
#else
@property (assign, nonatomic, readonly)	dispatch_queue_t		serialQueue;
#endif

// State
@property (assign, readwrite)	JFState				currentState;
@property (assign, readwrite)	JFStateTransition	currentTransition;


#pragma mark Methods

// State management
- (void)	startTransition:(JFStateTransition)transition;

@end
NS_ASSUME_NONNULL_END



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@implementation JFStateMachine

#pragma mark Properties

// Concurrency
@synthesize completion	= _completion;
@synthesize serialQueue	= _serialQueue;

// State
@synthesize currentState		= _currentState;
@synthesize currentTransition	= _currentTransition;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark Memory management

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
	dispatch_release(self.serialQueue);
#endif
}

- (instancetype)initWithState:(JFState)state delegate:(id<JFStateMachineDelegate>)delegate
{
	self = [super init];
	if(self)
	{
		// Concurrency
		_serialQueue	= dispatch_queue_create(JFStringToCString(JFStateMachineSerialQueueName), DISPATCH_QUEUE_SERIAL);
		
		// Relationships
		_delegate	= delegate;
		
		// State
		_currentState		= state;
		_currentTransition	= JFStateTransitionNone;
	}
	return self;
}


#pragma mark State management

- (void)onTransitionCompleted:(BOOL)succeeded error:(nullable NSError*)error
{
	JFStateTransition transition = self.currentTransition;
	if(transition == JFStateTransitionNone)
		return;
	
	self.currentState = (succeeded ? [self finalStateForSucceededTransition:transition] : [self finalStateForFailedTransition:transition]);
	self.currentTransition = JFStateTransitionNone;
	
	id<JFStateMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(stateMachine:didPerformTransition:)])
	{
		[MainOperationQueue addOperationWithBlock:^{
			[delegate stateMachine:self didPerformTransition:transition];
		}];
	}
	
	JFSimpleCompletionBlock completion = self.completion;
	if(completion)
	{
		self.completion = nil;
		[MainOperationQueue addOperationWithBlock:^{
			completion(succeeded, error);
		}];
	}
	
	dispatch_resume(self.serialQueue);
}

- (void)performTransition:(JFStateTransition)transition completion:(nullable JFSimpleCompletionBlock)completion
{
	JFErrorsManager* errorsManager = [JFErrorsManager sharedManager];
	
	JFBlockWithError errorBlock = ^(NSError* error)
	{
		if(completion)
		{
			[MainOperationQueue addOperationWithBlock:^{
				completion(NO, error);
			}];
		}
	};
	
	if((transition == JFStateTransitionNone) || (transition == JFStateTransitionNotAvailable))
	{
		errorBlock([errorsManager debugPlaceholderError]);
		return;
	}
	
	JFState initialState = [self initialStateForTransition:transition];
	if(initialState == JFStateNotAvailable)
	{
		errorBlock([errorsManager debugPlaceholderError]);
		return;
	}
	
	JFState finalState = [self finalStateForSucceededTransition:transition];
	if(finalState == JFStateNotAvailable)
	{
		errorBlock([errorsManager debugPlaceholderError]);
		return;
	}
	
	finalState = [self finalStateForFailedTransition:transition];
	if(finalState == JFStateNotAvailable)
	{
		errorBlock([errorsManager debugPlaceholderError]);
		return;
	}
	
#if __has_feature(objc_arc_weak)
	typeof(self) __weak weakSelf = self;
#endif
	
	JFBlock block = ^(void)
	{
#if __has_feature(objc_arc_weak)
		typeof(self) __strong strongSelf = weakSelf;
		if(!strongSelf)
		{
			errorBlock([errorsManager debugPlaceholderError]);
			return;
		}
#else
		typeof(self) __strong strongSelf = self;
#endif
		
		if(initialState != strongSelf.currentState)
		{
			errorBlock([errorsManager debugPlaceholderError]);
			return;
		}
		
		strongSelf.completion = completion;
		
		[strongSelf startTransition:transition];
	};
	
	dispatch_async(self.serialQueue, block);
}

- (void)startTransition:(JFStateTransition)transition
{
	dispatch_suspend(self.serialQueue);
	
	id<JFStateMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(stateMachine:willPerformTransition:)])
	{
		[MainOperationQueue addOperationWithBlock:^{
			[delegate stateMachine:self willPerformTransition:transition];
		}];
	}
	
	self.currentTransition = transition;
	
	[MainOperationQueue addOperationWithBlock:^{
		[delegate stateMachine:self performTransition:transition];
	}];
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

- (nullable NSString*)debugStringForTransition:(JFStateTransition)transition
{
	NSString* retObj = nil;
	switch(transition)
	{
		case JFStateTransitionNone:			retObj = @"JFTransitionNone";			break;
		case JFStateTransitionNotAvailable:	retObj = @"JFTransitionNotAvailable";	break;
		default:																	break;
	}
	return retObj;
}

- (JFState)finalStateForFailedTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

- (JFState)finalStateForSucceededTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

- (JFState)initialStateForTransition:(JFStateTransition)transition
{
	return JFStateNotAvailable;
}

@end
NS_ASSUME_NONNULL_END
