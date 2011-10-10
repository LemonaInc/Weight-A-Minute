//
//  UnitSelectorViewController.h
//  Health Beat
//
//  Created by Rich Warren on 10/9/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
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
