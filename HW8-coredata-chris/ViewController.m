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
#import "Tag.h"
#include "PopupImageViewController.h"

@interface ViewController()

@property NSMutableSet* pendingImages;
@property NSMutableSet* pendingTags;
@property NSArray* avialableTags;

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
    config.appIdentifier = @"czhang.HW.coredata";
    config.dataFileNameWithExtension = @"store.sqlite";
    config.searchPathDirectory = NSApplicationSupportDirectory;
    
    ConfigurableCoreDataStack* stack = [[ConfigurableCoreDataStack alloc] initWithConfiguration:config];
//    [stack removeCoreDataFilesFromDisk];
    
    self.moc = stack.managedObjectContext;
    
    //
    // retrieve all the items from data store
    //
    self.items = [Item fetchAllItemsInContext:self.moc];
    
    self.avialableTags = [Tag fetchAllTagsInContext:self.moc];
    
    self.pendingImages = [NSMutableSet new];
    self.pendingTags = [NSMutableSet new];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
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
        return 200 + 2*10;
    }
    else
    {
        // regular row
        return 150 + 10*2;
    }
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ( row >= self.items.count)
    {
        // the last one
        NewItemView* view = [self.tableView makeViewWithIdentifier:@"NewInventoryView" owner:self];
        
        view.addInvButton.image = [NSImage imageNamed:@"yes.png"];
        view.addImageButton.image = [NSImage imageNamed:@"list-add.png"];
        view.clrEntryButton.image = [NSImage imageNamed:@"clr.png"];
        
        CGFloat wh = 50;
        CGFloat div = 5;
        CGFloat x = div;
        CGFloat y= div + wh;
        
        [self addImages:self.pendingImages toView:view.imagePanelView startingAt:NSMakeRect(x, y, wh, wh) withHorizontalDiv:div];
        
        return view;
    }
    else
    {
        InventoryView* view = [self.tableView makeViewWithIdentifier:@"InventoryView" owner:self];
        view.checkButton.image = [NSImage imageNamed:@"del.png"];
        
        ( row %2 ==0 ) ? [view useNormalBackgroundColor] : [view useAlternativeBackgroundColor];
        
        Item* item = (Item*)[self.items objectAtIndex:row];
        view.item = item;
        NSString* tagString = [NSString new];
        for(Tag* tag in item.tags)
        {
            tagString = [[tagString stringByAppendingString:tag.name] stringByAppendingString:@" "];
        }
        view.label.stringValue = [NSString stringWithFormat:@"created at %@\n\n%@\n\nTAGS:%@", item.dateCreated, item.title, tagString ];
        
        CGFloat wh = 150;
        CGFloat div = 10;
        CGFloat x = div;
        CGFloat y = 170 - div - wh ;
        
        [self addImages:item.images toView:view.imagePanelView startingAt:NSMakeRect(x, y, wh, wh) withHorizontalDiv:div];
        
        return view;
    }
}

