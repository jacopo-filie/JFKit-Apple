//
//	The MIT License (MIT)
//
//	Copyright © 2017-2022 Jacopo Filié
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

#import "JFErrorFactory.h"

#import "JFStrings.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFErrorFactory

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize domain = _domain;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithDomain:(NSErrorDomain)domain
{
	self = [super init];
	
	_domain = [domain copy];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (NSString* _Nullable)localizedDescriptionForErrorCode:(NSInteger)errorCode
{
	return nil;
}

- (NSString* _Nullable)localizedDescriptionForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* _Nullable)values
{
	NSString* format = [self localizedDescriptionForErrorCode:errorCode];
	if(!values)
		return format;
	
	return JFStringByReplacingKeysInFormat(format, values);
}

- (NSString* _Nullable)localizedFailureReasonForErrorCode:(NSInteger)errorCode
{
	return nil;
}

- (NSString* _Nullable)localizedFailureReasonForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* _Nullable)values
{
	NSString* format = [self localizedFailureReasonForErrorCode:errorCode];
	if(!values)
		return format;
	
	return JFStringByReplacingKeysInFormat(format, values);
}

- (NSString* _Nullable)localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode
{
	return nil;
}

- (NSString* _Nullable)localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode values:(NSDictionary<NSString*, NSString*>* _Nullable)values
{
	NSString* format = [self localizedRecoverySuggestionForErrorCode:errorCode];
	if(!values)
		return format;
	
	return JFStringByReplacingKeysInFormat(format, values);
}

- (NSString*)stringForErrorCode:(NSInteger)errorCode
{
	return JFEmptyString;
}

- (NSDictionary<NSErrorUserInfoKey, id>* _Nullable)userInfoForErrorCode:(NSInteger)errorCode description:(NSString* _Nullable)description underlyingError:(NSError* _Nullable)underlyingError values:(NSDictionary<NSErrorUserInfoKey, NSDictionary<NSString*, NSString*>*>* _Nullable)values
{
	NSString* localizedDescription = [self localizedDescriptionForErrorCode:errorCode values:[values objectForKey:JFError.localizedDescriptionKey]];
	NSString* localizedFailureReason = [self localizedFailureReasonForErrorCode:errorCode values:[values objectForKey:JFError.localizedFailureReasonKey]];
	NSString* localizedRecoverySuggestion = [self localizedRecoverySuggestionForErrorCode:errorCode values:[values objectForKey:JFError.localizedRecoverySuggestionKey]];
	
	if(!description && !localizedDescription && !localizedFailureReason && !localizedRecoverySuggestion && !underlyingError)
		return nil;
	
	NSMutableDictionary<NSErrorUserInfoKey, id>* retObj = [NSMutableDictionary dictionary];
	if(description)
		[retObj setObject:description forKey:JFError.descriptionKey];
	if(localizedDescription)
		[retObj setObject:localizedDescription forKey:JFError.localizedDescriptionKey];
	if(localizedFailureReason)
		[retObj setObject:localizedFailureReason forKey:JFError.localizedFailureReasonKey];
	if(localizedRecoverySuggestion)
		[retObj setObject:localizedRecoverySuggestion forKey:JFError.localizedRecoverySuggestionKey];
	if(underlyingError)
		[retObj setObject:underlyingError forKey:JFError.underlyingErrorKey];
	return [retObj copy];
}

// =================================================================================================
// MARK: Methods - Data (Convenience)
// =================================================================================================

- (NSDictionary<NSErrorUserInfoKey, id>* _Nullable)userInfoForErrorCode:(NSInteger)errorCode
{
	return [self userInfoForErrorCode:errorCode description:nil underlyingError:nil values:nil];
}

// =================================================================================================
// MARK: Methods - Factory
// =================================================================================================

- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* _Nullable)description underlyingError:(NSError* _Nullable)underlyingError values:(NSDictionary<NSErrorUserInfoKey, NSDictionary<NSString*, NSString*>*>* _Nullable)values
{
	NSDictionary<NSErrorUserInfoKey, id>* userInfo = [self userInfoForErrorCode:errorCode description:description underlyingError:underlyingError values:values];
	return [self errorWithCode:errorCode userInfo:userInfo];
}

- (JFError*)errorWithCode:(NSInteger)errorCode userInfo:(NSDictionary<NSErrorUserInfoKey, id>* _Nullable)userInfo
{
	return [JFError errorWithDomain:self.domain code:errorCode userInfo:userInfo];
}

- (JFError*)newPlaceholderError:(NSError* _Nullable)underlyingError
{
	return [self errorWithCode:NSIntegerMax underlyingError:underlyingError];
}

// =================================================================================================
// MARK: Methods - Factory (Convenience)
// =================================================================================================

- (JFError*)errorWithCode:(NSInteger)errorCode
{
	return [self errorWithCode:errorCode description:nil underlyingError:nil values:nil];
}

- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* _Nullable)description
{
	return [self errorWithCode:errorCode description:description underlyingError:nil values:nil];
}

- (JFError*)errorWithCode:(NSInteger)errorCode description:(NSString* _Nullable)description underlyingError:(NSError* _Nullable)underlyingError
{
	return [self errorWithCode:errorCode description:description underlyingError:underlyingError values:nil];
}

- (JFError*)errorWithCode:(NSInteger)errorCode underlyingError:(NSError* _Nullable)underlyingError
{
	return [self errorWithCode:errorCode description:nil underlyingError:underlyingError values:nil];
}

- (JFError*)newPlaceholderError
{
	return [self newPlaceholderError:nil];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
