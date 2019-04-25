//
//  NSArray+Tracer.m
//  Tracer
//
//  Created by Ben Guo on 7/27/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import "NSArray+Tracer.h"
#import "NSDictionary+Tracer.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSArray (Tracer)

- (nullable NSArray *)trc_safeSubarrayWithRange:(NSRange)range {
    if (range.location + range.length > self.count ||
        range.location > self.count) {
        return nil;
    }
    return [self subarrayWithRange:range];
}

- (nullable id)trc_safeObjectAtIndex:(NSInteger)index {
    if (index + 1 > (NSInteger)self.count || index < 0) {
        return nil;
    }
    return self[index];
}

- (NSArray *)trc_arrayByRemovingNulls {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            // Save array after removing any null values
            [result addObject:[(NSArray *)obj trc_arrayByRemovingNulls]];
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            // Save dictionary after removing any null values
            [result addObject:[(NSDictionary *)obj trc_dictionaryByRemovingNulls]];
        }
        else if ([obj isKindOfClass:[NSNull class]]) {
            // Skip null value
        }
        else {
            // Save other value
            [result addObject:obj];
        }
    }

    // Make immutable copy
    return [result copy];
}

@end

NS_ASSUME_NONNULL_END
