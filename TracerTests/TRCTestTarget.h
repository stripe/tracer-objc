//
//  TestSubject.h
//  TracerTests
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Not supported
 - non-protocol methods
 - private methods
 - primitive arguments
 - class methods

 steipete/aspects doesn't support hooking class methods.
 possible alternative: https://github.com/Assuner-Lee/Stinger
 */

NS_ASSUME_NONNULL_BEGIN

@protocol TRCTestProtocol <NSObject>
- (void)protocol_method;
- (void)protocol_method_int:(NSInteger)p;
- (void)protocol_method_uint:(NSUInteger)i;
- (void)protocol_method_float:(float)f;
- (void)protocol_method_bool:(BOOL)b;
- (void)protocol_method_string:(NSString *)s;
- (void)protocol_method_boxed_int:(NSNumber *)n;
- (void)protocol_method_boxed_uint:(NSNumber *)n;
- (void)protocol_method_boxed_bool:(NSNumber *)n;
- (void)protocol_method_boxed_float:(NSNumber *)n;
- (void)protocol_method_dictSingleEntry:(NSDictionary *)d;
- (void)protocol_method_dictMultiEntry:(NSDictionary *)d;
- (void)protocol_method_int:(NSInteger)p1 string:(NSString *)string;
@end

@interface TRCTestTarget : NSObject <TRCTestProtocol>

@end

NS_ASSUME_NONNULL_END
