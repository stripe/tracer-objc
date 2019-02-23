//
//  TRCTraceRecording.m
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTraceRecording+Private.h"
#import "TRCMethodCall.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCTraceRecording ()

@property (atomic, strong, readwrite) NSMutableArray<TRCMethodCall*>*methodCalls;

@end

@implementation TRCTraceRecording

- (instancetype)init {
    self = [super init];
    if (self) {
        _methodCalls = [NSMutableArray new];
    }
    return self;
}

- (void)addMethodCall:(TRCMethodCall *)methodCall {
    [self.methodCalls addObject:methodCall];
}

- (NSObject *)jsonObject {
    NSMutableArray *json = [NSMutableArray new];
    for (TRCMethodCall *call in self.methodCalls) {
        [json addObject:[call jsonObject]];
    }
    return [json copy];
}

@end

NS_ASSUME_NONNULL_END
