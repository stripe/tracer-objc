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

- (void)testPlaybackFromFile {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCPlayer *player = [TRCPlayer new];
    TRCTrace *trace = [TRCTrace loadFromJSONFile:@"saved_trace"];
    [player playTrace:trace onTarget:t completion:^(NSError * _Nullable playError) {
        XCTAssertNil(playError);
        [exp fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
