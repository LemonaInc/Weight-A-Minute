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
    
    self.weightHistory = [[WeightHistory alloc] init];
    
    // Create a stack and load it with the view controllers from our tabs.
    NSMutableArray* stack = 
    [NSMutableArray arrayWithArray:self.viewControllers];
    
    // While we still have items on our stack
    while ([stack count] > 0) {
        
        // pop the last item off the stack.
        id controller = [stack lastObject];
        [stack removeLastObject];
        
        // If it is a container object, add its controllers to the stack.
        if ([controller respondsToSelector:@selector(viewControllers)]) {
            
            [stack addObjectsFromArray:[controller viewControllers]];
        }
        
        // If it responds to setWeightHistory, set the weight history.
        if ([controller respondsToSelector:@selector(setWeightHistory:)]) {
            
            [controller setWeightHistory:self.weightHistory];
        }
    }    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
