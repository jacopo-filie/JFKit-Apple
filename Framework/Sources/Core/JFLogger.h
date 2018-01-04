//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef NS_OPTIONS(UInt8, JFLoggerOutput)
{
	JFLoggerOutputConsole	= 1 << 0,	// Prints the message to the console.
	JFLoggerOutputFile		= 1 << 1,	// Writes the message into the file if 'fileURL' is set.
	
	JFLoggerOutputAll		= (JFLoggerOutputConsole | JFLoggerOutputFile),
};

typedef NS_ENUM(UInt8, JFLoggerRotation)
{
	JFLoggerRotationNone,
	JFLoggerRotationHour,
	JFLoggerRotationDay,
	JFLoggerRotationWeek,
	JFLoggerRotationMonth,
};

typedef NS_ENUM(UInt8, JFLoggerSeverity)
{
	JFLoggerSeverityEmergency,	// The highest priority, usually reserved for catastrophic failures and reboot notices.
	JFLoggerSeverityAlert,		// A serious failure in a key system.
	JFLoggerSeverityCritical,	// A failure in a key system.
	JFLoggerSeverityError,		// Something has failed.
	JFLoggerSeverityWarning,	// Something is amiss and might fail if not corrected.
	JFLoggerSeverityNotice,		// Things of moderate interest to the user or administrator.
	JFLoggerSeverityInfo,		// The lowest priority that you would normally log, and purely informational in nature.
	JFLoggerSeverityDebug,		// The lowest priority, and normally not logged except for messages from the kernel.
};

typedef NS_OPTIONS(UInt16, JFLoggerTags)
{
	JFLoggerTagsNone		= 0,		// Message is not associated to any hashtag.
	
	JFLoggerTagsAttention	= 1 << 0,	// Message that should be investigated by a system administrator, because it may be a sign of a larger issue. For example, errors from a hard drive controller that typically occur when the drive is about to fail.
	JFLoggerTagsClue		= 1 << 1,	// Message containing extra key/value pairs with additional information to help reconstruct the context.
	JFLoggerTagsComment		= 1 << 2,	// Message that is a comment.
	JFLoggerTagsCritical	= 1 << 3,	// Message in the context of a critical event or critical failure.
	JFLoggerTagsDeveloper	= 1 << 4,	// Message in the context of software development. For example, deprecated APIs and debugging messages.
	JFLoggerTagsError		= 1 << 5,	// Message that is a noncritical error.
	JFLoggerTagsFileSystem	= 1 << 6,	// Message describing a file system related event.
	JFLoggerTagsHardware	= 1 << 7,	// Message describing a hardware-related event.
	JFLoggerTagsMarker		= 1 << 8,	// Message that marks a change to divide the messages around it into those before and those after the change.
	JFLoggerTagsNetwork		= 1 << 9,	// Message describing a network-related event.
	JFLoggerTagsSecurity	= 1 << 10,	// Message related to security concerns.
	JFLoggerTagsSystem		= 1 << 11,	// Message in the context of a system process.
	JFLoggerTagsUser		= 1 << 12,	// Message in the context of a user process.
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFLogger : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * Creates the default directory for the log files on the current platform. This method returns a platform-dependent `NSURL` at which the log files will be located or are currently located. The default directory is located at path `Library/Application Support/Logs` on iOS and `Library/Application Support/<bundle identifier>/Logs` on macOS.
 */
@property (class, strong, readonly) NSURL* defaultDirectoryURL;

/**
 * The formatter to use when converting current date to string.
 */
@property (strong, null_resettable) NSDateFormatter* dateFormatter;

/**
 * The format string of each log written on file.
 * @warning Due to the implementation details, log to console ignores this property and uses the platform-dependent default format string.
 */
@property (copy, null_resettable) NSString* format;

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

/**
 * The formatter to use when converting current time to string.
 */
@property (strong, null_resettable) NSDateFormatter* timeFormatter;

// =================================================================================================
// MARK: Properties - File system
// =================================================================================================

/**
 * The base name of the log files. Suffixes will be appended to it (before the extension).
 * The default value is `Log.log`.
 */
@property (copy, null_resettable) NSString* fileName;

/**
 * The used log file will be changed after each rotation cycle, overwriting old existing files if needed.
 * The default value is `JFLoggerRotationNone`.
 */
@property (assign) JFLoggerRotation rotation;

// =================================================================================================
// MARK: Methods - Data management
// =================================================================================================

/**
 * Returns a string containing all the given tags, sorted alphabetically.
 * @param tags The tags to convert to string.
 * @return A string containing all the given tags, sorted alphabetically.
 */
+ (NSString*)stringFromTags:(JFLoggerTags)tags;

/**
 * Returns a string containing all the given tags, sorted alphabetically. This method simply calls the method `+stringFromTags:` of this class.
 * @param tags The tags to convert to string.
 * @return A string containing all the given tags, sorted alphabetically.
 */
- (NSString*)stringFromTags:(JFLoggerTags)tags;

// =================================================================================================
// MARK: Methods - Service management
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
// MARK: Methods - Service management (Convenience)
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

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
