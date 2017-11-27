//
//  UINavigationController+WTPlaybackRotation.m
//  123
//
//  Created by piyingke on 2017/10/26.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "UINavigationController+WTPlaybackRotation.h"

@implementation UINavigationController (WTPlaybackRotation)

/**
 * 如果window的根视图是UINavigationController，则会先调用这个Category，然后调用UIViewController+ZFPlayerRotation
 * 只需要在支持除竖屏以外方向的页面重新下边三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate{
    
    return [self.visibleViewController shouldAutorotate];
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.visibleViewController supportedInterfaceOrientations];
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

@end
