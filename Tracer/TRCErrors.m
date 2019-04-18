//
//  TRCErrors.m
//  Tracer
//
//  Created by Ben Guo on 3/16/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCErrors+Private.h"
#import "TRCCall.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const TRCErrorDomain = @"com.tracer";
NSString *const TRCErrorKeyCall = @"com.tracer:Call";

@implementation TRCErrors

+ (NSError *)buildError:(TRCError)errorCode call:(TRCCall *)call message:(NSString *)message {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: message,
                               TRCErrorKeyCall: call.jsonObject,
                               };
    NSError *error = [NSError errorWithDomain:TRCErrorDomain
                                         code:errorCode
                                     userInfo:userInfo];
    return error;
}

@end

NS_ASSUME_NONNULL_END
