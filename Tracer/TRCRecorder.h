//
//  TRCRecorder.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCBlocks.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Trace recorder
 */
NS_SWIFT_NAME(TraceRecorder)
@interface TRCRecorder : NSObject

/**
 Starts recording a protocol on a source.
 */
- (void)startRecording:(id)source protocol:(Protocol *)protocol;

/**
 Stops recording a protocol on a source.
 If recording fails, completes with an error.
 If recording succeeds, completes with nil.
 */
- (void)stopRecording:(id)source
             protocol:(Protocol *)protocol
           completion:(TRCTraceCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
