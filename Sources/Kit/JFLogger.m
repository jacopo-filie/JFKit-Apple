//
//	The MIT License (MIT)
//
//	Copyright © 2015-2023 Jacopo Filié
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#import "JFLogger.h"

#import <pthread/pthread.h>

#import "JFObserversController.h"
#import "JFPreprocessorMacros.h"
#import "JFShortcuts.h"
#import "JFStrings.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Constants
// =================================================================================================

NSString* const JFLoggerFormatDate = @"%1$@";
NSString* const JFLoggerFormatMessage = @"%2$@";
NSString* const JFLoggerFormatProcessID = @"%3$@";
NSString* const JFLoggerFormatSeverity = @"%4$@";
NSString* const JFLoggerFormatThreadID = @"%5$@";
NSString* const JFLoggerFormatTime = @"%6$@";

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFLogger (/* Private */)

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, null_resettable) NSArray<NSString*>* requestedFormatValues;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (strong, nonatomic, readonly) JFObserversController<JFLoggerDelegate>* delegatesController;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFLogger

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize dateFormatter = _dateFormatter;
@synthesize format = _format;
@synthesize outputFilter = _outputFilter;
@synthesize requestedFormatValues = _requestedFormatValues;
@synthesize severityFilter = _severityFilter;
@synthesize timeFormatter = _timeFormatter;

// =================================================================================================
// MARK: Properties - File system
// =================================================================================================

@synthesize fileName = _fileName;
@synthesize rotation = _rotation;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize delegatesController = _delegatesController;

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

+ (NSURL*)defaultDirectoryURL
{
	static NSURL* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError* error = nil;
		NSURL* url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
		NSAssert(url, @"Failed to load application support directory due to error '%@'.", error.description);
		
#if JF_MACOS
		NSString* domain = AppInfoIdentifier;
		NSAssert(domain, @"Bundle identifier not found!");
		url = [url URLByAppendingPathComponent:domain];
#endif
		
		retObj = [url URLByAppendingPathComponent:@"Logs"];
	});
	return retObj;
}

- (NSDateFormatter*)dateFormatter
{
	@synchronized(self)
	{
		if(!_dateFormatter)
		{
			NSDateFormatter* dateFormatter = [NSDateFormatter new];
			dateFormatter.dateFormat = @"yyyy/MM/dd";
			dateFormatter.locale = [NSLocale currentLocale];
			dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
			_dateFormatter = dateFormatter;
		}
		return _dateFormatter;
	}
}

- (void)setDateFormatter:(NSDateFormatter* _Nullable)dateFormatter
{
	@synchronized(self)
	{
		_dateFormatter = dateFormatter;
	}
}

- (NSString*)format
{
	@synchronized(self)
	{
		if(!_format)
			_format = [NSString stringWithFormat:@"%@ %@ [%@:%@] %@\n", JFLoggerFormatDate, JFLoggerFormatTime, JFLoggerFormatProcessID, JFLoggerFormatThreadID, JFLoggerFormatMessage];
		return [_format copy];
	}
}

- (void)setFormat:(NSString* _Nullable)format
{
	@synchronized(self)
	{
		_format = [format copy];
		self.requestedFormatValues = nil;
	}
}

- (NSArray<NSString*>*)requestedFormatValues
{
	@synchronized(self)
	{
		if(!_requestedFormatValues)
		{
			static NSArray<NSString*>* possibleValues = nil;
			if(!possibleValues)
				possibleValues = @[JFLoggerFormatDate, JFLoggerFormatMessage, JFLoggerFormatProcessID, JFLoggerFormatSeverity, JFLoggerFormatThreadID, JFLoggerFormatTime];
			
			NSString* format = self.format;
			
			NSMutableArray* requestedValues = [NSMutableArray arrayWithCapacity:possibleValues.count];
			for(NSString* value in possibleValues)
			{
				if([format rangeOfString:value].location != NSNotFound)
					[requestedValues addObject:value];
			}
			
			_requestedFormatValues = [requestedValues copy];
		}
		return _requestedFormatValues;
	}
}

- (void)setRequestedFormatValues:(NSArray<NSString*>* _Nullable)requestedFormatValues
{
	@synchronized(self)
	{
		_requestedFormatValues = requestedFormatValues;
	}
}

