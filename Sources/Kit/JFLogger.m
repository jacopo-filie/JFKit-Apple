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
// MARK: Types
// =================================================================================================

typedef struct {
	BOOL isConsoleEnabled;
	BOOL isDelegatesEnabled;
	BOOL isFileEnabled;
} JFLoggerEnabledOutputs;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Constants
// =================================================================================================

NSString* const JFLoggerFormatDate = @"%1$@";
NSString* const JFLoggerFormatDateTime = @"%2$@";
NSString* const JFLoggerFormatMessage = @"%3$@";
NSString* const JFLoggerFormatProcessID = @"%4$@";
NSString* const JFLoggerFormatSeverity = @"%5$@";
NSString* const JFLoggerFormatThreadID = @"%6$@";
NSString* const JFLoggerFormatTime = @"%7$@";

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFLogger (/* Private */)

// =================================================================================================
// MARK: Properties - Log format
// =================================================================================================

@property (strong, nonatomic, readonly) NSArray<NSString*>* textFormatActiveValues;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@property (strong, nonatomic, readonly) JFObserversController<JFLoggerDelegate>* delegates;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFLogger

// =================================================================================================
// MARK: Fields
// =================================================================================================

{
	pthread_mutex_t _filtersMutex;
	pthread_mutex_t _writerMutex;
}

// =================================================================================================
// MARK: Properties - File system
// =================================================================================================

@synthesize fileName = _fileName;
@synthesize folder = _folder;
@synthesize rotation = _rotation;

// =================================================================================================
// MARK: Properties - Filters
// =================================================================================================

@synthesize outputFilter = _outputFilter;
@synthesize severityFilter = _severityFilter;

// =================================================================================================
// MARK: Properties - Log format
// =================================================================================================

@synthesize dateFormatter = _dateFormatter;
@synthesize dateTimeFormatter = _dateTimeFormatter;
@synthesize textFormat = _textFormat;
@synthesize textFormatActiveValues = _textFormatActiveValues;
@synthesize timeFormatter = _timeFormatter;

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

@synthesize delegates = _delegates;

// =================================================================================================
// MARK: Properties (Accessors) - File system
// =================================================================================================

- (NSURL*)currentFile
{
	return [self fileURLForDate:NSDate.date];
}

// =================================================================================================
// MARK: Properties (Accessors) - Filters
// =================================================================================================

- (JFLoggerOutput)outputFilter
{
	pthread_mutex_t* mutex = &_filtersMutex;
	[self lockMutex:mutex];
	JFLoggerOutput retVal = _outputFilter;
	[self unlockMutex:mutex];
	return retVal;
}

- (void)setOutputFilter:(JFLoggerOutput)outputFilter
{
	pthread_mutex_t* mutex = &_filtersMutex;
	[self lockMutex:mutex];
	_outputFilter = outputFilter;
	[self unlockMutex:mutex];
}

- (JFLoggerSeverity)severityFilter
{
	pthread_mutex_t* mutex = &_filtersMutex;
	[self lockMutex:mutex];
	JFLoggerSeverity retVal = _severityFilter;
	[self unlockMutex:mutex];
	return retVal;
}

