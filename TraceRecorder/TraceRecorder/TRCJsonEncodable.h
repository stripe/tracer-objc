//
//  TRCJsonEncodable.h
//  StripeTerminal
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
@protocol TRCJsonEncodable <NSObject>

/**
 Converts the receiver into a JSON object (NSDictionary or NSArray), suitable
 for use with `NSJSONSerialization`.
 */
- (NSObject *)jsonObject;

@end

NS_ASSUME_NONNULL_END
