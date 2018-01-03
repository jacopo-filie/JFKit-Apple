//
//	The MIT License (MIT)
//
//	Copyright © 2017-2018 Jacopo Filié
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

#import "JFBlocks.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * This class can be used to replace the class `NSPersistentContainer` that has limited support for the most recent operating systems. It tries to extend the support down to macOS 10.6 and iOS 8.0 by using many checks to select the proper path of instructions to follow: if the class `NSPersistentContainer` is available, its properties and methods are used, otherwise the most recent available SDK APIs are used to implement a custom version of the needed `NSPersistentContainer` API.
 * @warning If the class `NSPersistentContainer` is not available, only the `NSSQLiteStoreType` is supported.
 */
@interface JFPersistentContainer : NSObject

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * Creates the default directory for the persistent stores on the current platform. This method returns a platform-dependent `NSURL` at which the persistent store(s) will be located or are currently located. If the class `NSPersistentContainer` is not available, the custom directory is located at path `Library/Application Support/Databases` on iOS and `Library/Application Support/<bundle identifier>/Databases` on macOS.
 */
@property (class, strong, readonly) NSURL* defaultDirectoryURL;

/**
 * The model associated with this persistent container.
 */
@property (strong, readonly) NSManagedObjectModel* managedObjectModel;

/**
 * The name of this persistent container.
 */
@property (copy, readonly) NSString* name;

// =================================================================================================
// MARK: Properties - Stack
// =================================================================================================

/**
 * The persistent store coordinator associated with this persistent container.
 */
@property (strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

/**
 * The persistent store descriptions used to create the persistent stores referenced by this persistent container.
 */
@property (copy) NSArray<NSPersistentStoreDescription*>* persistentStoreDescriptions API_AVAILABLE(ios(10.0), macos(10.12));

/**
 * The managed object context associated with the main queue.
 */
@property (strong, readonly) NSManagedObjectContext* viewContext;

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

/**
 * Initializes a new persistent container using the provided name for the container.
 * @param name The name of the persistent container.
 * @return An initialized persistent container using the passed in name.
 */
+ (instancetype)persistentContainerWithName:(NSString*)name;

/**
 * Initializes a new persistent container using the provided name and managed object model.
 * @param name The name of the persistent container.
 * @param model The `NSManagedObjectModel` object to be used by the persistent container.
 * @return An initialized persistent container using the passed in name and model.
*/
+ (instancetype)persistentContainerWithName:(NSString*)name managedObjectModel:(NSManagedObjectModel*)model;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the persistent container with the given name.
 * @param name The name of the persistent container.
 * @return An initialized persistent container using the passed in name.
 */
- (instancetype)initWithName:(NSString*)name;

/**
 * Initializes the persistent container with the given name and model.
 * @param name The name of the persistent container.
 * @param model The `NSManagedObjectModel` object to be used by the persistent container.
 * @return An initialized persistent container using the passed in name and model.
 */
- (instancetype)initWithName:(NSString*)name managedObjectModel:(NSManagedObjectModel*)model NS_DESIGNATED_INITIALIZER;

// =================================================================================================
// MARK: Methods - Stack management
// =================================================================================================

/**
 * Instructs the persistent container to load the persistent stores. Once the completion handler has fired, the stack is fully initialized and is ready for use. The completion block will be called once for each persistent store that is created.
 * @param completion Once the loading of each persistent store has completed, this completion block will be executed.
 * @warning You should use `-loadPersistentStoresWithCompletionHandler:` if available because the completion block of this method will be missing the description of the current store that has finished loading, so you won't be able to recognize which store has finished loading.
 */
- (void)loadPersistentStoresWithCompletion:(JFSimpleCompletion*)completion API_DEPRECATED_WITH_REPLACEMENT("-loadPersistentStoresWithCompletionHandler:", ios(8.0, 10.0), macos(10.6, 10.12));

/**
 * Instructs the persistent container to load the persistent stores. Once the completion handler has fired, the stack is fully initialized and is ready for use. The completion handler will be called once for each persistent store that is created.
 * @param completion Once the loading of each persistent store has completed, this completion handler will be executed.
 */
- (void)loadPersistentStoresWithCompletionHandler:(void (^)(NSPersistentStoreDescription* description, NSError* __nullable error))completion API_AVAILABLE(ios(10.0), macos(10.12));

/**
 * Creates a private managed object context.
 * @return A newly created private managed object context.
 */
- (NSManagedObjectContext*)newBackgroundContext;

/**
 * Causes the persistent container to execute the block against a new private queue context.
 * @param block A block that is executed by the persistent container against a newly created private context. The private context is passed into the block as part of the execution of the block.
 */
- (void)performBackgroundTask:(void (^)(NSManagedObjectContext*))block;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
