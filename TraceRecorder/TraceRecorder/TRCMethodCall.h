//
//  TRCMethodCall.h
//  TraceRecorder
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCJsonEncodable.h"

@protocol TRCAspectInfo;

NS_ASSUME_NONNULL_BEGIN

@interface TRCMethodCall : NSObject <TRCJsonEncodable>

- (instancetype)initWithClass:(Class)kls
                     selector:(SEL)sel
                         info:(id<TRCAspectInfo>)info
                       millis:(NSUInteger)millis;

@end

NS_ASSUME_NONNULL_END
