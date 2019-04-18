# tracer-objc

Tracer lets you record & playback the behavior of arbitrary objects in Objective-C. (This may also be useful in Swift, but ymmv).

Let's say you have a dependency in your code, `ThatThing`. You call `ThatThing`, it calls you back, and behavior varies depending on input. Testing this code is hard.

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

Tracer lets you record the behavior of this object as a trace:

```objective-c
ThatThing *thing = [ThatThing new];
TRCRecorder *recorder = [TRCRecorder new];
[recorder startRecording:thing protocol:@protocol(ThatInterface)];
NSString *result = [thing someCommand:-100];
[recorder stopRecording:thing protocol:@protocol(ThatInterface) completion:^(TRCTrace *trace, NSError *error) {
    // save trace
}];
```

After recording completes, Tracer prints the trace to the console as JSON, which you can save to a file:

```json
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

In your tests, instead of painstakingly mocking the behavior of `ThatThing`, you can simply playback a recorded trace:

```objective-c
ThatThing *thing = [ThatThing new];
TRCTrace *trace = [TRCTrace loadFromJSONFile:@"saved_trace"];
[TRCPlayer playTrace:trace onTarget:thing completion:^(NSError * _Nullable error) {

}];
```
