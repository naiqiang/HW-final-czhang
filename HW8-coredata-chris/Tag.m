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

@end
