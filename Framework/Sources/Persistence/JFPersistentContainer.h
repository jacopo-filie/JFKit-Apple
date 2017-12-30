//
//	The MIT License (MIT)
//
//	Copyright © 2017 Jacopo Filié
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

@import CoreData;

@class JFSimpleCompletion;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFPersistentContainer : NSObject

// MARK: Properties - Data
@property (class, strong, readonly)		NSURL*					defaultDirectoryURL;
@property (strong, nonatomic, readonly)	NSManagedObjectModel*	model;
@property (strong, nonatomic, readonly)	NSString*				name;

// MARK: Properties - Stack
@property (strong, readonly)	NSPersistentStoreCoordinator*	coordinator;
@property (strong, readonly)	NSManagedObjectContext*			viewContext;

// MARK: Methods - Memory management
+ (instancetype)	persistentContainerWithName:(NSString*)name;
+ (instancetype)	persistentContainerWithName:(NSString*)name managedObjectModel:(NSManagedObjectModel*)model;
- (instancetype)	init NS_UNAVAILABLE;
- (instancetype)	initWithName:(NSString*)name;
- (instancetype)	initWithName:(NSString*)name managedObjectModel:(NSManagedObjectModel*)model NS_DESIGNATED_INITIALIZER;

// MARK: Methods - Stack management
- (void)					loadPersistentStoresWithCompletionHandler:(JFSimpleCompletion*)completion;
- (NSManagedObjectContext*)	newBackgroundContext;
- (void)					performBackgroundTask:(void (^)(NSManagedObjectContext*))task;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
