//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightEntry.h"

@interface GraphView : UIView

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGSize cornerRadius;
@property (nonatomic, strong) UIColor* graphBorderColor;
@property (nonatomic, strong) UIColor* graphFillColor;
@property (nonatomic, assign) CGFloat graphBorderWidth;
@property (nonatomic, strong) UIColor* gridColor;
@property (nonatomic, assign) CGFloat gridSquareSize;
@property (nonatomic, assign) CGFloat gridLineWidth;
@property (nonatomic, strong) UIColor* trendLineColor;
@property (nonatomic, assign) CGFloat trendLineWidth;
@property (nonatomic, strong) UIColor* referenceLineColor;
@property (nonatomic, assign) CGFloat referenceLineWidth;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, assign) CGFloat fontSize;


- (void)setWeightEntries:(NSArray*)weightEntries 
                andUnits:(WeightUnit)units;

@end
