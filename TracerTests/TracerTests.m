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
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [t mWithZeroParams];
                        }),
//                        (^{
//                            [tgt mWithOneParamString:@"string"];
//                        }),
                        (^{
                            [t mWithOneParamNumber:@(100)];
                        }),
                        (^{
                            // broken
                            [t mWithOneParamPrimitive:100];
                        }),
//                        (^{
//                            [tgt mWithOneParamDict:@{@"key": @"value"}];
//                        }),
//                        (^{
//                            [tgt mWithTwoParamsPrimitive:2 primitive:3];
//                        }),
//                        (^{
//                            [tgt mWithTwoParamsPrimitive:3 string:@"s2"];
//                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
                                NSLog(@"%@", [trace jsonObject]);

                                [TRCPlayer playTrace:trace onTarget:t completion:^(NSError * _Nullable playError) {
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
