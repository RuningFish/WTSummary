//
//  ViewController.m
//  WTSummary
//
//  Created by admin on 17/6/25.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "TestViewController.h"
#import "WTQRCodeController.h"
#import "WTImageTextViewController.h"// 图文
#import "WTPlaybackViewController.h"
#import "WTPersonalViewController.h"
#import "WTCardViewController.h"
#import "TestTwoViewController.h"
#import "WTDisplayViewController.h"
#import "WTFormSettingController.h" // 表单
#import "WTAutoPlayViewController.h" // 自动播放测试

typedef void (^block)();

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView * tableView;
/** <#desc#> */
@property (nonatomic, strong) NSArray  * dataArray;
@property (nonatomic, copy) block block;
@end

static NSString * const WTAlertController_ActionSheet = @"WTAlertController - ActionSheet";
static NSString * const WTAlertController_Alert = @"WTAlertController - Alert";
static NSString * const JSAndOC = @"JS and OC";
static NSString * const ImageAndTitle = @"图文帖";
static NSString * const WTPlayback = @"WTPlayback";
static NSString * const WTPersonal = @"WTPersonalViewController";
static NSString * const WTCardView = @"WTCardViewController";
static NSString * const WTTransition = @"WTTransition";
static NSString * const WTDisplayView = @"WTDisplayView";
static NSString * const WTFormCell = @"WTFormCell";
static NSString * const AutoPlay = @"AutoPlay";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    UIBarButtonItem * leftItem = [UIBarButtonItem itemWithType:UIBarButtonItemTypeLeft Image:@"discover_tv_icon_code" highImage:nil target:self action:@selector(iconCodeClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    static int a = 10;
    self.block = ^(){
        a = 20;
        NSLog(@"%@ %ld",[self.block class],a);
    };
    
    self.block();
}

- (void)iconCodeClick{
    
    // 1.打开二维码界面
    WTQRCodeController *codeVC = [[WTQRCodeController alloc] initCodeVCWithScanResultCompletionHandler:^(NSString *result) {
        NSLog(@"扫描的结果 === %@",result);
    }];
    codeVC.qRCodeView.cornerColor = [UIColor redColor];
    codeVC.qRCodeView.scanLineImage = [UIImage imageNamed:@"home_share_code_line"];
    codeVC.qRCodeView.cornerLocation = CornerLocationDefault;
    codeVC.qRCodeView.animationTimeInterval = 0.07;
    [self.navigationController pushViewController:codeVC animated:YES];
    
}

- (void)tapGesture{
    TestViewController * test = [[TestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        //CGRectMake(0, 0, self.view.frame.size.width, self.view.size.height )
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MIN(rect.size.width, rect.size.height), MAX(rect.size.width, rect.size.height)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[WTAlertController_ActionSheet,WTAlertController_Alert,JSAndOC,ImageAndTitle,WTPlayback,WTPersonal,WTCardView,WTTransition,WTDisplayView,WTFormCell,AutoPlay];
    }
    return _dataArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView  deselectRowAtIndexPath:indexPath animated:NO];
    WTAlertControllerStyle style;
    if (indexPath.row > self.dataArray.count - 1) return;
    
    NSString * title = self.dataArray[indexPath.row];
    
    if ([title isEqualToString:WTAlertController_ActionSheet]) {
        style = WTAlertControllerStyleActionSheet;
        [self alertVontrollerWithType:style];
    }else if ([title isEqualToString:WTAlertController_Alert]){
        style = WTAlertControllerStyleAlert;
        [self alertVontrollerWithType:style];
    }else if ([title isEqualToString:JSAndOC]){
        // JSAndOC
        TestViewController * jsTest = [[TestViewController alloc] init];
        [self.navigationController pushViewController:jsTest animated:YES];
    }else if ([title isEqualToString:ImageAndTitle]){
        // 图文帖
        WTImageTextViewController * imageText = [[WTImageTextViewController alloc] init];
        [self.navigationController pushViewController:imageText animated:YES];
    }
    else if ([title isEqualToString:WTPlayback]){
        // WTPlayback
        WTPlaybackViewController * playbackController = [[WTPlaybackViewController alloc] init];
        [self.navigationController pushViewController:playbackController animated:YES];
    }
    else if ([title isEqualToString:WTPersonal]){
        // WTPersonalViewController
        WTPersonalViewController * personal = [[WTPersonalViewController alloc] init];
        [self.navigationController pushViewController:personal animated:YES];
    }
    else if ([title isEqualToString:WTCardView]){
        WTCardViewController * cardViewController = [[WTCardViewController alloc] init];
        [self.navigationController pushViewController:cardViewController animated:YES];
    }
    else if ([title isEqualToString:WTTransition]){
        TestTwoViewController * two = [[TestTwoViewController alloc] init];
        [self.navigationController pushViewController:two animated:YES];
    }
    else if ([title isEqualToString:WTDisplayView]){
        WTDisplayViewController * displayVC = [[WTDisplayViewController alloc] init];
        [self.navigationController pushViewController:displayVC animated:YES];
    }
    else if ([title isEqualToString:WTFormCell]){
        WTFormSettingController * seetingVC = [[WTFormSettingController alloc] init];
        [self.navigationController pushViewController:seetingVC animated:YES];
    }
    else if ([title isEqualToString:AutoPlay]){
        WTAutoPlayViewController * autoPlayVC = [[WTAutoPlayViewController alloc] init];
        [self.navigationController pushViewController:autoPlayVC animated:YES];
    }
}

- (void)alertVontrollerWithType:(WTAlertControllerStyle)type{
    
    WTAlertController * alert = [WTAlertController alertControllerWithTitle:@"或点击客户端杰卡斯" message:@"回到家看撒谎京东卡时间段" preferredStyle:type];
    
    WTAlertAction *action1 = [WTAlertAction actionWithTitle:@"取消" style:WTAlertActionStyleCancel handler:^(WTAlertAction *action) {
        
    }];
    
    WTAlertAction *action2 = [WTAlertAction actionWithTitle:@"置顶" style:WTAlertActionStyleDestructive handler:^(WTAlertAction *action) {
        NSLog(@"title - %@",action.title);
    }];
    
    WTAlertAction *action3 = [WTAlertAction actionWithTitle:@"收藏" style:WTAlertActionStyleDefault handler:^(WTAlertAction *action) {
        NSLog(@"title - %@",action.title);
    }];
    
    WTAlertAction *action4 = [WTAlertAction actionWithTitle:@"举报" style:WTAlertActionStyleDefault handler:^(WTAlertAction *action) {
        NSLog(@"title - %@",action.title);
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    
    [alert show];

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
