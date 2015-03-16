//
//  Image.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/15/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "Image.h"
#import "Item.h"
#import "NSManagedObject+Extensions.h"

@implementation Image

@dynamic imageURL;
@dynamic item;

+(NSString *)entityName
{
    return @"Image";
}

@end
