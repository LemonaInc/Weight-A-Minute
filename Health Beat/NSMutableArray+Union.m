//
//  NSMutableArray+Union.m
//  Health Beat
//
//  Created by Rich Warren on 10/20/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "NSMutableArray+Union.h"

@implementation NSMutableArray (Union)

- (void)unionWith:(NSArray*)array {
    
    NSMutableArray* toAdd = 
    [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (id entry in array) {
        if (![self containsObject:entry]) {
            
            [toAdd addObject:entry];
        }
    }
    
    for (id entry in toAdd) {
        
        [self addObject:entry];
    }
}

@end
