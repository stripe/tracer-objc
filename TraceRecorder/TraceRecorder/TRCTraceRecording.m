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

@property (atomic, strong, readonly) NSString *klass;
@property (atomic, strong, readwrite) NSMutableArray<TRCMethodCall*>*methodCalls;

@end

@implementation TRCTraceRecording

- (instancetype)initWithClass:(Class)kls {
    self = [super init];
    if (self) {
        _klass = NSStringFromClass(kls);
        _methodCalls = [NSMutableArray new];
    }
    return self;
}

- (void)addMethodCall:(TRCMethodCall *)methodCall {
    [self.methodCalls addObject:methodCall];
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"class"] = self.klass;
    NSMutableArray *calls = [NSMutableArray new];
    for (TRCMethodCall *call in self.methodCalls) {
        [calls addObject:[call jsonObject]];
    }
    json[@"calls"] = [calls copy];
    return [json copy];
}

@end

NS_ASSUME_NONNULL_END
