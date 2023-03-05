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

@import Foundation;

@class JFLoggerSettings;
@protocol JFKitLoggerDelegate;
@protocol JFLoggerDelegate;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Constants
// =================================================================================================

/**
 * The date component of the logger text format string.
 */
FOUNDATION_EXPORT NSString* const JFLoggerFormatDate;

/**
 * The date and time components of the logger text format string.
 */
FOUNDATION_EXPORT NSString* const JFLoggerFormatDateTime;

/**
 * The message component of the logger text format string.
 */
FOUNDATION_EXPORT NSString* const JFLoggerFormatMessage;

/**
 * The process ID component of the logger text format string.
 */
FOUNDATION_EXPORT NSString* const JFLoggerFormatProcessID;

/**
 * The severity component of the logger text format string.
 */
FOUNDATION_EXPORT NSString* const JFLoggerFormatSeverity;

/**
 * The thread ID component of the logger text format string.
 */
FOUNDATION_EXPORT NSString* const JFLoggerFormatThreadID;

/**
 * The time component of the logger text format string.
 */
FOUNDATION_EXPORT NSString* const JFLoggerFormatTime;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * A list of available output flags that represent where the log message should be written to.
 */
typedef NS_OPTIONS(UInt8, JFLoggerOutput)
{
	/**
	 * Prints the message to the console.
	 */
	JFLoggerOutputConsole = 1 << 0,
	
	/**
	 * Forwards the message to the registered delegates.
	 */
	JFLoggerOutputDelegates = 1 << 1,
	
	/**
	 * Prints the message to the currently active log file.
	 */
	JFLoggerOutputFile = 1 << 2,
	
	/**
	 * Prints the message to all available outputs.
	 */
	JFLoggerOutputAll = (JFLoggerOutputConsole | JFLoggerOutputDelegates | JFLoggerOutputFile),
};

/**
 * A list of available time interval rotation values that is used to divide the logged messages in multiple files, based on the currently active time interval. Specific log files are created only when needed; for example, if rotation is set to `day` and file name is set to `Log.log`, the log file called `Log-5.log` will be created (or overwritten if already existing) only on the fifth day of each month.
 */
typedef NS_ENUM(UInt8, JFLoggerRotation)
{
	/**
	 * Rotation is disabled. There is only one log file.
	 */
	JFLoggerRotationNone,
	
	/**
	 * Changes log file every hour. There is one log file for each hour of the day.
	 */
	JFLoggerRotationHour,
	
	/**
	 * Changes log file every day. There is one log file for each day of the month.
	 */
	JFLoggerRotationDay,
	
	/**
	 * Changes log file every week of the month. There is one log file for each week of the month.
	 * @warning If a week starts in a month and ends in the following one, the log file is changed on the first day of the following month.
	 */
	JFLoggerRotationWeek,
	
	/**
	 * Changes log file every month. There is one log file for each month of the year.
	 */
	JFLoggerRotationMonth,
};

/**
 * A list of available severity level values for the logged message. The list is sorted from most important to most verbose.
 */
typedef NS_ENUM(UInt8, JFLoggerSeverity)
{
	/**
	 * The highest priority, usually reserved for catastrophic failures and reboot notices.
	 */
	JFLoggerSeverityEmergency,
	
	/**
	 * A serious failure in a key system.
	 */
	JFLoggerSeverityAlert,
	
	/**
	 * A failure in a key system.
	 */
	JFLoggerSeverityCritical,
	
	/**
	 * Something has failed.
	 */
	JFLoggerSeverityError,
	
	/**
	 * Something is amiss and might fail if not corrected.
	 */
	JFLoggerSeverityWarning,
	
	/**
	 * Things of moderate interest to the user or administrator.
	 */
	JFLoggerSeverityNotice,
	
	/**
	 * The lowest priority that you would normally log, and purely informational in nature.
	 */
	JFLoggerSeverityInfo,
	
	/**
	 * The lowest priority, and normally not logged except for messages from the kernel.
	 */
	JFLoggerSeverityDebug,
};

