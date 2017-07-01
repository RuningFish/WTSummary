//
//  WTAuthorityManager.h
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> //定位权限

//@protocol LocationStatusProtocol <NSObject>
//@property (nonatomic,assign) CLAuthorizationStatus status;
//@optional
//-(void)locationStatusChangeNotification:(NSNotification *)notification;
//@end

@interface WTAuthorityManager : NSObject
+ (instancetype)authorityManager;

/** 相册 */
- (BOOL)hasPhotoAuthority;
- (void)getPhotoAuthorityWithHandle:(void (^)())handle;

/** 相机 */
- (BOOL)hasCameraAuthority;
- (void)getCameraAuthorityWithHandle:(void(^)())handle;

/** 录音 */
- (BOOL)hasAudioAuthority;
- (void)getAudioAuthorityWithHandle:(void(^)())handle;

/** 通讯录 */
- (BOOL)hasContactAuthority;
- (void)getContactAuthorityWithHandle:(void (^)())handle;

/** 媒体资料库 */
- (BOOL)hasMediaAuthority;
- (void)getMediaAuthorityWithHandle:(void (^)())handle;

/** 语音识别 */
- (BOOL)hasSpeechAuthority;
- (void)getSpeechAuthorityWithHandle:(void (^)())handle;

/** 日历 */
- (BOOL)hasEventAuthority;
- (void)getEventAuthorityWithHandle:(void (^)())handle;

/** 蓝牙 */
- (BOOL)hasBlueToothAuthority;
- (void)getBlueToothWithhandle:(void (^)())handle;

@end
