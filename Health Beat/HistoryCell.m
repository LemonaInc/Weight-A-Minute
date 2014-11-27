//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

@synthesize weightLabel=_weightLabel;
@synthesize dateLabel=_dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureWithWeightEntry:(WeightEntry*)entry 
                    defaultUnits:(WeightUnit)unit {
    
    self.weightLabel.text = [entry stringForWeightInUnit:unit];
    
    self.dateLabel.text = 
    [NSDateFormatter localizedStringFromDate:entry.date
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterShortStyle];
    
}

@end
