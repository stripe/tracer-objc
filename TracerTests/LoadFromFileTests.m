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

#ifdef SWIFT_PACKAGE
#import "resource_bundle_accessor.h"
#endif

@interface LoadFromFileTests : XCTestCase

@end

@implementation LoadFromFileTests

// SwiftPM puts test resources in a separate bundle, not the test bundle itself.
- (NSBundle *)fixtureBundle {
#ifdef SWIFT_PACKAGE
    return SWIFTPM_MODULE_BUNDLE;
#else
    return [NSBundle bundleForClass:[self class]];
#endif
}

- (void)testloadFromJsonFile {
    TRCTrace *trace = [TRCTrace loadFromJsonFile:@"trace_bt_scan_connect" bundle:[self fixtureBundle]];
    XCTAssertNotNil(trace);
}

- (void)xtestPlaybackFromFile {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCPlayer *player = [TRCPlayer new];
    // Playing back floats (maybe all primitives) from a file fails.
    // I think this may be because Player needs to retain them?
    TRCTrace *trace = [TRCTrace loadFromJsonFile:@"saved_trace" bundle:[self fixtureBundle]];
    [player playTrace:trace onTarget:t completion:^(NSError * _Nullable playError) {
        XCTAssertNil(playError);
        [exp fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
