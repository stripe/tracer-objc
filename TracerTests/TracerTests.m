//
//  TracerTests.m
//  TracerTests
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Tracer/Tracer.h>
#import "TRCTestTarget.h"
#import "TRCDispatchFunctions.h"

@interface TracerTests : XCTestCase

@end

@implementation TracerTests

- (void)testRecordClass {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *tgt = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:tgt protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [tgt mWithZeroParams];
                        }),
                        (^{
                            [tgt mWithOneParamString:@"s1"];
                        }),
                        (^{
                            [tgt mWithOneParamNumber:@(100)];
                        }),
//                        (^{
//                            // broken
//                            [tgt mWithOneParamPrimitive:1];
//                        }),

//                        (^{
//                            [tgt mWithOneParamDict:@{@"k1": @"v1"}];
//                        }),
//                        (^{
//                            [tgt mWithTwoParamsPrimitive:2 primitive:3];
//                        }),
//                        (^{
//                            [tgt mWithTwoParamsPrimitive:3 string:@"s2"];
//                        }),
                        (^{
                            [recorder stopRecording:tgt protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
                                NSLog(@"%@", [trace jsonObject]);

                                [TRCPlayer playTrace:trace onTarget:tgt completion:^(NSError * _Nullable playError) {
                                    XCTAssertNil(playError);
                                    [exp fulfill];
                                }];
                            }];
                        }),
                        ];

    for (NSUInteger i = 0; i < blocks.count; i++) {
        NSTimeInterval delay = (NSTimeInterval)(0.1*(i+1));
        trcDispatchToMainAfter(delay, blocks[i]);
    }

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
