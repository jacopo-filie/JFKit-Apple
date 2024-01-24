//
//	The MIT License (MIT)
//
//	Copyright © 2019-2024 Jacopo Filié
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#import "JFObjectIdentifier_Project.h"

#import "JFReferences.h"
#import "JFShortcuts.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Macros
// =================================================================================================

#define CleanRegistryDelay kJFObjectIdentifierLegacyImplementationCleanRegistryDelay
#define LegacyRegistry NSMutableDictionary<Reference*, NSNumber*>
#define Reference JFWeakReference<id<NSObject>>
#define Registry NSMapTable<id<NSObject>, NSNumber*>

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Constants
// =================================================================================================

static NSTimeInterval kJFObjectIdentifierLegacyImplementationCleanRegistryDelay = 10 /* seconds */;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@protocol JFObjectIdentifierImplementation <NSObject>

// =================================================================================================
// MARK: Properties - Identifiers
// =================================================================================================

@property (assign, readonly) NSUInteger count;

// =================================================================================================
// MARK: Methods - Identifiers
// =================================================================================================

- (void)clearID:(id<NSObject>)object;
- (NSUInteger)getID:(id<NSObject>)object;
- (void)resetID:(NSUInteger)objectID;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFObjectIdentifier (/* Private */)

// =================================================================================================
// MARK: Properties - Strategy
// =================================================================================================

@property (strong, nonatomic, readonly) id<JFObjectIdentifierImplementation> implementation;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

API_AVAILABLE(ios(8.0), macos(10.8))
@interface JFObjectIdentifierImplementation : NSObject <JFObjectIdentifierImplementation>

// =================================================================================================
// MARK: Properties - Identifiers
// =================================================================================================

@property (assign, readonly, getter=getAndIncrementNextFreeID) NSUInteger nextFreeID;
@property (strong, nonatomic, readonly) Registry* registry;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFObjectIdentifierLegacyImplementation : NSObject <JFObjectIdentifierImplementation>

// =================================================================================================
// MARK: Properties - Identifiers
// =================================================================================================

@property (assign) BOOL needsCleanRegistry;
@property (assign, readonly, getter=getAndIncrementNextFreeID) NSUInteger nextFreeID;
@property (strong, nonatomic, readonly) LegacyRegistry* registry;

// =================================================================================================
// MARK: Methods - Identifiers
// =================================================================================================

- (void)cleanRegistry;
- (void)cleanRegistryIfNeeded;

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (Reference* _Nullable)referenceForObject:(id<NSObject>)object;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFObjectIdentifier

// =================================================================================================
// MARK: Fields - Strategy
// =================================================================================================

@synthesize implementation = _implementation;

// =================================================================================================
// MARK: Properties - Memory
// =================================================================================================

+ (JFObjectIdentifier*)sharedInstance
{
	static JFObjectIdentifier* retObj;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		retObj = [JFObjectIdentifier new];
	});
	return retObj;
}

// =================================================================================================
// MARK: Properties - Identifiers
// =================================================================================================

- (NSUInteger)count
{
	return self.implementation.count;
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	
	id<JFObjectIdentifierImplementation> implementation;
	if(@available(macOS 10.8, *))
		implementation = [JFObjectIdentifierImplementation new];
	else
		implementation = [JFObjectIdentifierLegacyImplementation new];
	
	_implementation = implementation;

	return self;
}

- (instancetype)initWithCurrentImplementation API_AVAILABLE(ios(8.0), macos(10.8))
{
	self = [super init];
	
	_implementation = [JFObjectIdentifierImplementation new];
	
	return self;
}

- (instancetype)initWithLegacyImplementation
{
	self = [super init];
	
	_implementation = [JFObjectIdentifierLegacyImplementation new];
	
	return self;
}


// =================================================================================================
// MARK: Methods - Identifiers
// =================================================================================================

+ (void)clearID:(id<NSObject>)object
{
	[JFObjectIdentifier.sharedInstance clearID:object];
}

+ (NSUInteger)getID:(id<NSObject>)object
{
	return [JFObjectIdentifier.sharedInstance getID:object];
}

+ (void)resetID:(NSUInteger)objectID
{
	[JFObjectIdentifier.sharedInstance resetID:objectID];
}

- (void)clearID:(id<NSObject>)object
{
	[self.implementation clearID:object];
}

- (NSUInteger)getID:(id<NSObject>)object
{
	return [self.implementation getID:object];
}

