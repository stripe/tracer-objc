//
//  TRCTrace.h
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCJsonEncodable.h"

@class TRCRecordedInvocation;

NS_ASSUME_NONNULL_BEGIN

@interface TRCTrace : NSObject <TRCJsonEncodable>

@property (atomic, readonly) NSMutableArray<TRCRecordedInvocation*>*invocations;
@property (atomic, readonly) NSString *protocol;

+ (nullable instancetype)loadFromJSONFile:(NSString *)filename;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
