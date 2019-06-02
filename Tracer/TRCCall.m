//
//  TRCMethodCall.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCCall.h"

#import <UIKit/UIKit.h>

#import "TRCAspects.h"
#import "TRCValue+Private.h"
#import "NSDictionary+Tracer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCCall ()

@property (atomic, strong, readwrite) NSString *method;
@property (atomic, strong, readwrite) NSArray<TRCValue*>*arguments;
@property (atomic, strong, readwrite) TRCValue *returnValue;
@property (atomic, assign, readwrite) NSUInteger millis;

@end

@implementation TRCCall

- (instancetype)initWithSelector:(SEL)selector
                      invocation:(NSInvocation *)invocation
                       arguments:(NSArray<TRCValue*>*)arguments
                          millis:(NSUInteger)millis {
    self = [super init];
    if (self) {
        _method = NSStringFromSelector(selector);
        _arguments = arguments;
        _millis = millis;
        _returnValue = [TRCValue buildWithInvocationReturnValue:invocation];
    }
    return self;
}

- (NSString *)internalId {
    return [NSString stringWithFormat:@"%@_%lu", self.method, self.millis];
}

+ (nullable instancetype)decodedObjectFromJson:(nullable NSDictionary *)json {
    // precheck
    if (!json) {
        return nil;
    }
    NSDictionary *dict = [json trc_dictionaryByRemovingNulls];
    NSString *object = [dict trc_stringForKey:@"trace_object"];
    if (![object isEqualToString:@"call"]) {
        return nil;
    }

    // props
    NSString *method = [dict trc_stringForKey:@"method"];
    NSNumber *startMs = [dict trc_numberForKey:@"start_ms"];
    NSDictionary *rawReturnValue = [dict trc_dictionaryForKey:@"return_value"];
    NSArray *rawArguments = [dict trc_arrayForKey:@"arguments"];
    if (!method || !startMs || !rawReturnValue || !rawArguments) {
        return nil;
    }

    NSMutableArray *arguments = [NSMutableArray new];
    for (NSDictionary *rawValue in rawArguments) {
        TRCValue *value = [TRCValue decodedObjectFromJson:rawValue];
        if (value != nil) {
            [arguments addObject:value];
        }
    }
    TRCValue *returnValue = [TRCValue decodedObjectFromJson:rawReturnValue];

    // assemble
    TRCCall *decoded = [TRCCall new];
    decoded.method = method;
    // TODO: rename millis -> startMs
    decoded.millis = [startMs unsignedIntegerValue];
    decoded.arguments = [arguments copy];
    decoded.returnValue = returnValue;
    return decoded;
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"trace_object"] = @"call";
    json[@"method"] = self.method;
    NSMutableArray *args = [NSMutableArray new];
    for (TRCValue *arg in self.arguments) {
        [args addObject:[arg jsonObject]];
    }
    json[@"arguments"] = [args copy];
    json[@"start_ms"] = @(self.millis);
    json[@"return_value"] = [self.returnValue jsonObject];
    return [json copy];
}

- (NSString *)description {
    NSArray *props = @[
                       // Object
                       [NSString stringWithFormat:@"%@: %p", NSStringFromClass([self class]), self],

                       // Details (alphabetical)
                       [NSString stringWithFormat:@"jsonObject = %@", [self jsonObject]],
                       ];
    return [NSString stringWithFormat:@"<%@>", [props componentsJoinedByString:@"; "]];
}

@end

NS_ASSUME_NONNULL_END
