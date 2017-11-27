//
//  WTAudioSession.m
//  123
//
//  Created by piyingke on 17/10/10.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTAudioSession.h"
#import <AVFoundation/AVFoundation.h>
@implementation WTAudioSession
{
    BOOL _audioSessionInitialized;
}

+ (instancetype)sharedInstance{
    
    static WTAudioSession * audioSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioSession = [[WTAudioSession alloc] init];
    });
    return audioSession;
}

- (void)setupAudioSession{
    
    if (!_audioSessionInitialized) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        _audioSessionInitialized = YES;
    }
    
//    NSError * error = nil;
//    if (NO == [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]) {
//        NSLog(@"AVAudioSession.setCategory() failed: %@\n", error ? [error localizedDescription] : @"nil");
//        return;
//    }
//    
//    error = nil;
//    if (NO == [[AVAudioSession sharedInstance] setActive:YES error:&error]) {
//        NSLog(@"AVAudioSession.setActive(YES) failed: %@\n", error ? [error localizedDescription] : @"nil");
//        return;
//    }

}

- (void)setActive:(BOOL)active{
    
    if (active) {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    } else {
        @try {
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
        } @catch (NSException *exception) {
            NSLog(@"failed to inactive AVAudioSession\n");
        }
    }
}

- (void)handleInterruption:(NSNotification *)notification{
    
    int reason = [[[notification userInfo] valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    
    BOOL active = (reason == AVAudioSessionInterruptionTypeBegan)?NO:YES;
    
    [self setActive:active];
}
@end
