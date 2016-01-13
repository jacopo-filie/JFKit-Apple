//
//	The MIT License (MIT)
//
//	Copyright © 2015-2016 Jacopo Filié
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



#import "JFLogger.h"

#import <objc/runtime.h>
#import <pthread/pthread.h>

#import "JFShortcuts.h"
#import "JFUtilities.h"



#pragma mark - Functions (Definitions)

static	NSDateFormatter*	createDateFormatter();
static	BOOL				initializeDateFormatterLock(pthread_mutex_t* lock, Class class);
static	BOOL				initializeDestinationsLock(pthread_rwlock_t* lock, Class class);
static	BOOL				initializeFileLock(pthread_mutex_t* lock, Class class);



#pragma mark



@interface JFLogger ()
{
	// Concurrency
	pthread_mutex_t		_dateFormatterLock;
	BOOL				_dateFormatterLockInitialized;
	pthread_rwlock_t	_destinationsLock;
	BOOL				_destinationsLockInitialized;
	pthread_mutex_t		_fileLock;
	BOOL				_fileLockInitialized;
}


#pragma mark Properties

// Settings
@property (strong, nonatomic, readonly)	NSDateFormatter*	dateFormatter;


#pragma mark Methods

// Service management
- (void)	logMessageToConsole:(NSString*)message;
- (void)	logMessageToFile:(NSString*)message;

// Utilities management
- (BOOL)		createLogFileIfNecessary;
- (NSString*)	stringFromCurrentDate;

@end



#pragma mark



@implementation JFLogger

#pragma mark Properties

// Settings
@synthesize dateFormatter	= _dateFormatter;
@synthesize destinations	= _destinations;
@synthesize fileURL			= _fileURL;
@synthesize priority		= _priority;


#pragma mark Properties accessors (Settings)

- (JFLogDestinations)destinations
{
	if(_destinationsLockInitialized)
	{
		pthread_rwlock_rdlock(&_destinationsLock);
		JFLogDestinations retVal = _destinations;
		pthread_rwlock_unlock(&_destinationsLock);
		return retVal;
	}
	
	@synchronized(self)
	{
		return _destinations;
	}
}

- (void)setDestinations:(JFLogDestinations)destinations
{
	if((destinations & JFLogDestinationFile) && !self.fileURL)
		destinations = destinations & ~JFLogDestinationFile;
	
	if(_destinationsLockInitialized)
	{
		pthread_rwlock_wrlock(&_destinationsLock);
		_destinations = destinations;
		pthread_rwlock_unlock(&_destinationsLock);
	}
	else
	{
		@synchronized(self)
		{
			_destinations = destinations;
		}
	}
}


#pragma mark Memory management

- (void)dealloc
{
	if(_dateFormatterLockInitialized)	pthread_mutex_destroy(&_dateFormatterLock);
	if(_destinationsLockInitialized)	pthread_rwlock_destroy(&_destinationsLock);
	if(_fileLockInitialized)			pthread_mutex_destroy(&_fileLock);
}

- (instancetype)init
{
	return [self initWithFileURL:nil];
}

- (instancetype)initWithDefaultSettings
{
	self = [super initWithDefaultSettings];
	if(self)
	{
		Class class = [self class];
		
		// Prepares the fileURL.
		NSURL* fileURL = nil;
		NSError* error = nil;
		NSURL* folderURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
		if(folderURL)
		{
			NSString* applicationName = AppName;
			if(JFStringIsNullOrEmpty(applicationName))
				applicationName = @"Application";
			NSString* fileName = [applicationName stringByAppendingPathExtension:@"log"];
			fileURL = [folderURL URLByAppendingPathComponent:fileName];
		}
		else
		{
			NSString* hashtagsString = [self serializeHashtags:(JFLogHashtagAttention | JFLogHashtagFileSystem)];
			NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
			NSLog(@"%@: unable to locate the 'Application Support' system directory%@. %@", ClassName, errorString, hashtagsString);
		}
		
		// Prepares the priority.
#ifdef DEBUG
		JFLogPriority priority = JFLogPriority7Debug;
#else
		JFLogPriority priority = JFLogPriority6Info;
#endif
		
		// Concurrency
		_dateFormatterLockInitialized	= initializeDateFormatterLock(&_dateFormatterLock, class);
		_destinationsLockInitialized	= initializeDestinationsLock(&_destinationsLock, class);
		_fileLockInitialized			= initializeFileLock(&_fileLock, class);
		
		// Settings
		_dateFormatter	= createDateFormatter();
		_destinations	= (fileURL ? JFLogDestinationAll : JFLogDestinationConsole);
		_fileURL		= fileURL;
		_priority		= priority;
	}
	return self;
}

