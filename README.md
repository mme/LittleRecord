LittleRecord
============

Tiny active record style library for Core Data

```objectivec
// create
LRTestEntity *entity = [LRTestEntity create];
entity.identifier = @2;
entity.name = @"Markus";

// save
[NSManagedObjectContext save];

// query
[LRTestEntity first:[NSPredicate predicateWithFormat:@"identifier == %@", @2]];
[LRTestEntity all]

// delete
[entity remove];
```
