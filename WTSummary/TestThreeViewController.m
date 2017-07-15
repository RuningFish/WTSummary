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
@interface TestThreeViewController ()
//@property (nonatomic ,strong) UIImageView * imageView;
@property (nonatomic ,strong) UILabel * label;

@property (nonatomic ,strong) XWInteractiveTransition * interactiveTransition;
@end

@implementation TestThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.imageView];
//    [self.view addSubview:self.label];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.view addSubview:imageView];
//    imageView.backgroundColor = [UIColor blueColor];
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y - self.view.height / 2 + 210);
    imageView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180);
    
    //初始化手势过渡的代理
    self.interactiveTransition = [XWInteractiveTransition interactiveTransitionWithTransitionType:XWInteractiveTransitionTypePop GestureDirection:XWInteractiveTransitionGestureDirectionRight];
    //给当前控制器的视图添加手势
//    [_interactiveTransition addPanGestureForViewController:self];
    
//    UIButton * button = [UIButton ];
    return;
//    UIWebView * webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
//    webview.backgroundColor = [UIColor redColor];
//    [self.view addSubview:webview];
//    // http://huodong.piyingke.com/index.html
//        
//    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://huodong.piyingke.com/index.html"]]];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
//        
//    } completion:^(BOOL finished) {
//        NSLog(@"完成");
//        self.label.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 20, self.view.frame.size.width, 30);
//        self.label.hidden = NO;
//    }];
}


//- (UIImageView *)imageView{
//    if (!_imageView) {
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - self.cellFrame.size.height, self.cellFrame.size.width, self.cellFrame.size.height)];
//        _imageView.backgroundColor = [UIColor greenColor];
//    }
//    return _imageView;
//}
//
//- (UILabel *)label{
//    if (!_label) {
//        _label = [[UILabel alloc] initWithFrame:CGRectZero];
//        _label.text = @"回复 i 都是废话 i 史蒂夫 i 上班看见方便快捷地方就是大家反馈就是你放假开始动脑筋";
//        _label.numberOfLines = 0;
//        _label.backgroundColor = [UIColor redColor];
//        _label.hidden = YES;
//    }
//    return _label;
//}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    NSLog(@"ttttt %@", NSStringFromCGRect(self.imageView.frame));
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [WTNavigationTransition transitionWithType:operation == UINavigationControllerOperationPush ? WTNavigationTransitionTypePush : WTNavigationTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    //手势开始的时候才需要传入手势过渡代理，如果直接点击pop，应该传入空，否者无法通过点击正常pop
    return _interactiveTransition.interation ? _interactiveTransition : nil;
}

@end
