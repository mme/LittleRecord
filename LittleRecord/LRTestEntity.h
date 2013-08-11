//
//  LRTestEntity.h
//  LittleRecord
//
//  Created by Markus Ecker on 11.08.13.
//  Copyright (c) 2013 Instant Street. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LRTestEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * identifier;

@end
