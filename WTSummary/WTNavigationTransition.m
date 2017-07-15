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
//    XWMagicMoveCell * cell = (XWMagicMoveCell *)[fromVC.collectionView cellForItemAtIndexPath:fromVC.currentIndexPath];
    UIView * containerView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView * tempView = [cell.imageview snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [cell.imageview convertRect:cell.imageview.bounds toView: containerView];
    //设置动画前的各个控件的状态
    cell.imageView.hidden = YES;
    toVC.view.alpha = 0;
    toVC.imageView.hidden = YES;
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    //开始做动画
    [UIView animateWithDuration: 0.5/**[self transitionDuration:transitionContext]*/ delay:0.0 usingSpringWithDamping:0.0 initialSpringVelocity:0.0 options:0 animations:^{
        tempView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180);// [toVC.imageView convertRect:toVC.imageView.bounds toView:containerView];//
        toVC.view.alpha = 1;
        NSLog(@"88888");
    } completion:^(BOOL finished) {
//        tempView.hidden = YES;
//        toVC.imageView.hidden = NO;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    TestTwoViewController * toVC = (TestTwoViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    TestThreeViewController * fromVC = (TestThreeViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewKey];
    
    WTTableViewCell * cell = toVC.cell;//(XWMagicMoveCell *)[toVC.collectionView cellForItemAtIndexPath:toVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //这里的lastView就是push时候初始化的那个tempView
    UIView *tempView = containerView.subviews.lastObject;
    //设置初始状态
    cell.imageView.hidden = YES;
    fromVC.imageView.hidden = YES;
    tempView.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        tempView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {//手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            tempView.hidden = YES;
            fromVC.imageView.hidden = NO;
        }else{//手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            cell.imageView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

@end
