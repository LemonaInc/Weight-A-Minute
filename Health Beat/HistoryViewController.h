//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface HistoryViewController : UITableViewController <NSFetchedResultsControllerDelegate> 

@property (strong, nonatomic) UIManagedDocument* document;

@end
