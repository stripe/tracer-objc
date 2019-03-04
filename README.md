# tracer-objc

Tracer lets you record the behavior of arbitrary objects and play it back.

Let's say you have a legacy dependency that calls your code. The interface is well-defined, but fairly complex (e.g. behavior varies depending on external input). You've developed a mental model for this complex behavior, and your code handles different behaviors well, but you have a hard time sharing your intuitive understanding of the system with collaborators, and your test coverage is low. 

Logging, UI automation, HTTP-focused record & playback systems, and manual QA can all help in a situation like this, but it felt like there was a missing tool.

```objective-c
@protocol SomeProtocol <NSObject>
- (NSString *)someMethod:(int)i;
@end

@interface Thing : NSObject <SomeProtocol>
@end
```

```objective-c
Thing *thing = [Thing new];
TRCRecorder *recorder = [TRCRecorder new];
[recorder startRecording:thing protocol:@protocol(SomeProtocol)];
NSString *result = [thing someMethod:-100];
[recorder stopRecording:thing protocol:@protocol(SomeProtocol) completion:^(TRCTrace *trace, NSError *error) {
    // save trace
}];
```

```json
{
  "start_ms" : 1551678464427,
  "id" : "trace",
  "protocol" : "SomeProtocol",
  "calls" : [
    {
      "arguments" : [
        {
          "id" : "value",
          "type" : "int",
          "object_type" : "not_an_object",
          "object_value" : -100
        }
      ],
      "id" : "value",
      "method" : "someMethod:",
      "start_ms" : 203,
      "return_value" : {
        "object_class" : "NSString",
        "id" : "value",
        "type" : "object",
        "object_type" : "json_object",
        "object_value" : "string"
      }
    }
  ]
}
```

```objective-c
// load trace
[TRCPlayer playTrace:trace onTarget:thing completion:^(NSError * _Nullable error) {
    // playback complete
}];
```


## TODO
- [ ] automatically detect and trace completion blocks
- [ ] detect when json encoding method is available for non-json object
- [ ] add interface for injecting fixtures for non-json objects
- [ ] how often does this work with swift
- [ ] more exhaustive tests
