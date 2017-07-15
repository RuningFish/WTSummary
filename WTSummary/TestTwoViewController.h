//
//  TestTwoViewController.h
//  WTSummary
//
//  Created by piyingke on 17/7/7.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTTableViewCell;
@interface TestTwoViewController : UIViewController
/** <#desc#>*/
@property (nonatomic,strong)  WTTableViewCell * cell;
@end


@interface WTTableViewCell : UITableViewCell
/** u */
@property (nonatomic , weak) UIImageView * imageview;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
