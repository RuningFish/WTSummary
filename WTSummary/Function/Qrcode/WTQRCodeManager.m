//
//  WTQRCodeManager.m
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTQRCodeManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import<Photos/Photos.h>
@interface WTQRCodeManager ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@end
@implementation WTQRCodeManager

+ (instancetype)manager{
    return [[self alloc] init];
}

+ (UIImage *)createQRCodeImageWithData:(NSString *)data size:(CGFloat)size {
    return [self createQRCodeImageWithData:data size:size color:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
}
/**
 *  生成自定义颜色的 二维码
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param color    二维码颜色
 *  @param backgroundColor    二维码背景颜色
 */
+ (UIImage *)createQRCodeImageWithData:(NSString *)data size:(CGFloat)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor {
    NSData *string_data = [data dataUsingEncoding:NSUTF8StringEncoding];
    // 1、二维码滤镜
    CIFilter *fileter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [fileter setValue:string_data forKey:@"inputMessage"];
    [fileter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = fileter.outputImage;
    // 2、颜色滤镜
    CIFilter *color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    [color_filter setValue:ciImage forKey:@"inputImage"];
    [color_filter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
    [color_filter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"];
    // 3、生成处理
    CIImage *outImage = color_filter.outputImage;
    CGFloat scale = size / outImage.extent.size.width;
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
    return [UIImage imageWithCIImage:outImage];
}
/**
 *  生成带 logo 的二维码
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例
 */
+ (UIImage *)createQRCodeImageWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio {
    return [self createQRCodeImageWithData:data size:size logoImage:logoImage ratio:ratio logoImageCornerRadius:5 logoImageBorderWidth:5 logoImageBorderColor:[UIColor whiteColor]];
}
/**
 *  生成带 logo 的二维码
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例
 *  @param logoImageCornerRadius    logo 外边框圆角
 *  @param logoImageBorderWidth     logo 外边框宽度
 *  @param logoImageBorderColor     logo 外边框颜色
 */
+ (UIImage *)createQRCodeImageWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio logoImageCornerRadius:(CGFloat)logoImageCornerRadius logoImageBorderWidth:(CGFloat)logoImageBorderWidth logoImageBorderColor:(UIColor *)logoImageBorderColor {
    UIImage *image = [self createQRCodeImageWithData:data size:size color:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    if (logoImage == nil) return image;
    if (ratio < 0.0 || ratio > 0.5) {
        ratio = 0.25;
    }
    CGFloat logoImageW = ratio * size;
    CGFloat logoImageH = logoImageW;
    CGFloat logoImageX = 0.5 * (image.size.width - logoImageW);
    CGFloat logoImageY = 0.5 * (image.size.height - logoImageH);
    CGRect logoImageRect = CGRectMake(logoImageX, logoImageY, logoImageW, logoImageH);
    // 绘制logo
    UIGraphicsBeginImageContextWithOptions(image.size, false, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (logoImageCornerRadius < 0.0 || logoImageCornerRadius > 10) {
        logoImageCornerRadius = 5;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:logoImageRect cornerRadius:logoImageCornerRadius];
    if (logoImageBorderWidth < 0.0 || logoImageBorderWidth > 10) {
        logoImageBorderWidth = 5;
    }
    path.lineWidth = logoImageBorderWidth;
    [logoImageBorderColor setStroke];
    [path stroke];
    [path addClip];
    [logoImage drawInRect:logoImageRect];
    UIImage *QRCodeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return QRCodeImage;
}

- (void)establishQRCodeScanWithController:(UIViewController *)viewController{
    if (![self cameraAuthorization]) {
        @throw [NSException exceptionWithName:@"ScanQRCodeManager" reason:@"ScanQRCodeManager 中 相机权限禁止访问,请先调用 requestAccessForCamera" userInfo:nil];
    }
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.captureSession canAddInput:deviceInput]){
        [self.captureSession addInput:deviceInput];
    }
    if ([self.captureSession canAddOutput:dataOutput]){
        [self.captureSession addOutput:dataOutput];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [dataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    dataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // PreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = viewController.view.bounds;
    [viewController.view.layer insertSublayer:previewLayer atIndex:0];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // 设置界面显示扫描结果
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *codeObject = metadataObjects[0];
        NSString *result = codeObject.stringValue;
        NSLog(@"扫描的结果 === (%@)",result);
        [self.captureSession stopRunning];
        if (self.scanResultBlock) {
            self.scanResultBlock(self, result);
        }
    }
}

- (void)establishQRCodeScanFromAlbumWithController:(UIViewController *)viewController completionHandler:(nonnull void (^)(void))completionHandler{
    if (![self albumAuthorization]) {
        @throw [NSException exceptionWithName:@"ScanQRCodeManager" reason:@"ScanQRCodeManager 中 照片权限禁止访问,请先调用 requestAccessForAlbum" userInfo:nil];
    }
    
    __weak __typeof(self) weakSelf = self;
    if (!weakSelf.viewController) {
        weakSelf.viewController = viewController;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = weakSelf;
    [viewController presentViewController:imagePicker animated:YES completion:completionHandler];
}

#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    // 读取识别结果
    __weak __typeof(self) weakSelf = self;
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count > 0) {
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            NSString *result = feature.messageString;
            [weakSelf.viewController dismissViewControllerAnimated:YES completion:^{
                if (weakSelf.albumResultBlock) {
                    weakSelf.albumResultBlock(weakSelf, result);
                }
            }];
            NSLog(@"相册读取的结果 === (%@)",result);
        }
    }else{
        [weakSelf.viewController dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.albumResultBlock) {
                weakSelf.albumResultBlock(weakSelf, @"");
            }
            NSLog(@"相册读取的结果 === (%@) ",@"");
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    __weak __typeof(self) weakSelf = self;
    [weakSelf.viewController dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.albumCancelBlock) {
            weakSelf.albumCancelBlock(self);
        }
    }];
}

- (void)startRunning{
    [self.captureSession startRunning];
}

- (void)stopRunning{
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

- (BOOL)cameraAuthorization{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

- (void)requestAccessForCamera:(void(^)(BOOL granted))completion{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(granted);
        });
    }];
}

- (BOOL)albumAuthorization{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            return NO;
        }
    }
    else{
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted ||
            author ==ALAuthorizationStatusDenied){
            return NO;
        }
    }
    return YES;
}

- (void)requestAccessForAlbum:(void(^)(BOOL granted))completion{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [PHPhotoLibrary  requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL granted = (status == PHAuthorizationStatusAuthorized)?YES:NO;
                completion(granted);
            });
        }];
    }else{
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(*stop);
            });
            *stop = TRUE;
        } failureBlock:^(NSError *error) {}];
    }
}

@end
