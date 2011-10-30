//
//  GraphViewController.m
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "WeightEntry.h"

@interface GraphViewController()

@property (strong, nonatomic) NSArray* weightHistory;

@property (strong, nonatomic) UIPopoverController* 
historyPopoverController;

@end


@implementation GraphViewController

@synthesize document = _document;
@synthesize weightHistory = _weightHistory;
@synthesize historyPopoverController = _historyPopoverController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id graphView = self.view;    
    
    [graphView setWeightEntries:self.weightHistory 
                       andUnits:getDefaultUnits()];
    
    // register to recieve notifications when the default unit changes
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSUserDefaultsDidChangeNotification
     object:[NSUserDefaults standardUserDefaults] 
     queue:nil
     usingBlock:^(NSNotification *note) {
         
         [graphView setWeightEntries:self.weightHistory 
                            andUnits:getDefaultUnits()];
     }];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation 
                                          duration:(NSTimeInterval)duration {
    
    [self.view setNeedsDisplay];
}

#pragma mark - Custom Accessor

- (void)setDocument:(UIManagedDocument*)document {

    NSNotificationCenter* center = 
    [NSNotificationCenter defaultCenter];
    
    
    // if we're assigning the same history, don't do anything.
    if ([_document isEqual:document]) {
        return;
    }
    
    // clear any notifications for the old history, if any
    if (_document != nil) {
        
        [center 
         removeObserver:self
         name:NSManagedObjectContextObjectsDidChangeNotification
         object:self.document.managedObjectContext];
    }
    
    _document = document;
    
    // add new notifications for the new history, if any
    // and set the view's values.
    if (_document != nil) {
        
        // Create the fetch request
        NSFetchRequest *fetchRequest = 
        [NSFetchRequest fetchRequestWithEntityName:[WeightEntry entityName]];
        
        // Set up sort descriptor
        NSSortDescriptor *sortDescriptor = 
        [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        
        NSArray *sortDescriptors = 
        [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError* error;
        self.weightHistory = 
        [self.document.managedObjectContext 
         executeFetchRequest:fetchRequest
         error:&error];
        
        if (self.weightHistory == nil) {
            
            // We may want more thorough error checking; however,
            // at this point, the main cause for errors tends be
            // invalid keys in the sort descriptor. Let's fail fast
            // so we're sure to catch that during development.
            
            [NSException 
             raise:NSInternalInconsistencyException
             format:@"An error occurred when performing our fetch %@",
             [error localizedDescription]];
        }
        
        
        [center 
         addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
         object:self.document.managedObjectContext
         queue:nil 
         usingBlock:^(NSNotification* notification) {
             
             NSError* fetchError;
             self.weightHistory = 
             [self.document.managedObjectContext 
              executeFetchRequest:fetchRequest
              error:&fetchError];
             
             if (self.weightHistory == nil) {
                 
                 // We may want more thorough error checking; however,
                 // at this point, the main cause for errors tends be
                 // invalid keys in the sort descriptor. Let's fail fast
                 // so we're sure to catch that during development.
                 
                 [NSException 
                  raise:NSInternalInconsistencyException
                  format:@"An error occurred when performing our fetch %@",
                  [fetchError localizedDescription]];
             }
             
             // if the view is loaded, we need to update it
             if (self.isViewLoaded) {
                 
                 id graphView = self.view;
                 [graphView setWeightEntries:self.weightHistory 
                                    andUnits:getDefaultUnits()];
             }
         }];
          
        // if the view is loaded, we need to update it
        if (self.isViewLoaded) {
            
            id graphView = self.view;
            [graphView setWeightEntries:self.weightHistory 
                               andUnits:getDefaultUnits()];
        }
    }
}

#pragma mark - Split View Controller Delegate Methods

- (void)splitViewController:(UISplitViewController *)splitController 
     willHideViewController:(UIViewController *)viewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"History";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.historyPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController 
     willShowViewController:(UIViewController *)viewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, 
    // invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.historyPopoverController = nil;
}

@end
