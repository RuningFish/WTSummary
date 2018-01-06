//
//  TestThreeViewController.m
//  WTSummary
//
//  Created by piyingke on 17/7/7.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "TestThreeViewController.h"
#import "XWInteractiveTransition.h"
#import "WTNavigationTransition.h"
#import "TestTwoViewController.h"
#import "ViewController.h"

@interface TestThreeViewController ()
@property (nonatomic ,strong) UILabel * label;

@property (nonatomic ,strong) XWInteractiveTransition * interactiveTransition;
@end

@implementation TestThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    self.imageView.hidden = YES;
    imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
    [imageView addGestureRecognizer:tap];
    
    // 监听侧滑的全屏返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavigationStateChange:) name:KHandleNavigationStateChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavigationStateBegin:) name:KHandleNavigationStateBegin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavigationStateEnded:) name:KHandleNavigationStateEnd object:nil];
}

- (void)handleNavigationStateChange:(NSNotification *)notification{
    
    id value = notification.object;
    CGPoint point;
    [value getValue:&point];
    CGFloat contentOffsetX = point.x;
    if (contentOffsetX < 0) {
        contentOffsetX = 0.0;
    }
    else if (contentOffsetX >= self.view.frame.size.width){
        contentOffsetX = self.view.frame.size.width;
    }
    
    CGFloat alpha = contentOffsetX / (self.view.frame.size.width * 0.98);
    NSLog(@"=====> %lf %lf",point.x,alpha);
    self.imageView.alpha = 1 - alpha;
    self.cell.imageview.alpha = alpha;
}

- (void)handleNavigationStateBegin:(NSNotification *)notification{
    self.cell.imageview.hidden = NO;
    self.cell.imageview.alpha = 0.0;
}

- (void)handleNavigationStateEnded:(NSNotification *)notification{
    CGPoint point;
    id value = notification.object;
    [value getValue:&point];
    
    CGFloat width = self.view.frame.size.width;
    if (point.x >= width * 0.5) {
        self.cell.imageview.hidden = NO;
        self.cell.imageview.alpha = 1.0;
    }
    else if (point.x > 0 && point.x < width * 0.5){
        self.cell.imageview.hidden = YES;
        self.cell.imageview.alpha = 0.0;
    }
}

- (void)dealloc{
    NSLog(@"TestThreeViewController -> delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.cell = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"TestThreeViewController -> viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"TestThreeViewController -> viewDidDisappear");
}

- (void)imageViewTap{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.imageView.hidden = NO;
    self.imageView.backgroundColor = self.imageViewColor;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    NSLog(@"ttttt %@  %@  %@", NSStringFromCGRect(self.imageView.frame),fromVC,toVC);

    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [WTNavigationTransition transitionWithType:operation == UINavigationControllerOperationPush ? WTNavigationTransitionTypePush : WTNavigationTransitionTypePop];
}

@end
