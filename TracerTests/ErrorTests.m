//
//  ErrorTests.m
//  TracerTests
//
//  Created by Ben Guo on 3/16/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Tracer/Tracer.h>
#import "TRCTestTarget.h"
#import "TRCDispatchFunctions.h"

@interface ErrorTests : XCTestCase

@end

@implementation ErrorTests

- (void)xtestErrorUnknownObject {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [t ret_void__args_int:-100];
                        }),
                        (^{
                            [t ret_void__args_object:[NSObject new]];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
                                TRCPlayer *player = [TRCPlayer new];
                                [player playTrace:trace onTarget:t completion:^(NSError * _Nullable playError) {
                                    XCTAssertNotNil(playError);
                                    XCTAssertEqual(playError.code, TRCErrorPlaybackFailedUnknownObject);
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

- (void)testErrorUnsupportedType {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            [t ret_void__args_int:-100];
                        }),
                        (^{
                            [t ret_void__args_cgsize:CGSizeMake(0, 0)];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNil(trace);
                                XCTAssertNotNil(recError);
                                XCTAssertEqual(recError.code, TRCErrorRecordingFailedInvalidTraceJson);
                                [exp fulfill];
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
