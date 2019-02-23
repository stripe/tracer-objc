//
//  TRCTrace+Private.h
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTraceRecording.h"
#import "TRCMethodCall.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCTraceRecording (Private)

- (void)addMethodCall:(TRCMethodCall *)methodCall;

@end

NS_ASSUME_NONNULL_END
