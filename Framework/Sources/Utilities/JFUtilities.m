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

#import "JFUtilities.h"

#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Constants
// =================================================================================================

NSTimeInterval const	JFAnimationDuration	= 0.25;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Functions - Comparison management
// =================================================================================================

BOOL JFAreObjectsEqual(id<NSObject> __nullable obj1, id<NSObject> __nullable obj2)
{
	// If both are 'nil', they are equal.
	if(!obj1 && !obj2)
		return YES;
	
	// If anyone is still equal to 'nil', they can't be equal.
	if(!obj1 || !obj2)
		return NO;
	
	BOOL (^checkClass)(Class) = ^BOOL(Class class)
	{
		if(![obj1 isKindOfClass:class])	return NO;
		if(![obj2 isKindOfClass:class])	return NO;
		return YES;
	};
	
	id o1 = obj1;
	id o2 = obj2;
	
	if(checkClass([NSArray class]))				return [o1 isEqualToArray:o2];
	if(checkClass([NSAttributedString class]))	return [o1 isEqualToAttributedString:o2];
	if(checkClass([NSData class]))				return [o1 isEqualToData:o2];
	if(checkClass([NSDate class]))				return [o1 isEqualToDate:o2];
	if(checkClass([NSDictionary class]))		return [o1 isEqualToDictionary:o2];
	if(checkClass([NSNumber class]))			return [o1 isEqualToNumber:o2];
	if(checkClass([NSSet class]))				return [o1 isEqualToSet:o2];
	if(checkClass([NSString class]))			return [o1 isEqualToString:o2];
	
	return [obj1 isEqual:obj2];
}

// =================================================================================================
// MARK: Functions - Resources management
// =================================================================================================

id __nullable JFApplicationInfoForKey(NSString* key)
{
	return [MainBundle.infoDictionary objectForKey:key];
}

NSURL* __nullable JFBundleResourceURLForFile(NSBundle* bundle, NSString* __nullable filename)
{
	return JFBundleResourceURLForFileWithExtension(bundle, [filename stringByDeletingPathExtension], [filename pathExtension]);
}

NSURL* __nullable JFBundleResourceURLForFileWithExtension(NSBundle* bundle, NSString* __nullable filename, NSString* __nullable type)
{
	return [bundle URLForResource:filename withExtension:type];
}

// =================================================================================================
// MARK: Functions - Runtime management
// =================================================================================================

void JFPerformSelector(NSObject* target, SEL action)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL) = (void*)implementation;
	performMethod(target, action);
}

void JFPerformSelector1(NSObject* target, SEL action, id __nullable object)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id) = (void*)implementation;
	performMethod(target, action, object);
}

void JFPerformSelector2(NSObject* target, SEL action, id __nullable obj1, id __nullable obj2)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id, id) = (void*)implementation;
	performMethod(target, action, obj1, obj2);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
