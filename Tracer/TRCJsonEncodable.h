//
//  TRCJsonEncodable.h
//  Tracer
// 
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Objects conforming to this protocol can be convert themself into a JSON
 object (NSDictionary or NSArray), suitable for use with `NSJSONSerialization`.
 */
NS_SWIFT_NAME(JsonEncodable)
@protocol TRCJsonEncodable <NSObject>

/**
 Converts the receiver into a JSON object (NSDictionary or NSArray), suitable
 for use with `NSJSONSerialization`.
 */
- (NSDictionary *)jsonObject;

@end

NS_ASSUME_NONNULL_END
