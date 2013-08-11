//
//  CoreData+LittleRecord.h
//  LittleRecord
//
//  Created by Markus Ecker on 11.08.13.
//  Copyright (c) 2013 Instant Street. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject(LittleRecord)

+ (NSArray *)where:(NSPredicate *)predicate orderBySortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;
+ (NSArray *)where:(NSPredicate *)predicate orderBySortDescriptors:(NSArray *)sortDescriptors;

+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort ascending:(BOOL)asc inContext:(NSManagedObjectContext *)context;
+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort ascending:(BOOL)asc;

+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort inContext:(NSManagedObjectContext *)context;
+ (NSArray *)where:(NSPredicate *)predicate orderBy:(NSString *)sort;

+ (NSArray *)where:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray *)where:(NSPredicate *)predicate;

+ (id)first:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (id)first:(NSPredicate *)predicate;

+ (NSArray *)allOrderedBySortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allOrderedBySortDescriptors:(NSArray *)sortDescriptors;

+ (NSArray *)allOrderedBy:(NSString *)sort ascending:(BOOL)asc inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allOrderedBy:(NSString *)sort ascending:(BOOL)asc;

+ (NSArray *)allOrderedBy:(NSString *)sort inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allOrderedBy:(NSString *)sort;

+ (NSArray *)allInContext:(NSManagedObjectContext *)context;
+ (NSArray *)all;

- (void)removeObjectFromContext:(NSManagedObjectContext *)context;
- (void)remove;

+ (id)create;
+ (id)createInContext:(NSManagedObjectContext *)context;

@end

@interface NSManagedObjectContext(LittleRecord)

+ (NSManagedObjectContext *)defaultContext;
+ (NSManagedObjectContext *)createNewContext;
- (void)save;
+ (void)save;

@end

@interface NSPersistentStoreCoordinator(LittleRecord)

+ (NSPersistentStoreCoordinator *)defaultCoordinator;
+ (void)setupWithStoreNamed:(NSString *)name;

@end

@interface NSManagedObjectModel(LittleRecord)

+ (NSManagedObjectModel *)defaultModel;

@end