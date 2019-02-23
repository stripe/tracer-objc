//
//  TRCMethodCall.m
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCMethodCall.h"

#import "TRCAspects.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCMethodCall ()

@property (atomic, strong, readonly) NSString *selector;
@property (atomic, strong, readonly) NSString *klass;
@property (atomic, strong, readonly) NSArray *arguments;
@property (atomic, assign, readwrite) NSUInteger millis;

@end

@implementation TRCMethodCall

- (instancetype)initWithClass:(Class)kls
                     selector:(SEL)sel
                         info:(id<TRCAspectInfo>)info
                       millis:(NSUInteger)millis {
    self = [super init];
    if (self) {
        _klass = NSStringFromClass(kls);
        _selector = NSStringFromSelector(sel);
        _arguments = info.arguments;
        _millis = millis;
    }
    return self;
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"class"] = self.klass;
    json[@"selector"] = self.selector;
    json[@"arguments"] = self.arguments;
    json[@"millis"] = @(self.millis);
    return [json copy];
}

@end

NS_ASSUME_NONNULL_END
