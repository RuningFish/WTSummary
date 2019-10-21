//
//  WTQRCodeController.m
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTQRCodeController.h"
#import <AVFoundation/AVFoundation.h>

@class WTQRCodeController;
typedef void (^resultCompletionHandlerBlock)(NSString *result);
typedef void (^albumDidClcikCancelBlock)(void);
@interface WTQRCodeController ()
@property (nonatomic, copy) resultCompletionHandlerBlock completionHandler;
@end

@implementation WTQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.codeManager = [WTQRCodeManager manager];
    __weak __typeof(self) weakSelf = self;
    [weakSelf.codeManager requestAccessForCamera:^(BOOL granted) {
        if (granted) {
            [weakSelf.codeManager establishQRCodeScanWithController:weakSelf];
            [weakSelf.codeManager startRunning];
            [weakSelf.view addSubview:weakSelf.qRCodeView];
            [weakSelf.qRCodeView addTimer];
        }else{
            NSString *msg = @"你的相机权限没有打开，请打开“设置-隐私-相机”后进行设置";
            [weakSelf alertWithMessage:msg cancelHandler:^{
                [weakSelf backAction];
            }];
        }
    }];
    
    // 扫描结果的处理
    weakSelf.codeManager.scanResultBlock = ^(WTQRCodeManager *manager, NSString *result){
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.completionHandler) {
            weakSelf.completionHandler(result);
        }
    };
    
    // 相册按钮
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:photoBtn];
    [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    photoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    photoBtn.frame = CGRectMake(10, 0, 60, 44);
    [photoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [photoBtn addTarget:self action:@selector(openAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:photoBtn];
    
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(handlerPopGestureRecognizer:)];
}

- (instancetype)initCodeVCWithScanResultCompletionHandler:(void (^)(NSString *result))completionHandler{
    if (completionHandler) {
        self.completionHandler = completionHandler;
    }
    if (self == [super init]) {
        
    }
    return self;
}

- (void)backAction{
    if (self.qRCodeView) {
        [self.qRCodeView removeTimer];
        [self.qRCodeView removeFromSuperview];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openAlbumAction{
    __weak __typeof(self) weakSelf = self;
    [weakSelf.codeManager requestAccessForAlbum:^(BOOL granted) {
        if (granted) {
            [weakSelf.codeManager establishQRCodeScanFromAlbumWithController:weakSelf completionHandler:^{
                [weakSelf stopRuning];
            }];
        }else{
            NSString *msg = @"你的照片权限没有打开，请打开“设置-隐私-照片”后进行设置";
            [weakSelf alertWithMessage:msg cancelHandler:^{
                [weakSelf startRuning];
            }];
        }
    }];
    
    //    weakSelf.codeManager.albumCancelBlock = ^(WTQRCodeManager *manager){
    //        [weakSelf startRuning];
    //    };
    
    [weakSelf.codeManager setAlbumCancelBlock:^(WTQRCodeManager * _Nonnull manager) {
        [weakSelf startRuning];
    }];
    
    // 相册读取结果的处理
    weakSelf.codeManager.albumResultBlock = ^(WTQRCodeManager *manager, NSString *result){
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.completionHandler) {
            weakSelf.completionHandler(result);
        }
    };
    
}

- (void)handlerPopGestureRecognizer:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        [self stopRuning];
    }else {
        [self startRuning];
    }
}

- (WTQRCodeView *)qRCodeView {
    if (!_qRCodeView) {
        _qRCodeView = [[WTQRCodeView alloc] initWithFrame:self.view.bounds];
        _qRCodeView.userInteractionEnabled = YES;
        _qRCodeView.cornerLocation = CornerLocationOutside;
    }
    return _qRCodeView;
}

- (void)startRuning{
    [self.codeManager startRunning];
    [self.qRCodeView addTimer];
}

- (void)stopRuning{
    [self.codeManager stopRunning];
    [self.qRCodeView removeTimer];
}

- (void)dealloc{
    [self stopRuning];
    [self.qRCodeView removeFromSuperview];
    NSLog(@"ScanQRCodeVC --- delloc");
}

- (void)alertWithMessage:(NSString *)message cancelHandler:(void (^)(void))cancel{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if(cancel){
                cancel();
            }
        }];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"",nil];
        [alert show];
    }
}
@end
