//
//  TRCPlayer.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <objc/runtime.h>

#import "TRCPlayer.h"

#import "TRCValue+Private.h"
#import "TRCTrace+Private.h"
#import "TRCCall+Private.h"
#import "TRCDispatchFunctions.h"
#import "TRCNotNil.h"
#import "TRCErrors+Private.h"
#import "TRCFixtureProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCPlayer ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *traceIdToObjectArgs;

@end

@implementation TRCPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _traceIdToObjectArgs = [NSMutableDictionary new];
    }
    return self;
}

- (void)playTrace:(TRCTrace *)trace
         onTarget:(id)target
       completion:(TRCErrorCompletionBlock)completion {
    [self _playTrace:trace
           onTarget:target
withFixtureProvider:nil
         completion:completion];
}

- (void)playTrace:(TRCTrace *)trace
          onTarget:(id)target
withFixtureProvider:(id<TRCFixtureProvider>)fixtureProvider
        completion:(TRCErrorCompletionBlock)completion {
    [self _playTrace:trace
            onTarget:target
 withFixtureProvider:fixtureProvider
          completion:completion];
}

- (void)_playTrace:(TRCTrace *)trace
         onTarget:(id)target
withFixtureProvider:(nullable id<TRCFixtureProvider>)fixtureProvider
       completion:(TRCErrorCompletionBlock)completion {
    // TODO: validate target against trace

    NSString *traceId = [trace internalId];

    void (^cleanup)(void) = ^void() {
        // clear retained objects
        if (traceId != nil) {
            [self.traceIdToObjectArgs removeObjectForKey:traceId];
        }
    };

    NSTimeInterval longestDelay = 0;
    BOOL stopPlaying = NO;
    NSError *stopPlayingError = nil;
    for (TRCCall *call in trace.calls) {
        if (stopPlaying) {
            break;
        }

        SEL aSelector = NSSelectorFromString(call.method);
        NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:target];
        [invocation setSelector:aSelector];

        NSTimeInterval delay = ((double)call.millis)/1000.0;
        longestDelay = MAX(longestDelay, delay);

        for (NSUInteger i = 0; i < [call.arguments count]; i++) {
            TRCValue *arg = call.arguments[i];
            // indices 0 and 1 indicate the hidden arguments self and _cmd
            NSUInteger index = i + 2;
            NSValue *__nullable objectValue = (NSValue *)arg.objectValue;
            TRCObjectType objectType = arg.objectType;
            TRCType type = arg.type;
            switch (type) {
                case TRCTypeObject: {
                    id invocationArgument = nil;
                    switch (objectType) {
                        case TRCObjectTypeNotAnObject: {
                            NSString *message = [NSString stringWithFormat:@"Invalid argument in trace: %@", arg.jsonObject];
                             stopPlayingError = [TRCErrors buildError:TRCErrorPlaybackFailedUnexpectedError
                                                              call:call
                                                           message:message];
                            stopPlaying = YES;
                        } break;
                        case TRCObjectTypeUnknownObject: {
                            if (fixtureProvider != nil) {
                                __nullable id fixture = [fixtureProvider player:self didRequestFixtureForValue:arg];
                                if (fixture == nil) {
                                    stopPlayingError = [TRCErrors buildError:TRCErrorPlaybackFailedFixtureProviderReturnedNil];
                                    stopPlaying = YES;
                                }
                                else {
                                    invocationArgument = fixture;
                                }
                            }
                            else {
                                NSString *message = [NSString stringWithFormat:@"Can't play argument containing unknown object: %@", arg.objectClass];
                                stopPlayingError = [TRCErrors buildError:TRCErrorPlaybackFailedUnknownObject
                                                                    call:call
                                                                 message:message];
                                stopPlaying = YES;
                            }
                        } break;
                        case TRCObjectTypeJsonObject: break;
                    }
                    // retain object arguments
                    NSString *argId = [NSString stringWithFormat:@"%@_%lu", [call internalId], i];
                    NSMutableDictionary *argIdToArg = self.traceIdToObjectArgs[traceId];
                    if (argIdToArg == nil) {
                        argIdToArg = [NSMutableDictionary new];
                    }
                    if (invocationArgument == nil) {
                        invocationArgument = (NSObject *)objectValue;
                    }
                    argIdToArg[argId] = invocationArgument;
                    self.traceIdToObjectArgs[traceId] = argIdToArg;
                    [invocation setArgument:&invocationArgument atIndex:index];
                } break;
                case TRCTypeInt: {
                    int value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeUnsignedInt: {
                    unsigned int value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeFloat: {
                    float value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeBool: {
                    BOOL value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeDouble: {
                    double value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                    // TODO: test playback of more primitive types
                case TRCTypeCharacterString: {
                    const char *value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeClass: {
                    Class value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeShort: {
                    short value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeUnsignedShort: {
                    unsigned short value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeLong: {
                    long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeUnsignedLong: {
                    unsigned long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeLongLong: {
                    long long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeUnsignedLongLong: {
                    unsigned long long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeChar: {
                    char value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeUnsignedChar: {
                    unsigned char value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeSEL: {
                    SEL value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCTypeVoid: {

                } break;
                case TRCTypeIMP:
                case TRCTypeCGRect:
                case TRCTypeCGSize:
                case TRCTypeCGPoint:
                case TRCTypeUIEdgeInsets:
                case TRCTypeUnknown: {
                    NSString *typeString = [TRCValue stringFromType:type];
                    NSString *message = [NSString stringWithFormat:@"Can't play argument containing unsupported type: %@", typeString];
                    stopPlayingError = [TRCErrors buildError:TRCErrorPlaybackFailedUnsupportedType
                                                      call:call
                                                   message:message];
                    stopPlaying = YES;
                }
            }
        }

        if (!stopPlaying) {
            trcDispatchToMainAfter(delay, ^{
                [invocation invoke];
            });
        }
    }
    trcDispatchToMainAfter(longestDelay, ^{
        completion(stopPlayingError);
        cleanup();
    });
}

@end

NS_ASSUME_NONNULL_END
