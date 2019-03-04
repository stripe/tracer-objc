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

#pragma mark - public methods - return void

- (void)ret_void__args_none {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)ret_void__args_int:(int)i {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == -100);
}

- (void)ret_void__args_uint:(uint)i {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == 100);
}

- (void)ret_void__args_float:(float)f {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(f == -123.5);
}

- (void)ret_void__args_bool:(BOOL)b {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(b == YES);
}

- (void)ret_void__args_string:(NSString *)s {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([s isEqualToString:@"string"]);
}

- (void)ret_void__args_array_single:(NSArray *)a {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSArray *expected = @[
                          @"value1",
                          ];
    NSParameterAssert([a isEqualToArray:expected]);
}

- (void)ret_void__args_array_multi:(NSArray *)a {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSArray *expected = @[
                          @"value1",
                          @(100),
                          @(-123.5),
                          @[@"value2", @"value3"]
                          ];
    NSParameterAssert([a isEqualToArray:expected]);
}

- (void)ret_void__args_boxed_int:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n isEqual:@(-100)]);
}

- (void)ret_void__args_boxed_uint:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n unsignedIntegerValue] == 100);
}

- (void)ret_void__args_boxed_float:(NSNumber *)n {
    NSParameterAssert(n != nil);
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n floatValue] == -123.5);
}

- (void)ret_void__args_boxed_bool:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n boolValue] == YES);
}

- (void)ret_void__args_dict_single:(NSDictionary *)d {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSDictionary *expected = @{@"key1": @"value1"};
    NSParameterAssert([d isEqualToDictionary:expected]);
}

- (void)ret_void__args_dictMultiEntry:(NSDictionary *)d {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSDictionary *expected = @{
                               @"key1": @"value1",
                               @"key2": @"value2"
                               };
    NSParameterAssert([d isEqualToDictionary:expected]);
}

- (void)ret_void__args_dict_multi:(NSDictionary *)d {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSDictionary *expected = @{
                               @"key1": @"value1",
                               @"key2": @{
                                       @"key3": @[@"value2", @"value3"],
                                       @"key4": @{
                                               @"key5": @(-123.5),
                                               },
                                       },
                               };
    NSParameterAssert([d isEqualToDictionary:expected]);
}

- (void)ret_void__args_int:(int)i string:(NSString *)s {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == 100);
    NSParameterAssert([s isEqualToString:@"string"]);
}

#pragma mark - public methods - return value

- (NSString *)ret_string__args_none {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return @"string";
}

- (NSString *)ret_string__args_int:(int)i {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == -100);
    return @"string";
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