/**
 * A list of available tag flags that simplifies the assignment of standard hashtags to the log message.
 */
typedef NS_OPTIONS(UInt16, JFLoggerTags)
{
	/**
	 * Message not associated to any hashtag. Ignored if used together with other tags.
	 */
	JFLoggerTagsNone = 0,
	
	/**
	 * Message that should be investigated by a system administrator, because it may be a sign of a larger issue. For example, errors from a hard drive controller that typically occur when the drive is about to fail.
	 */
	JFLoggerTagsAttention = 1 << 0,
	
	/**
	 * Message containing extra key/value pairs with additional information to help reconstruct the context.
	 */
	JFLoggerTagsClue = 1 << 1,
	
	/**
	 * Message that is a comment.
	 */
	JFLoggerTagsComment = 1 << 2,
	
	/**
	 * Message in the context of a critical event or critical failure.
	 */
	JFLoggerTagsCritical = 1 << 3,
	
	/**
	 * Message in the context of software development. For example, deprecated APIs and debugging messages.
	 */
	JFLoggerTagsDeveloper = 1 << 4,
	
	/**
	 * Message that is a noncritical error.
	 */
	JFLoggerTagsError = 1 << 5,
	
	/**
	 * Message describing a file system related event.
	 */
	JFLoggerTagsFileSystem = 1 << 6,
	
	/**
	 * Message describing a hardware-related event.
	 */
	JFLoggerTagsHardware = 1 << 7,
	
	/**
	 * Message that marks a change to divide the messages around it into those before and those after the change.
	 */
	JFLoggerTagsMarker = 1 << 8,
	
	/**
	 * Message describing a network-related event.
	 */
	JFLoggerTagsNetwork = 1 << 9,
	
	/**
	 * Message related to security concerns.
	 */
	JFLoggerTagsSecurity = 1 << 10,
	
	/**
	 * Message in the context of a system process.
	 */
	JFLoggerTagsSystem = 1 << 11,
	
	/**
	 * Message in the context of a user process.
	 */
	JFLoggerTagsUser = 1 << 12,
};

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * The `JFLogger` manages all the necessary code to log messages to both console and files, formatting the resulting string with a default style or with a custom style (composed with the available constants) using the property `format`. It also handles the automatic rotation of log files based on the time interval specified with the property `rotation` and the base name of the log files can be customized using the property `fileName`. The date and time formatters used when composing the log message can also be customized through the properties `dateFormatter` and `timeFormatter`, if you need more control over them. There are also a couple of filter options that prevent some logs from being written to the output on specific conditions, like when the severity of the message is not enough (see property `severityFilter`) or when the specified output for that message is not available for this logger (see property `outputFilter`).
 */
@interface JFLogger : NSObject

// =================================================================================================
// MARK: Properties - File system
// =================================================================================================

/**
 * The base name of the log files. Suffixes will be appended to it (before the extension).
 * @see JFLoggerSettings.fileName
 */
@property (strong, nonatomic, readonly) NSString* fileName;

/**
 * The folder at which the log files will be located.
 * @see JFLoggerSettings.folder
 */
@property (strong, nonatomic, readonly) NSURL* folder;

/**
 * The used log file will be changed after each rotation cycle, overwriting old existing files if needed.
 * @see JFLoggerSettings.rotation
 */
@property (assign, nonatomic, readonly) JFLoggerRotation rotation;

// =================================================================================================
// MARK: Properties - Filters
// =================================================================================================

/**
 * Messages will be logged only if their selected output passes this filter.
 * The default value is `JFLoggerOutputAll`.
 */
@property (assign) JFLoggerOutput outputFilter;

/**
 * Messages will be logged only if their assigned severity level passes this filter.
 * The default value is `JFLoggerSeverityInfo` in release compilation mode, `JFLoggerSeverityDebug` in debug compilation mode.
 */
@property (assign) JFLoggerSeverity severityFilter;

// =================================================================================================
// MARK: Properties - Log format
// =================================================================================================

/**
 * The formatter to use when converting current date to string.
 * @see JFLoggerSettings.dateFormatter
 */
