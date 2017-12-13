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

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types - Common blocks
// =================================================================================================

typedef void	(^JFBlock)					(void);
typedef void	(^JFBlockWithArray)			(NSArray* array);
typedef void	(^JFBlockWithBOOL)			(BOOL value);
typedef void	(^JFBlockWithDictionary)	(NSDictionary* dictionary);
typedef void	(^JFBlockWithError)			(NSError* error);
typedef void	(^JFBlockWithInteger)		(NSInteger value);
typedef void	(^JFBlockWithNotification)	(NSNotification* notification);
typedef void	(^JFBlockWithSet)			(NSSet* set);
typedef void	(^JFCompletionBlock)		(BOOL succeeded, id __nullable object, NSError* __nullable error);
typedef void	(^JFSimpleCompletionBlock)	(BOOL succeeded, NSError* __nullable error);

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFCompletion<ObjectType> : NSObject

// MARK: Properties - Execution
@property (strong, nonatomic, readonly)	void (^block)(BOOL succeeded, ObjectType __nullable result, NSError* __nullable error)	;

// MARK: Methods - Memory management
+ (instancetype)	completionWithBlock:(void (^)(BOOL succeeded, ObjectType __nullable result, NSError* __nullable error))block;
- (instancetype)	init NS_UNAVAILABLE;
- (instancetype)	initWithBlock:(void (^)(BOOL succeeded, ObjectType __nullable result, NSError* __nullable error))block NS_DESIGNATED_INITIALIZER;

// MARK: Methods - Execution management
- (void)	executeWithError:(NSError*)error;
- (void)	executeWithError:(NSError*)error async:(BOOL)async;
- (void)	executeWithError:(NSError*)error queue:(NSOperationQueue*)queue;
- (void)	executeWithResult:(ObjectType)result;
- (void)	executeWithResult:(ObjectType)result async:(BOOL)async;
- (void)	executeWithResult:(ObjectType)result queue:(NSOperationQueue*)queue;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@interface JFSimpleCompletion : NSObject

// MARK: Properties - Execution
@property (strong, nonatomic, readonly)	JFSimpleCompletionBlock	block;

// MARK: Methods - Memory management
+ (instancetype)	completionWithBlock:(JFSimpleCompletionBlock)block;
- (instancetype)	init NS_UNAVAILABLE;
- (instancetype)	initWithBlock:(JFSimpleCompletionBlock)block NS_DESIGNATED_INITIALIZER;

// MARK: Methods - Execution management
- (void)	execute;
- (void)	execute:(BOOL)async;
- (void)	executeOnQueue:(NSOperationQueue*)queue;
- (void)	executeWithError:(NSError*)error;
- (void)	executeWithError:(NSError*)error async:(BOOL)async;
- (void)	executeWithError:(NSError*)error queue:(NSOperationQueue*)queue;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
