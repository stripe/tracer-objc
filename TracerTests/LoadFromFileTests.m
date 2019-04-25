//
//  LoadFromFileTests.m
//  TracerTests
//
//  Created by Ben Guo on 4/17/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Tracer/Tracer.h>
#import "TRCTestTarget.h"
#import "TRCDispatchFunctions.h"

@interface LoadFromFileTests : XCTestCase

@end

@implementation LoadFromFileTests

- (void)testloadFromJsonFile {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    TRCTrace *trace = [TRCTrace loadFromJsonFile:@"trace_bt_scan_connect" bundle:testBundle];
    XCTAssertNotNil(trace);
}

- (void)xtestPlaybackFromFile {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCPlayer *player = [TRCPlayer new];
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    // Playing back floats (maybe all primitives) from a file fails.
    // I think this may be because Player needs to retain them?
    TRCTrace *trace = [TRCTrace loadFromJsonFile:@"saved_trace" bundle:testBundle];
    [player playTrace:trace onTarget:t completion:^(NSError * _Nullable playError) {
        XCTAssertNil(playError);
        [exp fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
