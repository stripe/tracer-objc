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
    TRCErrorPlaybackFailedUnexpectedError,
    TRCErrorPlaybackFailedUnknownObject,
    TRCErrorPlaybackFailedUnsupportedType,
};

NS_ASSUME_NONNULL_END
