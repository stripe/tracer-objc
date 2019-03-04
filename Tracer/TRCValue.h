//
//  TRCValue.h
//  Tracer
//
//  Created by Ben Guo on 2/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRCJsonEncodable.h"
#import "TRCType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCValue : NSObject <TRCJsonEncodable>

@property (atomic, readonly) TRCType type;
@property (atomic, readonly) TRCObjectType objectType;

/**
 The argument's class. Nil if the argument is a primitive.
 */
@property (atomic, nullable, readonly) NSString *objectClass;

/**
 The argument's value.
 If the argument has type Primitive, this is the boxed value.
 If the argument has type UnknownObject, this is nil.
 */
@property (atomic, nullable, readonly) id objectValue;

@end

NS_ASSUME_NONNULL_END
