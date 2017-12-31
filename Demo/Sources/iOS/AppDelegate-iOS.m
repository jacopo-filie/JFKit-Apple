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

#import "AppDelegate-iOS.h"

#import "DetailViewController.h"
#import "MasterViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface AppDelegate ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation AppDelegate

// =================================================================================================
// MARK: Properties - Stores
// =================================================================================================

@synthesize persistentContainer = _persistentContainer;

// =================================================================================================
// MARK: Properties (Inherited) - User interface
// =================================================================================================

@synthesize window = _window;

// =================================================================================================
// MARK: Properties accessors - Stores
// =================================================================================================

- (JFPersistentContainer*)persistentContainer
{
	// The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
	@synchronized(self)
	{
		if(!_persistentContainer)
		{
			_persistentContainer = [[JFPersistentContainer alloc] initWithName:@"Database-ObjC"];
			
			JFBlockWithError errorBlock = ^(NSError* error)
			{
				// Replace this implementation with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				 Typical reasons for an error here include:
				 * The parent directory does not exist, cannot be created, or disallows writing.
				 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
				 * The device is out of space.
				 * The store could not be migrated to the current model version.
				 Check the error message to determine what the actual problem was.
				 */
				NSLog(@"Unresolved error %@, %@", error, error.userInfo);
				abort();
			};
			
			if(@available(iOS 10.0, *))
			{
				[_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription* storeDescription, NSError* error) {
					if(error)
						errorBlock(error);
				}];
			}
			else
			{
				[_persistentContainer loadPersistentStoresWithCompletion:[JFSimpleCompletion completionWithBlock:^(BOOL succeeded, NSError* __nullable error) {
					if(error)
						errorBlock(error);
				}]];
			}
		}
	}
	
	return _persistentContainer;
}

// =================================================================================================
// MARK: Methods - Stores management
// =================================================================================================

- (void)saveContext
{
	NSManagedObjectContext* context = self.persistentContainer.viewContext;
	
	NSError* error = nil;
	if([context hasChanges] && ![context save:&error])
	{
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		abort();
	}
}

// =================================================================================================
// MARK: Protocols (UIApplicationDelegate)
// =================================================================================================

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id>* __nullable)launchOptions
{
	UISplitViewController* splitViewController = (UISplitViewController*)self.window.rootViewController;
	UINavigationController* navigationController = [splitViewController.viewControllers lastObject];
	navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
	splitViewController.delegate = self;
	
	UINavigationController* masterNavigationController = splitViewController.viewControllers[0];
	MasterViewController* controller = (MasterViewController*)masterNavigationController.topViewController;
	controller.managedObjectContext = self.persistentContainer.viewContext;
	
	return YES;
}

- (void)applicationWillTerminate:(UIApplication*)application
{
	[self saveContext];
}

// =================================================================================================
// MARK: Protocols (UISplitViewControllerDelegate)
// =================================================================================================

- (BOOL)splitViewController:(UISplitViewController*)splitViewController collapseSecondaryViewController:(UIViewController*)secondaryViewController ontoPrimaryViewController:(UIViewController*)primaryViewController
{
	if(![secondaryViewController isKindOfClass:[UINavigationController class]])
		return NO;
	
	if(![[(UINavigationController*)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]])
		return NO;
	
	return ![(DetailViewController*)[(UINavigationController*)secondaryViewController topViewController] detailItem];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
