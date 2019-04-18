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

+ (NSString *)stringFromErrorCode:(TRCError)code {
    switch (code) {
        case TRCErrorRecordingFailedInvalidTraceJson:
            return @"Recording failed because the JSON representation of the trace is invalid.";
        case TRCErrorRecordingFailedTraceJsonSerializationError:
            return @"Recording failed because serializing the JSON trace to a string failed.";
        case TRCErrorRecordingFailedUnexpectedError:
            return @"Recording failed for an unexpected reason.";
        case TRCErrorPlaybackFailedUnknownObject:
            return @"Playback failed because the object is unknown.";
        case TRCErrorPlaybackFailedUnsupportedType:
            return @"Playback failed because the object type is unsupported.";
        case TRCErrorPlaybackFailedFixtureProviderReturnedNil:
            return @"Playback failed because the fixture provider return nil for a requested value.";
        case TRCErrorPlaybackFailedUnexpectedError:
            return @"Playback failed for an unexpected reason.";
    }
}

+ (NSError *)buildError:(TRCError)errorCode {
    NSString *message = [self stringFromErrorCode:errorCode];
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: message,
                               };
    NSError *error = [NSError errorWithDomain:TRCErrorDomain
                                         code:errorCode
                                     userInfo:userInfo];
    return error;
}

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
