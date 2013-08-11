//
//  LittleRecordTests.m
//  LittleRecordTests
//
//  Created by Markus Ecker on 11.08.13.
//  Copyright (c) 2013 Instant Street. All rights reserved.
//

#import "LittleRecordTests.h"
#import "CoreData+LittleRecord.h"
#import "LRTestEntity.h"

@implementation LittleRecordTests

- (void)setUp
{
    [super setUp];
    [NSPersistentStoreCoordinator setupWithStoreNamed:@"TestStore.sqlite"];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreate
{
    LRTestEntity *entity = [LRTestEntity create];
    STAssertNotNil(entity, @"Created entity must not be nil");
    
    entity.identifier = @1;
    entity.name = @"Markus";
    
    [NSManagedObjectContext save];
}

- (void)testQuery
{
    LRTestEntity *entity = [LRTestEntity create];
    entity.identifier = @2;
    entity.name = @"Markus";
    
    LRTestEntity *entity2 = [LRTestEntity first:[NSPredicate predicateWithFormat:@"identifier == %@", @2]];
    STAssertNotNil(entity2, @"query result not be nil");
    
    STAssertEquals(entity.name, entity2.name, @"Test Query");
    
}

@end
