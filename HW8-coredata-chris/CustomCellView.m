//
//  CustomCellView.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/10/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "CustomCellView.h"

@implementation CustomCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    if (self.backgroundColor==nil){
        self.backgroundColor = [NSColor lightGrayColor];
    }
    
    [self.backgroundColor set];
    
    [NSBezierPath fillRect:self.bounds];

}

@end
