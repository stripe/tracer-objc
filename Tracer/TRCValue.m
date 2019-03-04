//
//  TRCValue.m
//  Tracer
//
//  Created by Ben Guo on 2/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCValue.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRCValue ()

@property (atomic, assign, readwrite) TRCType type;
@property (atomic, assign, readwrite) TRCObjectType objectType;
@property (atomic, strong, nullable, readwrite) NSString *objectClass;
@property (atomic, strong, nullable, readwrite) id objectValue;

@end

@implementation TRCValue

static NSDictionary<NSNumber *, NSString *> *_typeToString;

- (instancetype)initWithTypeEncoding:(NSString *)encoding
                       boxedArgument:(id)boxedArgument {
    self = [super init];
    if (self) {
        TRCType type = [[self class] typeWithEncoding:encoding];
        _type = type;
        BOOL isObject = (type == TRCTypeObject);
        if (isObject) {
            NSString *classString = NSStringFromClass([boxedArgument class]);
            // clean up internal types for json objects
            // NSString
            if ([classString containsString:@"NSCFConstantString"] ||
                [classString containsString:@"NSCFString"]) {
                classString = @"NSString";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            // NSNumber
            else if ([classString containsString:@"NSCFNumber"]) {
                classString = @"NSNumber";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            // Boxed Bool
            else if ([classString containsString:@"NSCFBoolean"]) {
                classString = @"NSNumber";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            // NSDictionary
            else if ([classString containsString:@"NSSingleEntryDictionary"] ||
                     [classString containsString:@"NSDictionary"]) {
                classString = @"NSDictionary";
                _objectType = TRCObjectTypeJsonObject;
                _objectValue = boxedArgument;
            }
            // NSArray
            else if ([classString containsString:@"NSSingleObjectArray"] ||
                     [classString containsString:@"NSArray"]) {
                classString = @"NSArray";
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
    json[@"id"] = @"value";
    json[@"type"] = [[self class] stringFromType:self.type];
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
+ (TRCType)typeWithEncoding:(NSString *)encodingString {
    const char *typeEncoding = [encodingString UTF8String];
    if (strcmp(typeEncoding, @encode(char)) == 0) {
        return TRCTypeChar;
    } else if (strcmp(typeEncoding, @encode(int)) == 0) {
        return TRCTypeInt;
    } else if (strcmp(typeEncoding, @encode(short)) == 0) {
        return TRCTypeShort;
    } else if (strcmp(typeEncoding, @encode(long)) == 0) {
        return TRCTypeLong;
    } else if (strcmp(typeEncoding, @encode(long long)) == 0) {
        return TRCTypeLongLong;
    } else if (strcmp(typeEncoding, @encode(unsigned char)) == 0) {
        return TRCTypeUnsignedChar;
    } else if (strcmp(typeEncoding, @encode(unsigned int)) == 0) {
        return TRCTypeUnsignedInt;
    } else if (strcmp(typeEncoding, @encode(unsigned short)) == 0) {
        return TRCTypeUnsignedShort;
    } else if (strcmp(typeEncoding, @encode(unsigned long)) == 0) {
        return TRCTypeUnsignedLong;
    } else if (strcmp(typeEncoding, @encode(unsigned long long)) == 0) {
        return TRCTypeUnsignedLongLong;
    } else if (strcmp(typeEncoding, @encode(float)) == 0) {
        return TRCTypeFloat;
    } else if (strcmp(typeEncoding, @encode(double)) == 0) {
        return TRCTypeDouble;
    } else if (strcmp(typeEncoding, @encode(BOOL)) == 0) {
        return TRCTypeBool;
    } else if (strcmp(typeEncoding, @encode(void)) == 0) {
        return TRCTypeVoid;
    } else if (strcmp(typeEncoding, @encode(char *)) == 0) {
        return TRCTypeCharacterString;
    } else if (strcmp(typeEncoding, @encode(id)) == 0) {
        return TRCTypeObject;
    } else if (strcmp(typeEncoding, @encode(Class)) == 0) {
        return TRCTypeClass;
    } else if (strcmp(typeEncoding, @encode(CGPoint)) == 0) {
        return TRCTypeCGPoint;
    } else if (strcmp(typeEncoding, @encode(CGSize)) == 0) {
        return TRCTypeCGSize;
    } else if (strcmp(typeEncoding, @encode(CGRect)) == 0) {
        return TRCTypeCGRect;
    } else if (strcmp(typeEncoding, @encode(UIEdgeInsets)) == 0) {
        return TRCTypeUIEdgeInsets;
    } else if (strcmp(typeEncoding, @encode(SEL)) == 0) {
        return TRCTypeSEL;
    }  else if (strcmp(typeEncoding, @encode(IMP))) {
        return TRCTypeIMP;
    } else {
        return TRCTypeUnknown;
    }
}

+ (NSDictionary<NSNumber *, NSString *>*)typeToString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _typeToString = @{
                             @(TRCTypeUnknown): @"unknown",
                             @(TRCTypeChar): @"char",
                             @(TRCTypeInt): @"int",
                             @(TRCTypeShort): @"short",
                             @(TRCTypeLong): @"long",
                             @(TRCTypeLongLong): @"long_long",
                             @(TRCTypeUnsignedChar): @"unsigned_char",
                             @(TRCTypeUnsignedInt): @"unsigned_int",
                             @(TRCTypeUnsignedShort): @"unsigned_short",
                             @(TRCTypeUnsignedLong): @"unsigned_long",
                             @(TRCTypeUnsignedLongLong): @"unsigned_long_long",
                             @(TRCTypeFloat): @"float",
                             @(TRCTypeDouble): @"double",
                             @(TRCTypeBool): @"bool",
                             @(TRCTypeVoid): @"void",
                             @(TRCTypeCharacterString): @"character_string",
                             @(TRCTypeCGPoint): @"cgpoint",
                             @(TRCTypeCGSize): @"cgsize",
                             @(TRCTypeCGRect): @"cgrect",
                             @(TRCTypeUIEdgeInsets): @"uiedgeInsets",
                             @(TRCTypeObject): @"object",
                             @(TRCTypeClass): @"class",
                             @(TRCTypeSEL): @"sel",
                             @(TRCTypeIMP): @"imp",
                             };
    });
    return _typeToString;
}

+ (nullable NSString *)stringFromType:(TRCType)type {
    NSDictionary<NSNumber *, NSString *>*mapping = [self typeToString];
    return mapping[@(type)];
}

+ (nullable NSNumber *)typeFromString:(NSString *)string {
    NSDictionary<NSNumber *, NSString *>*mapping = [self typeToString];
    return [[mapping allKeysForObject:string] firstObject];
}



@end

NS_ASSUME_NONNULL_END