- (NSDateFormatter*)timeFormatter
{
	@synchronized(self)
	{
		if(!_timeFormatter)
		{
			NSDateFormatter* timeFormatter = [NSDateFormatter new];
			timeFormatter.dateFormat = @"HH:mm:ss.SSSZ";
			timeFormatter.locale = [NSLocale currentLocale];
			timeFormatter.timeZone = [NSTimeZone defaultTimeZone];
			_timeFormatter = timeFormatter;
		}
		return _timeFormatter;
	}
}

- (void)setTimeFormatter:(NSDateFormatter* _Nullable)timeFormatter
{
	@synchronized(self)
	{
		_timeFormatter = timeFormatter;
	}
}

// =================================================================================================
// MARK: Properties (Accessors) - File system
// =================================================================================================

- (NSString*)fileName
{
	@synchronized(self)
	{
		if(!_fileName)
			_fileName = @"Log.log";
		return [_fileName copy];
	}
}

- (void)setFileName:(NSString* _Nullable)fileName
{
	@synchronized(self)
	{
		_fileName = [fileName copy];
	}
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	
	_delegatesController = [JFObserversController<JFLoggerDelegate> new];
	_outputFilter = JFLoggerOutputAll;
	_rotation = JFLoggerRotationNone;
#if DEBUG
	_severityFilter = JFLoggerSeverityDebug;
#else
	_severityFilter = JFLoggerSeverityInfo;
#endif
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

+ (NSString*)stringFromSeverity:(JFLoggerSeverity)severity
{
	switch(severity)
	{
		case JFLoggerSeverityAlert:
			return @"Alert";
		case JFLoggerSeverityCritical:
			return @"Critical";
		case JFLoggerSeverityDebug:
			return @"Debug";
		case JFLoggerSeverityEmergency:
			return @"Emergency";
		case JFLoggerSeverityError:
			return @"Error";
		case JFLoggerSeverityInfo:
			return @"Info";
		case JFLoggerSeverityNotice:
			return @"Notice";
		case JFLoggerSeverityWarning:
			return @"Warning";
	}
}

+ (NSString*)stringFromTags:(JFLoggerTags)tags
{
	if(tags == JFLoggerTagsNone)
		return JFEmptyString;
	
	// Prepares the temporary buffer.
	NSMutableArray* tagStrings = [NSMutableArray arrayWithCapacity:13];
	
	// Inserts each requested hashtag.
	if(tags & JFLoggerTagsAttention)
		[tagStrings addObject:@"#Attention"];
	if(tags & JFLoggerTagsClue)
		[tagStrings addObject:@"#Clue"];
	if(tags & JFLoggerTagsComment)
		[tagStrings addObject:@"#Comment"];
	if(tags & JFLoggerTagsCritical)
		[tagStrings addObject:@"#Critical"];
	if(tags & JFLoggerTagsDeveloper)
		[tagStrings addObject:@"#Developer"];
	if(tags & JFLoggerTagsError)
		[tagStrings addObject:@"#Error"];
	if(tags & JFLoggerTagsFileSystem)
		[tagStrings addObject:@"#FileSystem"];
	if(tags & JFLoggerTagsHardware)
		[tagStrings addObject:@"#Hardware"];
	if(tags & JFLoggerTagsMarker)
		[tagStrings addObject:@"#Marker"];
	if(tags & JFLoggerTagsNetwork)
		[tagStrings addObject:@"#Network"];
	if(tags & JFLoggerTagsSecurity)
		[tagStrings addObject:@"#Security"];
	if(tags & JFLoggerTagsSystem)
		[tagStrings addObject:@"#System"];
	if(tags & JFLoggerTagsUser)
		[tagStrings addObject:@"#User"];
	
	return [tagStrings componentsJoinedByString:@" "];
}

- (NSString*)dateStringFromDate:(NSDate*)date
{
	return [self stringFromDate:date formatter:self.dateFormatter];
}

- (NSString*)stringFromDate:(NSDate*)date formatter:(NSDateFormatter*)formatter
{
#if JF_IOS || JF_ARCH64
	return [formatter stringFromDate:date];
#else
	// On macOS, only the 64-bit architecture implementation of NSDateFormatter is thread-safe.
	@synchronized(formatter) {
		return [formatter stringFromDate:date];
	}
#endif
}

- (NSString*)stringFromSeverity:(JFLoggerSeverity)severity
{
	return [self.class stringFromSeverity:severity];
}

- (NSString*)stringFromTags:(JFLoggerTags)tags
{
	return [self.class stringFromTags:tags];
}

- (NSURL*)fileURLForDate:(NSDate*)date
{
	NSURL* folderURL = [self.class defaultDirectoryURL];
	NSString* fileName = self.fileName;
	
	JFLoggerRotation rotation = self.rotation;
	if(rotation == JFLoggerRotationNone) {
		return [folderURL URLByAppendingPathComponent:fileName];
	}
	
	NSCalendarUnit component = [JFLogger calendarComponentForRotation:rotation];
	if(component == 0) {
		return [folderURL URLByAppendingPathComponent:fileName];
	}
	
	NSString* extension = fileName.pathExtension;
	NSInteger suffix = [NSCalendar.currentCalendar component:component fromDate:date];
	fileName = [fileName.stringByDeletingPathExtension stringByAppendingFormat:@"-%@", JFStringFromNSInteger(suffix)];
	if(!JFStringIsNullOrEmpty(extension)) {
		fileName = [fileName stringByAppendingPathExtension:extension];
	}
	
	return [folderURL URLByAppendingPathComponent:fileName];
}

- (NSString*)timeStringFromDate:(NSDate*)date
{
	return [self stringFromDate:date formatter:self.timeFormatter];
}

// =================================================================================================
// MARK: Methods - File system
// =================================================================================================

- (BOOL)createFileAtURL:(NSURL*)fileURL currentDate:(NSDate*)currentDate
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* filePath = fileURL.path;
	
	// Checks if the log file exists.
	BOOL fileExists = [fileManager fileExistsAtPath:filePath];
	if(fileExists)
	{
		// Reads the creation date of the existing log file and check if it's still valid. If the file attributes are not readable, it assumes that the log file is still valid.
		NSError* error = nil;
		NSDictionary* attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
		if(!attributes)
		{
			NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", error.description] : JFEmptyString);
			NSString* tagsString = [self stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
			[self logToConsole:[NSString stringWithFormat:@"%@: could not read attributes of log file at path '%@'%@. The existing file will be considered still valid. %@", ClassName, filePath, errorString, tagsString] currentDate:currentDate];
			return YES;
		}
		
		// If the creation date is not found, it assumes that the log file is still valid.
		NSDate* creationDate = [attributes objectForKey:NSFileCreationDate];
		if(!creationDate)
		{
			NSString* tagsString = [self stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
			[self logToConsole:[NSString stringWithFormat:@"%@: could not read creation date of log file at path '%@'. The existing file will be considered still valid. %@", ClassName, filePath, tagsString] currentDate:currentDate];
			return YES;
		}
		
		// If the log file is not valid anymore, it goes on with the method and replaces it with a new empty one.
		if([self validateFileCreationDate:creationDate currentDate:currentDate])
			return YES;
	}
	else
	{
		NSString* folderPath = filePath.stringByDeletingLastPathComponent;
		
		// Checks if the parent folder of the log file exists.
		if(![fileManager fileExistsAtPath:folderPath])
		{
			// Creates the parent folder.
			NSError* error = nil;
			if(![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error])
			{
				NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", error.description] : JFEmptyString);
				NSString* tagsString = [self stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
				[self logToConsole:[NSString stringWithFormat:@"%@: could not create logs folder at path '%@'%@. %@", ClassName, folderPath, errorString, tagsString] currentDate:currentDate];
				return NO;
			}
		}
	}
	
	// Creates the empty log file.
	NSError* error = nil;
	if(![NSData.data writeToFile:filePath options:NSDataWritingAtomic error:&error])
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", [error description]] : JFEmptyString);
		NSString* tagsString = [self stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
		[self logToConsole:[NSString stringWithFormat:@"%@: could not create log file at path '%@'%@. %@", ClassName, filePath, errorString, tagsString] currentDate:currentDate];
		return fileExists;
	}
	
	return YES;
}

- (BOOL)validateFileCreationDate:(NSDate*)creationDate currentDate:(NSDate*)currentDate
{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSCalendarUnit components = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour);
	
	NSDateComponents* creationDateComponents = [calendar components:components fromDate:creationDate];
	NSDateComponents* currentDateComponents = [calendar components:components fromDate:currentDate];
	
	if((creationDateComponents.era != currentDateComponents.era) || (creationDateComponents.year != currentDateComponents.year)) {
		return NO;
	}
	
	switch(self.rotation) {
		case JFLoggerRotationHour: {
			if(creationDateComponents.hour != currentDateComponents.hour) {
				return NO;
			}
		}
		case JFLoggerRotationDay: {
			if(creationDateComponents.day != currentDateComponents.day) {
				return NO;
			}
		}
		case JFLoggerRotationWeek: {
			if(creationDateComponents.weekOfMonth != currentDateComponents.weekOfMonth) {
				return NO;
			}
		}
		case JFLoggerRotationMonth: {
			if(creationDateComponents.month != currentDateComponents.month) {
				return NO;
			}
		}
		default: {
			return YES;
		}
	}
}

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)addDelegate:(id<JFLoggerDelegate>)delegate
{
	[self.delegatesController addObserver:delegate];
}

- (void)removeDelegate:(id<JFLoggerDelegate>)delegate
{
	[self.delegatesController removeObserver:delegate];
}

// =================================================================================================
// MARK: Methods - Service
// =================================================================================================

- (void)log:(NSString*)message output:(JFLoggerOutput)output severity:(JFLoggerSeverity)severity
{
	[self log:message output:output severity:severity tags:JFLoggerTagsNone];
}

- (void)log:(NSString*)message output:(JFLoggerOutput)output severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags
{
	// Filters by severity.
	if(severity > self.severityFilter)
		return;
	
	// Filters by output.
	JFLoggerOutput outputFilter = self.outputFilter;
	BOOL shouldLogToConsole = (output & JFLoggerOutputConsole) && (outputFilter & JFLoggerOutputConsole);
	BOOL shouldLogToDelegates = (output & JFLoggerOutputDelegates) && (outputFilter & JFLoggerOutputDelegates);
	BOOL shouldLogToFile = (output & JFLoggerOutputFile) && (outputFilter & JFLoggerOutputFile);
	if(!shouldLogToConsole && !shouldLogToDelegates && !shouldLogToFile)
		return;
	
	// Appends tags.
	NSString* tagsString = [self stringFromTags:tags];
	if(!JFStringIsNullOrEmpty(tagsString))
		message = [message stringByAppendingFormat:@" %@", tagsString];
	
	// Prepares the current date.
	NSDate* currentDate = NSDate.date;
	
	NSString* format;
	NSArray<NSString*>* requestedFormatValues;
	@synchronized(self)
	{
		format = self.format;
		requestedFormatValues = self.requestedFormatValues;
	}
	
	NSMutableDictionary<NSString*, NSString*>* values = [NSMutableDictionary dictionaryWithCapacity:requestedFormatValues.count];
	
	// Converts the severity level to string.
	if([requestedFormatValues containsObject:JFLoggerFormatSeverity])
		[values setObject:[self stringFromSeverity:severity] forKey:JFLoggerFormatSeverity];
	
	// Gets the current process ID.
	if([requestedFormatValues containsObject:JFLoggerFormatProcessID])
		[values setObject:JFStringFromInt(ProcessInfo.processIdentifier) forKey:JFLoggerFormatProcessID];
	
	// Gets the current thread ID.
	if([requestedFormatValues containsObject:JFLoggerFormatThreadID])
		[values setObject:JFStringFromUnsignedInt(pthread_mach_thread_np(pthread_self())) forKey:JFLoggerFormatThreadID];
	
	// Gets the current date.
	if([requestedFormatValues containsObject:JFLoggerFormatDate])
		[values setObject:[self dateStringFromDate:currentDate] forKey:JFLoggerFormatDate];
	
	// Gets the current time.
	if([requestedFormatValues containsObject:JFLoggerFormatTime])
		[values setObject:[self timeStringFromDate:currentDate] forKey:JFLoggerFormatTime];
	
	// Gets the message.
	if([requestedFormatValues containsObject:JFLoggerFormatMessage])
		[values setObject:message forKey:JFLoggerFormatMessage];
	
	// Prepares the log string.
	NSString* logMessage = JFStringByReplacingKeysInFormat(format, values);
	
	// Logs to console if needed.
	if(shouldLogToConsole) {
		[self logToConsole:logMessage currentDate:currentDate];
	}
	
	// Logs to file if needed.
	if(shouldLogToFile)
		[self logToFile:logMessage currentDate:currentDate];
	
	// Forwards the log message to the registered delegates if needed.
	if(shouldLogToDelegates)
	{
		[self.delegatesController notifyObservers:^(id<JFLoggerDelegate> delegate) {
			[delegate logger:self logMessage:logMessage currentDate:currentDate];
		} async:YES];
	}
}

- (void)log:(NSString*)message severity:(JFLoggerSeverity)severity
{
	[self log:message output:JFLoggerOutputAll severity:severity tags:JFLoggerTagsNone];
}

- (void)log:(NSString*)message severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:severity tags:tags];
}

