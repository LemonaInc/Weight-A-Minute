//
//  TabBarController.m
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "TabBarController.h"
#import "WeightHistory.h"

@implementation TabBarController

@synthesize weightHistory = _weightHistory;

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
    
    [WeightHistory accessWeightHistory:
     ^(BOOL success, WeightHistory *weightHistory) {
         
         if (!success) {
             
             // An error occurred while instantiating our history.
             // This probably indicates a catastrophic failure
             // (e.g. the device's hard drive is out of space).
             // We should really alert the user and tell them to 
             // take appropriate action. For now, just throw 
             // an exception.
             
             [NSException 
              raise:NSInternalInconsistencyException
              format:@"An error occured while trying to "
              @"instantiate our history"];
             
         }
         
         self.weightHistory = weightHistory;
         
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
             
             // if it responds to setWeightHistory, set the weight history
             if ([controller 
                  respondsToSelector:@selector(setWeightHistory:)]) {
                 
                 [controller setWeightHistory:self.weightHistory];
             }
         }   
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
