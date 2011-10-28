//
//  HistoryViewController.h
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface HistoryViewController : UITableViewController <NSFetchedResultsControllerDelegate> 

@property (strong, nonatomic) UIManagedDocument* document;

@end
