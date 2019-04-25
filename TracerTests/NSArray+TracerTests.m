//
//  NSArray+TracerTests.m
//  Tracer
//
//  Created by Ben Guo on 7/29/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSArray+Tracer.h"

@interface NSArray_TracerTests : XCTestCase

@end

@implementation NSArray_TracerTests

- (void)test_safeSubarray {
    NSArray *test = @[];
    XCTAssertNil([test trc_safeSubarrayWithRange:NSMakeRange(1, 1)]);

    test = @[@1, @2];
    XCTAssertNil([test trc_safeSubarrayWithRange:NSMakeRange(0, 3)]);

    test = @[@1, @2, @3, @4];
    NSArray *result = [test trc_safeSubarrayWithRange:NSMakeRange(1, 2)];
    NSArray *expected = @[@2, @3];
    XCTAssertEqualObjects(result, expected);
}

- (void)test_safeObjectAtIndex {
    NSArray *test = @[];
    XCTAssertNil([test trc_safeObjectAtIndex:5]);
    test = @[@1, @2, @3];
    XCTAssertNil([test trc_safeObjectAtIndex:5]);
    test = @[@1, @2, @3];
    XCTAssertEqual([test trc_safeObjectAtIndex:1], @2);
}

- (void)test_arrayByRemovingNulls_removesNullsDeeply {
    NSArray *array = @[
                       @"id",
                       [NSNull null], // null in root
                       @{
                           @"user": @"user_123",
                           @"country": [NSNull null], // null in dictionary
                           @"nicknames": @[
                                   @"john",
                                   @"johnny",
                                   [NSNull null], // null in array in dictionary
                                   ],
                           @"profiles": @{
                                   @"facebook": @"fb_123",
                                   @"twitter": [NSNull null], // null in dictionary in dictionary
                                   }
                           },
                       @[
                           [NSNull null], // null in array
                           @{
                               @"id": @"fee_123",
                               @"frequency": [NSNull null], // null in dictionary in array
                               },
                           @[
                               @"payment",
                               [NSNull null], // null in array in array
                               ],
                           ],
                       ];

    NSArray *expected = @[
                          @"id",
                          @{
                              @"user": @"user_123",
                              @"nicknames": @[
                                      @"john",
                                      @"johnny",
                                      ],
                              @"profiles": @{
                                      @"facebook": @"fb_123",
                                      }
                              },
                          @[
                              @{
                                  @"id": @"fee_123",
                                  },
                              @[
                                  @"payment",
                                  ],
                              ],
                          ];

    NSArray *result = [array trc_arrayByRemovingNulls];

    XCTAssertEqualObjects(result, expected);
}

- (void)test_arrayByRemovingNulls_keepsEmptyLeaves {
    NSArray *array = @[[NSNull null]];
    NSArray *result = [array trc_arrayByRemovingNulls];

    XCTAssertEqualObjects(result, @[]);
}

- (void)test_arrayByRemovingNulls_returnsImmutableCopy {
    NSArray *array = @[@"id", @"type"];
    NSArray *result = [array trc_arrayByRemovingNulls];

    XCTAssert(result);
    XCTAssertNotEqual(result, array);
    XCTAssertFalse([result isKindOfClass:[NSMutableArray class]]);
}

@end
