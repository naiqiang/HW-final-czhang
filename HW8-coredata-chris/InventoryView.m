//
//  CustomCellView.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/10/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "InventoryView.h"


@interface InventoryView()
@property NSColor* backgroundColor;
@end

@implementation InventoryView


-(void)useNormalBackgroundColor
{
    self.backgroundColor = [NSColor colorWithSRGBRed:0.7 green:0.9 blue:0.7 alpha:0.2];
}

-(void)useAlternativeBackgroundColor
{
    self.backgroundColor = [NSColor colorWithSRGBRed:0.7 green:0.7 blue:0.9 alpha:0.3];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    if (self.backgroundColor==nil){
        self.backgroundColor = [NSColor whiteColor];
    }
    
    [self.backgroundColor set];
    
    [NSBezierPath fillRect:self.bounds];

}

@end
