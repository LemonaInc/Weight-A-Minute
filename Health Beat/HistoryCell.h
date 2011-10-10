//
//  HistoryCell.h
//  Health Beat
//
//  Created by Rich Warren on 10/9/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightEntry.h"

@interface HistoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* weightLabel;
@property (nonatomic, strong) IBOutlet UILabel* dateLabel;


- (void)configureWithWeightEntry:(WeightEntry*)entry 
                    defaultUnits:(WeightUnit)unit;

@end
