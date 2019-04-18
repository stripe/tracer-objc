//
//  TRCError+Private.h
//  Tracer
//
//  Created by Ben Guo on 3/16/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCErrors.h"

@class TRCCall;

NS_ASSUME_NONNULL_BEGIN

@interface TRCErrors: NSError

+ (NSError *)buildError:(TRCError)errorCode call:(TRCCall *)call message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
