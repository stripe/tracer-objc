//
//  TRCTrace+Private.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTrace.h"
#import "TRCRecordedInvocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCTrace (Private)

- (instancetype)initWithProtocol:(Protocol *)protocol;

- (void)addInvocation:(TRCRecordedInvocation *)invocation;

@end

NS_ASSUME_NONNULL_END
