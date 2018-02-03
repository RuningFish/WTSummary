//
//  WTKVOManager.m
//  123
//
//  Created by piyingke on 17/9/29.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackKVO.h"
@interface WTPlaybackKVOInfo : NSObject
@property (nonatomic , weak) id observer;
@property (nonatomic , copy) NSString * keyPath;
@end

@implementation WTPlaybackKVOInfo
@end

@interface WTPlaybackKVO ()
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSMutableArray * observerArray;
@end

@implementation WTPlaybackKVO
- (id)initWithTarget:(id)target{
    if (self = [super init]) {
        self.target = target;
        _observerArray = [NSMutableArray array];
    }
    return self;
}

- (void)safeAddObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context{
    
    id target = self.target;
    if (target == nil) return;
    BOOL removed = [self removeEntryOfObserver:observer forKeyPath:keyPath];
    if (removed) {
        NSLog(@"duplicated observer");
    }
    
    [target addObserver:observer forKeyPath:keyPath options:options context:context];
    WTPlaybackKVOInfo * info = [[WTPlaybackKVOInfo alloc] init];
    info.observer = observer;
    info.keyPath = keyPath;
    [_observerArray addObject:info];
}

- (void)safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    NSObject * target = self.target;
    if (!target) return;
    BOOL removed = [self removeEntryOfObserver:observer forKeyPath:keyPath];
    if (removed) {
        [target removeObserver:observer forKeyPath:keyPath];
    }
}

- (void)safeRemoveAllObservers{
    __block NSObject *target = _target;
    if (target == nil) return;
    
    [_observerArray enumerateObjectsUsingBlock:^(WTPlaybackKVOInfo * info, NSUInteger idx, BOOL *stop) {
        if (info == nil) return;
        NSObject * observer = info.observer;
        if (observer == nil) return;
        @try {
            [target removeObserver:observer forKeyPath:info.keyPath];
        } @catch (NSException *e) {
            NSLog(@"failed to remove observer for %@\n", info.keyPath);
        }
    }];
    [_observerArray removeAllObjects];
}

- (BOOL)removeEntryOfObserver:(NSObject *)observer
                   forKeyPath:(NSString *)keyPath{
    
    __block NSInteger removeIndex = -1;
    [_observerArray enumerateObjectsUsingBlock:^(WTPlaybackKVOInfo * info, NSUInteger index, BOOL *stop) {
        if (info.observer == observer && [info.keyPath isEqualToString:keyPath]) {
            removeIndex = index;
            *stop = YES;
        }
    }];
    
    if (removeIndex >= 0) {
        [_observerArray removeObjectAtIndex:removeIndex];
        return YES;
    }
    return NO;
}

@end