- (void)setSeverityFilter:(JFLoggerSeverity)severityFilter
{
	pthread_mutex_t* mutex = &_filtersMutex;
	[self lockMutex:mutex];
	_severityFilter = severityFilter;
	[self unlockMutex:mutex];
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (void)dealloc
{
	[self destroyMutex:&_filtersMutex];
	[self destroyMutex:&_writerMutex];
}

- (instancetype)init
{
	return [self initWithSettings:[JFLoggerSettings new]];
}

- (instancetype)initWithSettings:(JFLoggerSettings*)settings
{
	self = [super init];
	
	NSString* textFormat = [settings.textFormat copy];
	
	_dateFormatter = settings.dateFormatter;
	_dateTimeFormatter = settings.dateTimeFormatter;
	_delegates = [JFObserversController<JFLoggerDelegate> new];
	_fileName = [settings.fileName copy];
	_folder = settings.folder;
	_outputFilter = JFLoggerOutputAll;
	_rotation = settings.rotation;
	_textFormat = textFormat;
	_textFormatActiveValues = [JFLogger activeValuesForTextFormat:textFormat];
	_timeFormatter = settings.timeFormatter;
	
#if DEBUG
	_severityFilter = JFLoggerSeverityDebug;
#else
	_severityFilter = JFLoggerSeverityInfo;
#endif
	
	[self initializeMutex:&_filtersMutex];
	[self initializeMutex:&_writerMutex];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (NSURL*)fileURLForDate:(NSDate*)date
{
	NSURL* folderURL = self.folder;
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
			NSString* tagsString = [JFLogger stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
			[self logTextToConsole:[NSString stringWithFormat:@"%@: could not read attributes of log file at path '%@'%@. The existing file will be considered still valid. %@", ClassName, filePath, errorString, tagsString] currentDate:currentDate];
			return YES;
		}
		
		// If the creation date is not found, it assumes that the log file is still valid.
		NSDate* creationDate = [attributes objectForKey:NSFileCreationDate];
		if(!creationDate)
		{
			NSString* tagsString = [JFLogger stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
			[self logTextToConsole:[NSString stringWithFormat:@"%@: could not read creation date of log file at path '%@'. The existing file will be considered still valid. %@", ClassName, filePath, tagsString] currentDate:currentDate];
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
				NSString* tagsString = [JFLogger stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
				[self logTextToConsole:[NSString stringWithFormat:@"%@: could not create logs folder at path '%@'%@. %@", ClassName, folderPath, errorString, tagsString] currentDate:currentDate];
				return NO;
			}
		}
	}
	
	// Creates the empty log file.
	NSError* error = nil;
	if(![NSData.data writeToFile:filePath options:NSDataWritingAtomic error:&error])
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", [error description]] : JFEmptyString);
		NSString* tagsString = [JFLogger stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
		[self logTextToConsole:[NSString stringWithFormat:@"%@: could not create log file at path '%@'%@. %@", ClassName, filePath, errorString, tagsString] currentDate:currentDate];
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
// MARK: Methods - Locks
// =================================================================================================

- (void)destroyMutex:(pthread_mutex_t*)lock
{
	if(pthread_mutex_destroy(lock) != 0) {
		NSLog(@"%@: failed to destroy %@. %@", ClassName, [self nameOfMutex:lock], [self.class stringFromTags:JFLoggerTagsCritical]);
	}
}

- (void)initializeMutex:(pthread_mutex_t*)lock
{
	if(pthread_mutex_init(lock, NULL) != 0) {
		NSLog(@"%@: failed to initialize %@. %@", ClassName, [self nameOfMutex:lock], [self.class stringFromTags:JFLoggerTagsCritical]);
	}
}

- (void)lockMutex:(pthread_mutex_t*)lock
{
	if(pthread_mutex_lock(lock) != 0) {
		NSLog(@"%@: failed to lock %@. %@", ClassName, [self nameOfMutex:lock], [self.class stringFromTags:JFLoggerTagsCritical]);
	}
}

- (NSString*)nameOfMutex:(pthread_mutex_t*)lock
{
	if(lock == &_filtersMutex) {
		return @"filters mutex";
	}
	
	if(lock == &_writerMutex) {
		return @"writer mutex";
	}
	
	return @"unknown mutex";
}

- (void)unlockMutex:(pthread_mutex_t*)lock
{
	if(pthread_mutex_unlock(lock) != 0) {
		NSLog(@"%@: failed to unlock %@. %@", ClassName, [self nameOfMutex:lock], [self.class stringFromTags:JFLoggerTagsCritical]);
	}
}

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)addDelegate:(id<JFLoggerDelegate>)delegate
{
	[self.delegates addObserver:delegate];
}

- (void)removeDelegate:(id<JFLoggerDelegate>)delegate
{
	[self.delegates removeObserver:delegate];
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
	pthread_mutex_t* filtersMutex = &_filtersMutex;
	[self lockMutex:filtersMutex];
	JFLoggerOutput outputFilter = _outputFilter;
	JFLoggerSeverity severityFilter = _severityFilter;
	[self unlockMutex:filtersMutex];
	
	// Filters by severity.
	if(severity > severityFilter) {
		return;
	}
	
	// Filters by output.
	JFLoggerEnabledOutputs outputs = [JFLogger intersectOutput:output withFilter:outputFilter];
	if(!outputs.isConsoleEnabled && !outputs.isDelegatesEnabled && !outputs.isFileEnabled) {
		return;
	}
	
	// Appends tags.
	NSString* tagsString = [JFLogger stringFromTags:tags];
	if(!JFStringIsNullOrEmpty(tagsString)) {
		message = [message stringByAppendingFormat:@" %@", tagsString];
	}
	
	// Prepares the current date.
	NSDate* currentDate = NSDate.date;
	
	NSArray<NSString*>* textFormatActiveValues = self.textFormatActiveValues;
	
	NSMutableDictionary<NSString*, NSString*>* values = [NSMutableDictionary dictionaryWithCapacity:textFormatActiveValues.count];
	
	// Converts the severity level to string.
	if([textFormatActiveValues containsObject:JFLoggerFormatSeverity]) {
		[values setObject:[JFLogger stringFromSeverity:severity] forKey:JFLoggerFormatSeverity];
	}
	
	// Gets the current process ID.
	if([textFormatActiveValues containsObject:JFLoggerFormatProcessID]) {
		[values setObject:JFStringFromInt(ProcessInfo.processIdentifier) forKey:JFLoggerFormatProcessID];
	}
	
	// Gets the current thread ID.
	if([textFormatActiveValues containsObject:JFLoggerFormatThreadID]) {
		[values setObject:JFStringFromUnsignedInt(pthread_mach_thread_np(pthread_self())) forKey:JFLoggerFormatThreadID];
	}
	
	// Gets the current date.
	if([textFormatActiveValues containsObject:JFLoggerFormatDate]) {
		[values setObject:[JFLogger stringFromDate:currentDate formatter:self.dateFormatter] forKey:JFLoggerFormatDate];
	}
	
	// Gets the current date and time.
	if([textFormatActiveValues containsObject:JFLoggerFormatDateTime]) {
		[values setObject:[JFLogger stringFromDate:currentDate formatter:self.dateTimeFormatter] forKey:JFLoggerFormatDateTime];
	}
	
	// Gets the current time.
	if([textFormatActiveValues containsObject:JFLoggerFormatTime]) {
		[values setObject:[JFLogger stringFromDate:currentDate formatter:self.timeFormatter] forKey:JFLoggerFormatTime];
	}
	
	// Gets the message.
	if([textFormatActiveValues containsObject:JFLoggerFormatMessage]) {
		[values setObject:message forKey:JFLoggerFormatMessage];
	}
	
	// Prepares the log text.
	NSString* text = JFStringByReplacingKeysInFormat(self.textFormat, values);
	
	pthread_mutex_t* writerMutex = &_writerMutex;
	[self lockMutex:writerMutex];
	
	// Logs to console if needed.
	if(outputs.isConsoleEnabled) {
		[self logTextToConsole:text currentDate:currentDate];
	}
	
	// Logs to file if needed.
	if(outputs.isFileEnabled) {
		[self logTextToFile:text currentDate:currentDate];
	}
	
	// Forwards the log message to the registered delegates if needed.
	if(outputs.isDelegatesEnabled) {
		[self.delegates notifyObservers:^(id<JFLoggerDelegate> delegate) {
			[delegate logger:self logText:text currentDate:currentDate];
		} async:YES];
	}
	
	[self unlockMutex:writerMutex];
}

- (void)log:(NSString*)message severity:(JFLoggerSeverity)severity
{
	[self log:message output:JFLoggerOutputAll severity:severity tags:JFLoggerTagsNone];
}

- (void)log:(NSString*)message severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags
{
	[self log:message output:JFLoggerOutputAll severity:severity tags:tags];
}

- (void)logTextToConsole:(NSString*)message currentDate:(NSDate*)currentDate
{
	fprintf(stderr, "%s", message.UTF8String);
}

- (void)logTextToFile:(NSString*)message currentDate:(NSDate*)currentDate
{
	// Prepares the data to be written.
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	if(!data)
	{
		NSString* tagsString = [JFLogger stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsUser)];
		[self logTextToConsole:[NSString stringWithFormat:@"%@: failed to create data from log message '%@'. %@", ClassName, message, tagsString] currentDate:currentDate];
		return;
	}
	
	NSURL* fileURL = [self fileURLForDate:currentDate];
	
	// Tries to append the data to the log file (NSFileHandle is NOT thread safe).
	if(![self createFileAtURL:fileURL currentDate:currentDate])
	{
		NSString* tagsString = [JFLogger stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
		[self logTextToConsole:[NSString stringWithFormat:@"%@: failed to create the log file at path '%@'. %@", ClassName, fileURL.path, tagsString] currentDate:currentDate];
		return;
	}
	
	// Opens the file.
	NSError* error = nil;
	NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingToURL:fileURL error:&error];
	if(!fileHandle)
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" due to error '%@'", error.description] : JFEmptyString);
		NSString* tagsString = [JFLogger stringFromTags:(JFLoggerTags)(JFLoggerTagsError | JFLoggerTagsFileSystem)];
		[self logTextToConsole:[NSString stringWithFormat:@"%@: could not open the log file at path '%@'%@. %@", ClassName, fileURL.path, errorString, tagsString] currentDate:currentDate];
		return;
	}
	
	// Goes to the end of the file, appends the new message and closes the file.
	[fileHandle seekToEndOfFile];
	[fileHandle writeData:data];
	[fileHandle closeFile];
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

