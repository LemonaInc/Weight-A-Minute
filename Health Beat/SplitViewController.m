//
//  SplitViewController.m
//  Health Beat
//
//  Created by Rich Warren on 10/29/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "SplitViewController.h"
#import <CoreData/CoreData.h>

@interface SplitViewController()

@property (strong, nonatomic) UIManagedDocument* document;

- (void)passDocumentToSubViewControllers;

@end

@implementation SplitViewController

@synthesize document = _document;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // index 1 is the detail view controller
    // This will be a navigation controller
    UINavigationController* navController = 
    [self.viewControllers objectAtIndex:1];
    
    // Our graph view should be on top
    id graphController = 
    navController.topViewController;
    
    // Set the delegate
    self.delegate = graphController;
    
    // Override point for customization after application launch.    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* ubiquitousURL = 
    [fileManager URLForUbiquityContainerIdentifier:nil];
    
    NSDictionary *options;
    if (ubiquitousURL != nil) {
        
        options = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithBool:YES], 
                   NSMigratePersistentStoresAutomaticallyOption,
                   [NSNumber numberWithBool:YES], 
                   NSInferMappingModelAutomaticallyOption, 
                   @"com.freelancemadscience.Health_Beat.history", 
                   NSPersistentStoreUbiquitousContentNameKey,
                   ubiquitousURL, 
                   NSPersistentStoreUbiquitousContentURLKey, nil];   
        
    } else {
        
        // Create options for local sandbox storage only
        options = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithBool:YES], 
                   NSMigratePersistentStoresAutomaticallyOption,
                   [NSNumber numberWithBool:YES], 
                   NSInferMappingModelAutomaticallyOption, nil];   
        
    }
    
    NSURL* localURL = [fileManager URLForDirectory:NSDocumentDirectory
                                          inDomain:NSUserDomainMask
                                 appropriateForURL:nil
                                            create:NO
                                             error:nil];
    
    NSURL* localCoreDataURL = 
    [localURL URLByAppendingPathComponent:@"MyData"];
    
    // Now Create our document
    self.document = 
    [[UIManagedDocument alloc] initWithFileURL:localCoreDataURL];
    
    self.document.persistentStoreOptions = options;
    
    if ([fileManager fileExistsAtPath:[localCoreDataURL path]]) {
        
        [self.document openWithCompletionHandler:
         ^(BOOL success) {
             
             [self passDocumentToSubViewControllers];
         }];
        
    } else {
        
        [self.document 
         saveToURL:localCoreDataURL
         forSaveOperation:UIDocumentSaveForCreating
         completionHandler:^(BOOL success) {
             
             [self passDocumentToSubViewControllers];
         }];
    }
}

- (void)passDocumentToSubViewControllers {
    
    // create a stack, and load it with the view 
    // controllers from our tabs
    NSMutableArray* stack = 
    [NSMutableArray arrayWithArray:self.viewControllers];
    
    // while we still have items on our stack
    while ([stack count] > 0) {
        
        // pop the last item off the stack
        id controller = [stack lastObject];
        [stack removeLastObject];
        
        // if it is a container object, add its view 
        // controllers to the stack
        if ([controller 
             respondsToSelector:@selector(viewControllers)]) {
            
            [stack addObjectsFromArray:[controller viewControllers]];
        }
        
        // if it responds to setDocument, pass our document
        if ([controller 
             respondsToSelector:@selector(setDocument:)]) {
            
            [controller setDocument:self.document];
        }
    } 
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
     object:[self.document.managedObjectContext persistentStoreCoordinator]
     queue:nil
     usingBlock:^(NSNotification *note) {
         
         [self.document.managedObjectContext performBlock:^{
             
             NSLog(@"Merging Changes");
             [self.document.managedObjectContext 
              mergeChangesFromContextDidSaveNotification:note];
             
         }];
     }];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}


@end
