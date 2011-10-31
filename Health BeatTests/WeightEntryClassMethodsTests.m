//
//  WeightEntryClassMethodsTests.m
//  Health Beat
//
//  Created by Rich Warren on 10/30/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "WeightEntryClassMethodsTests.h"
#import "WeightEntry.h"
#import "WeightUnits.h"

@implementation WeightEntryClassMethodsTests

static const CGFloat accuracy = 0.01;

-(void)testLbsToKg {
    
    // correct values according to Wolfram Alpha
    STAssertEqualsWithAccuracy([WeightEntry convertLbsToKg:0.0f], 
                               0.0f,
                               accuracy,
                               @"Incorrect weight for 0 lbs");
    
    STAssertEqualsWithAccuracy([WeightEntry convertLbsToKg:10.0f], 
                               4.5359f,
                               accuracy,
                               @"Incorrect weight for 10 lbs");
    
    STAssertEqualsWithAccuracy([WeightEntry convertLbsToKg:145.6f], 
                               66.043f,
                               accuracy,
                               @"Incorrect weight for 145.6 lbs");
}

- (void)testKgToLbs {
   
    // correct values according to Wolfram Alpha
    STAssertEqualsWithAccuracy([WeightEntry convertKgToLbs:0.0f], 
                               0.0f,
                               accuracy,
                               @"Incorrect weight for 0 kg");
    
    STAssertEqualsWithAccuracy([WeightEntry convertKgToLbs:10.0f], 
                               22.0462f,
                               accuracy,
                               @"Incorrect weight for 10 kg");
    
    STAssertEqualsWithAccuracy([WeightEntry convertKgToLbs:145.6f], 
                               320.9931f,
                               accuracy,
                               @"Incorrect weight for 145.6 kg");
}

- (void)testStringForUnit {
    
    STAssertEqualObjects([WeightEntry stringForUnit:LBS], 
                         @"lbs",
                         @"Invalid string returned for LBS");
    
    STAssertEqualObjects([WeightEntry stringForUnit:KG], 
                         @"kg", 
                         @"Invalid string returned for KG");
    
    STAssertThrows([WeightEntry stringForUnit:2], 
                   @"Any invalid value should throw an exception");
    
}

- (void)testStringForWeightOfUnit {
    
    STFail(@"TODO: implement the testStringForWeightOfUnit test case");
}

@end
