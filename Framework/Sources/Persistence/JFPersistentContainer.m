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

#import "JFPersistentContainer.h"

#import "JFBlocks.h"
#import	"JFPreprocessorMacros.h"
#import "JFShortcuts.h"
#import "JFVersion.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN
@interface JFPersistentContainer ()

// MARK: Properties - Concurrency
@property (strong, nonatomic, readonly) NSOperationQueue* serialQueue;

// MARK: Properties - Stack
@property (strong, nonatomic, readonly, nullable) NSPersistentContainer* container API_AVAILABLE(ios(10.0), macos(10.12));

// MARK: Methods - Stack management
- (NSManagedObjectContext*)createManagedObjectContext;
- (NSManagedObjectContext*)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType API_AVAILABLE(ios(5.0), macos(10.7));

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFPersistentContainer

// =================================================================================================
// MARK: Properties - Concurrency
// =================================================================================================

@synthesize serialQueue	= _serialQueue;

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize model	= _model;
@synthesize name	= _name;

// =================================================================================================
// MARK: Properties - Stack
// =================================================================================================

@synthesize container		= _container;
@synthesize coordinator		= _coordinator;
//@synthesize descriptions	= _descriptions;
@synthesize viewContext		= _viewContext;

// =================================================================================================
// MARK: Properties accessors - Data
// =================================================================================================

+ (NSURL*)defaultDirectoryURL
{
	NSError* error = nil;
	NSURL* retObj = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
	NSAssert(retObj, @"Failed to load application support directory for error '%@'", error.description);
	return [retObj URLByAppendingPathComponent:@"Databases"];
}

// =================================================================================================
// MARK: Properties accessors - Stack
// =================================================================================================

- (NSPersistentStoreCoordinator*)coordinator
{
	if(@available(iOS 10.0, macOS 10.12, *))
		return self.container.persistentStoreCoordinator;
	
	@synchronized(self)
	{
		return _coordinator;
	}
}

- (NSManagedObjectContext*)viewContext
{
	if(@available(iOS 10.0, macOS 10.12, *))
		return self.container.viewContext;
	
	@synchronized(self)
	{
		if(!_viewContext)
		{
			JFBlock block = ^(void) {
				if(@available(macOS 10.7, *))
					_viewContext = [self createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
				else
					_viewContext = [self createManagedObjectContext];
			};
			
			if([NSThread isMainThread])
				block();
			else
				[MainOperationQueue addOperations:@[[NSBlockOperation blockOperationWithBlock:block]] waitUntilFinished:YES];
		}
		return _viewContext;
	}
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (instancetype)persistentContainerWithName:(NSString*)name
{
	return [[self alloc] initWithName:name];
}

+ (instancetype)persistentContainerWithName:(NSString*)name managedObjectModel:(NSManagedObjectModel*)model
{
	return [[self alloc] initWithName:name managedObjectModel:model];
}

- (instancetype)initWithName:(NSString*)name
{
	NSURL* modelURL = JFBundleResourceURLForFile(MainBundle, name);
	NSAssert(modelURL, @"Missing the model URL! The given name is '%@'.", name);
	
	NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSAssert(model, @"Failed to load the model! The given url is '%@'.", modelURL);
	
	return [self initWithName:name managedObjectModel:model];
}

- (instancetype)initWithName:(NSString*)name managedObjectModel:(NSManagedObjectModel*)model
{
	self = [super init];
	if(self)
	{
		NSOperationQueue* queue = [NSOperationQueue new];
		queue.maxConcurrentOperationCount = 1;
		
		// Concurrency
		_serialQueue	= queue;
		
		// Data
		_model	= model;
		_name	= [name copy];
		
		// Stack
		if(@available(iOS 10.0, macOS 10.12, *))
			_container = [[NSPersistentContainer alloc] initWithName:name managedObjectModel:model];
	}
	return self;
}

// =================================================================================================
// MARK: Methods - Stack management
// =================================================================================================

- (NSManagedObjectContext*)createManagedObjectContext
{
	NSManagedObjectContext* retVal = [NSManagedObjectContext new];
	retVal.persistentStoreCoordinator = self.coordinator;
	return retVal;
}

- (NSManagedObjectContext*)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
	NSManagedObjectContext* retVal = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
	retVal.persistentStoreCoordinator = self.coordinator;
	return retVal;
}

- (void)loadPersistentStoresWithCompletionHandler:(JFSimpleCompletion*)completion
{
	if(@available(iOS 10.0, macOS 10.12, *))
	{
		[self.container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription* description, NSError* __nullable error) {
			if(error)
				[completion executeWithError:error];
			else
				[completion execute];
		}];
		return;
	}
	
#if JF_WEAK_ENABLED
	JFWeakifySelf;
#else
	id __block __strong tempSelf = self;
#endif
	
	JFBlock block = ^(void)
	{
#if JF_WEAK_ENABLED
		JFStrongifySelf;
		if(!strongSelf)
		{
			// TODO: replace with specific error.
			[completion executeWithError:[NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil]];
			return;
		}
#else
		__typeof(self) __strong strongSelf = tempSelf;
		tempSelf = nil;
#endif

		if(strongSelf.coordinator)
		{
			[completion execute];
			return;
		}
		
		NSURL* url = [strongSelf.class.defaultDirectoryURL URLByAppendingPathComponent:[strongSelf.name.stringByDeletingPathExtension stringByAppendingPathExtension:@"sqlite"]];
		if(!url)
		{
			// TODO: replace with specific error.
			[completion executeWithError:[NSError errorWithDomain:ClassName code:NSIntegerMax userInfo:nil]];
			return;
		}
		
		NSURL* folderURL = url.URLByDeletingLastPathComponent;
		
		NSFileManager* fileManager = NSFileManager.defaultManager;
		if(![fileManager fileExistsAtPath:folderURL.path])
		{
			NSError* error = nil;
			BOOL failed = NO;
			
			if(@available(macOS 10.7, *))
				failed = ![fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:nil error:&error];
			else
				failed = ![fileManager createDirectoryAtPath:folderURL.path withIntermediateDirectories:YES attributes:nil error:&error];
			
			if(failed)
			{
				[completion executeWithError:error];
				return;
			}
		}
		
		NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:strongSelf.model];
		
		NSError* error = nil;
		if(![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
		{
			[completion executeWithError:error];
			return;
		}
		
		@synchronized(strongSelf)
		{
			_coordinator = coordinator;
		}
		
		[completion execute];
	};
	
	[self.serialQueue addOperationWithBlock:block];
}

- (NSManagedObjectContext*)newBackgroundContext
{
	if(@available(iOS 10.0, macOS 10.12, *))
		return [self.container newBackgroundContext];
	
	if(@available(macOS 10.7, *))
		return [self createManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
	
	return [self createManagedObjectContext];
}

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext*))task
{
	if(@available(iOS 10.0, macOS 10.12, *))
	{
		[self.container performBackgroundTask:task];
		return;
	}
	
	NSManagedObjectContext* __block context = nil;
	
	JFBlock block = ^(void)
	{
		task(context);
		context = nil;
	};
	
	if(@available(macOS 10.7, *))
	{
		context = [self newBackgroundContext];
		[context performBlock:block];
	}
	else
	{
		[self.serialQueue addOperationWithBlock:^{
			context = [self newBackgroundContext];
			block();
		}];
	}
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
