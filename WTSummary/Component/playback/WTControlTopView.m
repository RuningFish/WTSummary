//
//  WTControlTopView.m
//  123
//
//  Created by admin on 17/10/16.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTControlTopView.h"

@interface WTControlTopView ()
/** 视频的描述 */
@property (nonatomic, weak) UILabel * descLabel;
/** 返回按钮 */
@property (nonatomic, weak) UIButton * backButton;
/** 更多按钮 */
@property (nonatomic, weak) UIButton * moreButton;

@end

@implementation WTControlTopView

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        // 视频的描述
        UILabel * descLabel = [[UILabel alloc] init];
        self.descLabel = descLabel;
        [self addSubview:descLabel];
        descLabel.numberOfLines = 2;
        descLabel.textColor = [UIColor whiteColor];
        descLabel.font = [UIFont systemFontOfSize:16];
        
        // 返回按钮
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton = backButton;
        [self addSubview:backButton];
        [backButton setImage:[UIImage imageNamed:WTPlaybackBundle(@"play_back_full")] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        // 更多按钮
//        UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.moreButton = moreButton;
//        [self addSubview:moreButton];
//        [moreButton setImage:[UIImage imageNamed:WTPlaybackBundle(@"play_back_full")] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        //$(SRCROOT)
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.bottom.offset(0);
            make.left.offset(10);
            make.right.offset(-10);
        }];
        
        self.backButton.hidden = YES;
    } else {
        self.backButton.hidden = NO;
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
            make.width.height.mas_equalTo(30);
        }];
        //$(SRCROOT)
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(self.backButton.mas_right).offset(10);
            make.right.offset(-10);
        }];
    }
    
}

- (void)setVideoInfo:(VideoInfo *)videoInfo{
    
    _videoInfo = videoInfo;
    
    self.descLabel.text = [NSString stringWithFormat:@"%@",videoInfo.title];
}

- (void)backButtonClick{
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation != UIDeviceOrientationPortrait) {
        WTPlaybackManager * manager = [WTPlaybackManager sharedManager];
        [manager.containterView.bottomView switchFullscreen:NO success:nil];
        [manager.containterView.mediaControlView.bottomView.fullScreenBtn setImage:[UIImage imageNamed:WTPlaybackBundle(@"Fullscreen")] forState:UIControlStateNormal];
    }
}
@end
