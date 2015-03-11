//
//  ViewController.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/7/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "ViewController.h"
#import "CustomCellView.h"
#import "ConfigurableCoreDataStack.h"
#import "Item.h"

@interface ViewController()

@property (nonatomic) NSColor* bgColor1;
@property (nonatomic) NSColor* bgColor2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.bgColor1 = [self backgroundColor1];
    self.bgColor2 = [self backgroundColor2];
    
    // now setup the core data stack
    CoreDataStackConfiguration* config = [CoreDataStackConfiguration new];
    config.storeType = NSSQLiteStoreType;
    config.modelName = @"InventoryModel";// note: match the xcdatamodel file
    config.appIdentifier = @"czhang.HW8.coredata";
    config.dataFileNameWithExtension = @"store.sqlite";
    config.searchPathDirectory = NSApplicationSupportDirectory;
    
    ConfigurableCoreDataStack* stack = [[ConfigurableCoreDataStack alloc] initWithConfiguration:config];
    
    self.moc = stack.managedObjectContext;
    
    // now retrieve all items from data store
    //[self doit];
    self.items = [self fetchItems];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(NSArray*)doit
{
    //@@ insert item
    Item* item = [Item createInMoc:self.moc];
    
    item.title = @"Used car - 98 civic, in great shape. needs repair. bumps. 120k miles. only $1500.";
    
    NSLog(@"%@", item);
    
    NSError* error = nil;
    BOOL success = [self.moc save:&error];
    if(!success)
    {
        [[NSApplication sharedApplication] presentError:error];
    }
    
    //@@ fetch item
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError* error2 = nil;
    NSArray* allItems = [self.moc executeFetchRequest:req error:&error2];
    
    NSLog(@"%@", allItems);
    for(Item* i in allItems){
        NSLog(@"%@", i.title);
    }
    return allItems;
}

-(NSArray*)fetchItems
{
    //@@ fetch item
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError* error = nil;
    NSArray* allItems = [self.moc executeFetchRequest:req error:&error];
    
    NSLog(@"%@", allItems);
    for(Item* i in allItems){
        NSLog(@"%@", i.title);
    }
    
    return allItems;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.items.count + 1;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 170;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"%@",[NSString stringWithFormat:@"%ldl",(long)row ]);
    
    if ( row >= self.items.count)
    {
        // the last one
        NSView* view = [self.tableView makeViewWithIdentifier:@"NewInventoryView" owner:self];
        return view;
    }
    else
    {
    CustomCellView* view = [self.tableView makeViewWithIdentifier:@"InventoryView" owner:self];
    
    [view.imageView2 setImage:[NSImage imageNamed:@"background.png"]];
    
    Item* item = (Item*)[self.items objectAtIndex:row];
    view.label.stringValue = item.title;
    
    if ( row %2 ==0 )
    {
        view.backgroundColor = self.bgColor1;
    }
    else
    {
        view.backgroundColor = self.bgColor2;
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
}

-(NSColor*)backgroundColor1
{
    CGFloat R = 0.6;
    CGFloat G = 0.8;
    CGFloat B = 0.6;
    CGFloat A = 0.3;
    
    return [NSColor colorWithSRGBRed:R green:G blue:B alpha:A];
}

-(NSColor*)backgroundColor2
{
    CGFloat R = 0.6;
    CGFloat G = 0.6;
    CGFloat B = 0.8;
    CGFloat A = 0.5;
    
    return [NSColor colorWithSRGBRed:R green:G blue:B alpha:A];
}

@end
