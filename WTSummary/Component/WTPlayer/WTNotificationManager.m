//
//  WTNotificationManager.m
//  123
//
//  Created by piyingke on 2017/10/10.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTNotificationManager.h"

@implementation WTNotificationManager
{
    NSMutableDictionary *_registerNotification;
}

- (instancetype)init{
    
    if (self = [super init]) {
        _registerNotification = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addObserver:(nonnull id)observer
           selector:(nonnull SEL)aSelector
               name:(nullable NSString *)aName
             object:(nullable id)anObject{
    
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:aName
                                               object:anObject];
    
    [_registerNotification setValue:aName forKey:aName];
}

- (void)removeAllObservers:(nonnull id)observer{
    
    for (NSString * name in [_registerNotification allKeys]) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                        name:name
                                                      object:nil];
    }
}
@end
