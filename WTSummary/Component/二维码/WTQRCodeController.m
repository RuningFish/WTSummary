//
//  WTQRCodeController.m
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTQRCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "WTQRCodeView.h"
@interface WTQRCodeController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureDevice * device;
/** input */
@property (nonatomic, strong) AVCaptureDeviceInput  * input;
/** output */
@property (nonatomic, strong) AVCaptureMetadataOutput  * output;
/** session */
@property (nonatomic, strong) AVCaptureSession  * session;
/** 图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;
/** 二维码界面视图 */
@property (nonatomic, strong) WTQRCodeView * codeView;

@end

@implementation WTQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])  [_session addInput:self.input];
    if ([_session canAddOutput:self.output])  [_session addOutput:self.output];
 
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // Preview
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
    
    [self.view addSubview:self.codeView];
    [self.codeView addTimer];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture)];
    [self.view addGestureRecognizer:pan];
    
    UIBarButtonItem * leftItem = [UIBarButtonItem itemWithType:UIBarButtonItemTypeLeft Image:@"backwhite" highImage:nil target:self action:@selector(leftBarButtonItemClick)];
    
    UIBarButtonItem * rightItem = [UIBarButtonItem itemWithType:UIBarButtonItemTypeRight Title:@"相册" highTitle:nil Image:nil highImage:nil target:self action:@selector(rightBarButtonItemClick)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftBarButtonItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
   
}
#pragma mark - 打开相册
- (void)rightBarButtonItemClick{

    WTAuthorityManager * manager = [WTAuthorityManager authorityManager];
    BOOL authority = [manager hasPhotoAuthority];
 
    if (authority) {
        UIImagePickerController * imgPick = [[UIImagePickerController alloc] init];
        imgPick.allowsEditing = NO;
        imgPick.delegate = self;
        imgPick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        [self presentViewController:imgPick animated:YES completion:nil];
    }else{
        
    }
}
- (void)panGesture{}

#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.codeView addTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - - - 从相册中识别二维码, 并进行界面跳转
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    // 取得识别结果
    NSArray * features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count) {
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            NSString * urlString = feature.messageString;
            NSLog(@"相册 ＝＝＝ %@ ",urlString);
            [self getItemLinkWithUrlString:urlString];
        }
    }else{
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.codeView removeTimer];
    
}
- (WTQRCodeView *)codeView {
    if (!_codeView) {
        _codeView = [[WTQRCodeView alloc] initWithFrame:self.view.bounds layer:self.view.layer];
        _codeView.userInteractionEnabled = YES;
    }
    return _codeView;
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    [self.codeView removeTimer];
    // 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * codeObject = metadataObjects[0];
        NSString * urlString = codeObject.stringValue;
        
    }
}

- (void)getItemLinkWithUrlString:(NSString * )urlString{
    
    [self.session stopRunning];
    [self.codeView removeTimer];
    
}

#pragma mark - 未识别到有效二维码的提示
- (void)showAlertMessageWithBlock:(void (^)())block{
//    [PYKAlertviewController showAlertViewWithTitle:nil message:alertMessage dismissCallBack:^{
//        if (block) {
//            block();
//        }
//    }];
}
- (void)dealloc{
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:PYKQRCodeInformationFromScanning object:nil];
}
@end
