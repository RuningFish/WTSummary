//
//  WTPlaybackManager.m
//  123
//
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackManager.h"

@interface WTPlaybackManager ()
@property (nonatomic, strong) NSMutableArray * containterArray;
@end
@implementation WTPlaybackManager

+ (instancetype)sharedManager{
    
    static WTPlaybackManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTPlaybackManager alloc] init];
        instance.playIndex = -1;
        instance.containterArray = [NSMutableArray array];
    });
    return instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setContentUrl:(NSString *)contentUrl{
    
    self.containterView = [[WTPlaybackContainerView alloc] initWithContentUrl:contentUrl];
    [self.containterArray addObject:self.containterView];
}

- (void)prepareToPlay{
    [self.containterView prepareToPlay];
}

- (void)play{
    [self.containterView play];
}

- (void)pause{
    [self.containterView pause];
}

- (void)shutdown{
    
//    NSLog(@"manager -> shutdown %@",self.containterArray);
    for (WTPlaybackContainerView * containter in self.containterArray) {
        [containter shutdown];
        [containter removeFromSuperview];
        [self.containterArray removeObject:containter];
    }
}

- (BOOL)isPlaying{
    
    return [self.containterView isPlaying];
}
@end
