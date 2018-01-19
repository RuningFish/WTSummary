//
//  WTFormEditCell.h
//  WTSummary
//
//  Created by piyingke on 2018/1/18.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormBaseCell.h"
@class WTFormEditItem;
@interface WTFormEditCell : WTFormBaseCell
/***/
@property (nonatomic ,strong) UITextField * editField;
/** item */
@property (nonatomic ,strong) WTFormEditItem * item;

//- (instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier;
@end
