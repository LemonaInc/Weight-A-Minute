//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightEntry.h"

@interface HistoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* weightLabel;
@property (nonatomic, strong) IBOutlet UILabel* dateLabel;


- (void)configureWithWeightEntry:(WeightEntry*)entry 
                    defaultUnits:(WeightUnit)unit;

@end
