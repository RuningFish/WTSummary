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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView * imageView = [[UIImageView alloc] init];
//    [self.view addSubview:imageView];
//    imageView.backgroundColor = [UIColor redColor];
//    imageView.frame = CGRectMake(0, 100, self.view.frame.size.width, 300);
//    
//    UIImage * image = [UIImage captureImageWithView:imageView];
    
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
    
//    WTTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    [cell.contentView addSubview:imageView];
    WTTableViewCell * cell = [WTTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WTTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cell = cell;
    CGRect rect = cell.frame;//[self.view convertRect:cell.frame fromView:cell];
    
  
    CGRect cellRect = [cell convertRect:rect toView:self.view];
    
    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    
    CGRect rectInSuperView = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
//    CGRect rect1 = [cell.imageView convertRect:cell.imageView.frame fromView:self.contentView];//获取button在contentView的位置
//    
//    CGRect rect2 = [sender convertRect:rect1 toView:window];
//    
//      NSLog(@"cell - %@ 2 %@",NSStringFromCGRect(cell.frame),NSStringFromCGRect(rectInSuperView));
    TestThreeViewController * testThree = [[TestThreeViewController alloc] init];
//    testThree.cellFrame = cell.frame;
    self.navigationController.delegate = testThree;
    [self.navigationController pushViewController:testThree animated:YES];
}

@end


@implementation WTTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString * ID = @"original";
    WTTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[WTTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * imageview = [[UIImageView alloc] init];
        [self.contentView addSubview:imageview];
        self.imageview = imageview;
        self.imageview.backgroundColor = WTRandomColor;
        self.imageview.userInteractionEnabled = YES;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//        [self.imageview addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageview.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20);
    
}

- (void)tap{
    
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    
//    CGRect rect1 = [self.imageview convertRect:self.imageview.frame fromView:self.contentView];//获取button在contentView的位置
//    
//    CGRect rect2 = [self.imageview convertRect:rect1 toView:window];
//    
//    NSLog(@"cell - %@ 2 %@",NSStringFromCGRect(rect1),NSStringFromCGRect(rect2));
    
  
}
@end

