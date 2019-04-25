//
//  TRCRecorder.m
//  Tracer
//
//  Created by Ben Guo on 2/22/19.
//  Copyright © 2019 tracer. All rights reserved.
//

#import "TRCRecorder.h"

#import <objc/runtime.h>

#import "TRCValue+Private.h"
#import "TRCAspects.h"
#import "TRCCall+Private.h"
#import "TRCTrace+Private.h"
#import "NSDate+Tracer.h"
#import "TRCErrors+Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRCRecorder ()

@property (atomic, strong, readwrite) dispatch_queue_t tracesQueue;
@property (atomic, strong, readonly) NSMutableDictionary<NSString*,TRCTrace*>*keyToTrace;

@end

@implementation TRCRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        _tracesQueue = dispatch_queue_create("com.tracer.tracerecorder.traces", DISPATCH_QUEUE_SERIAL);
        _keyToTrace = [NSMutableDictionary new];
    }
    return self;
}

- (NSString *)buildKeyWithSource:(id)instance protocol:(Protocol *)protocol {
    return [@[
             NSStringFromClass([instance class]),
             NSStringFromProtocol(protocol),
             ] componentsJoinedByString:@"."];
}

- (void)startRecording:(id)source protocol:(Protocol *)protocol {
    NSDate *start = [NSDate date];

    NSString *key = [self buildKeyWithSource:source protocol:protocol];

    // list methods
    BOOL showRequiredMethods = YES;
    BOOL showInstanceMethods = YES;
    unsigned int methodCount = 0;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, showRequiredMethods, showInstanceMethods, &methodCount);

    // get selectors
    NSMutableArray<NSValue*>*methodSelectors = [NSMutableArray new];
    NSMutableArray<NSMethodSignature*>*methodSigs = [NSMutableArray new];
    for (NSUInteger i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methodList[i];
        NSValue *sel = [NSValue valueWithPointer:methodDescription.name];
        [methodSelectors addObject:sel];
        NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
        [methodSigs addObject:sig];
    }

    // hook selectors to record calls
    for (NSUInteger i = 0; i < [methodSelectors count]; i++) {
        NSValue *selValue = methodSelectors[i];
        NSMethodSignature *sig = methodSigs[i];

        // get types
        // TODO: refactor to build types inside TRCCall from the NSInvocation
        NSMutableArray *typeEncodings = [NSMutableArray new];
        for (NSUInteger j = 0; j < sig.numberOfArguments; j++) {
            NSString *ts = [NSString stringWithUTF8String:[sig getArgumentTypeAtIndex:j]];
            [typeEncodings addObject:ts];
        }
        // indices 0 and 1 indicate the hidden arguments self and _cmd
        if ([typeEncodings count] >= 2) {
            [typeEncodings removeObjectAtIndex:0];
            [typeEncodings removeObjectAtIndex:0];
        }

        SEL sel = (SEL)selValue.pointerValue;
        Class klass = [source class];
        [klass trc_aspect_hookSelector:sel withOptions:TRCAspectPositionAfter usingBlock:^(id<TRCAspectInfo> info){
            NSUInteger ms = [[NSDate date] trc_millisSinceDate:start];

            NSMutableArray<TRCValue*>*args = [NSMutableArray new];
            for (NSUInteger j = 0; j < [typeEncodings count]; j++) {
                NSString *encoding = typeEncodings[j];
                id boxedArg = info.arguments[j];
                TRCValue *argument = [[TRCValue alloc] initWithTypeEncoding:encoding
                                                              boxedArgument:boxedArg];
                [args addObject:argument];
            }

            TRCCall *call = [[TRCCall alloc] initWithSelector:sel
                                                   invocation:info.originalInvocation
                                                      arguments:[args copy]
                                                         millis:ms];
            dispatch_async(self.tracesQueue, ^{
                TRCTrace *trace = self.keyToTrace[key];
                if (trace == nil) {
                    trace = [[TRCTrace alloc] initWithProtocol:protocol];
                }
                [trace addCall:call];
                self.keyToTrace[key] = trace;
            });
        } error:nil];
    }

    free(methodList);
}

- (void)stopRecording:(id)source
             protocol:(Protocol *)protocol
           completion:(TRCTraceCompletionBlock)completion {
    NSString *key = [self buildKeyWithSource:source protocol:protocol];
    dispatch_async(self.tracesQueue, ^{
        TRCTrace *trace = self.keyToTrace[key];
        if (trace != nil) {
            if (![NSJSONSerialization isValidJSONObject:trace.jsonObject]) {
                NSError *invalidJsonError = [TRCErrors buildError:TRCErrorRecordingFailedInvalidTraceJson];
                completion(nil, invalidJsonError);
            }
            else {
                NSError *jsonWritingError;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:trace.jsonObject
                                                                   options:(NSJSONWritingOptions)NSJSONWritingPrettyPrinted
                                                                     error:&jsonWritingError];
                if (jsonWritingError != nil) {
                    completion(nil, jsonWritingError);
                }
                else {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    if (jsonString == nil) {
                        NSError *serializationError = [TRCErrors buildError:TRCErrorRecordingFailedTraceJsonSerializationError];
                        completion(nil, serializationError);
                    }
                    else {
                        NSString *header = @"-----BEGIN TRACE JSON-----";
                        NSString *footer = @"-----END TRACE JSON-----";
                        NSArray *lines = @[
                                           header,
                                           jsonString,
                                           footer,
                                           ];
                        NSString *message = [lines componentsJoinedByString:@"\n"];
                        NSLog(@"%@", message);
                    }
                    completion(trace, nil);
                }
            }
        }
        else {
            NSError *error = [TRCErrors buildError:TRCErrorRecordingFailedUnexpectedError];
            completion(nil, error);
        }
        [self.keyToTrace removeObjectForKey:key];
    });
}

@end

NS_ASSUME_NONNULL_END