@property (strong, nonatomic, readonly) NSDateFormatter* dateFormatter;

/**
 * The formatter to use when converting current date and time to string.
 * @see JFLoggerSettings.dateTimeFormatter
 */
@property (strong, nonatomic, readonly) NSDateFormatter* dateTimeFormatter;

/**
 * The format string of each log written on file.
 * @see JFLoggerSettings.textFormat
 */
@property (strong, nonatomic, readonly) NSString* textFormat;

/**
 * The formatter to use when converting current time to string.
 * @see JFLoggerSettings.timeFormatter
 */
@property (strong, nonatomic, readonly) NSDateFormatter* timeFormatter;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Initializes a new logger instance with the default settings.
 * @return A new instance of this class.
 */
- (instancetype)init;

/**
 * Initializes a new logger instance with the given settings.
 * @param settings The settings to use to customize the behavior of the logger.
 * @return A new instance of this class.
 */
- (instancetype)initWithSettings:(JFLoggerSettings*)settings NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

/**
 * Returns a string containing the given severity level.
 * @param severity The severity level to convert to string.
 * @return A string containing the given severity level.
 */
+ (NSString*)stringFromSeverity:(JFLoggerSeverity)severity;

/**
 * Returns a string containing all the given tags, sorted alphabetically.
 * @param tags The tags to convert to string.
 * @return A string containing all the given tags, sorted alphabetically.
 */
+ (NSString*)stringFromTags:(JFLoggerTags)tags;

/**
 * Returns the URL of the log file used for the given date.
 * @param date The reference date.
 * @return The log file URL.
 */
- (NSURL*)fileURLForDate:(NSDate*)date;

/**
 * Returns a string containing the given severity level. This method simply calls the method `+stringFromSeverity:` of this class.
 * @param severity The severity level to convert to string.
 * @return A string containing the given severity level.
 */
- (NSString*)stringFromSeverity:(JFLoggerSeverity)severity;

/**
 * Returns a string containing all the given tags, sorted alphabetically. This method simply calls the method `+stringFromTags:` of this class.
 * @param tags The tags to convert to string.
 * @return A string containing all the given tags, sorted alphabetically.
 */
- (NSString*)stringFromTags:(JFLoggerTags)tags;

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

/**
 * Registers a delegate. If the given delegate is already registered, it does nothing.
 * @param delegate The delegate to register.
 */
- (void)addDelegate:(id<JFLoggerDelegate>)delegate;

/**
 * Unregisters a delegate. If the given delegate is not registered yet, it does nothing.
 * @param delegate The delegate to unregister.
 */
- (void)removeDelegate:(id<JFLoggerDelegate>)delegate;

// =================================================================================================
// MARK: Methods - Service
// =================================================================================================

/**
 * Logs the given message to the selected outputs, assigning it the given severity level.
 * @param message The string to log.
 * @param output The destinations where the message is to be logged.
 * @param severity The severity level of the given message.
 */
- (void)log:(NSString*)message output:(JFLoggerOutput)output severity:(JFLoggerSeverity)severity;

/**
 * Logs the given message to the selected outputs, assigning it the given severity level and appending it the given tags.
 * @param message The string to log.
 * @param output The destinations where the message is to be logged.
 * @param severity The severity level of the given message.
 * @param tags The tags assigned to the given message.
 */
- (void)log:(NSString*)message output:(JFLoggerOutput)output severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags;

/**
 * Logs the given message to all available outputs, assigning it the given severity level.
 * @param message The string to log.
 * @param severity The severity level of the given message.
 */
- (void)log:(NSString*)message severity:(JFLoggerSeverity)severity;

/**
 * Logs the given message to all available outputs, assigning it the given severity level and appending it the given tags.
 * @param message The string to log.
 * @param severity The severity level of the given message.
 * @param tags The tags assigned to the given message.
 */
- (void)log:(NSString*)message severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags;

// =================================================================================================
// MARK: Methods - Service (Convenience)
// =================================================================================================

