//
//  WTCardViewCell.h
//  WTSummary
//
//  Created by piyingke on 2017/11/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTCardViewCell;
@protocol WTCardViewCellDelegate<NSObject>
- (void)cellDidRemoveFromSuperView:(WTCardViewCell *)cardViewCell;
@end

@interface WTCardViewCell : UIView
@property (nonatomic, strong) UILabel * label;
/** delegate */
@property (nonatomic , weak) id<WTCardViewCellDelegate> delegate;
@property (nonatomic , copy) NSString * idientifier;
- (instancetype)initWithReuseIdentifier:(NSString *)identifier;
- (void)cellRemoveFromLeft:(BOOL)left andAngle:(CGFloat)angle;
@end
