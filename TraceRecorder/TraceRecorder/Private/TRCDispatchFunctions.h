//
//  TestDispatchFunctions.h
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
__BEGIN_DECLS

typedef void (^TestVoidBlock)(void);
void trcDispatchToMainAfter(NSTimeInterval timeInterval, TestVoidBlock block);

__END_DECLS
NS_ASSUME_NONNULL_END
