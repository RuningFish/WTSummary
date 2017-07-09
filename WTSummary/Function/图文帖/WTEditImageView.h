//
//  WTEditImageView.h
//  WTSummary
//
//  Created by piyingke on 17/7/7.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTEditImageView;
typedef void  (^WTEditImageViewEditBlock)(WTEditImageView * imageView);
typedef void  (^WTEditImageViewDeleteBlock)(WTEditImageView * imageView);
typedef void  (^WTEditImageViewMoveBlock)(WTEditImageView * imageView,UILongPressGestureRecognizer *longPress);

@protocol WTEditImageViewDataSource <NSObject>

- (void)p_longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress;

@end

@interface WTEditImageView : UIView

@property (nonatomic, strong) id image;
/** 图片的描述 */
@property(nonatomic, copy) NSString * title;
/** 图片的高度 (按比例缩放) */
@property (nonatomic, assign) CGFloat  imageH;
/** 图片的位置 */
@property (nonatomic, assign) NSInteger location;
/** 图片之间的间距 */
@property (nonatomic, assign) CGFloat margin;
/** uuid */
@property (nonatomic, copy) NSString * uuid;

/** <#desc#> */
@property(nonatomic, copy) WTEditImageViewEditBlock editBlock;
@property(nonatomic, copy) WTEditImageViewDeleteBlock deleteBlock;
@property(nonatomic, copy) WTEditImageViewMoveBlock moveBlock;

- (instancetype)initWithDataSourece:(id<WTEditImageViewDataSource>)dataSource;

@end
