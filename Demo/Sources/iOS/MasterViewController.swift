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

import CoreData
import UIKit

////////////////////////////////////////////////////////////////////////////////////////////////////

class MasterViewController : UITableViewController, NSFetchedResultsControllerDelegate
{
	// =================================================================================================
	// MARK: Properties - Stores
	// =================================================================================================
	
	var _fetchedResultsController:NSFetchedResultsController<Event>? = nil
	var fetchedResultsController:NSFetchedResultsController<Event> {
		if _fetchedResultsController == nil
		{
			let fetchRequest:NSFetchRequest<Event> = Event.fetchRequest()
			
			// Set the batch size to a suitable number.
			fetchRequest.fetchBatchSize = 20
			
			// Edit the sort key as appropriate.
			let sortDescriptor = NSSortDescriptor(key:"timestamp", ascending:false)
			
			fetchRequest.sortDescriptors = [sortDescriptor]
			
			// Edit the section name key path and cache name if appropriate.
			// nil for section name key path means "no sections".
			let aFetchedResultsController = NSFetchedResultsController(fetchRequest:fetchRequest, managedObjectContext:self.managedObjectContext!, sectionNameKeyPath:nil, cacheName:"Master")
			aFetchedResultsController.delegate = self
			_fetchedResultsController = aFetchedResultsController
			
			do
			{
				try _fetchedResultsController!.performFetch()
			}
			catch
			{
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
		return _fetchedResultsController!
	}
	var managedObjectContext:NSManagedObjectContext? = nil
	
	// =================================================================================================
	// MARK: Properties - User interface
	// =================================================================================================
	
	var detailViewController:DetailViewController? = nil

	// =================================================================================================
	// MARK: Methods - Stores management
	// =================================================================================================
	
	@objc
	func insertNewObject(_ sender:Any)
	{
		let context = self.fetchedResultsController.managedObjectContext
		let newEvent = Event(context:context)
		
		// If appropriate, configure the new managed object.
		newEvent.timestamp = Date()
		
		// Save the context.
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
	
	// =================================================================================================
	// MARK: Methods - User interface management
	// =================================================================================================
	
	func configureCell(_ cell:UITableViewCell, withEvent event:Event)
	{
		cell.textLabel!.text = event.timestamp!.description
	}
	
	// =================================================================================================
	// MARK: Methods (Inherited) - User interface management (Navigation)
	// =================================================================================================

	override func prepare(for segue:UIStoryboardSegue, sender:Any?)
	{
		if segue.identifier == "showDetail"
		{
			if let indexPath = tableView.indexPathForSelectedRow
			{
				let object = fetchedResultsController.object(at:indexPath)
				let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
				controller.detailItem = object
				controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
				controller.navigationItem.leftItemsSupplementBackButton = true
			}
		}
	}
	
	// =================================================================================================
	// MARK: Methods (Inherited) - User interface management (View lifecycle)
	// =================================================================================================
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		navigationItem.leftBarButtonItem = editButtonItem

		let addButton = UIBarButtonItem(barButtonSystemItem:.add, target:self, action:#selector(insertNewObject(_:)))
		navigationItem.rightBarButtonItem = addButton
		if let split = splitViewController
		{
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
		}
	}

	override func viewWillAppear(_ animated:Bool)
	{
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	// =================================================================================================
	// MARK: Protocols (NSFetchedResultsControllerDelegate)
	// =================================================================================================
	
	func controller(_ controller:NSFetchedResultsController<NSFetchRequestResult>, didChange anObject:Any, at indexPath:IndexPath?, for type:NSFetchedResultsChangeType, newIndexPath:IndexPath?)
	{
		switch type
		{
		case .delete:
			tableView.deleteRows(at:[indexPath!], with:.fade)
		case .insert:
			tableView.insertRows(at:[newIndexPath!], with:.fade)
		case .move:
			configureCell(tableView.cellForRow(at:indexPath!)!, withEvent:anObject as! Event)
			tableView.moveRow(at:indexPath!, to:newIndexPath!)
		case .update:
			configureCell(tableView.cellForRow(at:indexPath!)!, withEvent:anObject as! Event)
		}
	}
	
	func controller(_ controller:NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo:NSFetchedResultsSectionInfo, atSectionIndex sectionIndex:Int, for type:NSFetchedResultsChangeType)
	{
		switch type
		{
		case .delete:
			tableView.deleteSections(IndexSet(integer:sectionIndex), with:.fade)
		case .insert:
			tableView.insertSections(IndexSet(integer:sectionIndex), with:.fade)
		default:
			break
		}
	}
	
	func controllerDidChangeContent(_ controller:NSFetchedResultsController<NSFetchRequestResult>)
	{
		tableView.endUpdates()
		
		// Implementing these methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just reload the table data.
		
		// In the simplest, most efficient, case, reload the table view.
		//tableView.reloadData()
	}
	
	func controllerWillChangeContent(_ controller:NSFetchedResultsController<NSFetchRequestResult>)
	{
		tableView.beginUpdates()
	}
	
	// =================================================================================================
	// MARK: Protocols (UITableViewDataSource)
	// =================================================================================================

	override func numberOfSections(in tableView:UITableView) -> Int
	{
		return fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(_ tableView:UITableView, canEditRowAt indexPath:IndexPath) -> Bool
	{
		return true
	}
	
	override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for:indexPath)
		let event = fetchedResultsController.object(at:indexPath)
		configureCell(cell, withEvent:event)
		return cell
	}
	
	override func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath:IndexPath)
	{
		if editingStyle == .delete
		{
		    let context = fetchedResultsController.managedObjectContext
		    context.delete(fetchedResultsController.object(at:indexPath))
		        
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
	
	override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
	{
		let sectionInfo = fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
