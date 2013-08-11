//
//  LRAppDelegate.h
//  LittleRecord
//
//  Created by Markus Ecker on 11.08.13.
//  Copyright (c) 2013 Instant Street. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LRAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
