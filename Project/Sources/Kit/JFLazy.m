//
//	The MIT License (MIT)
//
//	Copyright © 2020-2021 Jacopo Filié
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

#import "JFLazy.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Macros
// =================================================================================================

#define Builder JFLazyBuilder
#define Implementation JFLazyImplementation
#define SynchronizedImplementation JFLazySynchronizedImplementation
#define Template JFLazyTemplate

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef id (^Builder)(void);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface Implementation<Template> : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly) Builder builder;
@property (strong, nonatomic, readonly) ObjectType get;
@property (strong, nonatomic, readonly, nullable) ObjectType opt;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithBuilder:(Builder)builder;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface SynchronizedImplementation<Template> : Implementation<ObjectType>

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFLazy<Template> (/* Private */)

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly) Implementation<ObjectType>* implementation;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithImplementation:(Implementation*)implementation NS_DESIGNATED_INITIALIZER;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFLazy

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize implementation = _implementation;

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

- (id)get
{
	return self.implementation.get;
}

- (id __nullable)opt
{
	return self.implementation.opt;
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

+ (instancetype)newInstance:(Builder)builder
{
	return [[JFLazy<id> alloc] initWithImplementation:[[Implementation alloc] initWithBuilder:builder]];
}

+ (instancetype)newSynchronizedInstance:(Builder)builder
{
	return [[JFLazy<id> alloc] initWithImplementation:[[SynchronizedImplementation alloc] initWithBuilder:builder]];
}

- (instancetype)initWithImplementation:(Implementation*)implementation
{
	self = [super init];
	
	_implementation = implementation;
	
	return self;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation Implementation

// =================================================================================================
// MARK: Fields
// =================================================================================================

{
@protected
	id __nullable _object;
}

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize builder = _builder;

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

- (id)get
{
	id retObj = _object;
	if(!retObj)
	{
		retObj = self.builder();
		_object = retObj;
	}
	return retObj;
}

- (id __nullable)opt
{
	return _object;
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)initWithBuilder:(Builder)builder
{
	self = [super init];
	
	_builder = builder;
	
	return self;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation SynchronizedImplementation

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (id)get
{
	@synchronized(self)
	{
		return super.get;
	}
}

- (id __nullable)opt
{
	@synchronized(self)
	{
		return super.opt;
	}
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
