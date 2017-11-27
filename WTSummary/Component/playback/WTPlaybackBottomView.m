//
//  WTPlaybackBottomView.m
//  
//
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackBottomView.h"

#define WTPlayerOrientationIsLandscape      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define WTPlayerOrientationIsPortrait       UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)

// 屏幕的宽
#define WTPlaybackScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define WTPlaybackScreenHeight                        [[UIScreen mainScreen] bounds].size.height

/** 旋转屏幕的时间 */
static CGFloat const animateDuration = 0.25f;
@implementation WTPlaybackBottomView

- (instancetype)init{
    if (self = [super init]) {

        // 监测设备方向
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(onDeviceOrientationChange)
                                            name:UIDeviceOrientationDidChangeNotification
                                           object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(onStatusBarOrientationChange)
                                            name:UIApplicationDidChangeStatusBarOrientationNotification
                                          object:nil];
        
        NSLog(@"WTPlaybackBottomView ");
        
    }
    return self;
}

- (void)onDeviceOrientationChange{

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            // 显示状态栏
            [self statusBarHidden:NO];
            [self removeFromSuperview];
            [self.bottomSuperView addSubview:self];
            self.frame = self.bottomSuperView.bounds;
            if (self.isFullScreen) {
                [self toOrientation:UIInterfaceOrientationPortrait];
                
                [UIView animateWithDuration:animateDuration animations:^{
                    self.transform = CGAffineTransformIdentity;
                }];
                self.isFullScreen = NO;
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            // 隐藏状态栏
            [self statusBarHidden:YES];
            [keywindow addSubview:self];
            if (self.isFullScreen == NO) self.isFullScreen = YES;
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
           
            [UIView animateWithDuration:animateDuration animations:^{
                self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            } completion:^(BOOL finished) {
                self.frame = CGRectMake(0, 0, WTPlaybackScreenHeight,WTPlaybackScreenWidth);
            }];
            
             NSLog(@"bottom frame left === %@",NSStringFromCGRect(self.frame));
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            // 隐藏状态栏
            [self statusBarHidden:YES];
            if (self.isFullScreen == NO) self.isFullScreen = YES;
            [keywindow addSubview:self];
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
            [UIView animateWithDuration:animateDuration animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI_2);
            } completion:^(BOOL finished) {
               self.frame = CGRectMake(0, 0, WTPlaybackScreenHeight,WTPlaybackScreenWidth);
            }];
            NSLog(@"bottom frame right === %@",NSStringFromCGRect(self.frame));
        }
            break;
        default:
            break;
    }
    
}

- (void)onStatusBarOrientationChange{
    
//    NSLog(@"onStatusBarOrientationChange");
    // 在应用内
    if (1) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
//            [self setOrientationPortraitConstraint];

        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else if (currentOrientation == UIDeviceOrientationLandscapeLeft){
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
        }
    }
    
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {

        }
       
    }
    
    [UIApplication sharedApplication].statusBarHidden = currentOrientation == UIInterfaceOrientationPortrait?NO:YES;
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    
}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

/** 全屏／小屏 按钮的点击 */
- (void)switchFullscreen:(BOOL)fullscreen success:(void (^)())success{
    
    self.isFullScreen = fullscreen;
    if (fullscreen) {
        [self enterFullScreen];
    }
    else{
        [self exitFullScreen];
    }
}

#pragma mark - 全屏
- (void)enterFullScreen{
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:self];
    [UIView animateWithDuration:animateDuration animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, 0, WTPlaybackScreenHeight,WTPlaybackScreenWidth);
    }];
    
    // 全屏标记
    self.isFullScreen = YES;
    [self statusBarHidden:YES];
 
}

#pragma mark - 半屏
-(void)exitFullScreen{
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    [self removeFromSuperview];
    [self.bottomSuperView addSubview:self];
    self.frame = self.bottomSuperView.bounds;
    [self statusBarHidden:NO];
    [UIView animateWithDuration:animateDuration animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
    self.isFullScreen = NO;
}

//#pragma mark - 全屏、半屏核心方法
//- (void)forceToOrientation:(UIDeviceOrientation)orientation{
//
//    NSNumber *orientationUnknown = [NSNumber numberWithInt:0];
//    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
//
//    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
//    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
//
//}

- (void)statusBarHidden:(BOOL)hidden{
    // 是否显示状态栏
    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden = hidden;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
