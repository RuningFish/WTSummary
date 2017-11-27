//
//  WTKVOManager.m
//  123
//
//  Created by piyingke on 17/9/29.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTKVOManager.h"
#import "WTKVOEntry.h"

@interface WTKVOManager ()
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSMutableArray * observerArray;

@end

@implementation WTKVOManager

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
    WTKVOEntry * entry = [[WTKVOEntry alloc] init];
    entry.observer = observer;
    entry.keyPath = keyPath;
    [_observerArray addObject:entry];
    
    
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
    if (target == nil)
        return;
    
    [_observerArray enumerateObjectsUsingBlock:^(WTKVOEntry * entry, NSUInteger idx, BOOL *stop) {
        if (entry == nil) return;
        
        NSObject * observer = entry.observer;
        if (observer == nil)
            return;
        
        @try {
            [target removeObserver:observer
                        forKeyPath:entry.keyPath];
        } @catch (NSException *e) {
            NSLog(@"failed to remove observer for %@\n", entry.keyPath);
        }
    }];
    
    [_observerArray removeAllObjects];

}

- (BOOL)removeEntryOfObserver:(NSObject *)observer
                   forKeyPath:(NSString *)keyPath{
    
    __block NSInteger foundIndex = -1;
    [_observerArray enumerateObjectsUsingBlock:^(WTKVOEntry * entry, NSUInteger index, BOOL *stop) {
        if (entry.observer == observer && [entry.keyPath isEqualToString:keyPath]) {
            foundIndex = index;
            *stop = YES;
        }
    }];
    
    if (foundIndex >= 0) {
        [_observerArray removeObjectAtIndex:foundIndex];
        return YES;
    }
    
    return NO;
}

@end
