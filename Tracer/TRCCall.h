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

/**
 might be able to consolidate some of these arguments

 @param selector     selector reference, before hooking
 @param invocation   invocation, from TRCAspects
 @param arguments    arguments, built from method sig and invocation
 @param millis       timestamp for method call
 */
- (instancetype)initWithSelector:(SEL)selector
                      invocation:(NSInvocation *)invocation
                         arguments:(NSArray<TRCValue*>*)arguments
                            millis:(NSUInteger)millis;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