- (void)resetID:(NSUInteger)objectID
{
	[self.implementation resetID:objectID];
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFObjectIdentifierImplementation

// =================================================================================================
// MARK: Fields - Identifiers
// =================================================================================================

@synthesize nextFreeID = _nextFreeID;
@synthesize registry = _registry;

// =================================================================================================
// MARK: Properties - Identifiers
// =================================================================================================

- (NSUInteger)count
{
	Registry* registry = self.registry;
	@synchronized(registry)
	{
		return registry.count;
	}
}

- (NSUInteger)getAndIncrementNextFreeID
{
	@synchronized(self)
	{
		return _nextFreeID++;
	}
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	
	_nextFreeID = 0;
	_registry = [Registry mapTableWithKeyOptions:(NSMapTableWeakMemory | NSMapTableObjectPointerPersonality) valueOptions:NSMapTableStrongMemory];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Identifiers
// =================================================================================================

- (void)clearID:(id<NSObject>)object
{
	Registry* registry = self.registry;
	@synchronized(registry)
	{
		[registry removeObjectForKey:object];
	}
}

- (NSUInteger)getID:(id<NSObject>)object
{
	Registry* registry = self.registry;
	@synchronized(registry)
	{
		NSUInteger retVal;
		NSNumber* value = [registry objectForKey:object];
		if(value != nil)
			retVal = [value unsignedIntegerValue];
		else
		{
			retVal = [self getAndIncrementNextFreeID];
			[registry setObject:@(retVal) forKey:object];
		}
		return retVal;
	}
}

- (void)resetID:(NSUInteger)objectID
{
	Registry* registry = self.registry;
	@synchronized(registry)
	{
		NSNumber* number = @(objectID);
		
		NSMutableArray<id<NSObject>>* objects = [NSMutableArray<id<NSObject>> array];
		for(id<NSObject> object in registry)
		{
			if([[registry objectForKey:object] isEqualToNumber:number])
				[objects addObject:object];
		}
		
		for(id<NSObject> object in objects)
			[registry removeObjectForKey:object];
	}
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@implementation JFObjectIdentifierLegacyImplementation

// =================================================================================================
// MARK: Fields - Identifiers
// =================================================================================================

@synthesize needsCleanRegistry = _needsCleanRegistry;
@synthesize nextFreeID = _nextFreeID;
@synthesize registry = _registry;

// =================================================================================================
// MARK: Properties - Identifiers
// =================================================================================================

- (NSUInteger)count
{
	LegacyRegistry* registry = self.registry;
	@synchronized(registry)
	{
		return registry.count;
	}
}

- (BOOL)needsCleanRegistry
{
	@synchronized(self)
	{
		return _needsCleanRegistry;
	}
}

- (void)setNeedsCleanRegistry:(BOOL)needsCleanRegistry
{
	@synchronized(self)
	{
		if(_needsCleanRegistry == needsCleanRegistry)
			return;
		
		_needsCleanRegistry = needsCleanRegistry;
	}
	
	if(!needsCleanRegistry)
		return;
	
	JFWeakifySelf;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CleanRegistryDelay * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[weakSelf cleanRegistryIfNeeded];
	});
}

- (NSUInteger)getAndIncrementNextFreeID
{
	@synchronized(self)
	{
		return _nextFreeID++;
	}
}

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

- (instancetype)init
{
	self = [super init];
	
	_needsCleanRegistry = NO;
	_nextFreeID = 0;
	_registry = [LegacyRegistry new];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Identifiers
// =================================================================================================

- (void)cleanRegistry
{
	LegacyRegistry* registry = self.registry;
	@synchronized(registry)
	{
		for(Reference* reference in registry.allKeys)
		{
			if(!reference.object)
				[registry removeObjectForKey:reference];
		}
	}
}

- (void)cleanRegistryIfNeeded
{
	@synchronized(self)
	{
		if(![self needsCleanRegistry])
			return;
		
		self.needsCleanRegistry = NO;
	}
	
	[self cleanRegistry];
}

- (void)clearID:(id<NSObject>)object
{
	LegacyRegistry* registry = self.registry;
	@synchronized(registry)
	{
		Reference* reference = [self referenceForObject:object];
		if(reference)
			[registry removeObjectForKey:reference];
	}
}

- (NSUInteger)getID:(id<NSObject>)object
{
	LegacyRegistry* registry = self.registry;
	@synchronized(registry)
	{
		Reference* reference = [self referenceForObject:object];
		if(reference)
		{
			NSNumber* value = [registry objectForKey:reference];
			if(value != nil)
				return [value unsignedIntegerValue];
			
			reference.object = object;
		}
		else
			reference = [Reference referenceWithObject:object];
		
		NSUInteger retVal = [self getAndIncrementNextFreeID];
		[registry setObject:@(retVal) forKey:reference];
		
		return retVal;
	}
}

- (void)resetID:(NSUInteger)objectID
{
	LegacyRegistry* registry = self.registry;
	@synchronized(registry)
	{
		for(Reference* reference in [registry allKeysForObject:@(objectID)])
			[registry removeObjectForKey:reference];
	}
}

// =================================================================================================
// MARK: Methods - Utilities
// =================================================================================================

- (Reference* _Nullable)referenceForObject:(id<NSObject>)object
{
	Reference* retObj = nil;
	BOOL needsCleanRegistry = NO;
	
	for(Reference* reference in self.registry)
	{
		NSObject* referencedObject = reference.object;
		if(!referencedObject)
		{
			needsCleanRegistry = YES;
			continue;
		}
		
		if(referencedObject == object)
		{
			retObj = reference;
			break;
		}
	}
	
	if(needsCleanRegistry)
		self.needsCleanRegistry = YES;
	
	return retObj;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
