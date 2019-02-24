//
//  TRCRecorder.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCRecorder.h"

#import <objc/runtime.h>

#import "TRCAspects.h"
#import "TRCRecordedInvocation.h"
#import "TRCTrace+Private.h"
#import "NSDate+Tracer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCRecorder ()

@property (atomic, strong, readwrite) dispatch_queue_t tracesQueue;
@property (atomic, strong, readonly) NSMutableDictionary<NSString*,TRCTrace*>*keyToTrace;

@end

@implementation TRCRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        _tracesQueue = dispatch_queue_create("com.tracer.tracerecorder.traces", DISPATCH_QUEUE_SERIAL);
        _keyToTrace = [NSMutableDictionary new];
    }
    return self;
}

- (NSString *)buildKeyWithSource:(id)instance protocol:(Protocol *)protocol {
    return [@[
             NSStringFromClass([instance class]),
             NSStringFromProtocol(protocol),
             ] componentsJoinedByString:@"."];
}

- (void)startRecording:(id)source protocol:(Protocol *)protocol {
    NSDate *start = [NSDate date];

    NSString *key = [self buildKeyWithSource:source protocol:protocol];

    // list methods
    BOOL showRequiredMethods = YES;
    BOOL showInstanceMethods = YES;
    unsigned int methodCount = 0;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, showRequiredMethods, showInstanceMethods, &methodCount);

    // get selectors
    NSMutableArray *methodSelectors = [NSMutableArray new];
    for (unsigned int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methodList[i];
        NSValue *sel = [NSValue valueWithPointer:methodDescription.name];
        [methodSelectors addObject:sel];
    }

    // hook selectors to record calls
    for (NSValue *value in methodSelectors) {
        SEL sel = (SEL)value.pointerValue;
        Class klass = [source class];
        [klass trc_aspect_hookSelector:sel withOptions:TRCAspectPositionAfter usingBlock:^(id<TRCAspectInfo> info){
            NSUInteger ms = [[NSDate date] trc_millisSinceDate:start];
            TRCRecordedInvocation *call = [[TRCRecordedInvocation alloc] initWithSelector:sel
                                                                                arguments:info.arguments
                                                                                   millis:ms];
            dispatch_async(self.tracesQueue, ^{
                TRCTrace *trace = self.keyToTrace[key];
                if (trace == nil) {
                    trace = [[TRCTrace alloc] initWithProtocol:protocol];
                }
                [trace addInvocation:call];
                self.keyToTrace[key] = trace;
            });
        } error:nil];
    }

    free(methodList);
}

- (void)stopRecording:(id)source
             protocol:(Protocol *)protocol
           completion:(TRCTraceCompletionBlock)completion {
    NSString *key = [self buildKeyWithSource:source protocol:protocol];
    dispatch_async(self.tracesQueue, ^{
        TRCTrace *trace = self.keyToTrace[key];
        if (trace != nil) {
            completion(trace, nil);
        }
        else {
            // TODO actual error
            NSError *error = [NSError errorWithDomain:@"tracer" code:0 userInfo:nil];
            completion(nil, error);
        }
        [self.keyToTrace removeObjectForKey:key];
    });
}

@end

NS_ASSUME_NONNULL_END
