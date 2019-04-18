//
//  TRCErrors.h
//  Tracer
//
//  Created by Ben Guo on 3/16/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ErrorDomain)
FOUNDATION_EXPORT NSString * const TRCErrorDomain;

/**
 Use this enum to access userInfo keys for NSError objects under the
 SCPErrorDomain domain.
 */
NS_SWIFT_NAME(ErrorKey)
typedef NSString *const TRCErrorKey NS_STRING_ENUM;

/**
 The TraceCall producing the error.
 */
FOUNDATION_EXPORT TRCErrorKey const TRCErrorKeyCall;

/**
 Possible error codes for NSError objects under the SCPErrorDomain domain.
 */
typedef NS_ERROR_ENUM(TRCErrorDomain, TRCError) {
    /**
     Recording failed for an unexpected reason.
     */
    TRCErrorRecordingFailedUnexpectedError = 1000,
    /**
     Recording failed because the JSON representation of the trace is invalid.
     */
    TRCErrorRecordingFailedInvalidTraceJson = 1001,
    /**
     Recording failed because serializing the JSON trace to a string failed.
     */
    TRCErrorRecordingFailedTraceJsonSerializationError = 1002,

    /**
     Playback failed for an unexpected reason.
     */
    TRCErrorPlaybackFailedUnexpectedError = 2000,
    /**
     Playback failed because the object is unknown.
     TODO: docs on using a fixture provider
     */
    TRCErrorPlaybackFailedUnknownObject = 2001,
    /**
     Playback failed because the object type is unsupported.
     */
    TRCErrorPlaybackFailedUnsupportedType = 2002,
    /**
     Playback failed because the fixture provider return nil for a requested value.
     */
    TRCErrorPlaybackFailedFixtureProviderReturnedNil = 2003,
} NS_SWIFT_NAME(ErrorCode);

NS_ASSUME_NONNULL_END
