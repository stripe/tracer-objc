//
//  TestSubject.m
//  TracerTests
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTestTarget.h"

#import "TRCDispatchFunctions.h"

@implementation TRCTestTarget

#pragma mark - public methods

- (void)protocol_method {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)protocol_method_int:(NSInteger)i {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == -100);
}

- (void)protocol_method_uint:(NSUInteger)i {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == 100);
}

- (void)protocol_method_float:(float)f {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(f == -123.5);
}

- (void)protocol_method_bool:(BOOL)b {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(b == YES);
}

- (void)protocol_method_string:(NSString *)s {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([s isEqualToString:@"string"]);
}

- (void)protocol_method_boxed_int:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n integerValue] == -100);
}

- (void)protocol_method_boxed_uint:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n unsignedIntegerValue] == 100);
}

- (void)protocol_method_boxed_float:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n floatValue] == -123.5);
}

- (void)protocol_method_boxed_bool:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n boolValue] == YES);
}

- (void)protocol_method_dictSingleEntry:(NSDictionary *)d {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSDictionary *expected = @{@"key1": @"value1"};
    NSParameterAssert([d isEqualToDictionary:expected]);
}

- (void)protocol_method_dictMultiEntry:(NSDictionary *)d {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSDictionary *expected = @{
                               @"key1": @"value1",
                               @"key2": @"value2"
                               };
    NSParameterAssert([d isEqualToDictionary:expected]);
}

- (void)protocol_method_int:(NSInteger)p string:(NSString *)s {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(p == 100);
    NSParameterAssert([s isEqualToString:@"string"]);
}

#pragma mark - private methods

- (void)private_method {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)private_method_primitive:(NSInteger)p {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)private_method_string:(NSString *)s {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
