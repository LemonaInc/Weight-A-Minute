//
//  HistoryCell.m
//  Health Beat
//
//  Created by Rich Warren on 10/9/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
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
