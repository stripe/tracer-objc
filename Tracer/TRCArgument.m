//
//  TRCArgument.m
//  Tracer
//
//  Created by Ben Guo on 2/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCArgument.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRCArgument ()

@property (atomic, assign, readwrite) TRCArgumentType type;
@property (atomic, assign, readwrite) TRCObjectType objectType;
@property (atomic, strong, nullable, readwrite) NSString *objectClass;
@property (atomic, strong, nullable, readwrite) id objectValue;

@end

@implementation TRCArgument

static NSDictionary<NSNumber *, NSString *> *_argumentTypeToString;

- (instancetype)initWithTypeEncoding:(NSString *)encoding
                       boxedArgument:(id)boxedArgument {
    self = [super init];
    if (self) {
        TRCArgumentType type = [[self class] argumentTypeWithEncoding:encoding];
        _type = type;
        BOOL isObject = (type == TRCArgumentTypeObject);
        if (isObject) {
            NSString *classString = NSStringFromClass([boxedArgument class]);
            // string comparison here is brittle, but seems to work
            // TODO: test array
            if ([classString containsString:@"NSCFConstantString"] ||
                [classString containsString:@"NSCFString"]) {
                classString = @"NSString";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([classString containsString:@"NSCFNumber"]) {
                classString = @"NSNumber";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([classString containsString:@"NSCFBoolean"]) {
                classString = @"NSNumber";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([classString containsString:@"NSSingleEntryDictionary"] ||
                     [classString containsString:@"NSDictionary"]) {
                classString = @"NSDictionary";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else if ([NSJSONSerialization isValidJSONObject:boxedArgument]) {
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            else {
                _objectType = TRCObjectTypeUnknownObject;
            }
            _objectClass = classString;
        }
        else {
            _objectType = TRCObjectTypeNotAnObject;
            _objectValue = boxedArgument;
        }
    }
    return self;
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"type"] = [[self class] stringFromArgumentType:self.type];
    json[@"object_type"] = [[self class] stringFromObjectType:self.objectType];
    json[@"object_class"] = self.objectClass;
    json[@"object_value"] = self.objectValue;
    return [json copy];
}

+ (NSString *)stringFromObjectType:(TRCObjectType)type {
    switch (type) {
        case TRCObjectTypeNotAnObject:
            return @"not_an_object";
        case TRCObjectTypeUnknownObject:
            return @"unknown_object";
        case TRCObjectTypeJsonObject:
            return @"json_object";
    }
}

/**
 https://nshipster.com/type-encodings/
 */
+ (TRCArgumentType)argumentTypeWithEncoding:(NSString *)encodingString {
    const char *typeEncoding = [encodingString UTF8String];
    if (strcmp(typeEncoding, @encode(char)) == 0) {
        return TRCArgumentTypeChar;
    } else if (strcmp(typeEncoding, @encode(int)) == 0) {
        return TRCArgumentTypeInt;
    } else if (strcmp(typeEncoding, @encode(short)) == 0) {
        return TRCArgumentTypeShort;
    } else if (strcmp(typeEncoding, @encode(long)) == 0) {
        return TRCArgumentTypeLong;
    } else if (strcmp(typeEncoding, @encode(long long)) == 0) {
        return TRCArgumentTypeLongLong;
    } else if (strcmp(typeEncoding, @encode(unsigned char)) == 0) {
        return TRCArgumentTypeUnsignedChar;
    } else if (strcmp(typeEncoding, @encode(unsigned int)) == 0) {
        return TRCArgumentTypeUnsignedInt;
    } else if (strcmp(typeEncoding, @encode(unsigned short)) == 0) {
        return TRCArgumentTypeUnsignedShort;
    } else if (strcmp(typeEncoding, @encode(unsigned long)) == 0) {
        return TRCArgumentTypeUnsignedLong;
    } else if (strcmp(typeEncoding, @encode(unsigned long long)) == 0) {
        return TRCArgumentTypeUnsignedLongLong;
    } else if (strcmp(typeEncoding, @encode(float)) == 0) {
        return TRCArgumentTypeFloat;
    } else if (strcmp(typeEncoding, @encode(double)) == 0) {
        return TRCArgumentTypeDouble;
    } else if (strcmp(typeEncoding, @encode(BOOL)) == 0) {
        return TRCArgumentTypeBool;
    } else if (strcmp(typeEncoding, @encode(void)) == 0) {
        return TRCArgumentTypeVoid;
    } else if (strcmp(typeEncoding, @encode(char *)) == 0) {
        return TRCArgumentTypeCharacterString;
    } else if (strcmp(typeEncoding, @encode(id)) == 0) {
        return TRCArgumentTypeObject;
    } else if (strcmp(typeEncoding, @encode(Class)) == 0) {
        return TRCArgumentTypeClass;
    } else if (strcmp(typeEncoding, @encode(CGPoint)) == 0) {
        return TRCArgumentTypeCGPoint;
    } else if (strcmp(typeEncoding, @encode(CGSize)) == 0) {
        return TRCArgumentTypeCGSize;
    } else if (strcmp(typeEncoding, @encode(CGRect)) == 0) {
        return TRCArgumentTypeCGRect;
    } else if (strcmp(typeEncoding, @encode(UIEdgeInsets)) == 0) {
        return TRCArgumentTypeUIEdgeInsets;
    } else if (strcmp(typeEncoding, @encode(SEL)) == 0) {
        return TRCArgumentTypeSEL;
    }  else if (strcmp(typeEncoding, @encode(IMP))) {
        return TRCArgumentTypeIMP;
    } else {
        return TRCArgumentTypeUnknown;
    }
}

+ (NSDictionary<NSNumber *, NSString *>*)argumentTypeToString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _argumentTypeToString = @{
                             @(TRCArgumentTypeUnknown): @"unknown",
                             @(TRCArgumentTypeChar): @"char",
                             @(TRCArgumentTypeInt): @"int",
                             @(TRCArgumentTypeShort): @"short",
                             @(TRCArgumentTypeLong): @"long",
                             @(TRCArgumentTypeLongLong): @"long_long",
                             @(TRCArgumentTypeUnsignedChar): @"unsigned_char",
                             @(TRCArgumentTypeUnsignedInt): @"unsigned_int",
                             @(TRCArgumentTypeUnsignedShort): @"unsigned_short",
                             @(TRCArgumentTypeUnsignedLong): @"unsigned_long",
                             @(TRCArgumentTypeUnsignedLongLong): @"unsigned_long_long",
                             @(TRCArgumentTypeFloat): @"float",
                             @(TRCArgumentTypeDouble): @"double",
                             @(TRCArgumentTypeBool): @"bool",
                             @(TRCArgumentTypeVoid): @"void",
                             @(TRCArgumentTypeCharacterString): @"character_string",
                             @(TRCArgumentTypeCGPoint): @"cgpoint",
                             @(TRCArgumentTypeCGSize): @"cgsize",
                             @(TRCArgumentTypeCGRect): @"cgrect",
                             @(TRCArgumentTypeUIEdgeInsets): @"uiedgeInsets",
                             @(TRCArgumentTypeObject): @"object",
                             @(TRCArgumentTypeClass): @"class",
                             @(TRCArgumentTypeSEL): @"sel",
                             @(TRCArgumentTypeIMP): @"imp",
                             };
    });
    return _argumentTypeToString;
}

+ (nullable NSString *)stringFromArgumentType:(TRCArgumentType)type {
    NSDictionary<NSNumber *, NSString *>*mapping = [self argumentTypeToString];
    return mapping[@(type)];
}

+ (nullable NSNumber *)argumentTypeFromString:(NSString *)string {
    NSDictionary<NSNumber *, NSString *>*mapping = [self argumentTypeToString];
    return [[mapping allKeysForObject:string] firstObject];
}



@end

NS_ASSUME_NONNULL_END
