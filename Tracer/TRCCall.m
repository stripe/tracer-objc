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
        _returnValue = [[self class] buildReturnValue:invocation];
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

+ (TRCValue *)buildReturnValue:(NSInvocation *)inv {
    NSMethodSignature *sig = inv.methodSignature;
    NSString *encodingString = [NSString stringWithUTF8String:sig.methodReturnType];
    TRCType returnType = [TRCValue typeWithEncoding:encodingString];

    __unsafe_unretained id returnValue;
    switch (returnType) {
        case TRCTypeChar: {
            char value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeInt:  {
            int value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeShort:  {
            short value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeLong:  {
            long value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeLongLong:  {
            long long value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeUnsignedChar:  {
            unsigned char value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeUnsignedInt:  {
            unsigned int value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeUnsignedShort:  {
            unsigned short value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeUnsignedLong:  {
            unsigned long value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeUnsignedLongLong:  {
            unsigned long long value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeFloat:  {
            float value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeDouble:  {
            double value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeBool: {
            BOOL value;
            [inv getReturnValue:&value];
            returnValue = @(value);
        } break;
        case TRCTypeCharacterString: {
            const char *value;
            [inv getReturnValue:&value];
            returnValue = [NSString stringWithUTF8String:value];
        } break;
        case TRCTypeCGPoint: {
            CGPoint value;
            [inv getReturnValue:&value];
            returnValue = [NSValue valueWithCGPoint:value];
        } break;
        case TRCTypeCGSize: {
            CGSize value;
            [inv getReturnValue:&value];
            returnValue = [NSValue valueWithCGSize:value];
        } break;
        case TRCTypeCGRect: {
            CGRect value;
            [inv getReturnValue:&value];
            returnValue = [NSValue valueWithCGRect:value];
        } break;
        case TRCTypeUIEdgeInsets: {
            UIEdgeInsets value;
            [inv getReturnValue:&value];
            returnValue = [NSValue valueWithUIEdgeInsets:value];
        } break;
        case TRCTypeSEL: {
            SEL sel;
            [inv getReturnValue:&sel];
            returnValue = [NSValue valueWithPointer:sel];
        } break;
        case TRCTypeIMP: {
            IMP imp;
            [inv getReturnValue:&imp];
            returnValue = [NSValue valueWithPointer:imp];
        } break;
        case TRCTypeObject:
        case TRCTypeClass:
            [inv getReturnValue:&returnValue];
            break;
        default: break;
    }
    TRCValue *value = [[TRCValue alloc] initWithTypeEncoding:encodingString
                                               boxedArgument:returnValue ?: @(0)];
    return value;
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
