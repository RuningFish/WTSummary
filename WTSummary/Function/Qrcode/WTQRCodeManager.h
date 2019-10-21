//
//  WTQRCodeManager.h
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WTQRCodeManager;
typedef void (^ScanQRCodeManagerResultBlock)(WTQRCodeManager *manager,NSString *result);
typedef void (^ScanQRCodeManagerFromAlbumResultBlock)(WTQRCodeManager *manager, NSString *result);
typedef void (^ScanQRCodeFromManagerAlbumCancelBlock)(WTQRCodeManager *manager);

@interface WTQRCodeManager : NSObject
@property (nonatomic, copy) ScanQRCodeManagerResultBlock scanResultBlock;        // 扫描结果的回调
@property (nonatomic, copy) ScanQRCodeManagerFromAlbumResultBlock albumResultBlock;// 相册结果的回调
@property (nonatomic, copy) ScanQRCodeFromManagerAlbumCancelBlock albumCancelBlock;// 扫描取消的回调
+ (instancetype)manager;

+ (UIImage *)createQRCodeImageWithData:(NSString *)data size:(CGFloat)size;
/**
 *  生成自定义颜色的二维码
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param color    二维码颜色
 *  @param backgroundColor    二维码背景颜色
 */
+ (UIImage *)createQRCodeImageWithData:(NSString *)data size:(CGFloat)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;
/**
 *  生成带 logo 的二维码
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例（取值范围 0.0 ～ 0.5f）
 */
+ (UIImage *)createQRCodeImageWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio;

- (void)establishQRCodeScanWithController:(UIViewController *)viewController;
- (void)establishQRCodeScanFromAlbumWithController:(UIViewController *)viewController completionHandler:(void(^)(void))completionHandler;
- (void)requestAccessForCamera:(void(^)(BOOL granted))completion;
- (void)requestAccessForAlbum:(void(^)(BOOL granted))completion;

- (BOOL)cameraAuthorization;
- (BOOL)albumAuthorization;

- (void)startRunning;
- (void)stopRunning;
@end

NS_ASSUME_NONNULL_END
