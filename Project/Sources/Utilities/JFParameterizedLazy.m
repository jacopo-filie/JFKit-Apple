//
//	The MIT License (MIT)
//
//	Copyright © 2020 Jacopo Filié
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

#import "JFParameterizedLazy.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Macros
// =================================================================================================

#define Builder ParameterizedLazyBuilder
#define Implementation ParameterizedLazyImplementation
#define SynchronizedImplementation ParameterizedLazySynchronizedImplementation
#define Template ParameterizedLazyTemplate

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Types
// =================================================================================================

typedef id (^Builder)(id param);

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface Implementation<Template> : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly) Builder builder;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithBuilder:(Builder)builder;

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (ObjectType)getObject:(ParamType)param;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface SynchronizedImplementation<Template> : Implementation<ObjectType, ParamType>

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFParameterizedLazy<Template> (/* Private */)

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (strong, nonatomic, readonly) Implementation<ObjectType, ParamType>* implementation;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

- (instancetype)initWithImplementation:(Implementation*)implementation NS_DESIGNATED_INITIALIZER;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFParameterizedLazy

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize implementation = _implementation;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (instancetype)newInstance:(Builder)builder
{
	return [[JFParameterizedLazy<id, id> alloc] initWithImplementation:[[Implementation alloc] initWithBuilder:builder]];
}

+ (instancetype)newSynchronizedInstance:(Builder)builder
{
	return [[JFParameterizedLazy<id, id> alloc] initWithImplementation:[[SynchronizedImplementation alloc] initWithBuilder:builder]];
}

- (instancetype)initWithImplementation:(Implementation*)implementation
{
	self = [super init];
	
	_implementation = implementation;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (id)getObject:(id)param
{
	return [self.implementation getObject:param];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

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
// MARK: Methods - Memory
// =================================================================================================

- (instancetype)initWithBuilder:(Builder)builder
{
	self = [super init];
	
	_builder = builder;
	
	return self;
}

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (id)getObject:(id)param
{
	id retObj = _object;
	if(!retObj)
	{
		retObj = self.builder(param);
		_object = retObj;
	}
	return retObj;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation SynchronizedImplementation

// =================================================================================================
// MARK: Methods - Data
// =================================================================================================

- (id)getObject:(id)param
{
	id retObj = _object;
	if(retObj)
		return retObj;
	
	@synchronized(self)
	{
		return [super getObject:param];
	}
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
