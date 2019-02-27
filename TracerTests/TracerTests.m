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
                            [t protocol_method];
                        }),
                        (^{
                            [t protocol_method_string:@"string"];
                        }),
                        (^{
                            [t protocol_method_int:-100];
                        }),
                        (^{
                            [t protocol_method_uint:100];
                        }),
                        (^{
                            [t protocol_method_float:-123.5];
                        }),
                        (^{
                            [t protocol_method_bool:YES];
                        }),
                        (^{
                            [t protocol_method_boxed_int:@(-100)];
                        }),
                        (^{
                            [t protocol_method_boxed_uint:@(100)];
                        }),
                        (^{
                            [t protocol_method_boxed_bool:@(YES)];
                        }),
//                        (^{
//                            // broken
//                            [t protocol_method_boxed_float:@(-123.5)];
//                        }),
//                        (^{
//                            // broken
//                            [t protocol_method_dictSingleEntry:@{
//                                                              @"key1": @"value1",
//                                                              }];
//                        }),
//                        (^{
//                            [t protocol_method_dictMultiEntry:@{
//                                                             @"key1": @"value1",
//                                                             @"key2": @"value2"
//                                                             }];
//                        }),
//                        (^{
//                            [t protocol_method_int:100 string:@"string"];
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
