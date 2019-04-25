//
//  NSDictionary+TracerTests.m
//  Tracer
//
//  Created by Ben Guo on 7/29/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSDictionary+Tracer.h"
#import "TRCJsonDecodable.h"

@interface NSDictionary_TracerTests : XCTestCase

@end

@interface MyDecodable: NSObject <TRCJsonDecodable>
@end
@implementation MyDecodable
+ (instancetype)decodedObjectFromJson:(NSDictionary *)json {
    MyDecodable *obj = [MyDecodable new];
    if ([json trc_boolForKey:@"invalid" or:NO]) {
        return nil;
    }
    return obj;
}
- (BOOL)isEqual:(id)object {
    return [object isMemberOfClass:[self class]];
}
@end

@implementation NSDictionary_TracerTests

- (void)test_dictionaryByRemovingNulls_removesNullsDeeply {
    NSDictionary *dictionary = @{
                                 @"id": @"card_123",
                                 @"tokenization_method": [NSNull null], // null in root
                                 @"metadata": @{
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
                                 @"fees": @[
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
                                 };

    NSDictionary *expected = @{
                               @"id": @"card_123",
                               @"metadata": @{
                                       @"user": @"user_123",
                                       @"nicknames": @[
                                               @"john",
                                               @"johnny",
                                               ],
                                       @"profiles": @{
                                               @"facebook": @"fb_123",
                                               },
                                       },
                               @"fees": @[
                                       @{
                                           @"id": @"fee_123",
                                           },
                                       @[
                                           @"payment",
                                           ],
                                       ],
                               };

    NSDictionary *result = [dictionary trc_dictionaryByRemovingNulls];

    XCTAssertEqualObjects(result, expected);
}

- (void)test_dictionaryByRemovingNulls_keepsEmptyLeaves {
    NSDictionary *dictionary = @{@"id": [NSNull null]};
    NSDictionary *result = [dictionary trc_dictionaryByRemovingNulls];

    XCTAssertEqualObjects(result, @{});
}

- (void)test_dictionaryByRemovingNulls_returnsImmutableCopy {
    NSDictionary *dictionary = @{@"id": @"card_123"};
    NSDictionary *result = [dictionary trc_dictionaryByRemovingNulls];

    XCTAssert(result);
    XCTAssertNotEqual(result, dictionary);
    XCTAssertFalse([result isKindOfClass:[NSMutableDictionary class]]);
}

#pragma mark - Getters

- (void)testArrayForKey {
    NSDictionary *dict = @{
                           @"a": @[@"foo"],
                           };

    XCTAssertEqualObjects([dict trc_arrayForKey:@"a"], @[@"foo"]);
    XCTAssertNil([dict trc_arrayForKey:@"b"]);
}

- (void)testBoxedBoolForKey {
    NSDictionary *dict = @{
                           @"a": @1,
                           @"b": @0,
                           @"c": @"true",
                           @"d": @"false",
                           @"e": @"1",
                           @"f": @"foo",
                           };

    XCTAssertEqualObjects([dict trc_boxedBoolForKey:@"a"], @YES);
    XCTAssertEqualObjects([dict trc_boxedBoolForKey:@"b"], @NO);
    XCTAssertEqualObjects([dict trc_boxedBoolForKey:@"c"], @YES);
    XCTAssertEqualObjects([dict trc_boxedBoolForKey:@"d"], @NO);
    XCTAssertEqualObjects([dict trc_boxedBoolForKey:@"e"], @YES);
    XCTAssertEqualObjects([dict trc_boxedBoolForKey:@"f"], @NO);
    XCTAssertNil([dict trc_boxedBoolForKey:@"g"]);
}

- (void)testBoolForKey {
    NSDictionary *dict = @{
                           @"a": @1,
                           @"b": @0,
                           @"c": @"true",
                           @"d": @"false",
                           @"e": @"1",
                           @"f": @"foo",
                           };

    XCTAssertTrue([dict trc_boolForKey:@"a" or:NO]);
    XCTAssertFalse([dict trc_boolForKey:@"b" or:YES]);
    XCTAssertTrue([dict trc_boolForKey:@"c" or:NO]);
    XCTAssertFalse([dict trc_boolForKey:@"d" or:YES]);
    XCTAssertTrue([dict trc_boolForKey:@"e" or:NO]);
    XCTAssertFalse([dict trc_boolForKey:@"f" or:NO]);
    XCTAssertTrue([dict trc_boolForKey:@"g" or:YES]);
}

- (void)testIntForKey {
    NSDictionary *dict = @{
                           @"a": @1,
                           @"b": @-1,
                           @"c": @"1",
                           @"d": @"-1",
                           @"e": @"10.0",
                           @"f": @"10.5",
                           @"g": @(10.0),
                           @"h": @(10.5),
                           @"i": @"foo",
                           };

    XCTAssertEqual([dict trc_intForKey:@"a" or:0], 1);
    XCTAssertEqual([dict trc_intForKey:@"b" or:0], -1);
    XCTAssertEqual([dict trc_intForKey:@"c" or:0], 1);
    XCTAssertEqual([dict trc_intForKey:@"d" or:0], -1);
    XCTAssertEqual([dict trc_intForKey:@"e" or:0], 10);
    XCTAssertEqual([dict trc_intForKey:@"f" or:0], 10);
    XCTAssertEqual([dict trc_intForKey:@"g" or:0], 10);
    XCTAssertEqual([dict trc_intForKey:@"h" or:0], 10);
    XCTAssertEqual([dict trc_intForKey:@"i" or:0], 0);
}

- (void)testDateForKey {
    NSDictionary *dict = @{
                           @"a": @0,
                           @"b": @"0",
                           };
    NSDate *expectedDate = [NSDate dateWithTimeIntervalSince1970:0];

    XCTAssertEqualObjects([dict trc_dateForKey:@"a"], expectedDate);
    XCTAssertEqualObjects([dict trc_dateForKey:@"b"], expectedDate);
    XCTAssertNil([dict trc_dateForKey:@"c"]);
}

- (void)testDictionaryForKey {
    NSDictionary *dict = @{
                           @"a": @{@"foo": @"bar"},
                           };

    XCTAssertEqualObjects([dict trc_dictionaryForKey:@"a"], @{@"foo": @"bar"});
    XCTAssertNil([dict trc_dictionaryForKey:@"b"]);
}

- (void)testNumberForKey {
    NSDictionary *dict = @{
                           @"a": @1,
                           };

    XCTAssertEqualObjects([dict trc_numberForKey:@"a"], @1);
    XCTAssertNil([dict trc_numberForKey:@"b"]);
}

- (void)testStringForKey {
    NSDictionary *dict = @{@"a": @"foo"};
    XCTAssertEqualObjects([dict trc_stringForKey:@"a"], @"foo");
    XCTAssertNil([dict trc_stringForKey:@"b"]);
}

- (void)testURLForKey {
    NSDictionary *dict = @{
                           @"a": @"https://example.com",
                           @"b": @"not a url"
                           };
    XCTAssertEqualObjects([dict trc_urlForKey:@"a"], [NSURL URLWithString:@"https://example.com"]);
    XCTAssertNil([dict trc_urlForKey:@"b"]);
    XCTAssertNil([dict trc_urlForKey:@"c"]);
}

- (void)testJsonDecodable {
    NSDictionary *json = @{@"a": @"foo", @"b": @"bar"};
    XCTAssertEqualObjects([NSDictionary decodedObjectFromJson:json], json);
}

- (void)testArrayOfDecodables {
    NSDictionary *json = @{
                           @"empty": @[],
                           @"string": @[@""],
                           @"dictionaries": @[@{}, @{}],
                           @"invalid-object": @[
                                   @{@"invalid": @YES},
                                   @{@"invalid": @NO},
                                   @{@"invalid": @NO},
                                   ],
                           };

    XCTAssertEqualObjects([json trc_arrayForKey:@"missing" deserializedAs:[MyDecodable class]],
                          [NSMutableArray new],
                          @"no array with that key returns empty mutable array");

    XCTAssertEqualObjects([json trc_arrayForKey:@"empty" deserializedAs:[MyDecodable class]],
                          [NSMutableArray new],
                          @"empty array with that key returns empty mutable array");

    XCTAssertEqualObjects([json trc_arrayForKey:@"string" deserializedAs:[MyDecodable class]],
                          [NSMutableArray new],
                          @"if array contains non-dictionaries, they are not deserialized");

    NSMutableArray *twoDecodedObjects = [@[[MyDecodable new], [MyDecodable new]] mutableCopy];

    XCTAssertEqualObjects([json trc_arrayForKey:@"dictionaries" deserializedAs:[MyDecodable class]],
                          twoDecodedObjects,
                          @"dictionaries are decoded using specified class");

    XCTAssertEqualObjects([json trc_arrayForKey:@"invalid-object" deserializedAs:[MyDecodable class]],
                          twoDecodedObjects,
                          @"if decoder returns nil, omitted from result");
}

@end
