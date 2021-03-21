//
//	The MIT License (MIT)
//
//	Copyright © 2017-2021 Jacopo Filié
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

/**
 * This is an extension of the default error class `NSError` that adds some methods to easily retrieve data and compose a loggable debug description.
 */
@interface JFError : NSError

// =================================================================================================
// MARK: Properties - Data (Convenience)
// =================================================================================================

/**
 * Retrieves the string associated with the key `descriptionKey` in the user info.
 */
@property (copy, readonly, nullable) NSString* description;

/**
 * Retrieves the string associated with the key `underlyingErrorKey` in the user info.
 */
@property (copy, readonly, nullable) NSError* underlyingError;

// =================================================================================================
// MARK: Properties - Data (User info keys)
// =================================================================================================

/**
 * A key that represents the error description in the user info.
 */
@property (class, strong, readonly) NSErrorUserInfoKey descriptionKey;

/**
 * A key that represents the error localized description in the user info. Its value is the same as the key `NSLocalizedDescriptionKey`.
 */
@property (class, strong, readonly) NSErrorUserInfoKey localizedDescriptionKey;

/**
 * A key that represents the error localized description in the user info. Its value is the same as the key `NSLocalizedFailureReasonErrorKey`.
 */
@property (class, strong, readonly) NSErrorUserInfoKey localizedFailureReasonKey;

/**
 * A key that represents the error localized description in the user info. Its value is the same as the key `NSLocalizedRecoverySuggestionErrorKey`.
 */
@property (class, strong, readonly) NSErrorUserInfoKey localizedRecoverySuggestionKey;

/**
 * A key that represents the error localized description in the user info. Its value is the same as the key `NSUnderlyingErrorKey`.
 */
@property (class, strong, readonly) NSErrorUserInfoKey underlyingErrorKey;

// =================================================================================================
// MARK: Properties (Inherited) - Data
// =================================================================================================

/**
 * The code of this error.
 */
@property (readonly) NSInteger code;

/**
 * The domain of this error.
 */
@property (copy, readonly) NSErrorDomain domain;

/**
 * Additional info associated with this error.
 */
@property (copy, readonly) NSDictionary* userInfo;

// =================================================================================================
// MARK: Properties (Inherited) - Data (Convenience)
// =================================================================================================

/**
 * Retrieves the string associated with the key `localizedDescriptionKey` in the user info.
 */
@property (copy, readonly, nullable) NSString* localizedDescription;

/**
 * Retrieves the string associated with the key `localizedFailureReasonKey` in the user info.
 */
@property (copy, readonly, nullable) NSString* localizedFailureReason;

/**
 * Retrieves the string associated with the key `localizedRecoverySuggestionKey` in the user info.
 */
@property (copy, readonly, nullable) NSString* localizedRecoverySuggestion;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

/**
 * Creates a new instance of this class using the data of an error of type `NSError`.
 * @param error The source error.
 * @return A new instance of this class.
 */
+ (instancetype)errorFromNSError:(NSError*)error;

/**
 * Initializes this instance using the given domain and error code.
 * @param domain The domain of the error.
 * @param code The code of the error.
 * @return The initialized instance.
 */
- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

/**
 * Returns a new string containing the debug description of the given error.
 * @param error The source error for the debug description string.
 * @return The debug description string of the given error.
 */
+ (NSString*)composeDebugDescriptionForError:(NSError*)error;

/**
 * Returns a new string containing the debug description of this error. It calls the class method `+composeDebugDescriptionForError:` to actually compose the string.
 * @return The debug description string of this error.
 */
- (NSString*)composeDebugDescription;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
