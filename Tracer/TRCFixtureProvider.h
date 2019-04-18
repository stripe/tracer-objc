//
//  TRCFixtureProvider.h
//  Tracer
//
//  Created by Ben Guo on 4/17/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Fixture provider for a trace player.
 */
NS_SWIFT_NAME(FixtureProvider)
@protocol TRCFixtureProvider <NSObject>

/**
 Synchronously return a fixture for the given value.
 Returning nil causes playback to fail.
 */
- (nullable id)player:(TRCPlayer *)player didRequestFixtureForValue:(TRCValue *)value;

@end

NS_ASSUME_NONNULL_END