- (void)logToConsole:(NSString*)message currentDate:(NSDate*)currentDate
{
	@synchronized(self) {
		fprintf(stderr, "%s", message.UTF8String);
	}
}

- (void)logToFile:(NSString*)message currentDate:(NSDate*)currentDate
{
	// Prepares the data to be written.
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	if(!data)
	{
		NSString* tagsString = [self stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsUser)];
		[self logToConsole:[NSString stringWithFormat:@"%@: failed to create data from log message '%@'. %@", ClassName, message, tagsString] currentDate:currentDate];
		return;
	}
	
	NSURL* fileURL = [self fileURLForDate:currentDate];
	
	@synchronized(self)
	{
		// Tries to append the data to the log file (NSFileHandle is NOT thread safe).
		if(![self createFileAtURL:fileURL currentDate:currentDate])
		{
			NSString* tagsString = [self stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
			[self logToConsole:[NSString stringWithFormat:@"%@: failed to create the log file at path '%@'. %@", ClassName, fileURL.path, tagsString] currentDate:currentDate];
			return;
		}
		
		// Opens the file.
		NSError* error = nil;
		NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingToURL:fileURL error:&error];
		if(!fileHandle)
		{
			NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", error.description] : JFEmptyString);
			NSString* tagsString = [self stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
			[self logToConsole:[NSString stringWithFormat:@"%@: could not open the log file at path '%@'%@. %@", ClassName, fileURL.path, errorString, tagsString] currentDate:currentDate];
			return;
		}
		
		// Goes to the end of the file, appends the new message and closes the file.
		[fileHandle seekToEndOfFile];
		[fileHandle writeData:data];
		[fileHandle closeFile];
	}
}

