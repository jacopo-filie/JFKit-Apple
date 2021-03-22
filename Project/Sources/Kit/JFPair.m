//
//	The MIT License (MIT)
//
//	Copyright © 2018-2021 Jacopo Filié
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

#import "JFPair.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@implementation JFPair

// =================================================================================================
// MARK: Fields
// =================================================================================================

{
@protected
	id _firstValue;
	id _secondValue;
}

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize firstValue = _firstValue;
@synthesize secondValue = _secondValue;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (instancetype)pairWithFirstValue:(id __nullable)firstValue secondValue:(id __nullable)secondValue
{
	return [[self alloc] initWithFirstValue:firstValue secondValue:secondValue];
}

- (instancetype)init
{
	return [self initWithFirstValue:nil secondValue:nil];
}

- (instancetype)initWithFirstValue:(id __nullable)firstValue secondValue:(id __nullable)secondValue
{
	self = [super init];
	
	_firstValue = firstValue;
	_secondValue = secondValue;
	
	return self;
}

// =================================================================================================
// MARK: Methods (NSCopying)
// =================================================================================================

- (id)copyWithZone:(NSZone* __nullable)zone
{
	return self;
}

// =================================================================================================
// MARK: Methods (NSMutableCopying)
// =================================================================================================

- (id)mutableCopyWithZone:(NSZone* __nullable)zone
{
	return [[JFMutablePair allocWithZone:zone] initWithFirstValue:self.firstValue secondValue:self.secondValue];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFMutablePair

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@dynamic firstValue;
@dynamic secondValue;

// =================================================================================================
// MARK: Properties (Accessors) - Data
// =================================================================================================

- (void)setFirstValue:(id __nullable)firstValue
{
	_firstValue = firstValue;
}

- (void)setSecondValue:(id __nullable)secondValue
{
	_secondValue = secondValue;
}

// =================================================================================================
// MARK: Methods (NSCopying)
// =================================================================================================

- (id)copyWithZone:(NSZone* __nullable)zone
{
	return [[JFPair allocWithZone:zone] initWithFirstValue:self.firstValue secondValue:self.secondValue];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
