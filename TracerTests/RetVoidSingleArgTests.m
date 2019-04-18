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

@interface RetVoidSingleArgTests : XCTestCase

@end

@implementation RetVoidSingleArgTests

- (void)testPrimitives {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [t ret_void__args_none];
                        }),
                        (^{
                            [t ret_void__args_int:-100];
                        }),
                        (^{
                            [t ret_void__args_uint:100];
                        }),
                        (^{
                            [t ret_void__args_float:-123.5];
                        }),
                        (^{
                            [t ret_void__args_bool:YES];
                        }),
                        (^{
                            [t ret_void__args_boxed_int:@(-100)];
                        }),
                        (^{
                            [t ret_void__args_boxed_uint:@(100)];
                        }),
                        (^{
                            [t ret_void__args_boxed_bool:@(YES)];
                        }),
                        (^{
                            [t ret_void__args_string:@"string"];
                        }),
                        (^{
                            [t ret_void__args_int:100 string:@"string"];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
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

- (void)testObjectLiterals {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [t ret_void__args_boxed_int:@(-100)];
                        }),
                        (^{
                            [t ret_void__args_boxed_uint:@(100)];
                        }),
                        (^{
                            [t ret_void__args_boxed_bool:@(YES)];
                        }),
                        (^{
                            [t ret_void__args_string:@"string"];
                        }),
                        (^{
                            [t ret_void__args_array_single:@[@"value1"]];
                        }),
                        (^{
                            [t ret_void__args_array_multi:@[
                                                            @"value1",
                                                            @(100),
                                                            @(-123.5),
                                                            @[@"value2", @"value3"]
                                                            ]];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
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

- (void)testObjectReferences {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            NSNumber *n = [NSNumber numberWithInt:-100];
                            [t ret_void__args_boxed_int:n];
                        }),
                        (^{
                            NSNumber *n = [NSNumber numberWithUnsignedInt:100];
                            [t ret_void__args_boxed_uint:n];
                        }),
                        (^{
                            NSNumber *n = [NSNumber numberWithFloat:-123.5];
                            [t ret_void__args_boxed_float:n];
                        }),
                        (^{
                            NSNumber *n = [NSNumber numberWithBool:YES];
                            [t ret_void__args_boxed_bool:n];
                        }),
                        (^{
                            NSString *s = @"string";
                            [t ret_void__args_string:s];
                        }),
                        (^{
                            NSDictionary *d = @{
                                                @"key1": @"value1",
                                                };
                            [t ret_void__args_dict_single:d];
                        }),
                        (^{
                            NSArray *a = @[
                                           @"value1",
                                           ];
                            [t ret_void__args_array_single:a];
                        }),
                        (^{
                            NSArray *a = @[
                                           @"value1",
                                           @(100),
                                           @(-123.5),
                                           @[@"value2", @"value3"]
                                           ];
                            [t ret_void__args_array_multi:a];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
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

#pragma mark - Regression tests

/**
 Boxed float playback failed until Player retained object args
 */
- (void)testBoxedFloatLiteral {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [t ret_void__args_boxed_float:@(-123.5)];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
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


/**
 Dictionary playback failed until Player retained object args
 */
- (void)testDictionary {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [t ret_void__args_dict_single:@{
                                                            @"key1": @"value1",
                                                            }];
                        }),
                        (^{
                            NSDictionary *d = @{
                                                @"key1": @"value1",
                                                };
                            [t ret_void__args_dict_single:d];
                        }),
                        (^{
                            NSMutableDictionary *d = [@{
                                                        @"key1": @"value1",
                                                        } mutableCopy];
                            [t ret_void__args_dict_single:d];
                        }),
                        (^{
                            [t ret_void__args_dict_multi:@{
                                                           @"key1": @"value1",
                                                           @"key2": @{
                                                                   @"key3": @[@"value2", @"value3"],
                                                                   @"key4": @{
                                                                           @"key5": @(-123.5),
                                                                           },
                                                                   },
                                                           }];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
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
