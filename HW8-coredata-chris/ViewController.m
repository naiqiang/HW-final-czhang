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
    return 20;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 170;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"%@",[NSString stringWithFormat:@"%ldl",(long)row ]);
    
    CustomCellView* view = [self.tableView makeViewWithIdentifier:@"InventoryView" owner:self];
    
    [view.imageView2 setImage:[NSImage imageNamed:@"background.png"]];
    view.label.stringValue = @"string";
    
    if ( row %2 ==0 )
    {
        CGFloat R = 0.6;
        CGFloat G = 0.8;
        CGFloat B = 0.6;
        CGFloat A = 0.5;
        
        view.backgroundColor = [NSColor colorWithSRGBRed:R green:G blue:B alpha:A];
    }
    else
    {
        CGFloat R = 0.6;
        CGFloat G = 0.6;
        CGFloat B = 0.8;
        CGFloat A = 0.7;
        
        view.backgroundColor = [NSColor colorWithSRGBRed:R green:G blue:B alpha:A];
    }
    
    [view setNeedsDisplay:YES];
    
//        {
//            NSTableCellView* view =    [self.tableView  makeViewWithIdentifier:@"CellWithImage" owner:self];
//    
//            view.textField.stringValue = [NSString stringWithFormat:@"Row %ld",(long)row];
//    
//            NSImage* image = [NSImage imageNamed:@"background.png"];
//
//            [view.imageView setImage:image];
//    
//            return view;
//        }

    
            return view;
    
}

@end
