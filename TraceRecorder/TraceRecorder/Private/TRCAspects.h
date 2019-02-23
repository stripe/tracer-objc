//
//  Aspects.h
//  Aspects - A delightful, simple library for aspect oriented programming.
//
//  Copyright (c) 2014 Peter Steinberger. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, TRCAspectOptions) {
    /// Called after the original implementation (default)
    TRCAspectPositionAfter   = 0,
    /// Will replace the original implementation.
    TRCAspectPositionInstead = 1,
    /// Called before the original implementation.
    TRCAspectPositionBefore  = 2,

    /// Will remove the hook after the first execution.
    TRCAspectOptionAutomaticRemoval = 1 << 3
};

/// Opaque Aspect Token that allows to deregister the hook.
@protocol TRCAspectToken <NSObject>

/// Deregisters an aspect.
/// @return YES if deregistration is successful, otherwise NO.
- (BOOL)remove;

@end

/// The AspectInfo protocol is the first parameter of our block syntax.
@protocol TRCAspectInfo <NSObject>

/// The instance that is currently hooked.
- (id)instance;

/// The original invocation of the hooked method.
- (NSInvocation *)originalInvocation;

/// All method arguments, boxed. This is lazily evaluated.
- (NSArray *)arguments;

@end

/**
 Aspects uses Objective-C message forwarding to hook into messages. This will create some overhead. Don't add aspects to methods that are called a lot. Aspects is meant for view/controller code that is not called a 1000 times per second.

 Adding aspects returns an opaque token which can be used to deregister again. All calls are thread safe.
 */
@interface NSObject (TRCAspects)

/// Adds a block of code before/instead/after the current `selector` for a specific class.
///
/// @param block Aspects replicates the type signature of the method being hooked.
/// The first parameter will be `id<TRCAspectInfo>`, followed by all parameters of the method.
/// These parameters are optional and will be filled to match the block signature.
/// You can even use an empty block, or one that simple gets `id<TRCAspectInfo>`.
///
/// @note Hooking static methods is not supported.
/// @return A token which allows to later deregister the aspect.
+ (id<TRCAspectToken>)trc_aspect_hookSelector:(SEL)selector
                                  withOptions:(TRCAspectOptions)options
                                   usingBlock:(id)block
                                        error:(NSError **)error;

/// Adds a block of code before/instead/after the current `selector` for a specific instance.
- (id<TRCAspectToken>)trc_aspect_hookSelector:(SEL)selector
                                  withOptions:(TRCAspectOptions)options
                                   usingBlock:(id)block
                                        error:(NSError **)error;

@end

void linkAspectsCategory(void);


typedef NS_ENUM(NSUInteger, TRCAspectErrorCode) {
    /// Selectors like release, retain, autorelease are blacklisted.
    TRCAspectErrorSelectorBlacklisted,
    /// Selector could not be found.
    TRCAspectErrorDoesNotRespondToSelector,
    /// When hooking dealloc, only AspectPositionBefore is allowed.
    TRCAspectErrorSelectorDeallocPosition,
    /// Statically hooking the same method in subclasses is not allowed.
    TRCAspectErrorSelectorAlreadyHookedInClassHierarchy,
    /// The runtime failed creating a class pair.
    TRCAspectErrorFailedToAllocateClassPair,
    /// The block misses compile time signature info and can't be called.
    TRCAspectErrorMissingBlockSignature,
    /// The block signature does not match the method or is too large.
    TRCAspectErrorIncompatibleBlockSignature,

    /// (for removing) The object hooked is already deallocated.
    TRCAspectErrorRemoveObjectAlreadyDeallocated = 100
};

extern NSString *const TRCAspectErrorDomain;
