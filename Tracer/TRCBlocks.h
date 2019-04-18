//
//  TRCBlocks.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TRCTrace;

NS_SWIFT_NAME(TraceCompletionBlock)
typedef void (^TRCTraceCompletionBlock)(TRCTrace *__nullable trace, NSError *__nullable error);

NS_SWIFT_NAME(ErrorCompletionBlock)
typedef void (^TRCErrorCompletionBlock)(NSError *__nullable error);

NS_ASSUME_NONNULL_END

