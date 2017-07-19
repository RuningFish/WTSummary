//
//  WTNavigationTransition.m
//  WTSummary
//
//  Created by piyingke on 17/7/15.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTNavigationTransition.h"
#import "TestTwoViewController.h"
#import "TestThreeViewController.h"

@interface WTNavigationTransition ()
/** 管理的动画类型 */
@property (nonatomic, assign) WTNavigationTransitionType transitionType;

@end

@implementation WTNavigationTransition
+ (instancetype)transitionWithType:(WTNavigationTransitionType)transitionType{
    return [[self alloc] initWithTransitionType:transitionType];
}

- (instancetype)initWithTransitionType:(WTNavigationTransitionType)transitionType{
    
    if (self = [super init]) {
        self.transitionType = transitionType;
    }
    return self;
}

#pragma mark - 动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.75;
}

#pragma mark -  如何执行过渡动画

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    if (self.transitionType == WTNavigationTransitionTypePush) {
         [self doPushAnimation:transitionContext];
    }else if (self.transitionType == WTNavigationTransitionTypePop){
         [self doPopAnimation:transitionContext];
    }
}

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    TestTwoViewController * fromVC = (TestTwoViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    TestThreeViewController * toVC = (TestThreeViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //拿到当前点击的cell的imageView
    WTTableViewCell * cell = fromVC.cell;
    UIView * containerView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView * tempView = [cell.imageview snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [cell.imageview convertRect:cell.imageview.bounds toView:containerView];
    //设置动画前的各个控件的状态
    cell.imageview.hidden = YES;
    toVC.view.alpha = 0;
    toVC.imageView.hidden = YES;
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    //开始做动画

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tempView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180);
        toVC.view.alpha = 1;
        NSLog(@"88888");
    } completion:^(BOOL finished) {
        NSLog(@"完成");
        cell.imageview.hidden = YES;
        toVC.imageViewColor = cell.imageview.backgroundColor;
        [tempView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}

/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    TestThreeViewController * fromVC = (TestThreeViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    TestTwoViewController * toVC = (TestTwoViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    UIView * snapView = [fromVC.imageView snapshotViewAfterScreenUpdates:NO];
    snapView.frame = CGRectMake(0, 0, fromVC.imageView.frame.size.width, fromVC.imageView.frame.size.height);//[containerView convertRect:fromVC.imageView.frame fromView:fromVC.view];
    fromVC.imageView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.cell.imageview.hidden = YES;
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapView];
     NSLog(@"pop animations - 1 %@",snapView);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = [containerView convertRect:toVC.cell.imageview.frame fromView:toVC.cell];
        snapView.frame = rect;
        fromVC.view.alpha = 0;
        [snapView layoutIfNeeded];
         NSLog(@"pop animations - %@ rect - %@",NSStringFromCGRect(snapView.frame),NSStringFromCGRect(rect));
    } completion:^(BOOL finished) {
        toVC.cell.imageview.hidden = NO;
        [snapView removeFromSuperview];
        fromVC.imageView.hidden = YES;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        NSLog(@"finished - %zd",finished);
    }];
    
}

@end
