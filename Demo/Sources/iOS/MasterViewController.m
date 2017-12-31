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

#import "MasterViewController.h"

#import "DetailViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MasterViewController ()

// =================================================================================================
// MARK: Methods - Stores management
// =================================================================================================

- (void)insertNewObject:(id)sender;

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (void)configureCell:(UITableViewCell*)cell withEvent:(Event*)event;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation MasterViewController

// =================================================================================================
// MARK: Properties - Stores
// =================================================================================================

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize detailViewController = _detailViewController;

// =================================================================================================
// MARK: Properties accessors - Stores
// =================================================================================================

- (NSFetchedResultsController<Event*>*)fetchedResultsController
{
	if(!_fetchedResultsController)
	{
		NSFetchRequest<Event*>* fetchRequest;
		if(@available(iOS 10.0, *))
			fetchRequest = Event.fetchRequest;
		else
			fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
		
		// Set the batch size to a suitable number.
		[fetchRequest setFetchBatchSize:20];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
		[fetchRequest setSortDescriptors:@[sortDescriptor]];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		NSFetchedResultsController<Event*>* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
		aFetchedResultsController.delegate = self;
		
		NSError* error = nil;
		if(![aFetchedResultsController performFetch:&error])
		{
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, error.userInfo);
			abort();
		}
		
		_fetchedResultsController = aFetchedResultsController;
	}
	return _fetchedResultsController;
}

// =================================================================================================
// MARK: Methods - Stores management
// =================================================================================================

- (void)insertNewObject:(id)sender
{
	NSManagedObjectContext* context = [self.fetchedResultsController managedObjectContext];
	
	Event* newEvent;
	if(@available(iOS 10.0, *))
		newEvent = [[Event alloc] initWithContext:context];
	else
		newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	
	// If appropriate, configure the new managed object.
	newEvent.timestamp = [NSDate date];
	
	// Save the context.
	NSError* error = nil;
	if(![context save:&error])
	{
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		abort();
	}
}

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (void)configureCell:(UITableViewCell*)cell withEvent:(Event*)event
{
	cell.textLabel.text = event.timestamp.description;
}

// =================================================================================================
// MARK: Methods (Inherited) - User interface management (Navigation)
// =================================================================================================

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id __nullable)sender
{
	if([[segue identifier] isEqualToString:@"showDetail"])
	{
		NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
		Event* object = [self.fetchedResultsController objectAtIndexPath:indexPath];
		DetailViewController* controller = (DetailViewController*)[[segue destinationViewController] topViewController];
		[controller setDetailItem:object];
		controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
		controller.navigationItem.leftItemsSupplementBackButton = YES;
	}
}

// =================================================================================================
// MARK: Methods (Inherited) - User interface management (View lifecycle)
// =================================================================================================

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
	self.detailViewController = (DetailViewController*)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.clearsSelectionOnViewWillAppear = [self.splitViewController isCollapsed];
	[super viewWillAppear:animated];
}

// =================================================================================================
// MARK: Protocols (NSFetchedResultsControllerDelegate)
// =================================================================================================

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath* __nullable)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath* __nullable)newIndexPath
{
	UITableView* tableView = self.tableView;
	
	switch(type)
	{
		case NSFetchedResultsChangeDelete:
		{
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeInsert:
		{
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeMove:
		{
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
			[tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
			break;
		}
		case NSFetchedResultsChangeUpdate:
		{
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
			break;
		}
	}
}

- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
	switch(type)
	{
		case NSFetchedResultsChangeDelete:
		{
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeInsert:
		{
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		default:
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
	[self.tableView endUpdates];
	
	// Implementing these methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just reload the table data.
	
	// In the simplest, most efficient, case, reload the table view.
	//[self.tableView reloadData];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
	[self.tableView beginUpdates];
}

// =================================================================================================
// MARK: Protocols (UITableViewDataSource)
// =================================================================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return self.fetchedResultsController.sections.count;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
	return YES;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	Event* event = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[self configureCell:cell withEvent:event];
	return cell;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSManagedObjectContext* context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError* error = nil;
		if(![context save:&error])
		{
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, error.userInfo);
			abort();
		}
	}
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
	return sectionInfo.numberOfObjects;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
