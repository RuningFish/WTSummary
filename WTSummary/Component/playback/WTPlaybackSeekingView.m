//
//  WTPlaybackSeekingView.m
//
//  Created by piyingke on 2017/10/30.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackSeekingView.h"

@interface WTPlaybackSeekingView ()
/** 当前的播放时间 */
@property (nonatomic, strong) UILabel * currentLabel;
/** 总时长 */
@property (nonatomic, strong) UILabel * durationLabel;
@end
static CGFloat const seekingViewWidth = 150;
@implementation WTPlaybackSeekingView

+ (instancetype)seekingView{
    
    static WTPlaybackSeekingView * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTPlaybackSeekingView alloc] init];
    });
    return instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, seekingViewWidth, 100);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        
        self.seekingImageView = [[UIImageView alloc] init];
        [self addSubview:self.seekingImageView];
        
        self.currentLabel = [[UILabel alloc] init];
        [self addSubview:self.currentLabel];
        
        self.durationLabel = [[UILabel alloc] init];
        [self addSubview:self.durationLabel];
        
        UIFont * labelFont = [UIFont systemFontOfSize:14];
        self.currentLabel.font = labelFont;
        self.durationLabel.font = labelFont;
        self.currentLabel.textAlignment = NSTextAlignmentRight;
        self.durationLabel.textAlignment = NSTextAlignmentLeft;
        self.currentLabel.textColor = [UIColor whiteColor];
        self.durationLabel.textColor = [UIColor whiteColor];

//        self.currentLabel.backgroundColor = [UIColor yellowColor];
//        self.durationLabel.backgroundColor = [UIColor blueColor];
//        self.seekingImageView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (currentOrientation == UIDeviceOrientationPortrait) {
        self.transform = CGAffineTransformIdentity;
        self.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    }
    else{
        CGFloat angle = (currentOrientation == UIDeviceOrientationLandscapeLeft)?M_PI_2:-M_PI_2;
        if (currentOrientation == UIDeviceOrientationLandscapeLeft) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }
        else if (currentOrientation == UIDeviceOrientationLandscapeRight){
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
        }
        self.transform = CGAffineTransformMakeRotation(angle);
        self.center = CGPointMake(screenSize.height/2, screenSize.width/2);
    }
    
    CGFloat seekingH = 30;
    CGFloat seekingW = 60;
    CGFloat seekingX = (seekingViewWidth - seekingW)/2;
    CGFloat seekingY = 10;
    self.seekingImageView.frame = CGRectMake(seekingX, seekingY, seekingW, seekingH);
    
    CGFloat labelHeight = 30;
    self.currentLabel.frame = CGRectMake(0, CGRectGetMaxY(self.seekingImageView.frame), seekingViewWidth/2, labelHeight);
    self.durationLabel.frame = CGRectMake(seekingViewWidth/2, self.currentLabel.frame.origin.y, seekingViewWidth/2, labelHeight);
}

- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 1.0;
    [self layoutSubviews];
}

- (void)remove{
    
    [self removeFromSuperview];
}

- (void)setCurrentTime:(CGFloat)currentTime{
    
    _currentTime = currentTime;
    self.currentLabel.text = [NSString stringWithFormat:@"%@/",[self time:currentTime]];
}

- (void)setDuration:(CGFloat)duration{
    
    if (duration <= 0) return;
    _duration = duration;
    self.durationLabel.text = [NSString stringWithFormat:@"%@",[self time:duration]];
}

- (NSString *)time:(CGFloat)time{
    
    NSInteger min = time/60;
    NSInteger sec = time - min*60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}
@end
