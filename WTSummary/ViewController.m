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
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView * tableView;
/** <#desc#> */
@property (nonatomic, strong) NSArray  * dataArray;
@end
static NSString * const WTAlertController_ActionSheet = @"WTAlertController - ActionSheet";
static NSString * const WTAlertController_Alert = @"WTAlertController - Alert";
static NSString * const JSAndOC = @"JS and OC";
static NSString * const ImageAndTitle = @"图文帖";
static NSString * const WTPlayback = @"WTPlayback";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem * leftItem = [UIBarButtonItem itemWithType:UIBarButtonItemTypeLeft Image:@"discover_tv_icon_code" highImage:nil target:self action:@selector(iconCodeClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage * image = [UIImage getImageFormVideoUrl:[NSURL URLWithString:@"https://o79mx21qy.qnssl.com/FumidvCTADJcIw2_r1D0RZ2_jiqO"] atIndex:6];
    [self.view addSubview:self.tableView];
//    return;
//    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
//    v.center = self.view.center;
//    [self.view addSubview:v];
//    //v.backgroundColor = [UIColor colorWithHexString:@"#95704f"];
//    
//    [v addDottedLineColor:[UIColor redColor] lineWidth:1.0 lineHeight:20 margin:10];
//    
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
//    [self.view addSubview:imageView];
//    imageView.image = [UIImage createImageWithColor:[UIColor colorWithHexString:@"#FF4F52"]];
//    imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
//    [imageView addGestureRecognizer:tap];
    
}

- (void)iconCodeClick{
    
    // 0.判断相机的权限
    WTAuthorityManager * manager = [WTAuthorityManager authorityManager];
    BOOL authority = [manager hasCameraAuthority];
    if (authority) {
        // 1.打开二维码界面
        WTQRCodeController * codeVC = [[WTQRCodeController alloc] init];
        [self.navigationController pushViewController:codeVC animated:YES];
    }else{
        
        [manager getCameraAuthorityWithHandle:^{
            // 1.打开二维码界面
            WTQRCodeController * codeVC = [[WTQRCodeController alloc] init];
            [self.navigationController pushViewController:codeVC animated:YES];
        }];
        return;
        WTAlertController * alert = [WTAlertController alertControllerWithTitle:@"请在设置中允许访问相册" message:nil preferredStyle:WTAlertControllerStyleAlert];
        WTAlertAction * cancel = [WTAlertAction actionWithTitle:@"取消" style:WTAlertActionStyleDefault handler:^(WTAlertAction *action) {
            
        }];
        [alert addAction:cancel];
        [alert show];
    }
    
}

- (void)tapGesture{
    TestViewController * test = [[TestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
   }

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.size.height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[WTAlertController_ActionSheet,WTAlertController_Alert,JSAndOC,ImageAndTitle,WTPlayback];
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
@end
