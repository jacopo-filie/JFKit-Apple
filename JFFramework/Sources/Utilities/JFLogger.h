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



#import "JFManager.h"



#pragma mark - Types

typedef NS_OPTIONS(UInt8, JFLogDestinations)
{
	JFLogDestinationConsole	= 1 << 0,	// Prints the message to the console.
	JFLogDestinationFile	= 1 << 1,	// Writes the message into the file if 'fileURL' is set.
	
	JFLogDestinationAll		= (JFLogDestinationConsole | JFLogDestinationFile),
};

typedef NS_OPTIONS(UInt16, JFLogHashtags)
{
	JFLogHashtagsNone		= 0,		// Message is not associated to any hashtag.
	
	JFLogHashtagAttention	= 1 << 0,	// Message that should be investigated by a system administrator, because it may be a sign of a larger issue. For example, errors from a hard drive controller that typically occur when the drive is about to fail.
	JFLogHashtagClue		= 1 << 1,	// Message containing extra key/value pairs with additional information to help reconstruct the context.
	JFLogHashtagComment		= 1 << 2,	// Message that is a comment.
	JFLogHashtagCritical	= 1 << 3,	// Message in the context of a critical event or critical failure.
	JFLogHashtagDeveloper	= 1 << 4,	// Message in the context of software development. For example, deprecated APIs and debugging messages.
	JFLogHashtagError		= 1 << 5,	// Message that is a noncritical error.
	JFLogHashtagFileSystem	= 1 << 6,	// Message describing a file system related event.
	JFLogHashtagHardware	= 1 << 7,	// Message describing a hardware-related event.
	JFLogHashtagMarker		= 1 << 8,	// Message that marks a change to divide the messages around it into those before and those after the change.
	JFLogHashtagNetwork		= 1 << 9,	// Message describing a network-related event.
	JFLogHashtagSecurity	= 1 << 10,	// Message related to security concerns.
	JFLogHashtagSystem		= 1 << 11,	// Message in the context of a system process.
	JFLogHashtagUser		= 1 << 12,	// Message in the context of a user process.
};

typedef NS_ENUM(UInt8, JFLogPriority)
{
	JFLogPriority0Emergency,	// The highest priority, usually reserved for catastrophic failures and reboot notices.
	JFLogPriority1Alert,		// A serious failure in a key system.
	JFLogPriority2Critical,		// A failure in a key system.
	JFLogPriority3Error,		// Something has failed.
	JFLogPriority4Warning,		// Something is amiss and might fail if not corrected.
	JFLogPriority5Notice,		// Things of moderate interest to the user or administrator.
	JFLogPriority6Info,			// The lowest priority that you would normally log, and purely informational in nature.
	JFLogPriority7Debug,		// The lowest priority, and normally not logged except for messages from the kernel.
};



#pragma mark



@interface JFLogger : JFManager

#pragma mark Properties

// Settings
@property (assign)						JFLogDestinations	destinations;
@property (strong, nonatomic, readonly)	NSURL*				fileURL;
@property (assign)						JFLogPriority		priority;	// Only messages that have a lower (or equal) priority value will be logged.


#pragma mark Methods

// Memory management
- (instancetype)	initWithDefaultSettings NS_DESIGNATED_INITIALIZER;
- (instancetype)	initWithFileURL:(NSURL*)fileURL;
- (instancetype)	initWithFileURL:(NSURL*)fileURL priority:(JFLogPriority)priority NS_DESIGNATED_INITIALIZER;

// Service management
- (void)	logMessage:(NSString*)message priority:(JFLogPriority)priority;
- (void)	logMessage:(NSString*)message priority:(JFLogPriority)priority hashtags:(JFLogHashtags)hashtags;
- (void)	logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations priority:(JFLogPriority)priority;
- (void)	logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations priority:(JFLogPriority)priority hashtags:(JFLogHashtags)hashtags;

// Utilities management
+ (NSString*)	serializeHashtags:(JFLogHashtags)hashtags;
- (NSString*)	serializeHashtags:(JFLogHashtags)hashtags;	// Calls the class implementation.

@end



#pragma mark



@interface NSObject (JFLogger)

#pragma mark Properties

// Logging
@property (strong, setter = jf_setLogger:)			JFLogger*	jf_logger;
@property (assign, setter = jf_setShouldDebugLog:)	BOOL		jf_shouldDebugLog;
@property (assign, setter = jf_setShouldLog:)		BOOL		jf_shouldLog;

@end
