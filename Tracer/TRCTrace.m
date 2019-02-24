//
//  TRCTraceRecording.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTrace+Private.h"
#import "TRCRecordedInvocation.h"
#import "NSDate+Tracer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCTrace ()

@property (atomic, strong, readwrite) NSDate *start;
@property (atomic, strong, readwrite) NSString *protocol;
@property (atomic, strong, readwrite) NSMutableArray<TRCRecordedInvocation*>*invocations;

@end

@implementation TRCTrace

+ (nullable instancetype)loadFromJSONFile:(NSString *)filename {
    NSData *data = [self dataFromJSONFile:filename];
    if (data != nil) {
        return [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:nil];
    }
    return nil;
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _protocol = NSStringFromProtocol(protocol);
        _invocations = [NSMutableArray new];
    }
    return self;
}

- (void)addInvocation:(TRCRecordedInvocation *)invocation {
    [self.invocations addObject:invocation];
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"protocol"] = self.protocol;
    json[@"start_millis"] = @([self.start trc_millisSince1970]);
    NSMutableArray *calls = [NSMutableArray new];
    for (TRCRecordedInvocation *call in self.invocations) {
        [calls addObject:[call jsonObject]];
    }
    json[@"invocation"] = [calls copy];
    return [json copy];
}

+ (NSData *)dataFromJSONFile:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:name ofType:@"json"];
    if (!path) {
        return nil;
    }

    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!jsonString) {
        return nil;
    }
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

@end

NS_ASSUME_NONNULL_END
