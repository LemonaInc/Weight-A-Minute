//
//  WeightHistory.h
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightEntry.h"

static NSString* const WeightHistoryChangedDefaultUnitsNotification =
@"WeightHistory changed the default units";

static NSString* const KVOWeightChangeKey = @"weightHistory";

@class WeightHistory;
typedef void (^historyAccessHandler) (BOOL success, WeightHistory* weightHistory);


@interface WeightHistory : UIDocument

// this is a virtual property
@property (nonatomic, readonly) NSArray* weights;

- (void)addWeight:(WeightEntry*)weight;
- (void)removeWeightAtIndex:(NSUInteger)index;

+ (void)accessWeightHistory:(historyAccessHandler)completionHandler;

@end
