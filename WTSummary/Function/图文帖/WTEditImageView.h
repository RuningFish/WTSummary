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
/** title */
@property(nonatomic, copy) NSString * title;
@property (nonatomic, assign) NSInteger location;

/** <#desc#> */
@property(nonatomic, copy) WTEditImageViewEditBlock editBlock;
@property(nonatomic, copy) WTEditImageViewDeleteBlock deleteBlock;
@property(nonatomic, copy) WTEditImageViewMoveBlock moveBlock;

- (instancetype)initWithDataSourece:(id<WTEditImageViewDataSource>)dataSource;

@end
