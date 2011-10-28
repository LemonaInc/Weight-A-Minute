//
//  WeightEntry.m
//  Health Beat
//
//  Created by Rich Warren on 10/27/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "WeightEntry.h"

static const CGFloat LBS_PER_KG = 2.20462262f;
static NSNumberFormatter* formatter;

@interface WeightEntry()

@property (nonatomic, readwrite, retain) NSDate* date;
@property (nonatomic, readwrite) float weightInLbs;

@end


@implementation WeightEntry

@dynamic date;
@dynamic weightInLbs;

+ (void)initialize {
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimum:[NSNumber numberWithFloat:0.0f]];
    [formatter setMaximumFractionDigits:2];
    
}

#pragma mark - Conversion Methods

+ (CGFloat)convertLbsToKg:(CGFloat)lbs {
    
    return lbs / LBS_PER_KG;
}

+ (CGFloat)convertKgToLbs:(CGFloat)kg {
    
    return kg * LBS_PER_KG;
}

#pragma mark - String Methods

+ (NSString*)stringForUnit:(WeightUnit)unit {
    
    switch (unit) {
            
        case LBS:
            return @"lbs";
            
        case KG:
            return @"kg";
            
        default:
            [NSException raise:NSInvalidArgumentException 
                        format:@"The value %d is not a valid WeightUnit", unit];
    }
    
    // This will never be executed.
    return @"";
}

+ (NSString*)stringForWeight:(CGFloat)weight ofUnit:(WeightUnit)unit {
    
    NSString* weightString = 
    [formatter stringFromNumber:[NSNumber numberWithFloat:weight]];
    
    NSString* unitString = [WeightEntry stringForUnit:unit];
    
    return [NSString stringWithFormat:@"%@ %@", 
            weightString, 
            unitString];
}

+ (NSString*)stringForWeightInLbs:(CGFloat)weight inUnit:(WeightUnit)unit {
    
    CGFloat convertedWeight;
    switch (unit) {
            
        case LBS:
            convertedWeight = weight;
            break;
        case KG:
            convertedWeight = [WeightEntry convertLbsToKg:weight];
            break;
        default:
            [NSException raise:NSInvalidArgumentException 
                        format:@"%d is not a valid WeightUnit", unit];
    }
    
    
    return [WeightEntry stringForWeight:convertedWeight ofUnit:unit];
}

#pragma mark - Public Methods

- (CGFloat)weightInUnit:(WeightUnit)unit {
    
    switch (unit) {
            
        case LBS:
            return self.weightInLbs;
            
        case KG:
            return [WeightEntry convertLbsToKg:self.weightInLbs];
            
        default:
            [NSException raise:NSInvalidArgumentException 
                        format:@"The value %d is not a valid WeightUnit", unit];
    }
    
    // This will never be executed.
    return 0.0f;
}

- (NSString*)stringForWeightInUnit:(WeightUnit)unit {
    
    return [WeightEntry stringForWeight:[self weightInUnit:unit] 
                                    ofUnit:unit];
}


#pragma mark - Conveniance Methods

+ (NSString*)entityName {
    return @"WeightEntry";
}

+ (WeightEntry*)addEntryToDocument:(UIManagedDocument*)document
                  usingWeightInLbs:(CGFloat)weight
                              date:(NSDate*)date 
{

    NSManagedObjectContext* context = document.managedObjectContext;
    
    NSAssert(context != nil, 
             @"The managed object context is nil");
    
    NSEntityDescription* entity = 
    [NSEntityDescription entityForName:[WeightEntry entityName]
                inManagedObjectContext:context];
    
    NSAssert1(entity != nil, 
              @"The entity description for WeightEntry in %@ is nil", 
              context);
    
    
    WeightEntry* entry = 
    [[WeightEntry alloc] initWithEntity:entity
         insertIntoManagedObjectContext:context];
    
    entry.weightInLbs = weight;    
    entry.date = date;
    
    // Save a snapshot to the parent context
    NSError *error = nil;
    if (![context save:&error]) {
        
        // ideally we should replace this with more robust error handling.
        // However, we're not saving to disk, we're just pushing the change
        // up to the parent context--so most errors should be
        // caused by mistakes in our code.
        [NSException 
         raise:NSInternalInconsistencyException
         format:@"An error occurred when saving the context: %@",
         [error localizedDescription]];
    }
    
    return entry;
}



@end
