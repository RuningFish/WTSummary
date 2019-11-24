//
//  WTPDFViewController.m
//  WTSummary
//
//  Copyright © 2019 飞奔的小鲨鱼. All rights reserved.
//

#import "WTPDFViewController.h"
#import <WebKit/WebKit.h>
#import <QuickLook/QuickLook.h>
#import "AFNetworking.h"
@interface WTPDFViewController ()<QLPreviewControllerDataSource>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) QLPreviewController *previewVC;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, copy) NSString *downloadURL;// pdfurl
@end

@implementation WTPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"PDF";
    self.downloadURL = @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf";
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 12.0) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.downloadURL]];
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.webView];
        [self.webView loadRequest:request];
        NSLog(@"wkwebview show pdf");
    }else{
        self.previewVC = [[QLPreviewController alloc] init];
        self.previewVC.dataSource = self;
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicatorView startAnimating];
        [self.view addSubview:self.activityIndicatorView];
        
        [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.width.height.mas_equalTo(50);
        }];
        
        [self downLoadPDF];
        NSLog(@"QLPreviewController show pdf");
    }
}

- (void)downLoadPDF{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",@"test"]];
    if ([fileManager fileExistsAtPath:filePath]) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
        [self addChildViewController:self.previewVC];
        [self.view addSubview:self.previewVC.view];
        self.previewVC.view.frame = self.view.bounds;
        self.fileURL = [NSURL fileURLWithPath:filePath];
        [self.previewVC reloadData];
        NSLog(@"本地加载===");
    }else{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURL *URL = [NSURL URLWithString:self.downloadURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
             self.fileURL = [NSURL fileURLWithPath:filePath];
             return self.fileURL;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [self.activityIndicatorView stopAnimating];
            [self.activityIndicatorView removeFromSuperview];
            if (!error) {
                [self addChildViewController:self.previewVC];
                [self.view addSubview:self.previewVC.view];
                self.previewVC.view.frame = self.view.bounds;
                [self.previewVC reloadData];
            }
        }];
        [downloadTask resume];
        NSLog(@"网络下载===");
    }
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.fileURL;
}
@end
