//
//  TRCPlayer.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <objc/runtime.h>

#import "TRCPlayer.h"
#import "TRCTrace.h"
#import "TRCRecordedInvocation.h"
#import "TRCDispatchFunctions.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCPlayer ()

@end

@implementation TRCPlayer

// example: creating a mock subclass
//    NSString *className = trace[@"class"];
//    Class mockClass = objc_allocateClassPair(NSClassFromString(className), "TraceClassMock", 0);
//    objc_registerClassPair(mockClass);
//    self.mock = [[mockClass alloc] init];

+ (void)playTrace:(TRCTrace *)trace
         onTarget:(id)target
       completion:(TRCErrorCompletionBlock)completion {

    // TODO: validate target against trace

    NSTimeInterval longestDelay = 0;
    for (TRCRecordedInvocation *recInv in trace.invocations) {

        SEL aSelector = NSSelectorFromString(recInv.selector);
        NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:target];
        [invocation setSelector:aSelector];
        for (NSUInteger i = 0; i < [recInv.arguments count]; i++) {
            id arg = recInv.arguments[i];
            // indices 0 and 1 indicate the hidden arguments self and _cmd
            NSUInteger index = i + 2;
            // NSNumber is an NSValue subclass
            if ([arg isKindOfClass:[NSValue class]] &&
                !([arg isKindOfClass:[NSNumber class]])) {
                NSValue *value = (NSValue *)arg;
                // Note: all primitive types are played back as type double
                double primitive;
                [value getValue:&primitive];
                [invocation setArgument:&primitive atIndex:index];
            }
            else {
                [invocation setArgument:&arg atIndex:index];
            }
        }

        NSTimeInterval delay = ((double)recInv.millis)/1000.0;
        longestDelay = MAX(longestDelay, delay);

        trcDispatchToMainAfter(delay, ^{
            [invocation invoke];
        });
    }
    trcDispatchToMainAfter(longestDelay + 1, ^{
        completion(nil);
    });

}

@end

NS_ASSUME_NONNULL_END
