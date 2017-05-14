//
//	The MIT License (MIT)
//
//	Copyright © 2015-2017 Jacopo Filié
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

#import "JFManager.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef NSInteger JFErrorCode;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JFErrorsManager : JFManager

// MARK: Properties - Data
@property (copy, nonatomic, readonly)	NSString*	domain;

// MARK: Methods - Memory management
- (instancetype)	init;	// Sets the domain to the value of the application info property 'CFBundleIdentifier'.
- (instancetype)	initWithDomain:(NSString*)domain NS_DESIGNATED_INITIALIZER;

// MARK: Methods - Data management
- (NSString* __nullable)		debugStringForErrorCode:(JFErrorCode)errorCode;
- (NSString* __nullable)		localizedDescriptionForErrorCode:(JFErrorCode)errorCode;
- (NSString* __nullable)		localizedFailureReasonForErrorCode:(JFErrorCode)errorCode;
- (NSString* __nullable)		localizedRecoverySuggestionForErrorCode:(JFErrorCode)errorCode;
- (NSDictionary* __nullable)	userInfoForErrorCode:(JFErrorCode)errorCode;
- (NSDictionary* __nullable)	userInfoForErrorCode:(JFErrorCode)errorCode underlyingError:(NSError* __nullable)error;

// MARK: Methods - Errors management
- (NSError*)	debugPlaceholderError;
- (NSError*)	debugPlaceholderErrorWithUnderlyingError:(NSError* __nullable)error;
- (NSError*)	errorWithCode:(JFErrorCode)errorCode;
- (NSError*)	errorWithCode:(JFErrorCode)errorCode underlyingError:(NSError* __nullable)error;
- (NSError*)	errorWithCode:(JFErrorCode)errorCode userInfo:(NSDictionary* __nullable)userInfo;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
