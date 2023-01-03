//
//	The MIT License (MIT)
//
//	Copyright © 2017-2023 Jacopo Filié
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

#import <JFKit/JFError.h>

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/**
 * The class `JFErrorFactory` is a base class that implements many methods to easily create new errors using the given information. It is associated with a specific domain during initialization and can create any kind of error for that specific domain. To use the localized methods, you need to subclass this class and override instance methods `-localizedDescriptionForErrorCode:`, `localizedFailureReasonForErrorCode:` and `localizedRecoverySuggestionForErrorCode:` to let them return the localized strings for the given error code. The instance methods `-localizedDescriptionForErrorCode:values:`, `localizedFailureReasonForErrorCode:values:` and `localizedRecoverySuggestionForErrorCode:values:` rely on them to retrieve the format string to populate with the given values; it is not necessary to subclass these methods.
 */
@interface JFErrorFactory : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The domain associated with the errors created with this factory.
 */
@property (strong, nonatomic, readonly) NSErrorDomain domain;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given domain.
 * @param domain The domain to associated to all created errors.
 * @return This initialized instance.
 */
- (instancetype)initWithDomain:(NSErrorDomain)domain NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

/**
 * Returns the localized description for the given error code.
 * @param errorCode The code of the error.
 * @return The localized description for the given error code.
 * @warning You need to override this method in a subclass for it to return something different than `nil`.
 */
- (NSString* _Nullable)localizedDescriptionForErrorCode:(NSInteger)errorCode;

/**
 * Returns the localized description for the given error code using the given values to replace any key found in it.
 * @param errorCode The code of the error.
 * @param values The values to use when replacing the keys found in the localized string.
 * @return The localized description for the given error code.
 */
- (NSString* _Nullable)localizedDescriptionForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* _Nullable)values;

/**
 * Returns the localized failure reason for the given error code using the given values to replace any key found in it.
 * @param errorCode The code of the error.
 * @return The localized failure reason for the given error code.
 * @warning You need to override this method in a subclass for it to return something different than `nil`.
 */
- (NSString* _Nullable)localizedFailureReasonForErrorCode:(NSInteger)errorCode;

/**
 * Returns the localized failure reason for the given error code using the given values to replace any key found in it.
 * @param errorCode The code of the error.
 * @param values The values to use when replacing the keys found in the localized string.
 * @return The localized failure reason for the given error code.
 */
- (NSString* _Nullable)localizedFailureReasonForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* _Nullable)values;

/**
 * Returns the localized recovery suggestion for the given error code using the given values to replace any key found in it.
 * @param errorCode The code of the error.
 * @return The localized recovery suggestion for the given error code.
 * @warning You need to override this method in a subclass for it to return something different than `nil`.
 */
- (NSString* _Nullable)localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode;

/**
 * Returns the localized recovery suggestion for the given error code using the given values to replace any key found in it.
 * @param errorCode The code of the error.
 * @param values The values to use when replacing the keys found in the localized string.
 * @return The localized recovery suggestion for the given error code.
 */
- (NSString* _Nullable)localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* _Nullable)values;

/**
 * Returns a string containing the given error code (tipically the name of the constant that represents the error code).
 * @param errorCode The errorCode to convert to string.
 * @return A string containing the given error code.
 */
- (NSString*)stringForErrorCode:(NSInteger)errorCode;

/**
 * Creates the user info for the given error code.
 * @param errorCode The code of the error.
 * @return The user info for the given error code.
 */
- (NSDictionary<NSErrorUserInfoKey, id>* _Nullable)userInfoForErrorCode:(NSInteger)errorCode;

/**
 * Creates the user info for the given error code using the given information (description, underlying error and values). To retrieve the needed localized information, this method calls the other instance methods `-localizedDescriptionForErrorCode:values:`, `localizedFailureReasonForErrorCode:values:` and `localizedRecoverySuggestionForErrorCode:values:` passing the appropriate values, found in `values`, to each of them. For example, when calling `-localizedDescriptionForErrorCode:values:`, this method passes the dictionary found in `values` associated with the key `JFError.localizedDescriptionKey`.
 * @param errorCode The code of the error.
 * @param description The description string of the error.
 * @param underlyingError The underlying error the caused the error owner of this user info.
 * @param values The values to use when replacing the keys found in the localized strings.
 * @return The user info for the given error code.
 */
- (NSDictionary<NSErrorUserInfoKey, id>* _Nullable)userInfoForErrorCode:(NSInteger)errorCode description:(NSString* _Nullable)description underlyingError:(NSError* _Nullable)underlyingError values:(NSDictionary<NSErrorUserInfoKey, NSDictionary<NSString*, NSString*>*>* _Nullable)values;

// =================================================================================================
// MARK: Methods - Factory
// =================================================================================================

/**
 * Creates a new error with the given information. The domain is the same of this factory instance.
 * @param errorCode The code of the error.
 * @param description The description of the error.
 * @param underlyingError The underlying error that caused the created error.
 * @param values The values to use when replacing the keys found in the localized strings.
 * @return A new error with the given information.
 */
- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* _Nullable)description underlyingError:(NSError* _Nullable)underlyingError values:(NSDictionary<NSErrorUserInfoKey, NSDictionary<NSString*, NSString*>*>* _Nullable)values;

/**
 * Creates a new error with the given information. The domain is the same of this factory instance.
 * @param errorCode The code of the error.
 * @param userInfo The user info of the error.
 * @return A new error with the given information.
 */
- (JFError*)errorWithCode:(NSInteger)errorCode userInfo:(NSDictionary<NSErrorUserInfoKey, id>* _Nullable)userInfo;

/**
 * Creates a new placeholder error with code `NSIntegerMax`.
 * @param underlyingError The underlying error that caused the created error.
 * @return A new placeholder error.
 * @warning You should never use this in production builds.
 */
- (JFError*)newPlaceholderError:(NSError* _Nullable)underlyingError;

// =================================================================================================
// MARK: Methods - Factory (Convenience)
// =================================================================================================

/**
 * A convenient method to create an error using only the given error code.
 * @param errorCode The code of the error.
 * @return A new error with the given error code.
 */
- (JFError*)errorWithCode:(NSInteger)errorCode;

/**
 * A convenient method to create an error using the given information.
 * @param errorCode The code of the error.
 * @param description The description of the error.
 * @return A new error with the given information.
 */
- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* _Nullable)description;

/**
 * A convenient method to create an error using the given information.
 * @param errorCode The code of the error.
 * @param description The description of the error.
 * @param underlyingError The underlying error that caused the created error.
 * @return A new error with the given information.
 */
- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* _Nullable)description underlyingError:(NSError* _Nullable)underlyingError;

/**
 * A convenient method to create an error using the given information.
 * @param errorCode The code of the error.
 * @param underlyingError The underlying error that caused the created error.
 * @return A new error with the given information.
 */
- (JFError*)errorWithCode:(NSInteger)errorCode underlyingError:(NSError* _Nullable)underlyingError;

/**
 * Creates a new placeholder error with code `NSIntegerMax`.
 * @return A new placeholder error.
 * @warning You should never use this in production builds.
 */
- (JFError*)newPlaceholderError;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
