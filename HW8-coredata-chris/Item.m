//
//  Item.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/10/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "Item.h"


@implementation Item

@dynamic title;

+(instancetype)createInMoc:(NSManagedObjectContext *)moc
{
    Item* item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc];
    return item;
}

@end
