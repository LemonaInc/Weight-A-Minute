//
//  HistoryViewController.m
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "HistoryViewController.h"
#import "DetailViewController.h"
#import "HistoryCell.h"
#import "WeightEntry.h"

static NSString* const DetailViewSegueIdentifier = @"Push Detail View";
static NSString* const EnterWeightViewSegueIdentifier = @"Push Enter Weight View";

@interface HistoryViewController()

@property (nonatomic, retain) NSFetchedResultsController* 
fetchedResultsController;

- (void)instantiateFetchedResultsController;

- (void)reloadTableData;

@end


@implementation HistoryViewController

@synthesize document = _document;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // register to recieve notifications when the user defaults change
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(reloadTableData)
     name:NSUserDefaultsDidChangeNotification 
     object:[NSUserDefaults standardUserDefaults]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"History Cell";
    
    HistoryCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    WeightEntry* entry = 
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureWithWeightEntry:entry 
                      defaultUnits:getDefaultUnits()];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
                
        WeightEntry* entry = 
        [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = 
        [self.fetchedResultsController managedObjectContext];
        
        [context deleteObject:entry];
        
        NSError* error;
        if (![context save:&error]) {
            
            // ideally we should replace this with more robust error handling.
            // However, we're not saving to disk, we're just pushing the change
            // up to the parent context--so most errors should be
            // caused by mistakes in our code.
            [NSException 
             raise:NSInternalInconsistencyException
             format:@"An error occurred when saving the context: %@",
             [error localizedDescription]];
        }
    } 
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
    if ([segue.identifier isEqualToString:DetailViewSegueIdentifier]) {
        
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        DetailViewController* controller = segue.destinationViewController;
        
        controller.weightHistory = 
        self.fetchedResultsController.fetchedObjects;
        controller.selectedIndex = path.row;
    }
    
    if ([segue.identifier isEqualToString:
         EnterWeightViewSegueIdentifier]) {
        
        [segue.destinationViewController 
         setDocument:self.document];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)reloadTableData {
    
    [self.tableView reloadData];
}

#pragma mark - Responder Events

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    // only respond to shake events
    if (event.type == UIEventSubtypeMotionShake) {
        
        [self.document.undoManager undo];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Private Methods

- (void)instantiateFetchedResultsController {
    
    // Create the fetch request
    NSFetchRequest *fetchRequest = 
    [NSFetchRequest fetchRequestWithEntityName:[WeightEntry entityName]];
    
    // Set the batch size
    [fetchRequest setFetchBatchSize:20];
    
    // Set up sort descriptor
    NSSortDescriptor *sortDescriptor = 
    [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *sortDescriptors = 
    [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // nil for section name key path means "no sections".
    self.fetchedResultsController = 
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:fetchRequest
     managedObjectContext:self.document.managedObjectContext
     sectionNameKeyPath:nil 
     cacheName:@"History View"];
    
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        // We may want more thorough error checking; however,
        // at this point, the main cause for errors tends be
        // invalid keys in the sort descriptor. Let's fail fast
        // so we're sure to catch that during development.
        
        [NSException 
         raise:NSInternalInconsistencyException
         format:@"An error occurred when performing our fetch %@",
         [error localizedDescription]];
    }
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    WeightEntry* entry;
    HistoryCell* cell;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView 
             insertRowsAtIndexPaths:
             [NSArray arrayWithObject:newIndexPath]
             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView 
             deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:indexPath]
             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            
            entry = 
            [self.fetchedResultsController 
             objectAtIndexPath:indexPath];
            
            cell = (HistoryCell*) 
            [self.tableView 
             cellForRowAtIndexPath:indexPath];
            
            [cell configureWithWeightEntry:entry 
                              defaultUnits:getDefaultUnits()];
            
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView 
             deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:indexPath]
             withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [tableView 
             insertRowsAtIndexPaths:
             [NSArray arrayWithObject:newIndexPath]
             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


    
#pragma mark - Custom Accessor

- (void)setDocument:(UIManagedDocument *)document {
    
    
    // if we're assiging the same history, don't do anything.
    if ([_document isEqual:document]) {
        return;
    }
    
    // remove any old fetched results controller
    if (_document != nil) {
        
        self.fetchedResultsController = nil;
    }
    
    _document = document;
    
    // add new notifications for the new history, if nay
    if (_document != nil) {

        [self instantiateFetchedResultsController];
        
        // if the view is loaded, we need to update it
        if (self.isViewLoaded) {
            
            [self.tableView reloadData];
        }
    }
}


@end
