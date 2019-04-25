//
//  NSDictionary+Tracer.h
//  Tracer
//
//  Created by Ben Guo on 7/26/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCJsonDecodable.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Tracer) <TRCJsonDecodable>

- (NSDictionary *)trc_dictionaryByRemovingNulls;

// Getters

- (nullable NSArray *)trc_arrayForKey:(NSString *)key;

/**
 Always return NSMutableArray, containing any/all objects that could
 deserialized from the array at `key`, using the `deserializer`'s class.

 Any objects that can't be deserialized are dropped silently, and the returned
 array might be empty.
 */
- (NSMutableArray *)trc_arrayForKey:(NSString *)key deserializedAs:(Class<TRCJsonDecodable>)deserializer;

- (nullable NSNumber *)trc_boxedBoolForKey:(NSString *)key;

- (BOOL)trc_boolForKey:(NSString *)key or:(BOOL)defaultValue;

- (nullable NSDate *)trc_dateForKey:(NSString *)key;

- (nullable NSDictionary *)trc_dictionaryForKey:(NSString *)key;

- (NSInteger)trc_intForKey:(NSString *)key or:(NSInteger)defaultValue;

- (nullable NSNumber *)trc_numberForKey:(NSString *)key;

- (nullable NSString *)trc_stringForKey:(NSString *)key;

- (nullable NSURL *)trc_urlForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

