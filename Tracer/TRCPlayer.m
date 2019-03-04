//
//  TRCPlayer.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import <objc/runtime.h>

#import "TRCPlayer.h"

#import "TRCArgument+Private.h"
#import "TRCTrace+Private.h"
#import "TRCCall+Private.h"
#import "TRCDispatchFunctions.h"
#import "TRCNotNil.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCPlayer ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *traceIdToObjectArgs;

@end

@implementation TRCPlayer

static TRCPlayer *_shared = nil;

// example: creating a mock subclass
//    NSString *className = trace[@"class"];
//    Class mockClass = objc_allocateClassPair(NSClassFromString(className), "TraceClassMock", 0);
//    objc_registerClassPair(mockClass);
//    self.mock = [[mockClass alloc] init];

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[TRCPlayer alloc] init];
    });
    return _shared;
}

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
    // TODO: validate target against trace

    NSString *traceId = [trace internalId];

    NSTimeInterval longestDelay = 0;
    for (TRCCall *call in trace.calls) {

        SEL aSelector = NSSelectorFromString(call.method);
        NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:target];
        [invocation setSelector:aSelector];

        NSTimeInterval delay = ((double)call.millis)/1000.0;
        longestDelay = MAX(longestDelay, delay);

        for (NSUInteger i = 0; i < [call.arguments count]; i++) {
            TRCArgument *arg = call.arguments[i];
            // indices 0 and 1 indicate the hidden arguments self and _cmd
            NSUInteger index = i + 2;
            NSValue *objectValue = (NSValue *)TRCNotNil(arg.objectValue);
            TRCArgumentType type = arg.type;
            switch (type) {
                case TRCArgumentTypeObject: {
                    // retain object arguments
                    NSString *argId = [NSString stringWithFormat:@"%@_%lu", [call internalId], i];
                    NSMutableDictionary *argIdToArg = self.traceIdToObjectArgs[traceId];
                    if (argIdToArg == nil) {
                        argIdToArg = [NSMutableDictionary new];
                    }
                    id object = (NSObject *)objectValue;
                    argIdToArg[argId] = object;
                    self.traceIdToObjectArgs[traceId] = argIdToArg;
                    [invocation setArgument:&object atIndex:index];
                } break;
                case TRCArgumentTypeInt: {
                    int value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeUnsignedInt: {
                    unsigned int value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeFloat: {
                    float value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeBool: {
                    BOOL value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeDouble: {
                    double value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                    // TODO: test playback of more primitive types
                case TRCArgumentTypeCharacterString: {
                    const char *value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeClass: {
                    Class value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeShort: {
                    short value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeUnsignedShort: {
                    unsigned short value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeLong: {
                    long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeUnsignedLong: {
                    unsigned long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeLongLong: {
                    long long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeUnsignedLongLong: {
                    unsigned long long value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeChar: {
                    char value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeUnsignedChar: {
                    unsigned char value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeSEL: {
                    SEL value;
                    [objectValue getValue:&value];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case TRCArgumentTypeVoid: {

                } break;
                case TRCArgumentTypeIMP:
                case TRCArgumentTypeCGRect:
                case TRCArgumentTypeCGSize:
                case TRCArgumentTypeCGPoint:
                case TRCArgumentTypeUIEdgeInsets:
                case TRCArgumentTypeUnknown: {
                    NSString *typeString = [TRCArgument stringFromArgumentType:type];
                    NSString *message = [NSString stringWithFormat:@"Playback is unsupported for this argument type: %@", typeString];
                    NSAssert(NO, message);
                }
            }
        }

        trcDispatchToMainAfter(delay, ^{
            [invocation invoke];
        });
    }
    trcDispatchToMainAfter(longestDelay + 1, ^{
        completion(nil);

        // clear retained objects
        [self.traceIdToObjectArgs removeObjectForKey:traceId];
    });
}

+ (void)playTrace:(TRCTrace *)trace
         onTarget:(id)target
       completion:(TRCErrorCompletionBlock)completion {
    [[TRCPlayer shared] playTrace:trace onTarget:target completion:completion];
}

@end

NS_ASSUME_NONNULL_END
