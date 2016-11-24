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

class DetailViewController:UIViewController
{
	// =================================================================================================
	// MARK: Properties - Data
	// =================================================================================================
	
	var detailItem:NSDate? {
		didSet {
			// Update the view.
			self.configureView()
		}
	}
	
	// =================================================================================================
	// MARK: Properties - User interface
	// =================================================================================================
	
	@IBOutlet weak var detailDescriptionLabel:UILabel!

	// =================================================================================================
	// MARK: Methods - User interface management
	// =================================================================================================
	
	func configureView()
	{
		// Update the user interface for the detail item.
		if let detail = self.detailItem
		{
		    if let label = self.detailDescriptionLabel
			{
		        label.text = detail.description
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
		self.configureView()
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
