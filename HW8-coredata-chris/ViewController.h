//
//  ViewController.h
//  HW8-coredata-chris
//
//  Created by czhang on 3/7/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>


@property (weak) IBOutlet NSTableView *tableView;

@property NSManagedObjectContext* moc;
@property (nonatomic, strong) NSArray* items;

@property (weak) IBOutlet NSTextField *addNewInvTextField;
@property (weak) IBOutlet NSButton *addNewInvButton;

@end

