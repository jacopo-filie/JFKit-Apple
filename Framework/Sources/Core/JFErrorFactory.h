//
//	The MIT License (MIT)
//
//	Copyright © 2017-2018 Jacopo Filié
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

#import "JFError.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFErrorFactory : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly) NSErrorDomain domain;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDomain:(NSErrorDomain)domain NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Data management
// =================================================================================================

- (NSString* __nullable)localizedDescriptionForErrorCode:(NSInteger)errorCode;
- (NSString* __nullable)localizedDescriptionForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* __nullable)values;
- (NSString* __nullable)localizedFailureReasonForErrorCode:(NSInteger)errorCode;
- (NSString* __nullable)localizedFailureReasonForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* __nullable)values;
- (NSString* __nullable)localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode;
- (NSString* __nullable)localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* __nullable)values;
- (NSString*)stringForErrorCode:(NSInteger)errorCode;
- (NSDictionary<NSErrorUserInfoKey, id>* __nullable)userInfoForErrorCode:(NSInteger)errorCode;
- (NSDictionary<NSErrorUserInfoKey, id>* __nullable)userInfoForErrorCode:(NSInteger)errorCode description:(NSString* __nullable)description underlyingError:(NSError* __nullable)underlyingError values:(NSDictionary<NSErrorUserInfoKey, NSDictionary<NSString*, NSString*>*>* __nullable)values;

// =================================================================================================
// MARK: Methods - Factory management
// =================================================================================================

- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* __nullable)description underlyingError:(NSError* __nullable)underlyingError values:(NSDictionary<NSErrorUserInfoKey, NSDictionary<NSString*, NSString*>*>* __nullable)values;
- (JFError*)errorWithCode:(NSInteger)errorCode userInfo:(NSDictionary<NSErrorUserInfoKey, id>* __nullable)userInfo;
- (JFError*)newPlaceholderError:(NSError* __nullable)underlyingError;

// =================================================================================================
// MARK: Methods - Factory management (Convenience)
// =================================================================================================

- (JFError*)errorWithCode:(NSInteger)errorCode;
- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* __nullable)description;
- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* __nullable)description underlyingError:(NSError* __nullable)underlyingError;
- (JFError*)errorWithCode:(NSInteger)errorCode underlyingError:(NSError* __nullable)underlyingError;
- (JFError*)newPlaceholderError;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
