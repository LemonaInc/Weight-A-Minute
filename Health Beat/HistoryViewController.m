//
//  HistoryViewController.m
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "HistoryViewController.h"
#import "WeightHistory.h"
#import "DetailViewController.h"
#import "HistoryCell.h"

static NSString* const DetailViewSegueIdentifier = @"Push Detail View";

@interface HistoryViewController()

- (void)reloadTableData;
- (void)weightHistoryChanged:(NSDictionary*) change;

@end




@implementation HistoryViewController

@synthesize weightHistory = _weightHistory;

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
    
    // We only have a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of entries in our weight history
    return [self.weightHistory.weights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"History Cell";
    
    HistoryCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    WeightEntry* entry = 
    [self.weightHistory.weights objectAtIndex:indexPath.row];
    
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
        
        
        [self.weightHistory removeWeightAtIndex:indexPath.row];
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
        
        controller.weightHistory = self.weightHistory;
        controller.selectedIndex = path.row;
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

#pragma mark - Notification Methods

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context   {
    
    if ([keyPath isEqualToString:KVOWeightChangeKey]) {
        
        [self weightHistoryChanged:change];
    }
}

- (void)weightHistoryChanged:(NSDictionary*) change {
    
    // First extract the kind of change.
    NSNumber* value = [change objectForKey:NSKeyValueChangeKindKey];
    
    // Next, get the indexes that changed.
    NSIndexSet* indexes = 
    [change objectForKey:NSKeyValueChangeIndexesKey];
    
    NSMutableArray* indexPaths = 
    [[NSMutableArray alloc] initWithCapacity:[indexes count]];
    
    // Use a block to process each index.
    [indexes enumerateIndexesUsingBlock:
     ^(NSUInteger indexValue, BOOL* stop) {
         
         NSIndexPath* indexPath = 
         [NSIndexPath indexPathForRow:indexValue inSection:0];
         
         [indexPaths addObject:indexPath];
     }];
    
    // Now update the table.
    switch ([value intValue]) {
            
        case NSKeyValueChangeInsertion:
            
            // Insert the row.
            [self.tableView insertRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
            
        case NSKeyValueChangeRemoval:
            
            // Delete the row.
            [self.tableView deleteRowsAtIndexPaths:indexPaths 
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
            
        case NSKeyValueChangeSetting:
            [self.tableView reloadData];
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException 
                        format:@"Change kind value %d not recognized", 
             [value intValue]];
            
    }
}

- (void)reloadTableData {
    
    [self.tableView reloadData];
}

#pragma mark - Responder Events

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    // only respond to shake events
    if (event.type == UIEventSubtypeMotionShake) {
        
        [self.weightHistory undo];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Custom Accessor

- (void)setWeightHistory:(WeightHistory *)weightHistory {
    
    
    // if we're assiging the same history, don't do anything.
    if ([_weightHistory isEqual:weightHistory]) {
        return;
    }
    
    // clear any notifications for the old history, if any
    if (_weightHistory != nil) {
        
        [_weightHistory removeObserver:self
                            forKeyPath:KVOWeightChangeKey]; 
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    _weightHistory = weightHistory;
    
    // add new notifications for the new history, if nay
    if (_weightHistory != nil) {
        
        // register to receive kvo messages when the weight history changes
        [_weightHistory addObserver:self 
                         forKeyPath:KVOWeightChangeKey 
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        
        
        // if the view is loaded, we need to update it
        if (self.isViewLoaded) {
            
            [self.tableView reloadData];
        }
    }
}


@end
