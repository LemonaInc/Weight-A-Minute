//
//  GraphViewController.h
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeightHistory;

@interface GraphViewController : UIViewController

@property (strong, nonatomic) WeightHistory* weightHistory;

@end