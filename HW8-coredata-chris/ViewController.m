//
//  ViewController.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/7/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "ViewController.h"
#import "CustomCellView.h"

@interface ViewController()

@property (nonatomic) NSImage* image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.image = [NSImage imageNamed:@"background.png"];
    
//    NSURL* url = [[NSBundle mainBundle] URLForResource:@"background" withExtension:@"png"];
//    self.image = [[NSImage alloc] initWithContentsOfURL:url];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 3;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 200;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView* view =    [self.tableView makeViewWithIdentifier:@"Cell2" owner:self];

    
    view.textField.stringValue = [NSString stringWithFormat:@"Row %ld",(long)row];
    
    NSImage* image = [NSImage imageNamed:@"background.png"];

    [view.imageView setImage:image];
    
    return view;
    
}

@end
