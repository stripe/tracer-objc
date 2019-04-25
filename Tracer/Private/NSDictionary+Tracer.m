//
//  NSDictionary+Tracer.m
//  Tracer
//
//  Created by Ben Guo on 7/26/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import "NSDictionary+Tracer.h"

#import "NSArray+Tracer.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSDictionary (Tracer)

- (NSDictionary *)trc_dictionaryByRemovingNulls {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, __unused BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            // Save array after removing any null values
            result[key] = [(NSArray *)obj trc_arrayByRemovingNulls];
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            // Save dictionary after removing any null values
            result[key] = [(NSDictionary *)obj trc_dictionaryByRemovingNulls];
        }
        else if ([obj isKindOfClass:[NSNull class]]) {
            // Skip null value
        }
        else {
            // Save other value
            result[key] = obj;
        }
    }];

    // Make immutable copy
    return [result copy];
}

#pragma mark - Getters

- (nullable NSArray *)trc_arrayForKey:(NSString *)key {
    id value = self[key];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSMutableArray *)trc_arrayForKey:(NSString *)key deserializedAs:(Class<TRCJsonDecodable>)deserializer {
    NSMutableArray *array = [NSMutableArray new];

    for (id element in [self trc_arrayForKey:key]) {
        if ([element isKindOfClass:[NSDictionary class]]) {
            id decoded = [deserializer decodedObjectFromJson:element];
            if (decoded) {
                [array addObject:decoded];
            }
        }
    }

    return array;
}

- (nullable NSNumber *)trc_boxedBoolForKey:(NSString *)key {
    id value = self[key];
    if (value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return @([value boolValue]);
        }
        if ([value isKindOfClass:[NSString class]]) {
            NSString *string = [(NSString *)value lowercaseString];
            // boolValue on NSString is true for "Y", "y", "T", "t", or 1-9
            if ([string isEqualToString:@"true"] || [string boolValue]) {
                return @YES;
            }
            else {
                return @NO;
            }
        }
    }
    return nil;
}

- (BOOL)trc_boolForKey:(NSString *)key or:(BOOL)defaultValue {
    NSNumber *boxedBool = [self trc_boxedBoolForKey:key];
    if (boxedBool != nil) {
        return [boxedBool boolValue];
    }
    return defaultValue;
}

- (nullable NSDate *)trc_dateForKey:(NSString *)key {
    id value = self[key];
    if (value &&
        ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])) {
        double timeInterval = [value doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    return nil;
}

- (nullable NSDictionary *)trc_dictionaryForKey:(NSString *)key {
    id value = self[key];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSInteger)trc_intForKey:(NSString *)key or:(NSInteger)defaultValue {
    id value = self[key];
    if (value &&
        ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])) {
        return [value integerValue];
    }
    return defaultValue;
}

- (nullable NSNumber *)trc_numberForKey:(NSString *)key {
    id value = self[key];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    return nil;
}

- (nullable NSString *)trc_stringForKey:(NSString *)key {
    id value = self[key];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}

- (nullable NSURL *)trc_urlForKey:(NSString *)key {
    id value = self[key];
    if (value && [value isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:value];
    }
    return nil;
}

#pragma mark - JsonDecodable

+ (nullable instancetype)decodedObjectFromJson:(nullable NSDictionary *)json {
    return json;
}

@end

NS_ASSUME_NONNULL_END

