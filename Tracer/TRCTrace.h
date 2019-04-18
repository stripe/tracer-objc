//
//  TRCTrace.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCJsonEncodable.h"

@class TRCCall;

NS_ASSUME_NONNULL_BEGIN

/**
 A trace. A trace is a timeseries of calls.
 */
NS_SWIFT_NAME(Trace)
@interface TRCTrace : NSObject <TRCJsonEncodable>

/**
 The recorded calls.
 */
@property (atomic, readonly) NSMutableArray<TRCCall*>*calls;

/**
 The recorded protocol.
 */
@property (atomic, readonly) NSString *protocol;

/**
 Loads a trace from a file.
 */
+ (nullable instancetype)loadFromJSONFile:(NSString *)filename;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