+ (NSArray<NSString*>*)activeValuesForTextFormat:(NSString*)logFormat
{
	NSArray<NSString*>* values = @[JFLoggerFormatDate, JFLoggerFormatDateTime, JFLoggerFormatMessage, JFLoggerFormatProcessID, JFLoggerFormatSeverity, JFLoggerFormatThreadID, JFLoggerFormatTime];
	NSMutableArray<NSString*>* retObj = [NSMutableArray<NSString*> arrayWithCapacity:values.count];
	for(NSString* value in values) {
		if([logFormat rangeOfString:value].location != NSNotFound) {
			[retObj addObject:value];
		}
	}
	return [retObj copy];
}

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

+ (JFLoggerEnabledOutputs)intersectOutput:(JFLoggerOutput)output withFilter:(JFLoggerOutput)filter
{
	JFLoggerEnabledOutputs retVal;
	retVal.isConsoleEnabled = (output & JFLoggerOutputConsole) && (filter & JFLoggerOutputConsole);
	retVal.isDelegatesEnabled = (output & JFLoggerOutputDelegates) && (filter & JFLoggerOutputDelegates);
	retVal.isFileEnabled = (output & JFLoggerOutputFile) && (filter & JFLoggerOutputFile);
	return retVal;
}

+ (NSString*)stringFromDate:(NSDate*)date formatter:(NSDateFormatter*)formatter
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

