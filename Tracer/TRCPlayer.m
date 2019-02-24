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
            [invocation setArgument:&arg atIndex:(i+2)];
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
