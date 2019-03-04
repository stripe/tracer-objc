//
//  TRCMethodCall.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCCall.h"

#import "TRCAspects.h"
#import "TRCArgument.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCCall ()

@property (atomic, strong, readwrite) NSString *method;
@property (atomic, strong, readwrite) NSArray<TRCArgument*>*arguments;
@property (atomic, assign, readwrite) NSUInteger millis;

@end

@implementation TRCCall

- (instancetype)initWithSelector:(SEL)selector
                       arguments:(NSArray<TRCArgument*>*)arguments
                          millis:(NSUInteger)millis {
    self = [super init];
    if (self) {
        _method = NSStringFromSelector(selector);
        _arguments = arguments;
        _millis = millis;
    }
    return self;
}

- (NSString *)internalId {
    return [NSString stringWithFormat:@"%@_%lu", self.method, self.millis];
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"method"] = self.method;
    NSMutableArray *args = [NSMutableArray new];
    for (TRCArgument *arg in self.arguments) {
        [args addObject:[arg jsonObject]];
    }
    json[@"arguments"] = [args copy];
    json[@"millis"] = @(self.millis);
    return [json copy];
}

@end

NS_ASSUME_NONNULL_END
