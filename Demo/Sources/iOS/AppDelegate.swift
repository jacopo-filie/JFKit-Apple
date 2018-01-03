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

import CoreData
import UIKit

import JFFramework_iOS

////////////////////////////////////////////////////////////////////////////////////////////////////

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate
{
	// =================================================================================================
	// MARK: Properties - Stores
	// =================================================================================================

	lazy var persistentContainer:JFPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = JFPersistentContainer(name:"Database-Swift")
		
		let errorBlock:JFBlockWithError = { (error) in
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			
			/*
			Typical reasons for an error here include:
			* The parent directory does not exist, cannot be created, or disallows writing.
			* The persistent store is not accessible, due to permissions or data protection when the device is locked.
			* The device is out of space.
			* The store could not be migrated to the current model version.
			Check the error message to determine what the actual problem was.
			*/
			let error = error as NSError
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}
		
		if #available(iOS 10.0, *)
		{
			container.loadPersistentStores(completionHandler:{ (storeDescription, error) in
				if let error = error as NSError?
				{
					errorBlock(error)
				}
			})
		}
		else
		{
			container.loadPersistentStores(with:JFSimpleCompletion(block:{ (succeeded, error) in
				if let error = error as NSError?
				{
					errorBlock(error)
				}
			}))
		}
		return container
	}()
	
	// =============================================================================================
	// MARK: Properties (Inherited) - User interface
	// =============================================================================================
	
	var window:UIWindow?
	
	// =============================================================================================
	// MARK: Methods - Stores management
	// =============================================================================================
	
	func saveContext()
	{
		let context = persistentContainer.viewContext
		if context.hasChanges
		{
			do
			{
				try context.save()
			}
			catch
			{
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	// =============================================================================================
	// MARK: Protocols (UIApplicationDelegate)
	// =============================================================================================
	
	func application(_ application:UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey:Any]?) -> Bool
	{
		// Override point for customization after application launch.
		let splitViewController = self.window!.rootViewController as! UISplitViewController
		let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count - 1] as! UINavigationController
		navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		splitViewController.delegate = self

		let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
		let controller = masterNavigationController.topViewController as! MasterViewController
		controller.managedObjectContext = self.persistentContainer.viewContext
		
		return true
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}

	// =================================================================================================
	// MARK: Protocols (UISplitViewControllerDelegate)
	// =================================================================================================

	func splitViewController(_ splitViewController:UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool
	{
	    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
	    guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
		
	    return (topAsDetailController.detailItem == nil)
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
