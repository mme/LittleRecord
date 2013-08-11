//
//  CoreData+LittleRecord.m
//  LittleRecord
//
//  Created by Markus Ecker on 11.08.13.
//  Copyright (c) 2013 Instant Street. All rights reserved.
//

#import "CoreData+LittleRecord.h"

NSManagedObjectContext *_defaultContext;
NSManagedObjectModel *_defaultModel;
NSPersistentStoreCoordinator *_defaultCoordinator;

@implementation NSManagedObject(LittleRecord)

+ (NSArray *)sortDescriptorsFromString:(NSString *)string ascending:(BOOL)asc
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *key in [string componentsSeparatedByString:@","]) {
        [result addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:asc]];
    }
    return result;
}
+ (NSArray *)where:(NSPredicate *)predicate orderBySortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    [fetch setPredicate:predicate];
    [fetch setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetch error:&error];
    if (error) {
        @throw error;
    }
    return result;
}

+ (NSArray *)where:(NSPredicate *)predicate orderBySortDescriptors:(NSArray *)sortDescriptors
{
    return [self where:predicate orderBySortDescriptors:sortDescriptors inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort ascending:(BOOL)asc inContext:(NSManagedObjectContext *)context
{
    return [self where:predicate orderBySortDescriptors:[self sortDescriptorsFromString:sort ascending:asc] inContext:context];
}

+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort ascending:(BOOL)asc
{
    return [self where:predicate orderBy:sort ascending:asc inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort inContext:(NSManagedObjectContext *)context
{
    return [self where:predicate orderBy:sort ascending:YES inContext:context];
}

+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort
{
    return [self where:predicate orderBy:sort ascending:YES];
}

+ (NSArray *)where:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    return [self where:predicate orderBySortDescriptors:nil inContext:context];
}

+ (NSArray *)where:(NSPredicate *)predicate
{
    return [self where:predicate orderBySortDescriptors:nil];
}

+ (id)first:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSArray *result = [self where:predicate orderBySortDescriptors:nil inContext:context];
    return [result count] == 0 ? nil : result[0];
}

+ (id)first:(NSPredicate *)predicate
{
    return [self first:predicate inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)allOrderedBySortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
    return [self where:nil orderBySortDescriptors:sortDescriptors inContext:context];
}

+ (NSArray *)allOrderedBySortDescriptors:(NSArray *)sortDescriptors
{
    return [self allOrderedBySortDescriptors:sortDescriptors inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)allOrderedBy:(NSString *)sort ascending:(BOOL)asc inContext:(NSManagedObjectContext *)context
{
    return [self where:nil orderBy:sort ascending:asc inContext:context];
}
+ (NSArray *)allOrderedBy:(NSString *)sort ascending:(BOOL)asc
{
    return [self where:nil orderBy:sort ascending:asc];
}

+ (NSArray *)allOrderedBy:(NSString *)sort inContext:(NSManagedObjectContext *)context
{
    return [self where:nil orderBy:sort inContext:context];
}
+ (NSArray *)allOrderedBy:(NSString *)sort
{
    return [self where:nil orderBy:sort];
}

+ (NSArray *)allInContext:(NSManagedObjectContext *)context
{
    return [self where:nil inContext:context];
}

+ (NSArray *)all
{
    return [self where:nil];
}

- (void)removeObjectFromContext:(NSManagedObjectContext *)context
{
    [context deleteObject:self];
}

- (void)remove
{
    [self removeObjectFromContext:[NSManagedObjectContext defaultContext]];
}

+ (id)create
{
    return [self createInContext:[NSManagedObjectContext defaultContext]];
}

+ (id)createInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription
            insertNewObjectForEntityForName:NSStringFromClass([self class])
            inManagedObjectContext:context];
}

@end


@implementation NSManagedObjectContext(LittleRecord)

+ (NSManagedObjectContext *)defaultContext
{
    return _defaultContext;
}

+ (NSManagedObjectContext *)createNewContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:[NSPersistentStoreCoordinator defaultCoordinator]];
    return context;
}

- (void)save
{
    NSError *error = nil;
    [self save:&error];
    if (error) {
        @throw error;
    }
}

+ (void)save
{
    [[self defaultContext] save];
}

@end


@implementation NSManagedObjectModel(LittleRecord)

+ (NSManagedObjectModel *)defaultModel
{
    if (!_defaultModel) {
        _defaultModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _defaultModel;
}

@end


@implementation NSPersistentStoreCoordinator(LittleRecord)

+ (NSPersistentStoreCoordinator *)defaultCoordinator
{
    return _defaultCoordinator;
}

+ (void)setupWithStoreNamed:(NSString *)name
{
    // logic lifted from magical record
    
    if ([NSPersistentStoreCoordinator defaultCoordinator]) {
        // already done
        return;
    }
    
    NSError *error = nil;
    
    NSManagedObjectModel *model = [NSManagedObjectModel defaultModel];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSDictionary *autoMigrationOptions =
        @{  NSMigratePersistentStoresAutomaticallyOption: @YES,
            NSInferMappingModelAutomaticallyOption: @YES,
            NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}};

     
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    NSString *applicationStorageDirectory = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject]
                                             stringByAppendingPathComponent:applicationName];
    NSString *storeFile = [applicationStorageDirectory stringByAppendingPathComponent:name];
    NSURL *storeURL = [NSURL fileURLWithPath:storeFile];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:applicationStorageDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (![[NSFileManager defaultManager] fileExistsAtPath:applicationStorageDirectory]) {
        @throw error ?: [NSString stringWithFormat:@"Could not create storage path %@", applicationStorageDirectory];
    }
    
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:storeURL
                                                            options:autoMigrationOptions
                                                              error:&error];
    
    if (!store) {
        @throw error ?: @"Could not create persistent store";
    }
  
    _defaultCoordinator = coordinator;
    _defaultContext = [NSManagedObjectContext createNewContext];
}

@end