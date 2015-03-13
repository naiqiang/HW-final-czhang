//
//  Location.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/13/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) Item *item;

@end
