//
//  NSDate+Tracer.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Tracer)

// unsigned milliseconds since the given date
- (NSUInteger)trc_millisSinceDate:(NSDate *)date;

// epoch time in milliseconds
- (NSUInteger)trc_millisSince1970;

@end

NS_ASSUME_NONNULL_END
