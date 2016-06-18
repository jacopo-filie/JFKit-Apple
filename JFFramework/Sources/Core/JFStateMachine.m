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



#pragma mark - Functions (Definitions)

static	void	dispatchAsyncOnMainQueue(JFBlock block);
static	void	dispatchSyncOnMainQueue(JFBlock block);



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@interface JFStateMachine ()

#pragma mark Properties

// Concurrency
#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic, readonly)	dispatch_queue_t	serialQueue;
#else
@property (assign, nonatomic, readonly)	dispatch_queue_t	serialQueue;
#endif


#pragma mark Methods

// Properties accessors (State)
- (void)	setCurrentState:(JFState)currentState andTransition:(JFStateTransition)currentTransition;

// State management
- (void)	completeTransition:(BOOL)succeeded error:(NSError* __nullable)error completion:(JFSimpleCompletionBlock __nullable)completion;
- (void)	performTransitionOnQueue:(JFStateTransition)transition completion:(JFSimpleCompletionBlock __nullable)completion;

// Utilities management
- (BOOL)	isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing __nullable *)outError;

@end
NS_ASSUME_NONNULL_END



#pragma mark



NS_ASSUME_NONNULL_BEGIN
@implementation JFStateMachine

#pragma mark Properties

// Concurrency
@synthesize serialQueue	= _serialQueue;

// State
@synthesize currentState		= _currentState;
@synthesize currentTransition	= _currentTransition;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark Properties accessors (State)

- (JFState)currentState
{
	@synchronized(self)
	{
		return _currentState;
	}
}

- (JFStateTransition)currentTransition
{
	@synchronized(self)
	{
		return _currentTransition;
	}
}

- (void)setCurrentState:(JFState)currentState andTransition:(JFStateTransition)currentTransition
{
	@synchronized(self)
	{
		_currentState		= currentState;
		_currentTransition	= currentTransition;
	}
}


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

- (void)completeTransition:(BOOL)succeeded error:(NSError* __nullable)error completion:(JFSimpleCompletionBlock __nullable)completion
{
	JFStateTransition transition = self.currentTransition;
	
	JFState finalState = (succeeded ? [self finalStateForSucceededTransition:transition] : [self finalStateForFailedTransition:transition]);
	
	[self setCurrentState:finalState andTransition:JFStateTransitionNone];
	
	id<JFStateMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(stateMachine:didPerformTransition:)])
	{
		dispatchSyncOnMainQueue(^{
			[delegate stateMachine:self didPerformTransition:transition];
		});
	}
	
	if(completion)
	{
		dispatchAsyncOnMainQueue(^{
			completion(succeeded, error);
		});
	}
	
	dispatch_resume(self.serialQueue);
}

- (void)performTransition:(JFStateTransition)transition completion:(JFSimpleCompletionBlock __nullable)completion
{
	JFBlockWithError errorBlock = ^(NSError* error)
	{
		if(completion)
		{
			dispatchAsyncOnMainQueue(^{
				completion(NO, error);
			});
		}
	};
	
	NSError* error = nil;
	if(![self isValidTransition:transition error:&error])
	{
		errorBlock(error);
		return;
	}
	
#if __has_feature(objc_arc_weak)
	typeof(self) __weak weakSelf = self;
#endif
	
	JFBlock block = ^(void)
	{
		JFErrorsManager* errorsManager = [JFErrorsManager sharedManager];
		
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
		
		if([strongSelf initialStateForTransition:transition] != strongSelf.currentState)
		{
			errorBlock([errorsManager debugPlaceholderError]);
			return;
		}
		
		[strongSelf performTransitionOnQueue:transition completion:completion];
	};
	
	dispatch_async(self.serialQueue, block);
}

- (void)performTransitionOnQueue:(JFStateTransition)transition completion:(JFSimpleCompletionBlock __nullable)completion
{
	dispatch_suspend(self.serialQueue);
	
	id<JFStateMachineDelegate> delegate = self.delegate;
	if([delegate respondsToSelector:@selector(stateMachine:willPerformTransition:)])
	{
		dispatchSyncOnMainQueue(^{
			[delegate stateMachine:self willPerformTransition:transition];
		});
	}
	
	[self setCurrentState:self.currentState andTransition:transition];
	
	JFSimpleCompletionBlock transitionCompletion = ^(BOOL succeeded, NSError* error)
	{
		// It's easier to force the machine to stay alive by keeping a strong reference to it while a transition is performed.
		[self completeTransition:succeeded error:error completion:completion];
	};
	
	dispatchSyncOnMainQueue(^{
		[delegate stateMachine:self performTransition:transition completion:transitionCompletion];
	});
}


#pragma mark Utilities management

- (NSString* __nullable)debugStringForState:(JFState)state
{
	NSString* retObj = nil;
	switch(state)
	{
		case JFStateNotAvailable:	retObj = @"JFStateNotAvailable";	break;
		default:														break;
	}
	return retObj;
}

- (NSString* __nullable)debugStringForTransition:(JFStateTransition)transition
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

- (BOOL)isValidTransition:(JFStateTransition)transition error:(NSError* __autoreleasing __nullable *)outError
{
	BOOL (^errorBlock)(NSError*) = ^BOOL(NSError* error)
	{
		if(outError != NULL)
			*outError = error;
		return NO;
	};
	
	JFErrorsManager* errorsManager = [JFErrorsManager sharedManager];
	
	if((transition == JFStateTransitionNone) || (transition == JFStateTransitionNotAvailable))
		return errorBlock([errorsManager debugPlaceholderError]);
	
	JFState initialState = [self initialStateForTransition:transition];
	if(initialState == JFStateNotAvailable)
		return errorBlock([errorsManager debugPlaceholderError]);
	
	JFState finalState = [self finalStateForSucceededTransition:transition];
	if(finalState == JFStateNotAvailable)
		return errorBlock([errorsManager debugPlaceholderError]);
	
	finalState = [self finalStateForFailedTransition:transition];
	if(finalState == JFStateNotAvailable)
		return errorBlock([errorsManager debugPlaceholderError]);
	
	return YES;
}

@end
NS_ASSUME_NONNULL_END



#pragma mark - Functions (Implementations)

static void dispatchAsyncOnMainQueue(JFBlock block)
{
	if(!block)
		return;
	
	dispatch_async(dispatch_get_main_queue(), block);
}

static void dispatchSyncOnMainQueue(JFBlock block)
{
	if(!block)
		return;
	
	if([NSThread isMainThread])
		block();
	else
		dispatch_sync(dispatch_get_main_queue(), block);
}

