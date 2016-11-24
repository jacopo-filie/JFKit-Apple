//
//	The MIT License (MIT)
//
//	Copyright © 2016 Jacopo Filié
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

import UIKit

////////////////////////////////////////////////////////////////////////////////////////////////////

class MasterViewController:UITableViewController
{
	// =================================================================================================
	// MARK: Properties - Data
	// =================================================================================================
	
	var objects = [Any]()
	
	// =================================================================================================
	// MARK: Properties - User interface
	// =================================================================================================

	var detailViewController:DetailViewController? = nil

	// =================================================================================================
	// MARK: Methods - Data management
	// =================================================================================================
	
	func insertNewObject(_ sender:Any)
	{
		objects.insert(NSDate(), at:0)
		let indexPath = IndexPath(row:0, section:0)
		self.tableView.insertRows(at:[indexPath], with:.automatic)
	}
	
	// =================================================================================================
	// MARK: Methods - User interface management (Navigation)
	// =================================================================================================
	
	override func prepare(for segue:UIStoryboardSegue, sender:Any?)
	{
		if(segue.identifier == "showDetail")
		{
			if let indexPath = self.tableView.indexPathForSelectedRow
			{
				let object = objects[indexPath.row] as! NSDate
				let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
				controller.detailItem = object
				controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
				controller.navigationItem.leftItemsSupplementBackButton = true
			}
		}
	}
	
	// =================================================================================================
	// MARK: Methods - User interface management (View lifecycle)
	// =================================================================================================
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem

		let addButton = UIBarButtonItem(barButtonSystemItem:.add, target:self, action:#selector(insertNewObject(_:)))
		self.navigationItem.rightBarButtonItem = addButton
		
		if let split = self.splitViewController
		{
		    let controllers = split.viewControllers
		    self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
	}

	override func viewWillAppear(_ animated:Bool)
	{
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	// =================================================================================================
	// MARK: Protocols - UITableViewDataSource
	// =================================================================================================
	
	override func numberOfSections(in tableView:UITableView) -> Int
	{
		return 1
	}
	
	override func tableView(_ tableView:UITableView, canEditRowAt indexPath:IndexPath) -> Bool
	{
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let object = objects[indexPath.row] as! NSDate
		cell.textLabel!.text = object.description
		return cell
	}
	
	override func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath:IndexPath)
	{
		if (editingStyle == .delete)
		{
			objects.remove(at:indexPath.row)
			tableView.deleteRows(at:[indexPath], with:.fade)
		}
		else if (editingStyle == .insert)
		{
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
	override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
	{
		return objects.count
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

