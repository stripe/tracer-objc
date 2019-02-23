//
//  TRCTracePlayer.m
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTracePlayer.h"
#import "TRCTestSubject.h"

#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRCTracePlayer ()

@property (nonatomic, strong, nullable, readwrite) id mock;
@property (nonatomic, strong, nullable, readwrite) NSDictionary *trace;

@end

@implementation TRCTracePlayer

- (id)loadTrace:(NSDictionary *)trace {
    self.trace = trace;

    NSString *className = trace[@"class"];
    Class mockClass = objc_allocateClassPair(NSClassFromString(className), "TraceClassMock", 0);
    objc_registerClassPair(mockClass);
    self.mock = [[mockClass alloc] init];
    return self.mock;
}

- (void)play {
    NSArray *calls = self.trace[@"calls"];
    for (NSDictionary *call in calls) {
        //            NSInteger delay = [[durationArr objectAtIndex:count] doubleValue];
        //        SEL aSelector = @selector(imageAnimationWithImage:andDurationArray:);
        //        NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
        //        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        //        [invocation setTarget:self];
        //        [invocation setSelector:aSelector];
        //            [invocation setArgument:&imgarray atIndex:2];
        //            [invocation setArgument:&durationArr atIndex:3];
        //        [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
    }
}

@end

NS_ASSUME_NONNULL_END
