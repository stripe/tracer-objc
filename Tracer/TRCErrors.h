//
//  TRCErrors.h
//  Tracer
//
//  Created by Ben Guo on 3/16/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const TRCErrorDomain;
FOUNDATION_EXPORT NSString * const TRCErrorKeyCall;

typedef NS_ERROR_ENUM(TRCErrorDomain, TRCError) {
    /**
     Recording failed because the JSON representation of the trace is invalid.
     */
    TRCErrorRecordingFailedInvalidTraceJson,
    /**
     Recording failed because serializing the JSON trace to a string failed.
     */
    TRCErrorRecordingFailedTraceJsonSerializationError,
    /**
     Recording failed for an unexpected reason.
     */
    TRCErrorRecordingFailedUnexpectedError,
    /**
     Playback failed because the object is unknown.
     TODO: docs on using a fixture provider
     */
    TRCErrorPlaybackFailedUnknownObject,
    /**
     Playback failed because the object type is unsupported.
     */
    TRCErrorPlaybackFailedUnsupportedType,
    /**
     Playback failed because the fixture provider return nil for a requested value.
     */
    TRCErrorPlaybackFailedFixtureProviderReturnedNil,
    /**
     Playback failed for an unexpected reason.
     */
    TRCErrorPlaybackFailedUnexpectedError,
};

NS_ASSUME_NONNULL_END
