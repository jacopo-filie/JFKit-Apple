//
//	The MIT License (MIT)
//
//	Copyright (c) 2015 Jacopo Filié
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



@class JFConnectionMachine;



#pragma mark - Types

typedef NS_ENUM(NSUInteger, JFConnectionState)
{
	JFConnectionStateReady			= 0,
	JFConnectionStateConnected		= 1,
	JFConnectionStateDisconnected	= 2,
	JFConnectionStateLost			= 3,
	JFConnectionStateUnknown		= 4,
};

typedef NS_ENUM(NSUInteger, JFConnectionTransition)
{
	JFConnectionTransitionNone			= 0,
	JFConnectionTransitionConnecting	= 1,
	JFConnectionTransitionDisconnecting	= 2,
	JFConnectionTransitionReconnecting	= 3,
	JFConnectionTransitionResetting		= 4,
};



#pragma mark



@protocol JFConnectionMachineDelegate <NSObject>

@required

- (void)	connectionMachine:(JFConnectionMachine*)machine performConnect:(NSDictionary*)userInfo;
- (void)	connectionMachine:(JFConnectionMachine*)machine performDisconnect:(NSDictionary*)userInfo;
- (void)	connectionMachine:(JFConnectionMachine*)machine performReconnect:(NSDictionary*)userInfo;
- (void)	connectionMachine:(JFConnectionMachine*)machine performReset:(NSDictionary*)userInfo;

- (void)	connectionMachine:(JFConnectionMachine*)machine didConnect:(BOOL)succeeded userInfo:(NSDictionary*)userInfo error:(NSError*)error;
- (void)	connectionMachine:(JFConnectionMachine*)machine didDisconnect:(BOOL)succeeded userInfo:(NSDictionary*)userInfo error:(NSError*)error;
- (void)	connectionMachine:(JFConnectionMachine*)machine didReconnect:(BOOL)succeeded userInfo:(NSDictionary*)userInfo error:(NSError*)error;
- (void)	connectionMachine:(JFConnectionMachine*)machine didReset:(BOOL)succeeded userInfo:(NSDictionary*)userInfo error:(NSError*)error;

@optional

- (void)	connectionMachine:(JFConnectionMachine*)machine willEnterState:(JFConnectionState)state;
- (void)	connectionMachine:(JFConnectionMachine*)machine didEnterState:(JFConnectionState)state;
- (void)	connectionMachine:(JFConnectionMachine*)machine didFailToEnterState:(JFConnectionState)state error:(NSError*)error;

- (void)	connectionMachine:(JFConnectionMachine*)machine willLeaveState:(JFConnectionState)state;
- (void)	connectionMachine:(JFConnectionMachine*)machine didLeaveState:(JFConnectionState)state;
- (void)	connectionMachine:(JFConnectionMachine*)machine didFailToLeaveState:(JFConnectionState)state error:(NSError*)error;

- (void)	connectionMachine:(JFConnectionMachine*)machine willBeginTransition:(JFConnectionTransition)transition;
- (void)	connectionMachine:(JFConnectionMachine*)machine didBeginTransition:(JFConnectionTransition)transition;

- (void)	connectionMachine:(JFConnectionMachine*)machine willEndTransition:(JFConnectionTransition)transition;
- (void)	connectionMachine:(JFConnectionMachine*)machine didEndTransition:(JFConnectionTransition)transition;

@end

 

#pragma mark



@interface JFConnectionMachine : NSObject

#pragma mark Properties

// Flags
@property (assign, readonly)	JFConnectionState		state;
@property (assign, readonly)	JFConnectionTransition	transition;

// Relationships
#if __has_feature(objc_arc_weak)
@property (weak, nonatomic, readonly)	id<JFConnectionMachineDelegate>	delegate;
#else
@property (assign, nonatomic, readonly)	id<JFConnectionMachineDelegate>	delegate;
#endif


#pragma mark Methods

// Memory management
- (instancetype)	initWithDelegate:(id<JFConnectionMachineDelegate>)delegate;	// The starting state is "Ready".
- (instancetype)	initWithState:(JFConnectionState)state delegate:(id<JFConnectionMachineDelegate>)delegate NS_DESIGNATED_INITIALIZER;

// Commands management
- (BOOL)	connect;
- (BOOL)	connect:(NSDictionary*)userInfo;
- (BOOL)	disconnect;
- (BOOL)	disconnect:(NSDictionary*)userInfo;
- (BOOL)	reconnect;
- (BOOL)	reconnect:(NSDictionary*)userInfo;
- (BOOL)	reset;
- (BOOL)	reset:(NSDictionary*)userInfo;

// Events management
- (void)	onConnectCompleted:(BOOL)succeeded error:(NSError*)error;
- (void)	onConnectionLost;
- (void)	onDisconnectCompleted:(BOOL)succeeded error:(NSError*)error;
- (void)	onReconnectCompleted:(BOOL)succeeded error:(NSError*)error;
- (void)	onResetCompleted:(BOOL)succeeded error:(NSError*)error;

// Utilities management
+ (NSString*)	debugStringFromState:(JFConnectionState)state;
+ (NSString*)	debugStringFromTransition:(JFConnectionTransition)transition;
+ (BOOL)		isTransitionEnabled:(JFConnectionTransition)transition fromState:(JFConnectionState)state;

@end
