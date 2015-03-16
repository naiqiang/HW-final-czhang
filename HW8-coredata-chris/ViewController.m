//
//  ViewController.m
//  HW8-coredata-chris
//
//  Created by czhang on 3/7/15.
//  Copyright (c) 2015 czhang. All rights reserved.
//

#import "ViewController.h"
#import "InventoryView.h"
#import "ConfigurableCoreDataStack.h"
#import "Item.h"
#import "NewItemView.h"
#import "CoreDataStackConfiguration.h"
#import "NSManagedObject+Extensions.h"
#import "Image.h"

@interface ViewController()
@property NSString* title;
@property NSMutableSet* pendingImages;
@property NSMutableSet* pendingTags;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // now setup the core data stack
    
    CoreDataStackConfiguration* config = [CoreDataStackConfiguration new];
    config.storeType = NSSQLiteStoreType;
    config.modelName = @"InventoryModel";
    config.appIdentifier = @"czhang.HW8.coredata.7";
    config.dataFileNameWithExtension = @"store.sqlite";
    config.searchPathDirectory = NSApplicationSupportDirectory;
    
    ConfigurableCoreDataStack* stack = [[ConfigurableCoreDataStack alloc] initWithConfiguration:config];
    
    self.moc = stack.managedObjectContext;
    
    //
    // retrieve all the items from data store
    //
    
    self.items = [Item fetchAllItemsInContext:self.moc];
    
    self.title = nil;
    self.pendingImages = [NSMutableSet new];
    self.pendingTags = [NSMutableSet new];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


-(BOOL)deleteItem:(Item*)item
{
    [self.moc deleteObject:item];
    
    NSError* error = nil;
    BOOL success = [self.moc save:&error];
    if(!success)
    {
        [[NSApplication sharedApplication] presentError:error];
    }
    return success;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    // add an extra row to the table
    // that's the view to add new items
    return self.items.count + 1;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if ( row >= self.items.count)
    {
        // last row
        return 75 + 2*10;
    }
    else
    {
        // regular row
        return 150 + 10*2;
    }
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"view for row %@",[NSString stringWithFormat:@"%ldl",(long)row ]);
    
    if ( row >= self.items.count)
    {
        // the last one
        NewItemView* view = [self.tableView makeViewWithIdentifier:@"NewInventoryView" owner:self];
        
        view.addInvButton.image = [NSImage imageNamed:@"yes.png"];
        view.addImageButton.image = [NSImage imageNamed:@"list-add.png"];
        view.addTagButton.image = [NSImage imageNamed:@"tag.png"];
        
        CGFloat x = 450;
        CGFloat y= 10;
        CGFloat wh = 25;
        CGFloat div = 5;
        
        [self addImages:self.pendingImages toView:view startingAt:NSMakeRect(x, y, wh, wh) withHorizontalDiv:div];

        return view;
    }
    else
    {
        InventoryView* view = [self.tableView makeViewWithIdentifier:@"InventoryView" owner:self];
        view.checkButton.image = [NSImage imageNamed:@"del.png"];
        
        ( row %2 ==0 ) ? [view useNormalBackgroundColor] : [view useAlternativeBackgroundColor];
        
        Item* item = (Item*)[self.items objectAtIndex:row];
        view.item = item;
        view.label.stringValue = [NSString stringWithFormat:@"created at %@\n\n%@", item.dateCreated, item.title ];
        
        CGFloat x = 20+300+10;//view.label.bounds.origin.x + view.label.bounds.size.width+10;
        CGFloat y= 10;
        CGFloat wh = 150;
        CGFloat div = 10;
        
        [self addImages:item.images toView:view startingAt:NSMakeRect(x, y, wh, wh) withHorizontalDiv:div];
        
        return view;
    }
}

-(void)addImages:(NSSet*)images toView:(NSView*)view startingAt:(NSRect)firstRect withHorizontalDiv:(CGFloat)div
{
    CGFloat x = firstRect.origin.x;
    CGFloat y = firstRect.origin.y;
    CGFloat w = firstRect.size.width;
    CGFloat h = firstRect.size.height;

    for(Image* img in images)
    {
        NSImageView* invImgView = [[NSImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        //NSImage* loadImage = [NSImage imageNamed:@"background.png"];
        NSImage* loadImage = [[NSImage alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:img.imageURL]];
        NSLog(@"add image %@", img.imageURL);
        
        [invImgView setImage: loadImage];
        
        [view addSubview:invImgView];
        
        x = x + w + div;
    }
}

- (IBAction)onClickAddNewInv:(id)sender {
    NewItemView* view = (NewItemView*)[sender superview];
    NSLog(@"add new inventory: %@", view.invDescTextView.string);
    
    NSString* title = view.invDescTextView.string;
    Item* newItem = [Item createItemInMoc:self.moc withTitle:title withImages:self.pendingImages withTags:self.pendingTags];
    if (newItem == nil ){
        NSLog(@"***** add new item failed! *****");
    }
    else
    {
        self.items = [Item fetchAllItemsInContext:self.moc];
        [self.tableView reloadData];
    }
    self.pendingImages = [NSMutableSet new];
    self.pendingTags = [NSMutableSet new];
}

- (IBAction)onClickAddImageButton:(id)sender {
    NSLog(@"onClickAddImageButton");
    
    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.directoryURL = [NSURL fileURLWithPath:[@"~/Downloads" stringByExpandingTildeInPath]];
    
    [op beginWithCompletionHandler:^(NSInteger returnCode)
     {
         // execute after user makes choice
         
         // for each url
         for(NSURL* url in op.URLs)
         {
             NSLog(@"user got: %@", url.relativePath);
             
             // make core data Image entiry
             Image* image = [Image createInMoc:self.moc];
             
             // generate the target URL
             NSString* fileNameWithExtension = url.lastPathComponent;
             //NSString* fileName = [fileNameWithExtension stringByDeletingPathExtension];
             NSString* extension = fileNameWithExtension.pathExtension;
             NSURL* appDirUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
             NSString *uuid = [[NSUUID UUID] UUIDString];
             NSURL* targetURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@/%@.%@",appDirUrl.absoluteString, @"HW-final-coredata", uuid, extension]];
             
             NSLog(@"copy to %@", targetURL.relativePath);
             
             // copy image to app's location
             [[NSFileManager defaultManager] copyItemAtURL:url toURL:targetURL error:nil];

             image.imageURL = targetURL.relativePath;
             [self.pendingImages addObject:image];
         }
     }];
    
    self.items = [Item fetchAllItemsInContext:self.moc];
    [self.tableView reloadData];
}

- (IBAction)onClickAddtagButton:(id)sender {
    NSLog(@"onClickAddtagButton");
}

- (IBAction)onClickCheckButton:(id)sender {
    InventoryView* view = (InventoryView*)[sender superview];
    NSLog(@"delete inventory: %@", view.item.title);

    [self deleteItem: view.item];
    
    self.items = [Item fetchAllItemsInContext:self.moc];
    [self.tableView reloadData];
}

@end
