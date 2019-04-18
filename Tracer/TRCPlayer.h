//
//  TRCPlayer.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCBlocks.h"

@class TRCTrace;

@protocol TRCFixtureProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 Trace player
 */
NS_SWIFT_NAME(TracePlayer)
@interface TRCPlayer : NSObject

/**
 Plays a trace by performing recorded invocations on the main queue.
 If playback fails, completes with an error.
 If playback succeeds, completes with nil.
 */
- (void)playTrace:(TRCTrace *)trace
         onTarget:(id)target
       completion:(TRCErrorCompletionBlock)completion;

/**
 Plays a trace by performing recorded invocations on the main queue.
 If an unknown object is encountered in the recorded trace, the player asks
 the fixture provider for a fixture.
 If playback fails, completes with an error.
 If playback succeeds, completes with nil.
 */
- (void)playTrace:(TRCTrace *)trace
         onTarget:(id)target
withFixtureProvider:(id<TRCFixtureProvider>)fixtureProvider
       completion:(TRCErrorCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
