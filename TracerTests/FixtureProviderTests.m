//
//  FixtureProviderTests.m
//  TracerTests
//
//  Created by Ben Guo on 4/17/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Tracer/Tracer.h>
#import "TRCTestTarget.h"
#import "TRCDispatchFunctions.h"

@interface FixtureProviderTests : XCTestCase <TRCFixtureProvider>

@end

@implementation FixtureProviderTests

- (void)testSingleFixture {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            TRCCustomObject *o = [TRCCustomObject new];
                            o.value = @"one";
                            [t ret_void__args_custom_object:o];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
                                TRCPlayer *player = [TRCPlayer new];
                                [player playTrace:trace
                                         onTarget:t
                              withFixtureProvider:self
                                       completion:^(NSError * _Nullable playError) {
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

- (void)testFixtureArray {
    XCTestExpectation *exp = [self expectationWithDescription:@"done"];
    TRCTestTarget *t = [[TRCTestTarget alloc] init];
    TRCRecorder *recorder = [TRCRecorder new];
    [recorder startRecording:t protocol:@protocol(TRCTestProtocol)];

    NSArray *blocks = @[
                        (^{
                            TRCCustomObject *one = [TRCCustomObject new];
                            one.value = @"one";
                            TRCCustomObject *two = [TRCCustomObject new];
                            two.value = @"two";
                            TRCCustomObject *three = [TRCCustomObject new];
                            three.value = @"three";
                            [t ret_void__args_custom_object_array:@[one, two, three]];
                        }),
                        (^{
                            [recorder stopRecording:t protocol:@protocol(TRCTestProtocol) completion:^(TRCTrace * _Nullable trace, NSError * _Nullable recError) {
                                XCTAssertNotNil(trace);
                                XCTAssertNil(recError);
                                TRCPlayer *player = [TRCPlayer new];
                                [player playTrace:trace
                                         onTarget:t
                              withFixtureProvider:self
                                       completion:^(NSError * _Nullable playError) {
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

- (id)player:(TRCPlayer *)player didRequestFixtureForValue:(TRCValue *)value {
    if ([value.objectClass isEqualToString:NSStringFromClass([TRCCustomObject class])]) {
        TRCCustomObject *fixture = [TRCCustomObject new];
        fixture.value = @"one";
        return fixture;
    }
    else {
        NSLog(@"%@", value);
        return nil;
    }
}

@end
