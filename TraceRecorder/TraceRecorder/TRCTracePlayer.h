//
//  TRCTracePlayer.h
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SCPTrace;

@interface TRCTracePlayer : NSObject

/**
 Loads a TraceRecording serialized to a JSON dictionary.
 Returns a mock object that can play the trace.
 */
- (id)loadTrace:(NSDictionary *)trace;

/**
 Plays the trace via the object returned by `loadTrace`.
 */
- (void)play;

@end

NS_ASSUME_NONNULL_END