-(void)addImages:(NSSet*)images toView:(NSView*)view startingAt:(NSRect)firstRect withHorizontalDiv:(CGFloat)div
{
    while(view.subviews.count>0)
    {
        [((NSView*)[view.subviews objectAtIndex:view.subviews.count-1]) removeFromSuperview];
    }
    
    CGFloat x = firstRect.origin.x;
    CGFloat y = firstRect.origin.y;
    CGFloat w = firstRect.size.width;
    CGFloat h = firstRect.size.height;
    
    for(Image* img in images)
    {
#if 0
        NSImageView* invImgView = [[NSImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        NSImage* loadImage = [[NSImage alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:img.imageURL]];
        
        [invImgView setImage: loadImage];
        [view addSubview:invImgView];
#endif
        NSButton* imgBtn = [[NSButton alloc] initWithFrame:CGRectMake(x,y, w, h)];
        imgBtn.image = [[NSImage alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:img.imageURL]];
        imgBtn.bordered = NO;
        [imgBtn setTarget:self];
        [imgBtn setAction:@selector(doSomething:)];
        [view addSubview:imgBtn];
        
        x = x + w + div;
    }
}

-(void)doSomething:(id)sender
{
    NSLog(@"imgBtn action");
    NSButton* view = ((NSButton*)sender);
    
    // get the main/default SB
    NSStoryboard* sb = [NSStoryboard storyboardWithName:@"Main"  bundle:nil];
    
    // get the VC by its id
    PopupImageViewController* vc = [sb instantiateControllerWithIdentifier:@"PopupImageViewController"];
    
    NSLog(@"img=%@", view.image);
    
    [self presentViewController:vc  asPopoverRelativeToRect:view.bounds
                         ofView:view
                  preferredEdge:NSMaxYEdge
                       behavior:NSPopoverBehaviorTransient];

    // must after view was popped up
    [vc.imageView setImage: view.image];
    
}

- (IBAction)onClickAddNewInv:(id)sender {
    NewItemView* view = (NewItemView*)[sender superview];
    
    if ([view.invDescTextView.string isEqualToString:@""])
    {
        // get the main/default SB
        NSStoryboard* sb = [NSStoryboard storyboardWithName:@"Main"  bundle:nil];
        
        // get the VC by its id
        NSViewController* vc = [sb instantiateControllerWithIdentifier:@"PopupViewController"];
        [self presentViewController:vc  asPopoverRelativeToRect:view.invDescTextView.bounds
                             ofView:view.invDescTextView
                      preferredEdge:NSMaxYEdge
                           behavior:NSPopoverBehaviorTransient];
        
        return;
    }
    
    NSLog(@"add new inventory: %@", view.invDescTextView.string);

    NSString* title = [[NSString alloc] initWithString: view.invDescTextView.string];
    NSArray* tagNames = [view.addTagTextView.string componentsSeparatedByString:@"," ];
    NSArray* newTags = [Tag createNewTagsInContext:self.moc withAvailableTags:self.avialableTags fromStringArray:tagNames];
    [self.pendingTags addObjectsFromArray:newTags];
    Item* newItem = [Item createItemInMoc:self.moc withTitle:title withImages:self.pendingImages withTags:self.pendingTags];
    if (newItem == nil ){
        NSLog(@"***** add new item failed! *****");
    }
    
    view.invDescTextView.string = @"";
    view.addTagTextView.string = @"";
    [self.pendingImages removeAllObjects];
    [self.pendingTags removeAllObjects];
    
    self.items = [Item fetchAllItemsInContext:self.moc];
    [self.tableView reloadData];
}

- (IBAction)onClickAddImageButton:(id)sender {
    NSLog(@"onClickAddImageButton");
    
    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.directoryURL = [NSURL fileURLWithPath:[@"~/Downloads" stringByExpandingTildeInPath]];
    op.allowsMultipleSelection=YES;
    
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
             
             //             NSLog(@"copy to %@", targetURL.relativePath);
             
             // copy image to app's location
             [[NSFileManager defaultManager] copyItemAtURL:url toURL:targetURL error:nil];
             
             image.imageURL = targetURL.relativePath;
             [self.pendingImages addObject:image];
         }
         
         [self.tableView reloadData];
         
     }];
}

- (IBAction)onClickClearButton:(id)sender {
    NewItemView* view = (NewItemView*)[sender superview];
    
    view.invDescTextView.string = @"";
    view.addTagTextView.string = @"";
    [self.pendingImages removeAllObjects];
    [self.pendingTags removeAllObjects];
    
    self.items = [Item fetchAllItemsInContext:self.moc];
    [self.tableView reloadData];
}

- (IBAction)onClickCheckButton:(id)sender {
    InventoryView* view = (InventoryView*)[sender superview];
    NSLog(@"delete inventory: %@", view.item.title);
    
    [Item deleteItem:view.item fromMoc:self.moc];
    
    self.items = [Item fetchAllItemsInContext:self.moc];
    [self.tableView reloadData];
}

@end
