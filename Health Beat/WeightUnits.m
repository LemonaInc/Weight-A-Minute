//
//  WeightUnits.m
//  Health Beat
//
//  Created by Rich Warren on 10/21/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
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
