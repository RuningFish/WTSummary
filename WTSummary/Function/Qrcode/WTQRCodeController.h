//
//  WTQRCodeController.h
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTQRCodeView.h"
#import "WTQRCodeManager.h"
@interface WTQRCodeController : UIViewController
@property (nonatomic, strong) WTQRCodeView *qRCodeView;//扫描二维码界面视图
@property (nonatomic, strong) WTQRCodeManager *codeManager;

- (instancetype)initCodeVCWithScanResultCompletionHandler:(void (^)(NSString *result))completionHandler;
@end
