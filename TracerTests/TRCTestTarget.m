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

- (void)mWithOneParamDict:(NSDictionary *)dict {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSParameterAssert([dict isEqualToDictionary:@{@"key": @"value"}]);
}

- (void)mWithTwoParamsPrimitive:(NSInteger)p1 primitive:(float)p2 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)mWithTwoParamsPrimitive:(NSInteger)p1 string:(NSString *)string {
    NSLog(@"%@", NSStringFromSelector(_cmd));
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
