//
//  TraceRecorderTests.m
//  TraceRecorderTests
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TraceRecorder/TraceRecorder.h>
#import "TestSubject.h"
#import "TestDispatchFunctions.h"

@interface TraceRecorderTests : XCTestCase

@end

@implementation TraceRecorderTests

- (void)testBasic {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TestSubject *sbj = [[TestSubject alloc] init];
    TRCTraceRecorder *recorder = [TRCTraceRecorder new];
    [recorder startRecording:sbj];

    NSArray *blocks = @[
                        (^{
                            [sbj mWithZeroParams];
                        }),
                        (^{
                            [sbj mWithOneParamPrimitive:1];
                        }),
                        (^{
                            [sbj mWithOneParamString:@"s1"];
                        }),
                        (^{
                            [sbj mWithOneParamNumber:@(100)];
                        }),
                        (^{
                            [sbj mWithOneParamDict:@{@"k1": @"v1"}];
                        }),
                        (^{
                            [sbj mWithTwoParamsPrimitive:2 primitive:3];
                        }),
                        (^{
                            [sbj mWithTwoParamsPrimitive:3 string:@"s2"];
                        }),
                        (^{
                            [recorder stopRecording:sbj completion:^(TRCTraceRecording * _Nullable recording, NSError * _Nullable error) {
                                XCTAssertNotNil(recording);
                                XCTAssertNil(error);
                                NSLog(@"%@", [recording jsonObject]);
                                [exp fulfill];
                            }];
                        }),
                        ];

    for (NSUInteger i = 0; i < blocks.count; i++) {
        NSTimeInterval delay = (NSTimeInterval)(0.1*(i+1));
        testDispatchToMainAfter(delay, blocks[i]);
    }

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
