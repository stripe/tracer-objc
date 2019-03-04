//
//  TRCType.h
//  Tracer
//
//  Created by Ben Guo on 3/3/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TRCType) {
    TRCTypeUnknown,
    TRCTypeChar,
    TRCTypeInt,
    TRCTypeShort,
    TRCTypeLong,
    TRCTypeLongLong,
    TRCTypeUnsignedChar,
    TRCTypeUnsignedInt,
    TRCTypeUnsignedShort,
    TRCTypeUnsignedLong,
    TRCTypeUnsignedLongLong,
    TRCTypeFloat,
    TRCTypeDouble,
    TRCTypeBool,
    TRCTypeVoid,
    TRCTypeCharacterString,
    TRCTypeCGPoint,
    TRCTypeCGSize,
    TRCTypeCGRect,
    TRCTypeUIEdgeInsets,
    TRCTypeObject,
    TRCTypeClass,
    TRCTypeSEL,
    TRCTypeIMP,
};

typedef NS_ENUM(NSUInteger, TRCObjectType) {
    TRCObjectTypeNotAnObject,
    TRCObjectTypeJsonObject,
    TRCObjectTypeUnknownObject,
};
