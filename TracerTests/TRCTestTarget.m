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

- (void)mWithZeroParams {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)mWithOneParamPrimitive:(NSInteger)primitive {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(primitive == 100);
}

- (void)mWithOneParamString:(NSString *)string {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([string isEqualToString:@"string"]);
}

- (void)mWithOneParamNumber:(NSNumber *)number {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([number isEqualToNumber:@(100)]);
}

- (void)mWithOneParamDictSingleEntry:(NSDictionary *)dict {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSDictionary *expected = @{@"key1": @"value1"};
    NSParameterAssert([dict isEqualToDictionary:expected]);
}

- (void)mWithOneParamDictMultiEntry:(NSDictionary *)dict {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSDictionary *expected = @{
                               @"key1": @"value1",
                               @"key2": @"value2"
                               };
    NSParameterAssert([dict isEqualToDictionary:expected]);
}

- (void)mWithTwoParamsPrimitive:(NSInteger)p1 primitive:(float)p2 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(p1 == 100);
    NSParameterAssert(p2 == 200);
}

- (void)mWithTwoParamsPrimitive:(NSInteger)p1 string:(NSString *)string {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert(p1 == 100);
    NSParameterAssert([string isEqualToString:@"string"]);
}

#pragma mark - private methods

- (void)pmWithZeroParams {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)pmWithOneParamPrimitive:(NSInteger)primitive {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)pmWithOneParamString:(NSString *)string {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
