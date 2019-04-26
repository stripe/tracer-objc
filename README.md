# Tracer 

Tracer is an experimental testing tool that lets you record & play back the behavior of arbitrary objects in Objective-C.

Let's say you have a dependency in your code, `ThatThing`. You call `ThatThing`, it calls you back, and behavior varies depending on user input or environmental factors. 

```objective-c
@protocol ThatInterface <NSObject>
- (void)someCommand:(int)i;
- (void)someOtherCommand:(NSArray *)objects;
// ...
- (void)onError:(NSError *)error;
- (void)onOtherError:(NSError *)error;
@end

@interface ThatThing : NSObject <ThatInterface>
@end
```

Testing complex async behavior is hard, especially if you don't control the source of behavior.

Tracer lets you **record behavior** of `ThatThing` as a trace:

```objective-c
ThatThing *thing = [ThatThing new];
TRCRecorder *recorder = [TRCRecorder new];
[recorder startRecording:thing protocol:@protocol(ThatInterface)];
NSString *result = [thing someCommand:-100];
[recorder stopRecording:thing protocol:@protocol(ThatInterface) completion:^(TRCTrace *trace, NSError *error) {
    // save trace
}];
```

After recording completes, Tracer prints the trace to the console as JSON, so you can **save behavior to a file**.

```txt
2019-04-17 23:01:22.689124-0700 xctest[62038:4377601] -----BEGIN TRACE JSON-----
{
  "start_ms" : 1551678464427,
  "id" : "trace",
  "protocol" : "SomeProtocol",
  "calls" : [
    {
      "id" : "call",
      "start_ms" : 203,
      "method" : "someCommand:",
      "arguments" : [
        {
          "id" : "value",
          "type" : "int",
          "object_type" : "not_an_object",
          "object_value" : -100
        }
      ],
      "return_value" : {
        "id" : "value",
        "type" : "void",
      }
    }
  ]
}
-----END TRACE JSON-----
```

In your tests, instead of mocking the complex behavior of `ThatThing`, you can simply **play recorded behavior**:

```objective-c
ThatThing *thing = [ThatThing new];
TRCTrace *trace = [TRCTrace loadFromJSONFile:@"saved_trace"];
[TRCPlayer playTrace:trace onTarget:thing completion:^(NSError * _Nullable error) {

}];
```

### Current limitations

- Tracer doesn't support hooking async behavior (e.g. completion blocks)
- You must provide a protocol to scope recording
- Optional protocol methods won't be recorded
- Naive introspection when recording unknown object types (Tracer simply records the object's `description`)


