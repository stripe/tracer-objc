//
//  TRCCall+Private.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTrace.h"
#import "TRCCall.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCCall (Private)

/**
 Internal id used to reference the call
 */
- (NSString *)internalId;

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

@end

NS_ASSUME_NONNULL_END
