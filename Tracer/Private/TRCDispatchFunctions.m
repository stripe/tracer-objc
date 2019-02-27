//
//  TestDispatchFunctions.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCDispatchFunctions.h"

NS_ASSUME_NONNULL_BEGIN

void trcDispatchToMainThreadIfNecessary(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void trcDispatchToMainAfter(NSTimeInterval timeInterval, TestVoidBlock block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

NS_ASSUME_NONNULL_END
