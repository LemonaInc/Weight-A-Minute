//
//  WeightUnits.h
//  Health Beat
//
//  Created by Rich Warren on 10/21/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//


typedef enum {
    LBS,
    KG
} WeightUnit;

WeightUnit getDefaultUnits(void);
void setDefaultUnits(WeightUnit value);

