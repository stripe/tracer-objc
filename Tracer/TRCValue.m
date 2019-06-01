//
//  TRCValue.m
//  Tracer
//
//  Created by Ben Guo on 2/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCValue.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "NSDictionary+Tracer.h"
#import "TRCCall+Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCValue ()

@property (atomic, assign, readwrite) TRCType type;
@property (atomic, assign, readwrite) TRCObjectType objectType;
@property (atomic, strong, nullable, readwrite) NSString *objectClass;
@property (atomic, strong, nullable, readwrite) id objectValue;

@end

@implementation TRCValue

static NSDictionary<NSNumber *, NSString *> *_typeToString;
static NSDictionary<NSNumber *, NSString *> *_objectTypeToString;

- (instancetype)initWithTypeEncoding:(NSString *)encoding
                       boxedArgument:(id)boxedArgument {
    self = [super init];
    if (self) {
        TRCType type = [[self class] typeWithEncoding:encoding];
        _type = type;
        BOOL isObject = (type == TRCTypeObject);
        if (isObject) {
            return [[self class] buildWithObject:boxedArgument];
        }
        else {
            _objectType = TRCObjectTypeNotAnObject;
            _objectValue = boxedArgument;
        }
    }
    return self;
}

+ (id)buildWithObject:(id)object {
    TRCValue *instance = [TRCValue new];
    instance.type = TRCTypeObject;
    NSString *classString = NSStringFromClass([object class]);
    // NSString
    if ([classString containsString:@"NSCFConstantString"] ||
        [classString containsString:@"NSCFString"]) {
        classString = @"NSString";
        instance.objectType = TRCObjectTypeJsonObject;
        instance.objectValue = object;
    }
    // NSNumber
    else if ([classString containsString:@"NSCFNumber"]) {
        classString = @"NSNumber";
        instance.objectType = TRCObjectTypeJsonObject;
        instance.objectValue = object;
    }
    // Boxed Bool
    else if ([classString containsString:@"NSCFBoolean"]) {
        classString = @"NSNumber";
        instance.objectType = TRCObjectTypeJsonObject;
        instance.objectValue = object;
    }
    // Valid JSON object
    else if ([NSJSONSerialization isValidJSONObject:object]) {
        instance.objectType = TRCObjectTypeJsonObject;
        instance.objectValue = object;
    }
    // NSDictionary, not valid JSON
    else if ([classString containsString:@"NSSingleEntryDictionary"] ||
             [classString containsString:@"NSDictionary"]) {
        classString = @"NSDictionary";
        instance.objectType = TRCObjectTypeUnknownDictionary;
        // TODO: we can do better than description
        instance.objectValue = [object description];
    }
    // NSArray, not valid JSON
    else if ([classString containsString:@"NSSingleObjectArray"] ||
             [classString containsString:@"NSArray"]) {
        classString = @"NSArray";
        instance.objectType = TRCObjectTypeUnknownArray;
        // TODO: we can do better than description
        instance.objectValue = [object description];
    }
    else {
        instance.objectType = TRCObjectTypeUnknownObject;
        NSMutableDictionary *objectValue = [NSMutableDictionary new];

        unsigned int methodCount = 0;
        Method *methodList = class_copyMethodList([object class], &methodCount);
        for (NSUInteger i = 0; i < methodCount; i++) {
            struct objc_method_description *methodDescription = method_getDescription(methodList[i]);
            NSValue *selValue = [NSValue valueWithPointer:methodDescription->name];
            NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:methodDescription->types];
            NSString *encodingString = [NSString stringWithUTF8String:sig.methodReturnType];
            // args 0 and 1 are the hidden arguments self and _cmd
            if (sig.numberOfArguments == 2) {
                SEL sel = (SEL)selValue.pointerValue;
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
                [invocation setSelector:sel];
                [invocation setTarget:object];
                [invocation invoke];

                NSString *selString = NSStringFromSelector(sel);
                TRCType type = [[self class] typeWithEncoding:encodingString];

                BOOL isObject = (type == TRCTypeObject);
                if (isObject) {
                    __unsafe_unretained id returnValue;
                    [invocation getReturnValue:&returnValue];
                    objectValue[selString] = returnValue;
                }
            }
        }
        instance.objectValue = [objectValue copy];
    }
    instance.objectClass = classString;
    return instance;
}

+ (nullable instancetype)decodedObjectFromJson:(nullable NSDictionary *)json {
    // precheck
    if (!json) {
        return nil;
    }
    NSDictionary *dict = [json trc_dictionaryByRemovingNulls];
    NSString *object = [dict trc_stringForKey:@"trace_object"];
    if (![object isEqualToString:@"value"]) {
        return nil;
    }

    // props
    NSString *rawType = [json trc_stringForKey:@"type"];
    NSString *rawObjectType = [json trc_stringForKey:@"object_type"];
    NSString *classString = [json trc_stringForKey:@"object_class"];
    NSNumber *boxedType = [[self class] typeFromString:rawType];
    NSNumber *boxedObjectType = [[self class] objectTypeFromString:rawObjectType];
    id objectValue = [json objectForKey:@"object_value"];
    if (!boxedType || !boxedObjectType) {
        return nil;
    }

    // assemble
    TRCValue *decoded = [TRCValue new];
    decoded.type = [boxedType unsignedIntegerValue];
    decoded.objectType = [boxedObjectType unsignedIntegerValue];
    decoded.objectClass = classString;
    decoded.objectValue = objectValue;
    return decoded;
}

- (NSObject *)jsonObject {
    NSMutableDictionary *json = [NSMutableDictionary new];
    json[@"trace_object"] = @"value";
    json[@"type"] = [[self class] stringFromType:self.type];
    json[@"object_type"] = [[self class] stringFromObjectType:self.objectType];
    json[@"object_class"] = self.objectClass;
    json[@"object_value"] = self.objectValue;
    return [json copy];
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

+ (NSDictionary<NSNumber *, NSString *>*)objectTypeToString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _objectTypeToString = @{
                          @(TRCObjectTypeNotAnObject): @"not_an_object",
                          @(TRCObjectTypeUnknownObject): @"unknown_object",
                          @(TRCObjectTypeJsonObject): @"json_object",
                          @(TRCObjectTypeUnknownArray): @"unknown_array",
                          @(TRCObjectTypeUnknownDictionary): @"unknown_dictionary",
                          };
    });
    return _objectTypeToString;
}

+ (nullable NSString *)stringFromObjectType:(TRCObjectType)type {
    NSDictionary<NSNumber *, NSString *>*mapping = [self objectTypeToString];
    return mapping[@(type)];
}

+ (nullable NSNumber *)objectTypeFromString:(NSString *)string {
    NSDictionary<NSNumber *, NSString *>*mapping = [self objectTypeToString];
    return [[mapping allKeysForObject:string] firstObject];
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
