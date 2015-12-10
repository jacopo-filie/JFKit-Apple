//
//	The MIT License (MIT)
//
//	Copyright (c) 2015 Jacopo Filié
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



#import "JFErrorsManager.h"

#import "JFShortcuts.h"
#import "JFString.h"
#import "JFUtilities.h"



@interface JFErrorsManager ()

@end



#pragma mark



@implementation JFErrorsManager

#pragma mark Properties

// Data
@synthesize domain	= _domain;


#pragma mark Memory management

- (instancetype)init
{
	return [self initWithDomain:nil];
}

- (instancetype)initWithDefaultSettings
{
	NSString* domain = AppIdentifier;
	
	self = (JFStringIsNullOrEmpty(domain) ? nil : [super initWithDefaultSettings]);
	if(self)
	{
		// Data
		_domain = domain;
	}
	return self;
}

- (instancetype)initWithDomain:(NSString*)domain
{
	self = (JFStringIsNullOrEmpty(domain) ? nil : [super init]);
	if(self)
	{
		// Data
		_domain = [domain copy];
	}
	return self;
}


#pragma mark Data management

- (NSString*)debugStringForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSString*)localizedDescriptionForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSString*)localizedFailureReasonForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSString*)localizedRecoverySuggestionForErrorCode:(JFErrorCode)errorCode
{
	return nil;
}

- (NSDictionary*)userInfoForErrorCode:(JFErrorCode)errorCode
{
	return [self userInfoForErrorCode:errorCode underlyingError:nil];
}

- (NSDictionary*)userInfoForErrorCode:(JFErrorCode)errorCode underlyingError:(NSError*)error
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


#pragma mark Errors management

- (NSError*)debugPlaceholderError
{
	return [self errorWithCode:NSIntegerMax];
}

- (NSError*)errorWithCode:(JFErrorCode)errorCode
{
	NSDictionary* userInfo = [self userInfoForErrorCode:errorCode];
	return [self errorWithCode:errorCode userInfo:userInfo];
}

- (NSError*)errorWithCode:(JFErrorCode)errorCode userInfo:(NSDictionary*)userInfo
{
	return [NSError errorWithDomain:self.domain code:errorCode userInfo:userInfo];
}

@end
