//
//  CustomCellView.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/10/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "CustomCellView.h"

@implementation CustomCellView

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
}

@end
