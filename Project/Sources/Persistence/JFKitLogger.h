//
//	The MIT License (MIT)
//
//	Copyright © 2015-2020 Jacopo Filié
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

#import "JFLogger.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * The following methods should only be used to log kit messages.
 */
@interface JFKitLogger (/* Project */)

// =================================================================================================
// MARK: Methods - Service
// =================================================================================================

/**
 * Logs the given message, assigning it the `alert` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logAlert:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message, assigning it the `critical` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logCritical:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message, assigning it the `debug` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logDebug:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message, assigning it the `emergency` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logEmergency:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message, assigning it the `error` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logError:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message, assigning it the `info` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logInfo:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message, assigning it the `notice` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logNotice:(NSString*)message tags:(JFLoggerTags)tags;

/**
 * Logs the given message, assigning it the `warning` severity level and appending it the given tags.
 * @param message The string to log.
 * @param tags The tags assigned to the given message.
 */
+ (void)logWarning:(NSString*)message tags:(JFLoggerTags)tags;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
