//
//  TRCTraceRecorder.m
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTraceRecorder.h"
#import "TRCAspects.h"
#import "TRCMethodCall.h"
#import "TRCTraceRecording+Private.h"
#import "NSDate+TraceRecorder.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRCTraceRecorder ()

@property (atomic, strong, readwrite) dispatch_queue_t tracesQueue;
@property (atomic, strong, readonly) NSMutableDictionary<NSString*,TRCTraceRecording*>*keyToTrace;

@end

@implementation TRCTraceRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        _tracesQueue = dispatch_queue_create("com.tracer.tracerecorder.traces", DISPATCH_QUEUE_SERIAL);
        _keyToTrace = [NSMutableDictionary new];
    }
    return self;
}

- (void)startRecording:(id)instance {
    NSDate *start = [NSDate date];

    Class inClass = [instance class];
    NSString *key = NSStringFromClass(inClass);

    // list methods
    unsigned int inMethodCount = 0;
    Method *inMethodList = class_copyMethodList(inClass, &inMethodCount);

    // get selectors
    NSMutableArray *inMethodSelectors = [NSMutableArray new];
    for (unsigned int i = 0; i < inMethodCount; i++) {
        Method method = inMethodList[i];
        NSValue *sel = [NSValue valueWithPointer:sel_getName(method_getName(method))];
        [inMethodSelectors addObject:sel];

    }

    // hook selectors to record calls
    for (NSValue *value in inMethodSelectors) {
        SEL sel = (SEL)value.pointerValue;
        [inClass trc_aspect_hookSelector:sel withOptions:TRCAspectPositionAfter usingBlock:^(id<TRCAspectInfo> info){
            NSUInteger ms = [[NSDate date] trc_millisSinceDate:start];
            TRCMethodCall *call = [[TRCMethodCall alloc] initWithClass:inClass
                                                              selector:sel
                                                                  info:info
                                                                millis:ms];
            dispatch_async(self.tracesQueue, ^{
                TRCTraceRecording *trace = self.keyToTrace[key];
                if (trace == nil) {
                    trace = [TRCTraceRecording new];
                }
                [trace addMethodCall:call];
                self.keyToTrace[key] = trace;
            });
        } error:nil];
    }

    free(inMethodList);
}

- (void)stopRecording:(id)instance completion:(TRCTraceCompletionBlock)completion {
    Class inClass = [instance class];
    NSString *key = NSStringFromClass(inClass);
    dispatch_async(self.tracesQueue, ^{
        TRCTraceRecording *trace = self.keyToTrace[key];
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
