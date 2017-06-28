//
//  WTBaseViewController.m
//  WTSummary
//
//  Created by admin on 17/6/25.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTBaseViewController.h"

@interface WTBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 80, 44);
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    leftBtn.backgroundColor = [UIColor orangeColor];
    [leftBtn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#ff4f52"];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
//    //step1:需要获取系统自带滑动手势的target对象
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    //step2:创建全屏滑动手势~调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    //step3:设置手势代理~拦截手势触9
//    pan.delegate = self;
//    //step4:别忘了~给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    //step5:将系统自带的滑动手势禁用
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //step6:还记得刚刚设置的代理吗？下面方法什么时候调用？在每次触发手势之前都会询问下代理，是否触发。
//    这个方法就是拦截手势触发的方法.
//    - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{}
//    return NO;则不需要触发滑动手势
//    return YES;则需要触发滑动手势
}

@end
