//
//  TRCValue.h
//  Tracer
//
//  Created by Ben Guo on 2/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCJsonDecodable.h"
#import "TRCJsonEncodable.h"
#import "TRCType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A trace value.
 A call's arguments are represented as an array of TRCValues.
 */
NS_SWIFT_NAME(TraceValue)
@interface TRCValue : NSObject <TRCJsonEncodable, TRCJsonDecodable>

/**
 The value's type.
 */
@property (atomic, readonly) TRCType type;

/**
 The value's object type.
 */
@property (atomic, readonly) TRCObjectType objectType;

/**
 The value's class.
 If the value has type Primitive, this is nil.
 */
@property (atomic, nullable, readonly) NSString *objectClass;

/**
 The value's object value.
 If the value has type Primitive, this is the boxed value.
 If the value has type UnknownObject, UnknownArray, or UnknownDictionary,
 this is the String returned by the object's `description` selector.
 */
@property (atomic, nullable, readonly) id objectValue;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
