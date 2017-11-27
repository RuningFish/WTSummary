//
//  WTPageControl.h
//  123
//
//  Created by piyingke on 2017/11/13.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTPageControl;

typedef enum {
    WTPageControlStyleLine = 0,            // 下划线与item等宽
    WTPageControlStyleLineLongerThanItem,  // 下划线 = item + 间距
    WTPageControlStyleLineAttachment,      // 弹性的动画效果
    WTPageControlStyleTextZoom,            // 文字缩放
    WTPageControlStyleRoundRect,           // 圆角
    WTPageControlStyleRect                 // 矩形
    
}WTPageControlStyle;

/** 布局类型 */
typedef enum {
    WTPageControlLayoutTypeAdaptContent = 0,  // 自适应内容，可以左右滑动
    WTPageControlLayoutTypeEqualWidth,        // 等宽排列
}WTPageControlLayoutType;

/** item的样式 */
typedef enum {
    WTPageControlItemStyleNone = 0,   // 默认样式
    WTPageControlItemStyleLeft ,      // 图片在左，文字在右
    WTPageControlItemStyleRight ,     // 图片在右，文字在左
    WTPageControlItemStyleBottom ,    // 图片在下，文字在上
    WTPageControlItemStyleTop ,       // 图片在上，文字在下
    WTPageControlItemStyleImage ,     // 只有图片，没有文字
    WTPageControlItemStyleTitle       // 只有文字，没有图片
    
}WTPageControlItemStyle;

@protocol WTPageControlDelegate <NSObject>
@optional
/** 若两个方法同时实现,优先响应 selectexItemFromIndex:toIndex 方法 */
- (void)pageControl:(WTPageControl *)pageControl selectexItemIndex:(NSInteger)index;
- (void)pageControl:(WTPageControl *)pageControl selectexItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
@end

@interface WTPageControl : UIControl
/** item 图片的大小 (有图片，有文字的情况) */
@property (nonatomic, assign) CGSize itemImageSize;
/** item 样式 */
@property (nonatomic, assign) WTPageControlItemStyle itemStyle;

/** 选中的下标 */
@property (nonatomic, assign) NSInteger selectedItemIndex;
/** item标题字体 */
@property (nonatomic, strong) UIFont * itemFont;
/** 未选中的标题颜色 */
@property (nonatomic, strong) UIColor * normalItemTitleColor;
/** 选中的标题颜色 */
@property (nonatomic, strong) UIColor * selectedItemTitleColor;
/** 下划线的背景色 */
@property (nonatomic, strong) UIColor * bottomLineBgColor;
/** item之间的间距 */
@property (nonatomic, assign) CGFloat itemPadding;
/** 下划线的高度 默认为2 */
@property (nonatomic, assign) CGFloat bottomLineHeight;
/** item的内边距 */
@property (nonatomic, assign) UIEdgeInsets contentInset;
/** 底部的下划线 */
@property (nonatomic, strong)   UIView * bottomLine;
/** 传入的scrollView,需要监听它的滚动让下划线移动 */
@property (nonatomic, strong) UIScrollView * scrollView;
/** 是否需要文字渐变效果 默认 YES */
@property (nonatomic, assign) BOOL itemColorGradient;

/** 布局item的类型 */
@property (nonatomic, assign) WTPageControlLayoutType layoutType;
/** delegate */
@property (nonatomic , weak) id<WTPageControlDelegate> delegate;

+ (instancetype)pageControlWithFrame:(CGRect)frame pageControlStyle:(WTPageControlStyle)pageControlStyle;
- (instancetype)initWithFrame:(CGRect)frame pageControlStyle:(WTPageControlStyle)pageControlStyle;
/**
 *  传递数组(数组元素只能是NSString或UIImage类型)
 *
 *  @param items    数组
 *  @param selectedItemIndex  选中哪个item
 */
- (void)setItems:(NSArray *)items selectedItemIndex:(NSUInteger)selectedItemIndex;
@end
