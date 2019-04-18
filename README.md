# tracer-objc <img src="https://img.shields.io/badge/Experimental-9cf.svg">

Tracer lets you record & playback the behavior of arbitrary objects in Objective-C.

Let's say you have a dependency in your code, `ThatThing`. You call `ThatThing`, it calls you back, and behavior varies depending on input. Testing complex async behavior is hard, especially if you don't control the source of behavior.

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

Tracer lets you record the behavior of `ThatThing` as a trace:

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

In your tests, instead of mocking the complex behavior of `ThatThing`, you can simply playback a recorded trace:

```objective-c
ThatThing *thing = [ThatThing new];
TRCTrace *trace = [TRCTrace loadFromJSONFile:@"saved_trace"];
[TRCPlayer playTrace:trace onTarget:thing completion:^(NSError * _Nullable error) {

}];
```



