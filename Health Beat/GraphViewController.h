//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface GraphViewController : UIViewController  <UISplitViewControllerDelegate, ADBannerViewDelegate>


@property (strong, nonatomic) UIManagedDocument* document;

@end
