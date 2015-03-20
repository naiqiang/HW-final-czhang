//
//  Tag.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/15/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "Tag.h"
#import "Item.h"
#import "NSManagedObject+Extensions.h"


@implementation Tag

@dynamic name;
@dynamic items;

+(NSString *)entityName
{
    return @"Tag";
}

+(NSArray *)fetchAllTagsInContext:(NSManagedObjectContext*)moc
{
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:[Tag entityName]];
    NSError* error = nil;
    NSArray* allTags = [moc executeFetchRequest:req error:&error];
    
    //    NSLog(@"fetched %ld items", allItems.count);
    //    for(Item* i in allItems){
    //        NSLog(@"title=%@ created=%@ img#=%ld tag#=%ld", i.title, i.dateCreated, i.images.count, i.tags.count);
    //    }
    
    return allTags;
}

+(NSArray*)createNewTagsInContext:(NSManagedObjectContext*)moc withAvailableTags:(NSArray*)availableTags fromStringArray:(NSArray*)names
{
    NSMutableArray* newTags = [NSMutableArray new];
    
    for(NSString* tagName in names)
    {
        NSLog(@"searching tag name %@", tagName);
        
        NSString *trimmedtagName = [tagName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSUInteger index = [availableTags indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            Tag* currentTag = (Tag*)obj;
            return [currentTag.name isEqualToString:trimmedtagName];
        }];
        
        if ( index == NSNotFound)
        {
            NSLog(@"didn't find one... creating...");
            
            Tag* tag = [Tag createInMoc:moc];
            tag.name = [NSString stringWithString:trimmedtagName];
            [newTags addObject:tag];
        }
        else
        {
            NSLog(@"found it.");
            [newTags addObject:[availableTags objectAtIndex:index]];
        }
    }
    
    NSLog(@"the set of tags has %@ tags", @(newTags.count));
    return newTags;
}

@end
