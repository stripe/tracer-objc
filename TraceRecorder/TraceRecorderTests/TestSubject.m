//
//  TestSubject.m
//  TraceRecorderTests
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TestSubject.h"

@implementation TestSubject

+ (void)clMethodWithZeroParams {

}

+ (void)clMethodWithOneParamPrimitive:(NSInteger)primitive {

}

+ (void)clMethodWithOneParamString:(NSString *)string {

}

- (void)mWithZeroParams {

}

- (void)mWithOneParamPrimitive:(NSInteger)primitive {

}

- (void)mWithOneParamString:(NSString *)string {

}

- (void)mWithOneParamNumber:(NSNumber *)number {
    
}

- (void)mWithOneParamDict:(NSDictionary *)dict {
    
}

- (void)mWithTwoParamsPrimitive:(NSInteger)p1 primitive:(float)p2 {

}

- (void)mWithTwoParamsPrimitive:(NSInteger)p1 string:(NSString *)string {

}

@end