- (instancetype)initWithFileURL:(NSURL*)fileURL
{
#ifdef DEBUG
	JFLogPriority priority = JFLogPriority7Debug;
#else
	JFLogPriority priority = JFLogPriority6Info;
#endif
	
	return [self initWithFileURL:fileURL priority:priority];
}

- (instancetype)initWithFileURL:(NSURL*)fileURL priority:(JFLogPriority)priority
{
	self = [super init];
	if(self)
	{
		Class class = [self class];
		
		if(fileURL && ![fileURL isFileURL])
		{
			NSString* hashtagsString = [self serializeHashtags:(JFLogHashtagAttention | JFLogHashtagFileSystem)];
			NSLog(@"%@: the provided URL '%@' is not a file URL so it will be ignored. %@", ClassName, [fileURL absoluteString], hashtagsString);
			fileURL = nil;
		}
		
		// Concurrency
		_dateFormatterLockInitialized	= initializeDateFormatterLock(&_dateFormatterLock, class);
		_destinationsLockInitialized	= initializeDestinationsLock(&_destinationsLock, class);
		_fileLockInitialized			= initializeFileLock(&_fileLock, class);
		
		// Settings
		_dateFormatter	= createDateFormatter();
		_destinations	= (fileURL ? JFLogDestinationAll : JFLogDestinationConsole);
		_fileURL		= [fileURL copy];
		_priority		= priority;
	}
	return self;
}


#pragma mark Service management

- (void)logMessage:(NSString*)message priority:(JFLogPriority)priority
{
	[self logMessage:message priority:priority hashtags:JFLogHashtagsNone];
}

- (void)logMessage:(NSString*)message priority:(JFLogPriority)priority hashtags:(JFLogHashtags)hashtags
{
	[self logMessage:message toDestinations:self.destinations priority:priority hashtags:hashtags];
}

- (void)logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations priority:(JFLogPriority)priority
{
	[self logMessage:message toDestinations:destinations priority:priority hashtags:JFLogHashtagsNone];
}

- (void)logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations priority:(JFLogPriority)priority hashtags:(JFLogHashtags)hashtags
{
	if(!message || (priority > self.priority))
		return;
	
	BOOL shouldLogToConsole = (destinations & JFLogDestinationConsole);
	BOOL shouldLogToFile = (self.fileURL && (destinations & JFLogDestinationFile));
	
	if(!shouldLogToConsole && !shouldLogToFile)
		return;
	
	NSString* hashtagsString = [self serializeHashtags:hashtags];
	
	if(!JFStringIsNullOrEmpty(hashtagsString))
		message = [message stringByAppendingFormat:@" %@", hashtagsString];
	
	if(shouldLogToConsole)	[self logMessageToConsole:message];
	if(shouldLogToFile)		[self logMessageToFile:message];
}

- (void)logMessageToConsole:(NSString*)message
{
	if(!message)
		return;
	
	NSLog(@"%@", message);
}

