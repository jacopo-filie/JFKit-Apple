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

#import "JFManager.h"

#import <pthread/pthread.h>

#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFManager

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)defaultManager
{
	return [[self alloc] init];
}

+ (instancetype)sharedManager
{
	static NSMutableDictionary* sharedManagers = nil;
	static pthread_mutex_t mutex;
	static pthread_mutexattr_t mutexAttributes;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		pthread_mutexattr_init(&mutexAttributes);
		pthread_mutexattr_settype(&mutexAttributes, PTHREAD_MUTEX_RECURSIVE);
		pthread_mutex_init(&mutex, &mutexAttributes);
		sharedManagers = [NSMutableDictionary new];
	});
	
	id retObj = nil;
	NSString* key = ClassName;
	
	pthread_mutex_lock(&mutex);
	
	retObj = sharedManagers[key];
	if(!retObj)
	{
		retObj = [self defaultManager];
		sharedManagers[key] = retObj;
	}
	
	pthread_mutex_unlock(&mutex);
	
	return retObj;
}

- (instancetype)init
{
	return [super init];
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
