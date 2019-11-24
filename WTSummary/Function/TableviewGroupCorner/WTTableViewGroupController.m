//
//  WTTableViewGroupController.m
//  WTSummary
//
//  Copyright © 2019 飞奔的小鲨鱼. All rights reserved.
//

#import "WTTableViewGroupController.h"
#import "WTTableViewGroupCornerCell.h"
@interface WTTableViewGroupController ()
@property (nonatomic, strong) NSMutableArray *groupData;
@end

@implementation WTTableViewGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分组圆角cell";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.groupData[section];
    NSArray *arr = dict[@"data"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTTableViewGroupCornerCell *cell = [WTTableViewGroupCornerCell cellWithTableView:tableView];
    NSDictionary *dict = self.groupData[indexPath.section];
    cell.title = dict[@"data"][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{

    NSDictionary *dict = self.groupData[indexPath.section];
    NSArray *group = dict[@"data"];
    WTTableViewGroupCornerCell *cornerCell = (WTTableViewGroupCornerCell *)cell;
    CGFloat cornerRadius = 10;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:cornerCell.contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0, 0)];;
    if (group.count == 1 || group.count == 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:cornerCell.contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (group.count > 1){
        if (indexPath.row == 0) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:cornerCell.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }else if (indexPath.row == group.count - 1){
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:cornerCell.contentView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
    }
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = cornerCell.contentView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    cornerCell.contentView.layer.mask = shapeLayer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, headerView.frame.size.height)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [headerView addSubview:titleLabel];
    NSDictionary *dict = self.groupData[section];
    titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"type"]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, footerView.frame.size.width, 10)];
    [footerView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorWithRed:244/255.0 green:249/255.0 blue:251/255.0 alpha:1.0];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - lazy
- (NSMutableArray *)groupData{
    if (!_groupData) {
        NSArray *arr = @[@"如梦令",@"昨夜雨疏风骤",@"浓睡不消残酒",@"试问卷帘人",@"却道海棠依旧",@"知否？知否？",@"应是绿肥红瘦"];
        _groupData = [NSMutableArray array];
        for (int i = 0; i < arr.count; i ++) {
            NSString *string = [NSString stringWithFormat:@"%@ ----- %d",arr[i],i];
            NSMutableArray *temp = [NSMutableArray array];
            for (int j = 0; j <= i; j++) {
                if (i == 0) {
                    string = @"宋·李清照";
                }
                [temp addObject:string];
            }
            NSDictionary *dict = @{@"type":arr[i],
                                @"data":temp,
                                };
            [_groupData addObject:dict];
        }
    }
    return _groupData;
}

@end
