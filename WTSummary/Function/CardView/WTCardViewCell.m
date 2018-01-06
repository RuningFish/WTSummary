//
//  WTCardViewCell.m
//  WTSummary
//
//  Created by piyingke on 2017/11/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTCardViewCell.h"

@interface WTCardViewCell ()

@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, assign) BOOL isLeft;
@end
@implementation WTCardViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)identifier{
    
    self.idientifier = identifier;
    // 添加拖拽手势
    self.userInteractionEnabled = NO;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [self addGestureRecognizer:pan];
    
    return [self init];
}
- (instancetype)init{
    if (self = [super init]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.label.font = [UIFont systemFontOfSize:20];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        NSLog(@"WTCardViewCell ==> init");
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
   
    self.label.frame = CGRectMake(0, 0, 50, 50);
    self.label.center = self.center;
    self.label.backgroundColor = [UIColor whiteColor];
    self.originalCenter = self.center;
}
- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture{
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged){
//        CGPoint locationPoint = [panGesture translationInView:self];
//        self.isLeft = (locationPoint.x < 0);
//        self.center = CGPointMake(self.center.x + locationPoint.x, self.center.y + locationPoint.y);
//        CGFloat angle = (self.center.x - self.frame.size.width/2) / self.frame.size.width/4;
//        self.currentAngle = angle;
//        self.transform = CGAffineTransformMakeRotation(angle);
//        [panGesture setTranslation:CGPointZero inView:self];
        CGPoint point = [panGesture translationInView:self];
        CGPoint movedPoint = CGPointMake(panGesture.view.center.x + point.x, panGesture.view.center.y + point.y);
        self.center = movedPoint;
        self.transform = CGAffineTransformMakeRotation((self.center.x - self.originalCenter.x) / self.originalCenter.x *(M_PI_4/12));
        [panGesture setTranslation:CGPointZero inView:self];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded){
//        CGPoint velocityPoint = [panGesture velocityInView:self];
//        if (velocityPoint.x > 800 || velocityPoint.x < -800) {
//            [self cellRemoveFromLeft:self.isLeft andAngle:self.currentAngle];
//            return;
//        }
//
//        if (self.frame.origin.x + self.frame.size.width > 150 && self.frame.origin.x < self.frame.size.width - 150) {
//            [UIView animateWithDuration:0.25 animations:^{
//                self.center = self.originalCenter;
//                self.transform = CGAffineTransformIdentity;
//            }];
//        }
//        else{
//           [self cellRemoveFromLeft:self.isLeft andAngle:self.currentAngle];
//        }
        
        CGFloat widthRatio = (panGesture.view.center.x - self.originalCenter.x) / self.originalCenter.x;
        CGFloat moveWidth  = panGesture.view.center.x - self.originalCenter.x;
        CGFloat moveHeight = panGesture.view.center.y - self.originalCenter.y;
        
        NSLog(@"widthRatio == %lf ",widthRatio);
        [self finishedPanGesture:self direction:widthRatio>0 scale:moveWidth/moveHeight disappear:fabs(widthRatio) > 0.95];
    }
}

- (void)finishedPanGesture:(UIView *)cardView direction:(BOOL)direction scale:(CGFloat)scale disappear:(BOOL)disappear {
    
    if (!disappear) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.center = self.originalCenter;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        NSInteger flag = direction ? 2 : -1;
        [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            cardView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * flag, [UIScreen mainScreen].bounds.size.width * flag / scale + self.originalCenter.y);
        } completion:^(BOOL finished) {
            [cardView removeFromSuperview];
            // 通知代理方法
            if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidRemoveFromSuperView:)]) {
                [self.delegate cellDidRemoveFromSuperView:self];
            }
        }];
    }
    
}

- (void)cellRemoveFromLeft:(BOOL)left andAngle:(CGFloat)angle{
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isLeft) {
            self.center = CGPointMake(-1000, self.center.y - self.currentAngle*self.frame.size.height + angle?angle:100);
        }
        else{
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + self.currentAngle * self.frame.size.height + angle?angle:100);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            // 通知代理方法
            if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidRemoveFromSuperView:)]) {
                [self.delegate cellDidRemoveFromSuperView:self];
            }
        }
    }];
    
}

- (void)setIdientifier:(NSString *)idientifier{
    _idientifier = idientifier;
}
@end
