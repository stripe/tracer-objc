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

@class TRCValue;

/**
 A trace call.
 */
NS_SWIFT_NAME(TraceCall)
@interface TRCCall : NSObject <TRCJsonEncodable>

/**
 The method, as a string.
 */
@property (atomic, readonly) NSString *method;

/**
 The arguments of the method.
 */
@property (atomic, readonly) NSArray<TRCValue*>*arguments;

/**
 The epoch time.
 */
@property (atomic, readonly) NSUInteger millis;

/**
 The return value.
 */
@property (atomic, readonly) TRCValue *returnValue;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
