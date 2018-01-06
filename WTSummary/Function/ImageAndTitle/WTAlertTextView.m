//
//  WTAlertTextView.m
//  WTSummary
//
//  Created by admin on 17/7/9.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTAlertTextView.h"
#import "WTCustomTextView.h"
@interface WTAlertTextView ()
/** contentView */
@property (nonatomic, weak) UIView * contentView;
/** horizontalLine 水平线 */
@property (nonatomic, weak) UIView * horizontalLine;
/** verticalLine 垂直线 */
@property (nonatomic, weak) UIView * verticalLine;

@end

@implementation WTAlertTextView

- (instancetype)init{
    if (self = [super init]) {
        
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIView * contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    // 标题
    UILabel * titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"图片描述";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-medium" size:17];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    // textView
    WTCustomTextView * textView = [[WTCustomTextView alloc] init];
    self.textView = textView;
//    [textView resignFirstResponder];
    textView.placeHolder = @"图片描述（最多30字）";
    textView.placeColor = [UIColor lightGrayColor];
    textView.placeFont = [UIFont systemFontOfSize:15];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 0.5;
    [contentView addSubview:textView];
    
    UIFont * font = [UIFont fontWithName:@"PingFangSC-medium" size:17];
    UIColor * textColor = [UIColor colorWithRed:51/255.0 green:94/255.0 blue:247/255.0 alpha:1.0];
    
    // leftBtn
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn = leftButton;
    [contentView addSubview:leftButton];
    leftButton.titleLabel.font = font;
    leftButton.tag = 10;
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:textColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // rightBtn
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightButton;
    [contentView addSubview:rightButton];
    rightButton.titleLabel.font = font;
    rightButton.tag = 20;
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:textColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 水平线
    UIView * horizontalLine = [[UIView alloc] init];
    [contentView addSubview:horizontalLine];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    self.horizontalLine = horizontalLine;
    
    // 垂直线
    UIView * verticalLine = [[UIView alloc] init];
    [contentView addSubview:verticalLine];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    self.verticalLine = verticalLine;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    // 键盘高度
    CGFloat keyboardH = 282;
    CGFloat contentViewH = 150;
    CGFloat contentViewW = 260;
    CGFloat contentViewX = (self.frame.size.width - contentViewW ) * 0.5;
    CGFloat contentViewY = self.frame.size.height - keyboardH - contentViewH - 20;
    self.contentView.frame = CGRectMake(contentViewX, contentViewY, contentViewW, contentViewH);
    
    self.titleLabel.frame = CGRectMake(0, 0, contentViewW, 30);
    
    CGFloat buttonW = contentViewW / 2;
    CGFloat buttonH = 40;
    self.leftBtn.frame = CGRectMake(0, contentViewH - buttonH, buttonW, buttonH);
    self.rightBtn.frame = CGRectMake(buttonW, CGRectGetMinY(self.leftBtn.frame), buttonW, buttonH);
   
    CGFloat textViewH = contentViewH - 10 - 30 - buttonH;
    self.textView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 5, contentViewW - 20, textViewH);
    // 水平
    self.horizontalLine.frame = CGRectMake(0, CGRectGetMinY(self.leftBtn.frame), contentViewW, 0.5);
    // 竖直
    self.verticalLine.frame = CGRectMake(buttonW, CGRectGetMinY(self.leftBtn.frame), 0.5, buttonH);
}


- (void)buttonClick:(UIButton *)button{
    
    if (button.tag == 10) {// 左
        if (self.leftBlock) self.leftBlock(self);
    }else if (button.tag == 20){
        if (self.rightBlock) self.rightBlock(self);
    }
    
    [self dismiss];
}

- (void)show{
    
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:self];
    
}

- (void)dismiss{
    
    [self removeFromSuperview];
}

@end
