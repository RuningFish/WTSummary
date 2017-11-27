//
//  WTPlaybackLoadingView.m
//  123
//
//  Created by admin on 17/10/22.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackLoadingView.h"

@interface WTPlaybackLoadingView ()
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

/** loading imageView */
@property (nonatomic, strong) UIImageView * loadingImageView;
/** replay */
@property (nonatomic, strong) UIButton * replayButton;
/** share */
@property (nonatomic, strong) UIButton * shareButton;
/** replayLabel */
@property (nonatomic, strong) UILabel * replayDescLabel;
/** shareLabel */
@property (nonatomic, strong) UILabel * shareDescLabel;

@end

/** loading 的大小 */
static CGFloat const loadingImageWH = 30;
/** 分享和重播按钮的大小 */
static CGFloat const replayButtonW = 40;

@implementation WTPlaybackLoadingView

- (instancetype)init{

    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.activityIndicator];
        self.activityIndicator.hidden = YES;
        
        self.loadingImageView = [[UIImageView alloc] init];
        [self addSubview:self.loadingImageView];
        self.loadingImageView.hidden = YES;
        self.loadingImageView.backgroundColor = [UIColor clearColor];
        
        // replay
        self.replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.replayButton.tag = 100;
        [self addSubview:self.replayButton];
        
        // share
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.tag = 101;
        [self addSubview:self.shareButton];
        
        self.replayButton.hidden = self.shareButton.hidden = YES;
        self.replayButton.adjustsImageWhenHighlighted = self.shareButton.adjustsImageWhenHighlighted = NO;
        
        // 按钮的点击事件
        [self.replayButton addTarget:self action:@selector(loadViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.replayButton addTarget:self action:@selector(loadViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.replayDescLabel = [[UILabel alloc] init];
        self.replayDescLabel.hidden = YES;
        self.replayDescLabel.text = @"重播";
        self.replayDescLabel.textColor = [UIColor whiteColor];
        self.replayDescLabel.textAlignment = NSTextAlignmentCenter;
        self.replayDescLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.replayDescLabel];
        
        self.shareDescLabel = [[UILabel alloc] init];
        self.shareDescLabel.hidden = YES;
        self.shareDescLabel.text = @"分享";
        self.shareDescLabel.textColor = [UIColor whiteColor];
        self.shareDescLabel.textAlignment = NSTextAlignmentCenter;
        self.shareDescLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.shareDescLabel];
        
        self.replayButton.backgroundColor = self.shareButton.backgroundColor = [UIColor clearColor];
        self.replayDescLabel.backgroundColor = self.shareDescLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // loading
    if (self.loadingImage) {
        self.loadingImageView.hidden = NO;
        self.activityIndicator.hidden = YES;
        CGFloat loadingX = (self.frame.size.width - loadingImageWH)/2;
        CGFloat loadingY = (self.frame.size.height - loadingImageWH)/2;
        self.loadingImageView.frame = CGRectMake(loadingX, loadingY, loadingImageWH, loadingImageWH);
    }
    
    else{
        self.activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    
    // replay and share
    if (self.replayImage && !self.shareImage) {
        
        CGFloat replayX = (self.frame.size.width - replayButtonW)/2;
        CGFloat replayY = (self.frame.size.height - replayButtonW - 30)/2;
        self.replayButton.frame = CGRectMake(replayX, replayY, replayButtonW, replayButtonW);
        self.replayDescLabel.frame = CGRectMake(replayX, replayY + replayButtonW + 5, replayButtonW, 25);
        
    }
    
    else if (self.replayImage && self.shareImage){
        
        // 按钮之间的间距
        CGFloat margin = 40;
        CGFloat replayX = (self.frame.size.width - replayButtonW*2 - margin)/2;
        CGFloat replayY = (self.frame.size.height - replayButtonW - 30)/2;
        CGFloat shareX  = replayX + replayButtonW + margin;
        
        self.replayButton.frame = CGRectMake(replayX, replayY, replayButtonW, replayButtonW);
        self.shareButton.frame  = CGRectMake(shareX, replayY, replayButtonW, replayButtonW);
        self.replayDescLabel.frame = CGRectMake(replayX, replayY + replayButtonW + 5, replayButtonW, 25);
        self.shareDescLabel.frame = CGRectMake(shareX, replayY + replayButtonW + 5, replayButtonW, 25);
        
    }
}

- (void)startLoading{
    
    
    if (!self.loadingImage) {
        self.hidden = self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
    }
    
    else{
        self.hidden = self.loadingImageView.hidden = NO;
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.duration = 2.0;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = CGFLOAT_MAX;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.removedOnCompletion = NO;
        [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    }
    
}

- (void)stopLoading{
    
    if (!self.loadingImage) {
        self.hidden = self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
    
    else{
        
        [self.loadingImageView stopAnimating];
        [self.loadingImageView.layer removeAllAnimations];
        
        if (!self.replayButton.hidden) {
            self.loadingImageView.hidden = YES;
            self.hidden = NO;
        }
        else{
            self.hidden = self.loadingImageView.hidden = YES;
            self.activityIndicator.hidden = YES;
        }
        
    }
    
}

- (void)setLoadingImage:(UIImage *)loadingImage{
    
    _loadingImage = loadingImage;
    self.loadingImageView.image = loadingImage;
    
}

- (void)setReplayImage:(UIImage *)replayImage{
    
    _replayImage = replayImage;
    [self.replayButton setImage:replayImage forState:UIControlStateNormal];
    [self layoutSubviews];
}

- (void)setShareImage:(UIImage *)shareImage{
    
    _shareImage = shareImage;
    [self.shareButton setImage:shareImage forState:UIControlStateNormal];
    [self layoutSubviews];
    
}

- (void)showReplayAndShare{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.replayButton.hidden = self.shareButton.hidden = self.hidden = NO;
    self.replayDescLabel.hidden = self.shareDescLabel.hidden = NO;

}

- (void)hiddenReplayAndShare{
    
    self.backgroundColor = [UIColor clearColor];
    self.replayButton.hidden = self.shareButton.hidden = self.hidden = YES;
    self.replayDescLabel.hidden = self.shareDescLabel.hidden = YES;
}

- (void)loadViewButtonClick:(UIButton *)button{
    
    // replay
    if (button.tag == 100) {
        if (self.replayBlock) {
            self.replayBlock();
        }
    }
    else if (button.tag == 101){
     // share
        if (self.shareBlock) {
            self.shareBlock();
        }
    }
}
@end

