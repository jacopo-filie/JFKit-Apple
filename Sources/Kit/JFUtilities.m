//
//	The MIT License (MIT)
//
//	Copyright © 2015-2023 Jacopo Filié
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

#import "JFUtilities.h"

#import "JFShortcuts.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Constants
// =================================================================================================

NSTimeInterval const JFAnimationDuration = 0.25;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Functions - Comparison
// =================================================================================================

BOOL JFAreObjectsEqual(id<NSObject> _Nullable obj1, id<NSObject> _Nullable obj2)
{
	// If both are 'nil', they are equal.
	if(!obj1 && !obj2)
		return YES;
	
	// If anyone is still equal to 'nil', they can't be equal.
	if(!obj1 || !obj2)
		return NO;
	
	BOOL (^checkClass)(Class) = ^BOOL(Class class) {
		return ([obj1 isKindOfClass:class] && [obj2 isKindOfClass:class]);
	};
	
	id o1 = obj1;
	id o2 = obj2;
	
	if(checkClass([NSArray class]))
		return [o1 isEqualToArray:o2];
	if(checkClass([NSAttributedString class]))
		return [o1 isEqualToAttributedString:o2];
	if(checkClass([NSData class]))
		return [o1 isEqualToData:o2];
	if(checkClass([NSDate class]))
		return [o1 isEqualToDate:o2];
	if(checkClass([NSDictionary class]))
		return [o1 isEqualToDictionary:o2];
	if(checkClass([NSNumber class]))
		return [o1 isEqualToNumber:o2];
	if(checkClass([NSSet class]))
		return [o1 isEqualToSet:o2];
	if(checkClass([NSString class]))
		return [o1 isEqualToString:o2];
	
	return [obj1 isEqual:obj2];
}

// =================================================================================================
// MARK: Functions - Queues
// =================================================================================================

NSOperationQueue* JFCreateConcurrentOperationQueue(NSString* _Nullable name)
{
	NSOperationQueue* retObj = [NSOperationQueue new];
	retObj.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
	retObj.name = name;
	return retObj;
}

NSOperationQueue* JFCreateSerialOperationQueue(NSString* _Nullable name)
{
	NSOperationQueue* retObj = [NSOperationQueue new];
	retObj.maxConcurrentOperationCount = 1;
	retObj.name = name;
	return retObj;
}


// =================================================================================================
// MARK: Functions - Resources
// =================================================================================================

id _Nullable JFApplicationInfoForKey(NSString* key)
{
	return [MainBundle.infoDictionary objectForKey:key];
}

NSURL* _Nullable JFBundleResourceURLForFile(NSBundle* bundle, NSString* _Nullable filename)
{
	return JFBundleResourceURLForFileWithExtension(bundle, [filename stringByDeletingPathExtension], [filename pathExtension]);
}

NSURL* _Nullable JFBundleResourceURLForFileWithExtension(NSBundle* bundle, NSString* _Nullable filename, NSString* _Nullable type)
{
	return [bundle URLForResource:filename withExtension:type];
}

// =================================================================================================
// MARK: Functions - Runtime
// =================================================================================================

void JFPerformOnMainThread(JFBlock block)
{
	if([NSThread isMainThread])
		block();
	else
		[MainOperationQueue addOperationWithBlock:block];
}

void JFPerformOnMainThreadAndWait(JFBlock block)
{
	if([NSThread isMainThread])
		block();
	else
	{
		NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:block];
		[MainOperationQueue addOperation:operation];
		[operation waitUntilFinished];
	}
}

void JFPerformSelector(NSObject* target, SEL action)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL) = (void*)implementation;
	performMethod(target, action);
}

void JFPerformSelector1(NSObject* target, SEL action, id _Nullable object)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id) = (void*)implementation;
	performMethod(target, action, object);
}

void JFPerformSelector2(NSObject* target, SEL action, id _Nullable obj1, id _Nullable obj2)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id, id) = (void*)implementation;
	performMethod(target, action, obj1, obj2);
}

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