+ (NSString*)stringFromSeverity:(JFLoggerSeverity)severity
{
	switch(severity) {
		case JFLoggerSeverityAlert: {
			return @"Alert";
		}
		case JFLoggerSeverityCritical: {
			return @"Critical";
		}
		case JFLoggerSeverityDebug: {
			return @"Debug";
		}
		case JFLoggerSeverityEmergency: {
			return @"Emergency";
		}
		case JFLoggerSeverityError: {
			return @"Error";
		}
		case JFLoggerSeverityInfo: {
			return @"Info";
		}
		case JFLoggerSeverityNotice: {
			return @"Notice";
		}
		case JFLoggerSeverityWarning: {
			return @"Warning";
		}
	}
}

+ (NSString*)stringFromTags:(JFLoggerTags)tags
{
	if(tags == JFLoggerTagsNone) {
		return JFEmptyString;
	}
	
	// Prepares the temporary buffer.
	NSMutableArray* tagStrings = [NSMutableArray arrayWithCapacity:13];
	
	// Inserts each requested hashtag.
	if(tags & JFLoggerTagsAttention) {
		[tagStrings addObject:@"#Attention"];
	}
	if(tags & JFLoggerTagsClue) {
		[tagStrings addObject:@"#Clue"];
	}
	if(tags & JFLoggerTagsComment) {
		[tagStrings addObject:@"#Comment"];
	}
	if(tags & JFLoggerTagsCritical) {
		[tagStrings addObject:@"#Critical"];
	}
	if(tags & JFLoggerTagsDeveloper) {
		[tagStrings addObject:@"#Developer"];
	}
	if(tags & JFLoggerTagsError) {
		[tagStrings addObject:@"#Error"];
	}
	if(tags & JFLoggerTagsFileSystem) {
		[tagStrings addObject:@"#FileSystem"];
	}
	if(tags & JFLoggerTagsHardware) {
		[tagStrings addObject:@"#Hardware"];
	}
	if(tags & JFLoggerTagsMarker) {
		[tagStrings addObject:@"#Marker"];
	}
	if(tags & JFLoggerTagsNetwork) {
		[tagStrings addObject:@"#Network"];
	}
	if(tags & JFLoggerTagsSecurity) {
		[tagStrings addObject:@"#Security"];
	}
	if(tags & JFLoggerTagsSystem) {
		[tagStrings addObject:@"#System"];
	}
	if(tags & JFLoggerTagsUser) {
		[tagStrings addObject:@"#User"];
	}
	
	return [tagStrings componentsJoinedByString:@" "];
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
@synthesize dateTimeFormatter = _dateTimeFormatter;
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

- (NSDateFormatter*)dateTimeFormatter
{
	NSDateFormatter* retObj = _dateTimeFormatter;
	if(!retObj) {
		retObj = [JFLoggerSettings newDefaultDateTimeFormatter];
		_dateTimeFormatter = retObj;
	}
	return retObj;
}

- (void)setDateTimeFormatter:(NSDateFormatter* _Nullable)dateTimeFormatter
{
	_dateTimeFormatter = dateTimeFormatter;
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

+ (NSString*)newDefaultDateFormat
{
	return @"yyyy/MM/dd";
}

+ (NSDateFormatter*)newDefaultDateFormatter
{
	NSDateFormatter* retObj = [NSDateFormatter new];
	retObj.dateFormat = [JFLoggerSettings newDefaultDateFormat];
	retObj.locale = [NSLocale currentLocale];
	retObj.timeZone = [NSTimeZone defaultTimeZone];
	return retObj;
}

+ (NSDateFormatter*)newDefaultDateTimeFormatter
{
	NSDateFormatter* retObj = [NSDateFormatter new];
	retObj.dateFormat = [NSString stringWithFormat:@"%@ %@", [JFLoggerSettings newDefaultDateFormat], [JFLoggerSettings newDefaultTimeFormat]];
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
	return [NSString stringWithFormat:@"%@ [%@:%@] %@\n", JFLoggerFormatDateTime, JFLoggerFormatProcessID, JFLoggerFormatThreadID, JFLoggerFormatMessage];
}

+ (NSString*)newDefaultTimeFormat
{
	return @"HH:mm:ss.SSSZ";
}

+ (NSDateFormatter*)newDefaultTimeFormatter
{
	NSDateFormatter* retObj = [NSDateFormatter new];
	retObj.dateFormat = [JFLoggerSettings newDefaultTimeFormat];
	retObj.locale = [NSLocale currentLocale];
	retObj.timeZone = [NSTimeZone defaultTimeZone];
	return retObj;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
