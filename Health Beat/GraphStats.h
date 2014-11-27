//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeightEntry;



@interface GraphStats : NSObject

@property (strong, nonatomic, readonly) NSDate* startingDate;
@property (strong, nonatomic, readonly) NSDate* endingDate;
@property (assign, nonatomic, readonly) NSTimeInterval duration;

@property (assign, nonatomic, readonly) CGFloat minWeight;
@property (assign, nonatomic, readonly) CGFloat maxWeight;
@property (assign, nonatomic, readonly) CGFloat weightSpan;


- (id)initWithWeightEntryArray:(NSArray*)weightEntries;
- (void)processWeightEntryUsingBlock:(void (^)(WeightEntry*)) block;

@end