// =================================================================================================
// MARK: Methods - Service (Convenience)
// =================================================================================================

- (void)logAlert:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityAlert tags:tags];
}

- (void)logCritical:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityCritical tags:tags];
}

- (void)logDebug:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityDebug tags:tags];
}

- (void)logEmergency:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityEmergency tags:tags];
}

- (void)logError:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityError tags:tags];
}

- (void)logInfo:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityInfo tags:tags];
}

- (void)logNotice:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityNotice tags:tags];
}

- (void)logWarning:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:JFLoggerSeverityWarning tags:tags];
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (NSCalendarUnit)calendarComponentForRotation:(JFLoggerRotation)rotation
{
	switch(rotation) {
		case JFLoggerRotationHour: {
			return NSCalendarUnitHour;
		}
		case JFLoggerRotationDay: {
			return NSCalendarUnitDay;
		}
		case JFLoggerRotationWeek: {
			return NSCalendarUnitWeekOfMonth;
		}
		case JFLoggerRotationMonth: {
			return NSCalendarUnitMonth;
		}
		default: {
			return 0;
		}
	}
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFKitLogger (/* Private */)

@property (class, strong, nonatomic, readonly) JFLogger* logger;

+ (void)log:(NSString*)message severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFKitLogger

static id<JFKitLoggerDelegate> __weak _delegate;

+ (id<JFKitLoggerDelegate> _Nullable)delegate
{
	@synchronized(self)
	{
		return _delegate;
	}
}

+ (void)setDelegate:(id<JFKitLoggerDelegate> _Nullable)delegate
{
	@synchronized(self)
	{
		_delegate = delegate;
	}
}

+ (JFLogger*)logger
{
	static JFLogger* retObj;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = [JFLogger new];
		retObj.outputFilter = JFLoggerOutputConsole;
	});
	return retObj;
}

