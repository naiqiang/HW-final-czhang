//
//  CustomCellView.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/10/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CustomCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSButton *checkButton;

-(void)useNormalBackgroundColor;
-(void)useAlternativeBackgroundColor;

@end
