//
//  WTToolbar.m
//  WTSummary
//
//  Created by piyingke on 17/7/6.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTToolbar.h"


@interface WTToolbar ()
/** 选择图片的按钮 */
@property (nonatomic, weak) UIButton * choseImageBtn;
/** @好友的按钮 */
@property (nonatomic, weak) UIButton * atFriendBtn;

@end

@implementation WTToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        /** 选择图片的按钮 */
        UIButton * choseImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:choseImageBtn];
        choseImageBtn.tag = WTToolbarButtonTypeImage;
        [choseImageBtn setImage:[UIImage imageNamed:@"home_forum_setup_pic"] forState:UIControlStateNormal];
        //choseImageBtn.backgroundColor = [UIColor greenColor];
        self.choseImageBtn = choseImageBtn;
        
        /** @好友的按钮 */
        UIButton * atFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:atFriendBtn];
        atFriendBtn.tag = WTToolbarButtonTypeAt;
        [atFriendBtn setImage:[UIImage imageNamed:@"home_forum_setup_@"] forState:UIControlStateNormal];
        //atFriendBtn.backgroundColor = [UIColor blueColor];
        self.atFriendBtn = atFriendBtn;
        
        [choseImageBtn addTarget:self action:@selector(discussToolbarClick:) forControlEvents:UIControlEventTouchUpInside];
        [atFriendBtn addTarget:self action:@selector(discussToolbarClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / 5;
    self.choseImageBtn.frame = CGRectMake(0, 0, width, self.frame.size.height);
    self.atFriendBtn.frame = CGRectMake(width, 0, width, self.frame.size.height);
}

- (void)discussToolbarClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(toolbar:didClickWithType:)]) {
        [self.delegate toolbar:self didClickWithType:button.tag];
    }
}

@end
