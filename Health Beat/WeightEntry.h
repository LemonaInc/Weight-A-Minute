//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeightEntry : NSManagedObject

@property (nonatomic, readonly, retain) NSDate* date;
@property (nonatomic, readonly) float weightInLbs;

+ (CGFloat)convertLbsToKg:(CGFloat)lbs;
+ (CGFloat)convertKgToLbs:(CGFloat)kg;

+ (NSString*)stringForUnit:(WeightUnit)unit;
+ (NSString*)stringForWeight:(CGFloat)weight ofUnit:(WeightUnit)unit;
+ (NSString*)stringForWeightInLbs:(CGFloat)weight inUnit:(WeightUnit)unit; 

+ (WeightEntry*)addEntryToDocument:(UIManagedDocument*)document
                  usingWeightInLbs:(CGFloat)weight
                              date:(NSDate*)date;

+ (NSString*)entityName;

- (CGFloat)weightInUnit:(WeightUnit)unit;
- (NSString*)stringForWeightInUnit:(WeightUnit)unit;

@end
