//
//  Tag.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/15/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *items;

+(NSArray *)fetchAllTagsInContext:(NSManagedObjectContext*)moc;
+(NSArray*)createNewTagsInContext:(NSManagedObjectContext*)moc withAvailableTags:(NSArray*)tags fromStringArray:(NSArray*)s;

@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
