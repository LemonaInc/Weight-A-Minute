//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightEntry.h"

@protocol UnitSelectorViewControllerDelegate;




@interface UnitSelectorViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource> 


@property (strong, nonatomic) IBOutlet UIPickerView *unitPickerView;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) id<UnitSelectorViewControllerDelegate> 
delegate;

@property (assign, nonatomic) WeightUnit defaultUnit;

- (IBAction)done:(id)sender;

@end




@protocol UnitSelectorViewControllerDelegate <NSObject>

- (void)unitSelectorDone:(UnitSelectorViewController*)controller;

- (void)unitSelector:(UnitSelectorViewController*)controller 
        changedUnits:(WeightUnit)unit;

@end
