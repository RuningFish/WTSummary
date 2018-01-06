//
//  WTAlertTextView.h
//  WTSummary
//
//  Created by admin on 17/7/9.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//  弹框编辑页面

#import <UIKit/UIKit.h>
@class WTAlertTextView;
typedef void (^leftBlock)(WTAlertTextView * alertTextView);
typedef void (^rightBlock)(WTAlertTextView * alertTextView);

@interface WTAlertTextView : UIView

/** titleLabel */
@property (nonatomic, weak) UILabel * titleLabel;
/** leftButton */
@property (nonatomic, weak) UIButton * leftBtn;
/** rightButton */
@property (nonatomic, weak) UIButton * rightBtn;
/** textView */
@property (nonatomic, weak) WTCustomTextView * textView;
/** left */
@property (nonatomic, copy) leftBlock leftBlock;
/** right */
@property (nonatomic, copy) rightBlock rightBlock;

- (void)show;
- (void)dismiss;

@end
