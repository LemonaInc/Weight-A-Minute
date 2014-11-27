//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeightHistory;

@interface DetailViewController : UITableViewController

@property (nonatomic, strong) NSArray* weightHistory;
@property (nonatomic, assign) NSUInteger selectedIndex;


@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *averageTextField;
@property (strong, nonatomic) IBOutlet UITextField *lossTextField;
@property (strong, nonatomic) IBOutlet UITextField *gainTextField;


@end
