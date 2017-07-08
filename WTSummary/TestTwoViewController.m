//
//  TestTwoViewController.m
//  WTSummary
//
//  Created by piyingke on 17/7/7.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "TestTwoViewController.h"
#import "TestThreeViewController.h"
@interface TestTwoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation TestTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 200;
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 10, self.tableView.frame.size.width - 20, self.tableView.rowHeight - 20);
    imageView.backgroundColor = WTRandomColor;
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = cell.frame;//[self.view convertRect:cell.frame fromView:cell];
    
    NSLog(@"cell - %@ 2 %@",NSStringFromCGRect(cell.frame),NSStringFromCGRect(rect));
    TestThreeViewController * testThree = [[TestThreeViewController alloc] init];
    testThree.cellFrame = cell.frame;
    [self.navigationController pushViewController:testThree animated:NO];
}

@end
