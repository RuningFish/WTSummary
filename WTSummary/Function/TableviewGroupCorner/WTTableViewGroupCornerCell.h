//
//  WTTableViewGroupCornerCell.h
//  WTSummary
//
//  Created by wangtian on 2019/11/24.
//  Copyright © 2019 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTTableViewGroupCornerCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