- (void)logMessageToFile:(NSString*)message
{
	if(!message)
		return;
	
	// Gets the current thread ID.
	mach_port_t threadID = pthread_mach_thread_np(pthread_self());
	
	// Gets the current date as a string.
	NSString* dateString = [self stringFromCurrentDate];
	
	// Encapsulate the message.
	message = [NSString stringWithFormat:@"%@ [%x] %@\n", dateString, threadID, message];
	
	// Prepares the data to be written.
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	if(!data)
	{
		NSString* hashtagsString = [self serializeHashtags:(JFLogHashtagError | JFLogHashtagUser)];
		NSLog(@"%@: failed to create data from log message '%@'. %@", ClassName, message, hashtagsString);
		return;
	}
	
	// Prepares the block to write the data to the log file.
	JFBlock block = ^(void)
	{
		NSURL* fileURL = self.fileURL;
		
		// Tries to append the data to the log file (NSFileHandle is NOT thread safe).
		if(![self createLogFileIfNecessary])
			return;
		
		// Opens the file.
		NSError* error = nil;
		NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingToURL:fileURL error:&error];
		if(!fileHandle)
		{
			NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
			NSString* hashtagsString = [self serializeHashtags:(JFLogHashtagError | JFLogHashtagFileSystem)];
			NSLog(@"%@: could not open the log file at path '%@'%@. %@", ClassName, [fileURL path], errorString, hashtagsString);
			return;
		}
		
		// Goes to the end of the file, appends the new message and closes the file.
		[fileHandle seekToEndOfFile];
		[fileHandle writeData:data];
		[fileHandle closeFile];
	};
	
	if(_fileLockInitialized)
	{
		pthread_mutex_lock(&_fileLock);
		block();
		pthread_mutex_unlock(&_fileLock);
	}
	else
	{
		@synchronized(self)
		{
			block();
		}
	}
}


#pragma mark Utilities management

+ (NSString*)serializeHashtags:(JFLogHashtags)hashtags
{
	if(hashtags == JFLogHashtagsNone)
		return nil;
	
	// Prepares the temporary buffer.
	NSMutableArray* hashtagStrings = [NSMutableArray arrayWithCapacity:13];
	
	// Inserts each requested hashtag.
	if(hashtags & JFLogHashtagAttention)	[hashtagStrings addObject:@"#Attention"];
	if(hashtags & JFLogHashtagClue)			[hashtagStrings addObject:@"#Clue"];
	if(hashtags & JFLogHashtagComment)		[hashtagStrings addObject:@"#Comment"];
	if(hashtags & JFLogHashtagCritical)		[hashtagStrings addObject:@"#Critical"];
	if(hashtags & JFLogHashtagDeveloper)	[hashtagStrings addObject:@"#Developer"];
	if(hashtags & JFLogHashtagError)		[hashtagStrings addObject:@"#Error"];
	if(hashtags & JFLogHashtagFileSystem)	[hashtagStrings addObject:@"#FileSystem"];
	if(hashtags & JFLogHashtagHardware)		[hashtagStrings addObject:@"#Hardware"];
	if(hashtags & JFLogHashtagMarker)		[hashtagStrings addObject:@"#Marker"];
	if(hashtags & JFLogHashtagNetwork)		[hashtagStrings addObject:@"#Network"];
	if(hashtags & JFLogHashtagSecurity)		[hashtagStrings addObject:@"#Security"];
	if(hashtags & JFLogHashtagSystem)		[hashtagStrings addObject:@"#System"];
	if(hashtags & JFLogHashtagUser)			[hashtagStrings addObject:@"#User"];
	
	return [hashtagStrings componentsJoinedByString:@" "];
}

- (BOOL)createLogFileIfNecessary
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSURL* fileURL = self.fileURL;
	NSString* filePath = [fileURL path];
	
	// Checks if the log file exists.
	if([fileManager fileExistsAtPath:filePath])
		return YES;
	
	NSString* folderPath = [filePath stringByDeletingLastPathComponent];
	
	// Checks if the parent folder of the log file exists.
	if(![fileManager fileExistsAtPath:folderPath])
	{
		// Creates the parent folder.
		NSError* error = nil;
		if(![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error])
		{
			NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
			NSString* hashtagsString = [self serializeHashtags:(JFLogHashtagError | JFLogHashtagFileSystem)];
			NSLog(@"%@: could not create folder at path '%@'%@. %@", ClassName, folderPath, errorString, hashtagsString);
			return NO;
		}
	}
	
	// Creates the empty log file.
	NSError* error = nil;
	if(![[NSData data] writeToFile:filePath options:0 error:&error])
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		NSString* hashtagsString = [self serializeHashtags:(JFLogHashtagError | JFLogHashtagFileSystem)];
		NSLog(@"%@: could not create log file at path '%@'%@. %@", ClassName, filePath, errorString, hashtagsString);
		return NO;
	}
	
	return YES;
}

- (NSString*)serializeHashtags:(JFLogHashtags)hashtags
{
	return [[self class] serializeHashtags:hashtags];
}

