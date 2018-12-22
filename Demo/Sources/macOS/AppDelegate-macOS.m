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

#import "AppDelegate-macOS.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface AppDelegate ()

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (NSUndoManager*)windowWillReturnUndoManager:(NSWindow*)window;

// =================================================================================================
// MARK: Methods - User interface management (Actions)
// =================================================================================================

- (IBAction)saveAction:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation AppDelegate

// =================================================================================================
// MARK: Properties - Stores
// =================================================================================================

@synthesize persistentContainer = _persistentContainer;

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
			
			if(@available(macOS 10.12, *))
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
// MARK: Methods - User interface management
// =================================================================================================

- (NSUndoManager*)windowWillReturnUndoManager:(NSWindow*)window
{
	// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
	return self.persistentContainer.viewContext.undoManager;
}

// =================================================================================================
// MARK: Methods - User interface management (Actions)
// =================================================================================================

- (IBAction)saveAction:(id)sender
{
	// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
	NSManagedObjectContext* context = self.persistentContainer.viewContext;
	
	if(![context commitEditing])
		NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
	
	NSError* error = nil;
	if(context.hasChanges && ![context save:&error])
	{
		// Customize this code block to include application-specific recovery steps.
		[[NSApplication sharedApplication] presentError:error];
	}
}

// =================================================================================================
// MARK: Protocols (NSApplicationDelegate)
// =================================================================================================

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication*)sender
{
	// Save changes in the application's managed object context before the application terminates.
	NSManagedObjectContext* context = self.persistentContainer.viewContext;
	
	if(![context commitEditing])
	{
		NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
		return NSTerminateCancel;
	}
	
	if(!context.hasChanges)
		return NSTerminateNow;
	
	NSError* error = nil;
	if(![context save:&error])
	{
		// Customize this code block to include application-specific recovery steps.
		BOOL result = [sender presentError:error];
		if(result)
			return NSTerminateCancel;
		
		NSString* question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
		NSString* info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
		NSString* quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
		NSString* cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
		
		NSAlert* alert = [[NSAlert alloc] init];
		[alert setMessageText:question];
		[alert setInformativeText:info];
		[alert addButtonWithTitle:quitButton];
		[alert addButtonWithTitle:cancelButton];
		
		NSInteger answer = [alert runModal];
		
		if(answer == NSAlertSecondButtonReturn)
			return NSTerminateCancel;
	}
	
	return NSTerminateNow;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
