//
//  Item.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/13/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Location, Tag;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
