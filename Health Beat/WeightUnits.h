//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//


typedef enum {
    LBS,
    KG
} WeightUnit;

WeightUnit getDefaultUnits(void);
void setDefaultUnits(WeightUnit value);

