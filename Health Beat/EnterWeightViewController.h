//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitSelectorViewController.h"
#import <iAd/iAd.h>


@interface EnterWeightViewController : UIViewController <UITextFieldDelegate, ADBannerViewDelegate,
 UnitSelectorViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UIButton* unitsButton;
@property (strong, nonatomic) IBOutlet UILabel *saveWarningLabel;

@property (strong, nonatomic) UIManagedDocument* document;

- (IBAction)saveWeight:(id)sender;
- (IBAction)changeUnits:(id)sender;
- (IBAction)handleDownwardSwipe:(id)sender;
- (IBAction)handleUpwardSwipe:(id)sender;

@end
