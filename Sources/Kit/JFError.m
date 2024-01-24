//
//	The MIT License (MIT)
//
//	Copyright © 2017-2024 Jacopo Filié
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

#import "JFError.h"

#import "JFShortcuts.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFError

// =================================================================================================
// MARK: Properties (Inherited) - Data
// =================================================================================================

@dynamic code;
@dynamic domain;
@dynamic userInfo;

// =================================================================================================
// MARK: Properties (Accessors) - Data (User info keys)
// =================================================================================================

+ (NSErrorUserInfoKey)descriptionKey
{
	static NSString* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = @"com.jackfelle.error.description";
	});
	return retObj;
}

+ (NSErrorUserInfoKey)localizedDescriptionKey
{
	static NSString* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = NSLocalizedDescriptionKey;
	});
	return retObj;
}

+ (NSErrorUserInfoKey)localizedFailureReasonKey
{
	static NSString* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = NSLocalizedFailureReasonErrorKey;
	});
	return retObj;
}

+ (NSErrorUserInfoKey)localizedRecoverySuggestionKey
{
	static NSString* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = NSLocalizedRecoverySuggestionErrorKey;
	});
	return retObj;
}

+ (NSErrorUserInfoKey)underlyingErrorKey
{
	static NSString* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = NSUnderlyingErrorKey;
	});
	return retObj;
}

// =================================================================================================
// MARK: Properties accesors - Data (Convenience)
// =================================================================================================

- (NSString* _Nullable)description
{
	return [[self.userInfo objectForKey:self.class.descriptionKey] copy];
}

- (NSError* _Nullable)underlyingError
{
	return [[self.userInfo objectForKey:self.class.underlyingErrorKey] copy];
}

// =================================================================================================
// MARK: Properties accesors (Inherited) - Data (Convenience)
// =================================================================================================

- (NSString* _Nullable)localizedDescription
{
	return [[self.userInfo objectForKey:self.class.localizedDescriptionKey] copy];
}

- (NSString* _Nullable)localizedFailureReason
{
	return [[self.userInfo objectForKey:self.class.localizedFailureReasonKey] copy];
}

- (NSString* _Nullable)localizedRecoverySuggestion
{
	return [[self.userInfo objectForKey:self.class.localizedRecoverySuggestionKey] copy];
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)errorFromNSError:(NSError*)error
{
	return [[self alloc] initWithDomain:error.domain code:error.code userInfo:error.userInfo];
}

- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code
{
	return [self initWithDomain:domain code:code userInfo:nil];
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

+ (NSString*)composeDebugDescriptionForError:(NSError*)error
{
	NSInteger code = error.code;
	
	NSMutableString* retObj = [NSMutableString stringWithFormat:@"%@<%@> {domain = '%@', code = '%@'", ClassName, JFStringFromPointer(error), error.domain, JFStringFromNSInteger(code)];
	
	if([error isKindOfClass:JFError.class])
	{
		NSString* description = ((JFError*)error).description;
		if(!JFStringIsNullOrEmpty(description))
			[retObj appendFormat:@", description = '%@'", description];
	}
	
	NSError* underlyingError = [error.userInfo objectForKey:NSUnderlyingErrorKey];
	if(underlyingError)
		[retObj appendFormat:@", underlyingError = '%@'", [self composeDebugDescriptionForError:underlyingError]];
	
	[retObj appendString:@"}"];
	
	return [retObj copy];
}

- (NSString*)composeDebugDescription
{
	return [self.class composeDebugDescriptionForError:self];
}

// =================================================================================================
// MARK: Methods (NSCopying)
// =================================================================================================

- (instancetype)copyWithZone:(NSZone* _Nullable)zone
{
	return [[[self class] allocWithZone:zone] initWithDomain:self.domain code:self.code userInfo:self.userInfo];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
