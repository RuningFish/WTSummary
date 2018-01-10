//
//  WTDisplayView.h
//  WTSummary
//
//  Created by piyingke on 2018/1/8.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    WTDisplayViewPageControlAligmentCenter = 0,
    WTDisplayViewPageControlAligmentRight
}WTDisplayViewPageControlAligment;

@class WTDisplayView;
@protocol WTDisplayViewDelegate<NSObject>
@optional
- (void)displayView:(WTDisplayView *)displayView didSelectItemAtIndex:(NSInteger)index;

@end

@interface WTDisplayView : UIView
/** 存放images的数组 */
@property (nonatomic ,strong) NSArray * images;
/** 存放title的数组 */
@property (nonatomic ,strong) NSArray * titles;
/** 是否循环播放 默认yes */
@property (nonatomic ,assign) BOOL isRepeat;
/** 是否自动滚动 默认yes */
@property (nonatomic ,assign) BOOL autoDisplay;
/** 图片的间隔 */
@property (nonatomic ,assign) NSTimeInterval timeInterval;
/** 只显示文字 */
@property (nonatomic ,assign) BOOL displayText;
/** 滚动的方向 */
@property (nonatomic ,assign) UICollectionViewScrollDirection scrollDirection;
/** pageControl的位置 */
@property (nonatomic ,assign) WTDisplayViewPageControlAligment pageAligment;
@property (nonatomic ,strong) UIColor * currentPageTintColor;
@property (nonatomic ,strong) UIColor * pageTintColor;
@property (nonatomic ,weak) id<WTDisplayViewDelegate> delegate;
@property (nonatomic ,copy) void (^clickItemAtIndexBlock)(NSInteger clickIndex);

+ (instancetype)displayViewWithFrame:(CGRect)frame delegate:(id<WTDisplayViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

+ (instancetype)displayViewWithFrame:(CGRect)frame imageStringArray:(NSArray *)imageString;
/** 只展示文字的时候不响应手势 */
- (void)disableScroll;
/** viewWillAppear时出现时轮播图卡在一半的问题 */
- (void)adjustWhenViewControllerWillAppear;
@end

@interface WTDisplayCell : UICollectionViewCell
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UIImageView * imageView; // 要显示的图片
@property (nonatomic ,copy)   NSString * title;  // 要显示的文字
@property (nonatomic ,strong) UIColor * textColor;// 文字的颜色
@property (nonatomic ,strong) UIFont * textFont; // 文字的大小
@property (nonatomic ,strong) UIColor * textBackgroundColor;//文字所在区域的背景色
@property (nonatomic ,assign) CGFloat textHeight;// 文字所在区域的高度
@property (nonatomic ,assign) BOOL displayText;// 只展示文字
@end
