//
//  TRCJsonDecodable.h
//  Tracer
//
//  Created by Ben Guo on 4/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Objects conforming to this protocol can be instantiated by decoding a JSON
 dictionary.
 */
NS_SWIFT_NAME(JsonDecodable)
@protocol TRCJsonDecodable <NSObject>

/**
 Parses a JSON dictionary into an instance of the class. Returns nil if the
 object could not be decoded.
 */
+ (nullable instancetype)decodedObjectFromJson:(nullable NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
