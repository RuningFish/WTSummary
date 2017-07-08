//
//  WTNavigationController.m
//  WTSummary
//
//  Created by admin on 17/6/25.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTNavigationController.h"
#import <objc/runtime.h>
@interface WTNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.获取系统的target 和 action
    NSArray * targets = [self.interactivePopGestureRecognizer valueForKey:@"_targets"];
    id target = [targets.firstObject valueForKey:@"target"];
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    // 2.创建全屏的滑动手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    NSMutableArray * navArray = [self class_copyIvarList:[UINavigationBar class]];
    //NSLog(@"navArray - %@",navArray);
    
    UIView * barBackgroundView = [self.navigationBar valueForKey:@"_barBackgroundView"];
    
//    for (UIView * view in barBackgroundView.subviews) {
//        //NSLog(@"view - %@",view);
//        if ([view isKindOfClass:[UIImageView class]]) {
//            view.hidden = YES;
//        }
//    }
    
//    //UIView * leftViews = [self.navigationBar valueForKey:@"_leftViews"];
//    
//    for (NSString * string in navArray) {
//        
//        id view = [self.navigationBar valueForKey:string];
//        if ([view isKindOfClass:[UIView class]]) {
//            UIView * v = (UIView *)view;
//            for (UIView * subview in v.subviews) {
//                NSLog(@"view - %@ ,父控件 %@",subview,string);
//            }
//        }else{
//            
//        }
//    }

}

+ (void)initialize{
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [UINavigationBar appearance].backIndicatorImage =
    [UINavigationBar appearance].backIndicatorTransitionMaskImage =
    [UIImage imageNamed:@"nav_bar_back_icon_white"];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // hide title of back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *clearShadow = [[NSShadow alloc] init];
    clearShadow.shadowColor = [UIColor clearColor];
    clearShadow.shadowOffset = CGSizeMake(0, 0);
    
    UIColor *normalTitleColor = [UIColor whiteColor];
    UIColor *highlightedTitleColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : normalTitleColor,
                                                           NSShadowAttributeName : clearShadow
                                                           } forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : highlightedTitleColor,
                                                           NSShadowAttributeName : clearShadow
                                                           } forState:UIControlStateHighlighted];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIToolbar appearance] setBarTintColor:[UIColor whiteColor]];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    //解决与左滑手势冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
   // NSLog(@"xx - %@",NSStringFromCGPoint(translation));
    if (translation.x <= 0) {
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}

- (NSMutableArray *)class_copyIvarList:(id)class {
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList(class, &count);
    NSMutableArray * property = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        const char * ivar = ivar_getName(ivars[i]);
        [property addObject:[NSString stringWithUTF8String:ivar]];
    }
    free(ivars);
    
    return property;
}

@end
