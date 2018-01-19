//
//  WTFormSelectCell.h
//  WTSummary
//
//  Created by piyingke on 2018/1/18.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormBaseCell.h"
@class WTFormSelectItem;
@interface WTFormSelectCell : WTFormBaseCell
/** label */
@property (nonatomic, strong) UILabel * selectLabel;
/** item */
@property (nonatomic, strong) WTFormSelectItem * item;
@end