- (NSString*)stringFromCurrentDate
{
	NSDateFormatter* dateFormatter = self.dateFormatter;
	
	NSString* retObj = nil;
	if(_dateFormatterLockInitialized)
	{
		pthread_mutex_lock(&_dateFormatterLock);
		retObj = [dateFormatter stringFromDate:[NSDate date]];
		pthread_mutex_unlock(&_dateFormatterLock);
	}
	else
	{
		@synchronized(dateFormatter)
		{
			retObj = [dateFormatter stringFromDate:[NSDate date]];
		}
	}
	return retObj;
}

@end



#pragma mark



@implementation NSObject (JFLogger)

#pragma mark Properties accessors (Logging)

- (JFLogger*)jf_logger
{
	JFLogger* retObj = objc_getAssociatedObject(self, @selector(jf_logger));
	if(!retObj)
		retObj = [JFLogger sharedManager];
	return retObj;
}

- (void)jf_setLogger:(JFLogger*)logger
{
	objc_setAssociatedObject(self, @selector(jf_logger), logger, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jf_shouldDebugLog
{
	NSNumber* number = objc_getAssociatedObject(self, @selector(jf_shouldDebugLog));
	
#ifdef DEBUG
	return (number ? [number boolValue] : YES);
#else
	return (number ? [number boolValue] : NO);
#endif
}

- (void)jf_setShouldDebugLog:(BOOL)shouldDebugLog
{
	objc_setAssociatedObject(self, @selector(jf_shouldDebugLog), @(shouldDebugLog), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jf_shouldLog
{
	NSNumber* number = objc_getAssociatedObject(self, @selector(jf_shouldLog));
	return (number ? [number boolValue] : YES);
}

- (void)jf_setShouldLog:(BOOL)shouldLog
{
	objc_setAssociatedObject(self, @selector(jf_shouldLog), @(shouldLog), OBJC_ASSOCIATION_RETAIN);
}

@end



#pragma mark - Functions (Implementations)

static NSDateFormatter* createDateFormatter()
{
	NSDateFormatter* retObj = [NSDateFormatter new];
	
	retObj.dateFormat	= @"yyyy/MM/dd HH:mm:ss.SSS";
	retObj.locale		= [NSLocale currentLocale];
	retObj.timeZone		= [NSTimeZone defaultTimeZone];
	
	return retObj;
}

static BOOL initializeDateFormatterLock(pthread_mutex_t* lock, Class class)
{
	if(!lock || ![class isSubclassOfClass:[JFLogger class]])
		return NO;
	
	int errorCode = pthread_mutex_init(lock, NULL);
	if(errorCode != 0)
	{
		NSString* className = NSStringFromClass(class);
		NSString* hashtagsString = [class serializeHashtags:(JFLogHashtagCritical | JFLogHashtagError | JFLogHashtagUser)];
		NSLog(@"%@: failed to initialize the date formatter lock for error '%@'. %@", className, JFStringFromInt(errorCode), hashtagsString);
		return NO;
	}
	
	return YES;
}

static BOOL initializeDestinationsLock(pthread_rwlock_t* lock, Class class)
{
	if(!lock || ![class isSubclassOfClass:[JFLogger class]])
		return NO;
	
	int errorCode = pthread_rwlock_init(lock, NULL);
	if(errorCode != 0)
	{
		NSString* className = NSStringFromClass(class);
		NSString* hashtagsString = [class serializeHashtags:(JFLogHashtagCritical | JFLogHashtagError | JFLogHashtagUser)];
		NSLog(@"%@: failed to initialize the destinations lock for error '%@'. %@", className, JFStringFromInt(errorCode), hashtagsString);
		return NO;
	}
	
	return YES;
}

static BOOL initializeFileLock(pthread_mutex_t* lock, Class class)
{
	if(!lock || ![class isSubclassOfClass:[JFLogger class]])
		return NO;
	
	int errorCode = pthread_mutex_init(lock, NULL);
	if(errorCode != 0)
	{
		NSString* className = NSStringFromClass(class);
		NSString* hashtagsString = [class serializeHashtags:(JFLogHashtagCritical | JFLogHashtagError | JFLogHashtagUser)];
		NSLog(@"%@: failed to initialize the file lock for error '%@'. %@", className, JFStringFromInt(errorCode), hashtagsString);
		return NO;
	}
	
	return YES;
}
