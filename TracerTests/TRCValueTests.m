//
//  TRCValueTests.m
//  TracerTests
//
//  Created by Ben Guo on 6/1/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TRCValue+Private.h"

@interface UnknownObject: NSObject
@property (nonatomic, nullable, strong) NSString *stringProp;
@property (nonatomic, nullable, strong) NSNumber *numberProp;
- (NSDictionary *)dictGetter;
- (NSArray *)arrayGetter;
@end
@implementation UnknownObject
- (instancetype)init {
    self = [super init];
    if (self) {
        _stringProp = @"stringValue";
        _numberProp = @(123);
    }
    return self;
}
- (NSDictionary *)dictGetter {
    return @{
             @"stringKey" : @(123)
             };
}
- (NSArray *)arrayGetter {
    return @[
             @"string",
             @(123),
             ];
}
@end

@interface TRCValueTests : XCTestCase

@end

@implementation TRCValueTests

- (void)testBuildWithUnknownObject {
    UnknownObject *obj = [UnknownObject new];
    TRCValue *value = [TRCValue buildWithObject:obj];
    XCTAssertEqual(value.type, TRCTypeObject);
    XCTAssertEqual(value.objectType, TRCObjectTypeUnknownObject);
    XCTAssertEqualObjects(value.objectClass, NSStringFromClass([UnknownObject class]));
    NSLog(@"%@", value.objectValue);
    XCTAssertEqual([[value.objectValue allKeys] count], 4);
}

- (void)testBuildWithInvalidJSONDictionary {
}

- (void)testBuildWithInvalidJSONArray {
}

@end
