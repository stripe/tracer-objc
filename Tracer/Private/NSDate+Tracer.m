//
//  NSDate+Tracer.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "NSDate+Tracer.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSDate (Tracer)

- (NSUInteger)trc_millisSinceDate:(NSDate *)date {
    return (NSUInteger)ABS(ceil([self timeIntervalSinceDate:date]*1000));
}

- (NSUInteger)trc_millisSince1970 {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    return [self trc_millisSinceDate:date];
}

@end

NS_ASSUME_NONNULL_END

