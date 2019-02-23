//
//  TestSubject.h
//  TraceRecorderTests
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRCTestSubject : NSObject

/**
 Note: steipete/aspects doesn't support hooking class methods.
 possible alternative: https://github.com/Assuner-Lee/Stinger
 */

- (void)mWithZeroParams;
- (void)mWithOneParamPrimitive:(NSInteger)primitive;
- (void)mWithOneParamString:(NSString *)string;
- (void)mWithOneParamNumber:(NSNumber *)number;
- (void)mWithOneParamDict:(NSDictionary *)dict;
- (void)mWithTwoParamsPrimitive:(NSInteger)p1 primitive:(float)p2;
- (void)mWithTwoParamsPrimitive:(NSInteger)p1 string:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
