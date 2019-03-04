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

- (void)protocol_method_int:(int)i {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == -100);
}

- (void)protocol_method_uint:(uint)i {
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
    NSParameterAssert([n isEqual:@(-100)]);
}

- (void)protocol_method_boxed_uint:(NSNumber *)n {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([n unsignedIntegerValue] == 100);
}

- (void)protocol_method_boxed_float:(NSNumber *)n {
    NSParameterAssert(n != nil);
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"class: %@", [n class]);
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

- (void)protocol_method_dictNested:(NSDictionary *)d {
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

- (void)protocol_method_int:(int)i string:(NSString *)s {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(i == 100);
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
