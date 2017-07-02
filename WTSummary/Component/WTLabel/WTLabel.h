//
//  WTLabel.h
//  WTLabel
//
//  Created by admin on 17/4/8.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    // @
    WTLinkTypeUserHandle = 0,
    // #
    WTLinkTypeTopic,
    // url
    WTLinkTypeUrl,
    // 自定义
    WTLinkTypeCustom
}WTLinkType;

@class WTLabel;

@protocol WTLabelDelegate <NSObject>
@optional
- (void)label:(WTLabel *)label didSelsectedWithType:(WTLinkType)type string:(NSString *)string range:(NSRange)selectRange;
@end

/** 点击高亮文字的时候调用 */
typedef void (^WTLinkTapHandle)(WTLabel * label,NSString * selectString,NSRange selectRange);
/** 点击非高亮文字的时候调用 */
typedef void (^WTNoLinkTapHandle)(WTLabel * label);

@interface WTLabel : UILabel
@property (nonatomic, copy) WTLinkTapHandle userHandle;
@property (nonatomic, copy) WTLinkTapHandle topicHandle;
@property (nonatomic, copy) WTLinkTapHandle urlHandle;
@property (nonatomic, copy) WTLinkTapHandle customHandle;

/** 点击label的空白区域 或者非高亮时调用 */
@property (nonatomic, copy) WTNoLinkTapHandle noLinkHandle;
/** 忽略的关键字 */
@property (nonatomic, strong) NSArray * igoreKeywords;
/** 行间距 */
@property (nonatomic, assign) CGFloat lineSpacing;
/** 是否自动高亮显示 */
@property (nonatomic, assign,getter=isAutoHighlightText) BOOL autoHighlightText;
/** 点击高亮时的背景颜色 */
@property (nonatomic, strong) UIColor * selectBackgroundColor;
/** 自定义高亮的数组 @{@"text":@"",@"attribute":@{}}*/
@property (nonatomic, strong) NSArray<NSDictionary *> * customArray;

@property (nonatomic, weak) id<WTLabelDelegate> delegate;
/**
 *  设置高亮属性
 *  attributes: 高亮属性
 *  linkType: 高亮类型
 */
- (void)setAttributes:(NSDictionary *)attributes forLinkType:(WTLinkType)linkType;
@end
