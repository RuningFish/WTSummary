//
//  WTKVOManager.h
//  123
//
//  Created by piyingke on 17/9/29.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKVOManager : NSObject

- (id)initWithTarget:(id)target;

- (void)safeAddObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath
                  options:(NSKeyValueObservingOptions)options
                  context:(void *)context;

- (void)safeRemoveObserver:(NSObject *)observer
                  forKeyPath:(NSString *)keyPath;

- (void)safeRemoveAllObservers;

@end


