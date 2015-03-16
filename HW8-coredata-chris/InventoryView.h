//
//  CustomCellView.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/10/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Item.h"

@interface InventoryView : NSTableCellView

@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSButton *checkButton;

@property (weak) Item* item;

-(void)useNormalBackgroundColor;
-(void)useAlternativeBackgroundColor;

@end
