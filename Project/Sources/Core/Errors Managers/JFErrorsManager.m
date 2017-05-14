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

#import "JFErrorsManager.h"

#import "JFShortcuts.h"
#import "JFString.h"
#import "JFUtilities.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFErrorsManager

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize domain	= _domain;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

- (instancetype)init
{
	return [self initWithDomain:AppIdentifier];
}

- (instancetype)initWithDomain:(NSString*)domain
{
	self = [super init];
	if(self)
	{
		// Data
		_domain = [domain copy];
	}
	return self;
}

// =================================================================================================
// MARK: Methods - Data management
// =================================================================================================

- (NSString* __nullable)debugStringForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSString* __nullable)localizedDescriptionForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSString* __nullable)localizedFailureReasonForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSString* __nullable)localizedRecoverySuggestionForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSDictionary* __nullable)userInfoForErrorCode:(JFErrorCode)errorCode
{
	return [self userInfoForErrorCode:errorCode underlyingError:nil];
}

- (NSDictionary* __nullable)userInfoForErrorCode:(JFErrorCode)errorCode underlyingError:(NSError* __nullable)error
{
	NSString* description = [self localizedDescriptionForErrorCode:errorCode];
	NSString* failureReason = [self localizedFailureReasonForErrorCode:errorCode];
	NSString* recoverySuggestion = [self localizedRecoverySuggestionForErrorCode:errorCode];
	
	if(!description && !failureReason && !recoverySuggestion && !error)
		return nil;
	
	NSMutableDictionary* retObj = [NSMutableDictionary dictionary];
	if(description)			retObj[NSLocalizedDescriptionKey]				= description;
	if(error)				retObj[NSUnderlyingErrorKey]					= error;
	if(failureReason)		retObj[NSLocalizedFailureReasonErrorKey]		= failureReason;
	if(recoverySuggestion)	retObj[NSLocalizedRecoverySuggestionErrorKey]	= recoverySuggestion;
	return [retObj copy];
}

// =================================================================================================
// MARK: Methods - Errors management
// =================================================================================================

- (NSError*)debugPlaceholderError
{
	return [self debugPlaceholderErrorWithUnderlyingError:nil];
}

- (NSError*)debugPlaceholderErrorWithUnderlyingError:(NSError* __nullable)error
{
	JFErrorCode errorCode = NSIntegerMax;
	NSDictionary* userInfo = [self userInfoForErrorCode:errorCode underlyingError:error];
	return [self errorWithCode:errorCode userInfo:userInfo];
}

- (NSError*)errorWithCode:(JFErrorCode)errorCode
{
	NSDictionary* userInfo = [self userInfoForErrorCode:errorCode];
	return [self errorWithCode:errorCode userInfo:userInfo];
}

- (NSError*)errorWithCode:(JFErrorCode)errorCode underlyingError:(NSError* __nullable)error
{
	NSDictionary* userInfo = [self userInfoForErrorCode:errorCode underlyingError:error];
	return [self errorWithCode:errorCode userInfo:userInfo];
}

- (NSError*)errorWithCode:(JFErrorCode)errorCode userInfo:(NSDictionary* __nullable)userInfo
{
	return [NSError errorWithDomain:self.domain code:errorCode userInfo:userInfo];
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
