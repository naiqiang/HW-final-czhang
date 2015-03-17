//
//  NewInventoryView.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/11/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

IB_DESIGNABLE
@interface NewItemView : NSTableCellView

@property (weak) IBOutlet NSButton *addInvButton;
@property (unsafe_unretained) IBOutlet NSTextView *invDescTextView;
@property (weak) IBOutlet NSButton *addImageButton;
@property (weak) IBOutlet NSButton *addTagButton;
@property (weak) IBOutlet NSView *imagePanelView;

@end
