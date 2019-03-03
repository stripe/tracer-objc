//
//  TRCArgument.m
//  Tracer
//
//  Created by Ben Guo on 2/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCArgument.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCArgument ()

/// consider using deeper type
/// https://github.com/cyanzhong/RuntimeInvoker/blob/master/RuntimeInvoker/RuntimeInvoker.m
@property (atomic, assign, readwrite) TRCArgumentType type;
@property (atomic, strong, nullable, readwrite) NSString *objectClass;
@property (atomic, strong, nullable, readwrite) id objectValue;

@end

@implementation TRCArgument

- (instancetype)initWithTypeEncoding:(NSString *)encoding
                       boxedArgument:(id)boxedArgument {
    self = [super init];
    if (self) {
        // https://nshipster.com/type-encodings/
        BOOL isObject = [encoding isEqualToString:@"@"];
        if (isObject) {
            NSString *classString = NSStringFromClass([boxedArgument class]);
            // TODO: regex
            if ([classString containsString:@"NSCFConstantString"] ||
                [classString containsString:@"NSCFString"]) {
                classString = @"NSString";
                _type = TRCArgumentTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([classString containsString:@"NSCFNumber"]) {
                classString = @"NSNumber";
                _type = TRCArgumentTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([classString containsString:@"NSCFBoolean"]) {
                classString = @"NSNumber";
                _type = TRCArgumentTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([classString containsString:@"NSSingleEntryDictionary"] ||
                     [classString containsString:@"NSDictionary"]) {
                classString = @"NSDictionary";
                _type = TRCArgumentTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([NSJSONSerialization isValidJSONObject:boxedArgument]) {
                _type = TRCArgumentTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else {
                _type = TRCArgumentTypeUnknownObject;
            }
            _objectClass = classString;
        }
        else {
            _type = TRCArgumentTypePrimitive;
            _objectValue = boxedArgument;
        }
    }
    return self;
}

+ (NSString *)stringFromType:(TRCArgumentType)type {
    switch (type) {
        case TRCArgumentTypePrimitive:
            return @"primitive";
        case TRCArgumentTypeUnknownObject:
            return @"unknown_object";
        case TRCArgumentTypeJsonObject:
            return @"json_object";
    }
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"type"] = [[self class] stringFromType:self.type];
    json[@"object_class"] = self.objectClass;
    json[@"object_value"] = self.objectValue;
    return [json copy];
}

@end

NS_ASSUME_NONNULL_END
