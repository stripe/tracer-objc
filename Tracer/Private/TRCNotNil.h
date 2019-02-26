//
//  TRCNotNil.h
//  StripeTerminal
//
//  Created by Ben Guo on 1/11/18.
//  Copyright © 2018 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Based on RBBNotNil from
 https://gist.github.com/robb/d55b72d62d32deaee5fa
 */

// We purposefully don't have a matching @implementation.
// We don't want +asNonnull to ever actually be called
// because that will add a lot of overhead to every TRCNotNil
// and we want TRCNotNil to be very cheap.
// If there is no @implementation, then if the +asNonnull is
// actually called, we'll get a linker error complaining about
// the lack of @implementation.
@interface SCPBox <__covariant Type>

// This as a class method so you don't need to
// declare an unused lvalue just for a __typeof
+ (Type _Nonnull)asNonnull;

@end

/*!
 * @define TRCNotNil(V)
 * Converts an Objective-C object expression from _Nullable to _Nonnull.
 * Crashes if it receives a nil! We must crash or else we'll receive
 * static analyzer warnings when archiving. I think in Release mode,
 * the compiler ignores the _Nonnull cast.
 * @param V a _Nullable Objective-C object expression
 */
#define TRCNotNil(V) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wgnu-statement-expression\"") \
({ \
__typeof__(V) __nullableV = V; \
NSCAssert(__nullableV, @"Expected '%@' not to be nil.", @#V); \
if (!__nullableV) { \
abort(); \
} \
(__typeof([SCPBox<__typeof(V)> asNonnull]))__nullableV; \
}) \
_Pragma("clang diagnostic pop")

NS_ASSUME_NONNULL_END