/**
 * Logs the given message to the selected outputs, assigning it the `alert` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logAlert:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message to the selected outputs, assigning it the `critical` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logCritical:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message to the selected outputs, assigning it the `debug` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logDebug:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message to the selected outputs, assigning it the `emergency` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logEmergency:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message to the selected outputs, assigning it the `error` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logError:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message to the selected outputs, assigning it the `info` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logInfo:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message to the selected outputs, assigning it the `notice` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logNotice:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message to the selected outputs, assigning it the `warning` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
- (void)logWarning:(NSString*)message tags:(JFLoggerTags)tags;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * Use the `JFLoggerSettings` class to set up a logger with custom options, like the text format or the location of the log file.
 */
@interface JFLoggerSettings : NSObject

// =================================================================================================
// MARK: Properties - File system
// =================================================================================================

/**
 * The base name of the log files. Suffixes will be appended to it (before the extension).
 * The default value is `Log.log`.
 */
@property (strong, nonatomic, null_resettable) NSString* fileName;

/**
 * The folder at which the log files will be located.
 * @discussion
 * The default folder is platform-dependent: on iOS it's located at path `Library/Application Support/Logs`; on macOS it's located at path `Library/Application Support/<bundle identifier>/Logs`.
 */
@property (strong, nonatomic, null_resettable) NSURL* folder;

/**
 * The used log file will be changed after each rotation cycle, overwriting old existing files if needed.
 * The default value is `JFLoggerRotationNone`.
 */
@property (assign, nonatomic) JFLoggerRotation rotation;

// =================================================================================================
// MARK: Properties - Log format
// =================================================================================================

/**
 * The formatter to use when converting current date to string.
 * This is used only if the text format contains the component `JFLoggerFormatDate`.
 */
@property (strong, nonatomic, null_resettable) NSDateFormatter* dateFormatter;

/**
 * The formatter to use when converting current date and time to string.
 * This is used only if the text format contains the component `JFLoggerFormatDateTime`.
 */
@property (strong, nonatomic, null_resettable) NSDateFormatter* dateTimeFormatter;

/**
 * The format string of each log written on file. The following constants can be used to retrieve specific values:
 * @code
 *   JFLoggerFormatDate      = the current date;
 *   JFLoggerFormatDateTime  = the current date and time;
 *   JFLoggerFormatMessage   = the message to log;
 *   JFLoggerFormatProcessID = the ID of the running process;
 *   JFLoggerFormatSeverity  = the severity of the message;
 *   JFLoggerFormatThreadID  = the ID of the running thread;
 *   JFLoggerFormatTime      = the current time;
 * @endcode
 * For example, the default format is composed like this:
 * @code
 *   NSString* format = [NSString stringWithFormat:@"%@ [%@:%@] %@\n", JFLoggerFormatDateTime, JFLoggerFormatProcessID, JFLoggerFormatThreadID, JFLoggerFormatMessage];
 * @endcode
 */
@property (strong, nonatomic, null_resettable) NSString* textFormat;

/**
 * The formatter to use when converting current time to string.
 * This is used only if the text format contains the component `JFLoggerFormatTime`.
 */
@property (strong, nonatomic, null_resettable) NSDateFormatter* timeFormatter;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * The protocol that the delegates of the logger must implement.
 */
@protocol JFLoggerDelegate <NSObject>

@required

/**
 * Sends the delegate the formatted log message, passing also the reference current date associated with it.
 * @param sender The logger instance.
 * @param message The formatted message.
 * @param date The date associated with the log message.
 * @warning The parameter `message` is not the original string given to the logger, it's the result of the composition of the format string (see parameter `format`) and the available values.
 */
- (void)logger:(JFLogger*)sender logMessage:(NSString*)message currentDate:(NSDate*)date;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFKitLogger : NSObject

// =================================================================================================
// MARK: Properties - Observers
// =================================================================================================

/**
 * The delegate of the kit logger.
 */
@property (class, weak, nullable) id<JFKitLoggerDelegate> delegate;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@protocol JFKitLoggerDelegate <NSObject>

@required

- (void)log:(NSString*)message severity:(JFLoggerSeverity)severity tags:(JFLoggerTags)tags;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
