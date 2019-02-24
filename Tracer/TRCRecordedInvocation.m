//
//  TRCMethodCall.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCRecordedInvocation.h"

#import "TRCAspects.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCRecordedInvocation ()

@property (atomic, strong, readwrite) NSString *selector;
@property (atomic, strong, readwrite) NSArray *arguments;
@property (atomic, assign, readwrite) NSUInteger millis;

@end

@implementation TRCRecordedInvocation

- (instancetype)initWithSelector:(SEL)selector
                       arguments:(NSArray *)arguments
                          millis:(NSUInteger)millis {
    self = [super init];
    if (self) {
        _selector = NSStringFromSelector(selector);
        _arguments = arguments;
        _millis = millis;
    }
    return self;
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"selector"] = self.selector;
    json[@"arguments"] = self.arguments;
    json[@"millis"] = @(self.millis);
    return [json copy];
}

@end

NS_ASSUME_NONNULL_END
