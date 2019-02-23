//
//  TestSubject.m
//  TraceRecorderTests
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCTestSubject.h"

#import "TRCDispatchFunctions.h"

@implementation TRCTestSubject

#pragma mark - public methods

- (void)mWithZeroParams {
    trcDispatchToMainAfter(0.05, ^{
        [self pmWithZeroParams];
    });
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

#pragma mark - private methods

- (void)pmWithZeroParams {

}

@end
