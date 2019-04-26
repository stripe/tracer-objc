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
 Defaults to false. Tracer is experimental, and still work-in-progress.
 */
@property (nonatomic, assign) BOOL debugModeEnabled;

/**
 Starts recording a protocol on a source.
 */
- (void)startRecording:(id)source protocol:(Protocol *)protocol;

/**
 Stops recording a protocol on a source.

 Note that optional protocol methods aren't currently supported, and will not
 be recorded.

 If recording fails, completes with an error.
 If recording succeeds, completes with nil.
 */
- (void)stopRecording:(id)source
             protocol:(Protocol *)protocol
           completion:(TRCTraceCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
