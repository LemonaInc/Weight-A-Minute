//
//  EnterWeightViewController.h
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitSelectorViewController.h"

@interface EnterWeightViewController : UIViewController 
<UITextFieldDelegate, UnitSelectorViewControllerDelegate> 

@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UIButton* unitsButton;
@property (strong, nonatomic) IBOutlet UILabel *saveWarningLabel;

- (IBAction)saveWeight:(id)sender;
- (IBAction)changeUnits:(id)sender;
- (IBAction)handleDownwardSwipe:(id)sender;
- (IBAction)handleUpwardSwipe:(id)sender;

@end
