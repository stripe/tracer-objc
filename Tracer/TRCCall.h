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

@interface TRCCall : NSObject <TRCJsonEncodable>

@property (atomic, readonly) NSString *method;
@property (atomic, readonly) NSArray<TRCValue*>*arguments;
@property (atomic, readonly) NSUInteger millis;
@property (atomic, readonly) TRCValue *returnValue;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
