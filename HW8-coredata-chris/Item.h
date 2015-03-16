//
//  Item.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/15/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Tag;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *images;

+(NSArray*)fetchAllItemsInContext:(NSManagedObjectContext*)moc;
+(Item*)createItemInMoc:(NSManagedObjectContext*)moc withTitle:(NSString*)title withImages:(NSSet*)images withTags:(NSSet*)tags;
+(BOOL)deleteItem:(Item*)item fromMoc:(NSManagedObjectContext*)moc;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
