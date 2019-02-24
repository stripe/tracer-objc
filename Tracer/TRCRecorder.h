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

@interface TRCRecorder : NSObject

- (void)startRecording:(id)source protocol:(Protocol *)protocol;

- (void)stopRecording:(id)source
             protocol:(Protocol *)protocol
           completion:(TRCTraceCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
