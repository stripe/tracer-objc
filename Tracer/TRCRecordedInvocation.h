//
//  TRCRecordedInvocation.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCJsonEncodable.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCRecordedInvocation : NSObject <TRCJsonEncodable>

@property (atomic, readonly) NSString *selector;
@property (atomic, readonly) NSArray *arguments;
@property (atomic, readonly) NSUInteger millis;

- (instancetype)initWithSelector:(SEL)selector
                       arguments:(NSArray *)arguments
                          millis:(NSUInteger)millis;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
