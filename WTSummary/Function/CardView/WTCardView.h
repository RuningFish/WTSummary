//
//  WTCardView.h
//  WTSummary
//
//  Created by piyingke on 2017/11/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTCardView,WTCardViewCell;
typedef enum {
    WTCardViewStyleDefault = 0, // 重合样式
    WTCardViewStyleStack        // 层叠样式
}WTCardViewStyle;

@protocol WTCardViewDelegate<NSObject>
- (void)cardView:(WTCardView *)cardView didSelectItemAtIndex:(NSInteger)index;
@end

@protocol WTCardViewDataSource<NSObject>
@required
- (NSInteger)numberOfItemsInCardView:(WTCardView *)cardView;
- (WTCardViewCell *)cardView:(WTCardView *)cardView cellAtIndex:(NSInteger )index;

@optional
- (CGSize)cardView:(WTCardView *)cardView sizeForCellAtIndex:(NSInteger )index;
@end

@interface WTCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame andStyle:(WTCardViewStyle)style;

/** delegate */
@property (nonatomic, weak) id<WTCardViewDelegate> delegate;
/** dataSource */
@property (nonatomic, weak) id<WTCardViewDataSource> dataSource;

- (void)reloadData;
- (WTCardViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
