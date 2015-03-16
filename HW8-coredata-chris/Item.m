//
//  Item.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/15/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "Item.h"
#import "Image.h"
#import "Tag.h"
#import "NSManagedObject+Extensions.h"


@implementation Item

@dynamic dateCreated;
@dynamic title;
@dynamic tags;
@dynamic images;

+(NSString *)entityName
{
    return @"Item";
}

+(NSArray *)fetchAllItemsInContext:(NSManagedObjectContext*)moc
{
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:[Item entityName]];
    NSError* error = nil;
    NSArray* allItems = [moc executeFetchRequest:req error:&error];
        
    NSLog(@"fetched %ld items", allItems.count);
    for(Item* i in allItems){
        NSLog(@"title=%@ created=%@ img#=%ld tag#=%ld", i.title, i.dateCreated, i.images.count, i.tags.count);
    }
        
    return allItems;
}

+(Item*)createItemInMoc:(NSManagedObjectContext*)moc withTitle:(NSString*)title withImages:(NSSet*)images withTags:(NSSet*)tags
{
    NSLog(@"adding item: %@ with %ld imgs %ld tags", title, images.count, tags.count);
    
    Item* item = [Item createInMoc:moc];
    item.title = title;
    item.dateCreated = [NSDate date];
    item.images = images;
    item.tags = tags;
    
    NSError* error = nil;
    BOOL success = [moc save:&error];
    if(success)
    {
        return item;
    }
    else
    {
        return nil;
    }
}

@end