+ (void)log:(NSString*)message severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags
{
	id<JFKitLoggerDelegate> delegate = self.delegate;
	if(delegate)
	{
		[delegate log:message severity:severity tags:tags];
		return;
	}
	
	[self.logger log:message severity:severity tags:tags];
}

+ (void)logAlert:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityAlert tags:tags];
}

+ (void)logCritical:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityCritical tags:tags];
}

+ (void)logDebug:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityDebug tags:tags];
}

+ (void)logEmergency:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityEmergency tags:tags];
}

+ (void)logError:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityError tags:tags];
}

+ (void)logInfo:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityInfo tags:tags];
}

+ (void)logNotice:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityNotice tags:tags];
}

+ (void)logWarning:(NSString*)message tags:(JFLoggerTags)tags
{
	[self log:message severity:JFLoggerSeverityWarning tags:tags];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFLoggerSettings

// =================================================================================================
// MARK: Properties - File system
// =================================================================================================

@synthesize fileName = _fileName;
@synthesize folder = _folder;
@synthesize rotation = _rotation;

// =================================================================================================
// MARK: Properties - Log format
// =================================================================================================

@synthesize dateFormatter = _dateFormatter;
@synthesize textFormat = _textFormat;
@synthesize timeFormatter = _timeFormatter;

// =================================================================================================
// MARK: Properties (Accessors) - File system
// =================================================================================================

- (NSString*)fileName
{
	NSString* retObj = _fileName;
	if(!retObj) {
		retObj = [JFLoggerSettings newDefaultFileName];
		_fileName = retObj;
	}
	return retObj;
}

- (void)setFileName:(NSString* _Nullable)fileName
{
	_fileName = fileName;
}

- (NSURL*)folder
{
	NSURL* retObj = _folder;
	if(!retObj) {
		retObj = [JFLoggerSettings newDefaultFolder];
		_folder = retObj;
	}
	return retObj;
}

- (void)setFolder:(NSURL* _Nullable)folder
{
	_folder = folder;
}

// =================================================================================================
// MARK: Properties (Accessors) - Log format
// =================================================================================================

- (NSDateFormatter*)dateFormatter
{
	NSDateFormatter* retObj = _dateFormatter;
	if(!retObj) {
		retObj = [JFLoggerSettings newDefaultDateFormatter];
		_dateFormatter = retObj;
	}
	return retObj;
}

- (void)setDateFormatter:(NSDateFormatter* _Nullable)dateFormatter
{
	_dateFormatter = dateFormatter;
}

- (NSString*)textFormat
{
	NSString* retObj = _textFormat;
	if(!retObj) {
		retObj = [JFLoggerSettings newDefaultTextFormat];
		_textFormat = retObj;
	}
	return retObj;
}

- (void)setTextFormat:(NSString* _Nullable)format
{
	_textFormat = format;
}

- (NSDateFormatter*)timeFormatter
{
	NSDateFormatter* retObj = _timeFormatter;
	if(!retObj) {
		retObj = [JFLoggerSettings newDefaultTimeFormatter];
		_timeFormatter = retObj;
	}
	return retObj;
}

- (void)setTimeFormatter:(NSDateFormatter* _Nullable)timeFormatter
{
	_timeFormatter = timeFormatter;
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	_rotation = JFLoggerRotationNone;
	return self;
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

+ (NSDateFormatter*)newDefaultDateFormatter
{
	NSDateFormatter* retObj = [NSDateFormatter new];
	retObj.dateFormat = @"yyyy/MM/dd";
	retObj.locale = [NSLocale currentLocale];
	retObj.timeZone = [NSTimeZone defaultTimeZone];
	return retObj;
}

+ (NSString*)newDefaultFileName
{
	return @"Logs.log";
}

+ (NSURL*)newDefaultFolder
{
	NSError* error = nil;
	NSURL* url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
	NSAssert(url, @"Failed to get URL of application support folder. [error = '%@']", error.description);
	
#if JF_MACOS
	NSString* domain = AppInfoIdentifier;
	NSAssert(domain, @"Bundle identifier not found!");
	url = [url URLByAppendingPathComponent:domain];
#endif
	
	return [url URLByAppendingPathComponent:@"Logs"];
}

+ (NSString*)newDefaultTextFormat
{
	return [NSString stringWithFormat:@"%@ %@ [%@:%@] %@\n", JFLoggerFormatDate, JFLoggerFormatTime, JFLoggerFormatProcessID, JFLoggerFormatThreadID, JFLoggerFormatMessage];
}

+ (NSDateFormatter*)newDefaultTimeFormatter
{
	NSDateFormatter* retObj = [NSDateFormatter new];
	retObj.dateFormat = @"HH:mm:ss.SSSZ";
	retObj.locale = [NSLocale currentLocale];
	retObj.timeZone = [NSTimeZone defaultTimeZone];
	return retObj;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
