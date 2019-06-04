#import "AudioPlayerServicePlugin.h"

@implementation AudioPlayerServicePlugin{
  FlutterMethodChannel* _channel;
  AudioPlayer* _audioPlayer;
}

+ (id)sharedManager {
    static AudioPlayerServicePlugin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"audio_player_service"
            binaryMessenger:[registrar messenger]];
  [[AudioPlayerServicePlugin sharedManager] setChannel: channel];
  [registrar addMethodCallDelegate:[AudioPlayerServicePlugin sharedManager] channel:channel];
}

- (id)init {
  if (self = [super init]) {
    _audioPlayer = [AudioPlayer sharedManager];
    [_audioPlayer addListener:self];
  }
  return self;
}

- (void)setChannel:(FlutterMethodChannel*)channel {
  _channel = channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  
  if ([@"initPlayerQueue" isEqualToString:call.method]) {
    
    NSDictionary* args = call.arguments;

    NSLog(@"\nplatform: initPlayerQueue items: %@", [args objectForKey:@"items"]);

    [_audioPlayer playerStop];
    [_audioPlayer initPlayerQueue: [args objectForKey:@"items"]];

    result(nil);
  
  } else if ([@"play" isEqualToString:call.method]) {
    
    NSLog(@"\nplatform: play");

    [_audioPlayer playerPlayPause];

    result(nil);
  
  } else if ([@"pause" isEqualToString:call.method]) {
    
    NSLog(@"\nplatform: pause");

    [_audioPlayer playerPlayPause];

    result(nil);
  
  } else if ([@"stop" isEqualToString:call.method]) {
    
    NSLog(@"\nplatform: stop");

    [_audioPlayer playerStop];

    result(nil);
  
  } else if ([@"next" isEqualToString:call.method]) {
    
    NSLog(@"\nplatform: next");

    [_audioPlayer playerNext];

    result(nil);
  
  } else if ([@"prev" isEqualToString:call.method]) {
    
    NSLog(@"\nplatform: prev");

    [_audioPlayer playerPrevious];

    result(nil);
  
  } else if ([@"seek" isEqualToString:call.method]) {
    
    NSDictionary* args = call.arguments;
    
    NSLog(@"\nplatform: seek args: %@", args);

    [_audioPlayer playerSeek: [NSNumber numberWithInt: [[args objectForKey:@"seekPosition"] intValue]]];

    result(nil);
  
  } else if ([@"setIndex" isEqualToString:call.method]) {
    
    NSDictionary* args = call.arguments;

    NSLog(@"\nplatform: setIndex args: %@", args);

    [_audioPlayer setPlayerIndex: [[args objectForKey:@"index"] intValue]];

    result(nil);
  
  } else {
  
    result(FlutterMethodNotImplemented);
  
  }

}

# pragma mark AudioPlayerListener
//----------- AudioPlayerListener -----------
- (void) onAudioLoading {
  NSLog(@"\nonAudioLoading");
  [_channel invokeMethod:@"onAudioLoading" arguments:nil];
}

- (void) onBufferingUpdate:(int) percent {
  NSLog(@"\nonBufferingUpdate: %i", percent);
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:percent], @"percent",
                        nil];
  [_channel invokeMethod:@"onBufferingUpdate" arguments:args];
}

- (void) onAudioReady:(long) audioLengthInMillis {
  NSLog(@"\nonAudioReady");
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithLong:audioLengthInMillis], @"audioLength",
                        nil];
  [_channel invokeMethod:@"onAudioReady" arguments:args];
}

- (void) onPlayerPlaying {
  NSLog(@"\nonPlayerPlaying");
  [_channel invokeMethod:@"onPlayerPlaying" arguments:nil];
}

- (void) onFailedPrepare {
  NSLog(@"\nonFailedPrepare");
  [_channel invokeMethod:@"onFailedPrepare" arguments:nil];
}

- (void) onPlayerPlaybackUpdate:(NSNumber*)position :(long)audioLength {
  NSLog(@"\nonPlayerPlaybackUpdate - position: %@", position);
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        position, @"position",
                        [NSNumber numberWithLong:audioLength], @"audioLength",
                        nil];
  [_channel invokeMethod:@"onPlayerPlaybackUpdate" arguments:args];
}

- (void) onPlayerPaused {
  NSLog(@"\nonPlayerPaused");
  [_channel invokeMethod:@"onPlayerPaused" arguments:nil];
}

- (void) onPlayerStopped {
  NSLog(@"\nonPlayerStopped");
  [_channel invokeMethod:@"onPlayerStopped" arguments:nil];
}

- (void) onPlayerCompleted {
  NSLog(@"\nonPlayerCompleted");
  [_channel invokeMethod:@"onPlayerCompleted" arguments:nil];
}

- (void) onSeekStarted {
  NSLog(@"\nonSeekStarted");
  [_channel invokeMethod:@"onSeekStarted" arguments:nil];
}

- (void) onSeekCompleted:(long) position {
  NSLog(@"\nonSeekCompleted");
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithLong:position], @"position",
                        nil];
  [_channel invokeMethod:@"onSeekCompleted" arguments:args];
}

// play next track started
- (void) onNextStarted: (int) index{
  NSLog(@"\nonNextStarted: index %d", index);
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:index], @"index",
                        nil];
  [_channel invokeMethod:@"onNextStarted" arguments:args];
}

// play next track completed
- (void) onNextCompleted: (int) index{
  NSLog(@"\nonNextCompleted: index %d", index);
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:index], @"index",
                        nil];
  [_channel invokeMethod:@"onNextCompleted" arguments:args];
}

// play previous track started
- (void) onPreviousStarted: (int) index{
  NSLog(@"\nonPreviousStarted: index %d", index);
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:index], @"index",
                        nil];
  [_channel invokeMethod:@"onPreviousStarted" arguments:args];
}

// play previous track completed
- (void) onPreviousCompleted: (int) index{
  NSLog(@"\nonPreviousCompleted: index %d", index);
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:index], @"index",
                        nil];
  [_channel invokeMethod:@"onPreviousCompleted" arguments:args];
}

// play previous track completed
- (void) onIndexChangedExternally: (int) index{
  NSLog(@"\nonIndexChangedExternally: index %d", index);
  NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:index], @"index",
                        nil];
  [_channel invokeMethod:@"onIndexChangedExternally" arguments:args];
}

//---------- End AudioPlayerListener ---------

@end
