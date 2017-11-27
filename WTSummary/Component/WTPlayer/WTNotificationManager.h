//
//  WTNotificationManager.h
//  123
//
//  Created by piyingke on 2017/10/10.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNotificationManager : NSObject

- (nullable instancetype)init;

- (void)addObserver:(nonnull id)observer
           selector:(nonnull SEL)aSelector
               name:(nullable NSString *)aName
             object:(nullable id)anObject;

- (void)removeAllObservers:(nonnull id)observer;

@end
