//
//  WTFormBaseCell.h
//  WTSummary
//
//  Created by piyingke on 2018/1/17.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTFormBaseItem.h"
@interface WTFormBaseCell : UITableViewCell
/** image */
@property (nonatomic ,strong) UIImageView * baseCellImage;
/** arrowImage */
@property (nonatomic ,strong) UIImageView * arrowImage;
/** title */
@property (nonatomic ,strong) UILabel * titleLabel;
/** 分割线 */
@property (nonatomic ,strong) UIView * devideLine;
/** 分割线的颜色 */
@property (nonatomic ,strong) UIColor * devideLineColor;
/** image的大小 */
@property (nonatomic ) CGSize baseImageSize;
/** arrow的大小 */
@property (nonatomic ) CGSize arrowImageSize;

- (instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier item:(WTFormBaseItem *)item;
@end
