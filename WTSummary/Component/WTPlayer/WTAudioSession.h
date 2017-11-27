//
//  WTAudioSession.h
//  123
//
//  Created by piyingke on 17/10/10.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTAudioSession : NSObject

+ (instancetype)sharedInstance;
- (void)setupAudioSession;
- (void)setActive:(BOOL)active;

@end
