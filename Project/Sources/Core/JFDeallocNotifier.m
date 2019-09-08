//
//	The MIT License (MIT)
//
//	Copyright © 2019 Jacopo Filié
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

#import "JFDeallocNotifier.h"

@import ObjectiveC;

#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Constants
// =================================================================================================

static char kJFDeallocNotifierAssociatedObjectKey;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFDeallocNotifier

// =================================================================================================
// MARK: Properties - Service
// =================================================================================================

@synthesize block = _block;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (instancetype)notifierWithBlock:(JFBlock)block
{
	return [[[self class] alloc] initWithBlock:block];
}

- (void)dealloc
{
	self.block();
}

- (instancetype)initWithBlock:(JFBlock)block
{
	self = [super init];
	
	_block = block;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Service
// =================================================================================================

- (void)attachToObject:(id)object
{
	@synchronized(object)
	{
		NSMutableSet<id>* collection = objc_getAssociatedObject(object, &kJFDeallocNotifierAssociatedObjectKey);
		if(collection)
		{
			[collection addObject:self];
			return;
		}
		
		collection = [NSMutableSet<id> setWithObject:self];
		objc_setAssociatedObject(object, &kJFDeallocNotifierAssociatedObjectKey, collection, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (void)detachFromObject:(id)object
{
	@synchronized(object)
	{
		NSMutableSet<id>* collection = objc_getAssociatedObject(object, &kJFDeallocNotifierAssociatedObjectKey);
		if(!collection)
			return;
		
		[collection removeObject:self];
		if(collection.count == 0)
			objc_setAssociatedObject(object, &kJFDeallocNotifierAssociatedObjectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
