//
//  WTNavigationTransition.h
//  WTSummary
//
//  Created by piyingke on 17/7/15.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WTNavigationTransitionTypePush = 0,
    WTNavigationTransitionTypePop
}WTNavigationTransitionType;

@interface WTNavigationTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithType:(WTNavigationTransitionType)transitionType;
- (instancetype)initWithTransitionType:(WTNavigationTransitionType)transitionType;
@end
