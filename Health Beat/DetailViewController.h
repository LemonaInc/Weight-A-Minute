//
//  DetailViewController.h
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
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
