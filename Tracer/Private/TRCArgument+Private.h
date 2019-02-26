//
//  TRCArgument+Private.h
//  Tracer
//
//  Created by Ben Guo on 2/25/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCArgument.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCArgument (Private)

/**
 https://nshipster.com/type-encodings/
 */
- (instancetype)initWithTypeEncoding:(NSString *)encoding
                       boxedArgument:(id)boxedArgument;

@end

NS_ASSUME_NONNULL_END
