//
//  NSArray+Tracer.h
//  Tracer
//
//  Created by Ben Guo on 7/27/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Tracer)

- (nullable NSArray *)trc_safeSubarrayWithRange:(NSRange)range;

- (nullable id)trc_safeObjectAtIndex:(NSInteger)index;

- (NSArray *)trc_arrayByRemovingNulls;

@end

NS_ASSUME_NONNULL_END
