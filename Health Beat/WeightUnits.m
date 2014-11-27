//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import "WeightUnits.h"
#import <Foundation/Foundation.h>

static NSString* const WeightUnitKey = @"weight_unit";

WeightUnit getDefaultUnits(void) {
    
    return [[NSUserDefaults standardUserDefaults]
            integerForKey:WeightUnitKey];
}

void setDefaultUnits(WeightUnit value) {
    
    [[NSUserDefaults standardUserDefaults]
     setInteger:value forKey:WeightUnitKey];
    
}
