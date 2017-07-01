//
//  WTAuthorityManager.m
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//  权限请求的管理类

#import "WTAuthorityManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Contacts/Contacts.h> //通讯录权限
#import <Speech/Speech.h> //语音识别
#import <MediaPlayer/MediaPlayer.h> //媒体资料库
#import <EventKit/EventKit.h> //日历\备提醒事项权限
#import <CoreBluetooth/CoreBluetooth.h> //蓝牙权限
#import <CoreLocation/CoreLocation.h> //定位权限

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS7Front ([UIDevice currentDevice].systemVersion.floatValue <= 7.0f)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

typedef void(^BlueToothBlock)();
@interface WTAuthorityManager ()<CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager * centralManager;

@property (nonatomic, copy) BlueToothBlock block;
@end

@implementation WTAuthorityManager
+ (instancetype)authorityManager{
    static WTAuthorityManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 访问相册权限
- (BOOL)hasPhotoAuthority{
    
    BOOL authority = NO;
    if (iOS8Later) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                authority = NO;
                break;
            }
            case PHAuthorizationStatusAuthorized:
            {
                authority = YES;
                break;
            }
        }
    }else{
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        switch (status) {
            case ALAuthorizationStatusNotDetermined:
            case ALAuthorizationStatusRestricted:
            case ALAuthorizationStatusDenied:
            {
                authority = NO;
            }
            case ALAuthorizationStatusAuthorized:
            {
                authority = YES;
            }
        }
    }
  
    return authority;
}

- (void)getPhotoAuthorityWithHandle:(void (^)())handle{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            if (handle) {
                handle();
            }
        }
    }];
}

#pragma mark - 访问相机权限
- (BOOL)hasCameraAuthority{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status == AVAuthorizationStatusAuthorized ? YES : NO;

}

- (void)getCameraAuthorityWithHandle:(void (^)())handle{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            if (handle) {
                handle();
            }
        }else{
            NSLog(@"访问相机禁止！");
        }
    }];
}

#pragma mark - 访问录音权限
- (BOOL)hasAudioAuthority{
    
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    return (permission == AVAudioSessionRecordPermissionGranted)?YES:NO;
}

- (void)getAudioAuthorityWithHandle:(void (^)())handle{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL available) {
            if(available){
                if (handle) {
                    handle();
                }
            }else{
               NSLog(@"录音权限禁止！");
            }
        }];
    }
}

#pragma mark - 通讯录权限
- (BOOL)hasContactAuthority{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    return (status == CNAuthorizationStatusAuthorized)?YES:NO;
}

- (void)getContactAuthorityWithHandle:(void (^)())handle{

    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            if (handle) handle();
        }else{
            NSLog(@"通讯录权限禁止！");
        }
    }];
}

#pragma mark - 媒体资料库权限
- (BOOL)hasMediaAuthority{
    
    MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
    return (status == MPMediaLibraryAuthorizationStatusAuthorized)?YES:NO;
}

- (void)getMediaAuthorityWithHandle:(void (^)())handle{
    
    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
    if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
           if (status == MPMediaLibraryAuthorizationStatusAuthorized){
               if (handle) handle();
           }else{
               NSLog(@"媒体资料权限禁止！");
           }
            
        }];
    }
}

#pragma mark - 语音识别
- (BOOL)hasSpeechAuthority{
    
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    return (status == SFSpeechRecognizerAuthorizationStatusAuthorized)?YES:NO;
}

- (void)getSpeechAuthorityWithHandle:(void (^)())handle{

    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            if (handle) handle();
        }else{
            NSLog(@"语音识别权限禁止！");
        }
    }];
}

#pragma mark - 日历权限
- (BOOL)hasEventAuthority{
    
    EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
     return (status == EKAuthorizationStatusAuthorized)?YES:NO;
}

- (void)getEventAuthorityWithHandle:(void (^)())handle{

    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            if (handle) handle();
        }else{
            NSLog(@"日历权限禁止！");
        }
    }];
}

#pragma mark - 蓝牙
- (BOOL)hasBlueToothAuthority{
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    CBManagerState state = [_centralManager state];
    return (state == CBManagerStatePoweredOn)?YES:NO;
}

- (void)getBlueToothWithhandle:(void (^)())handle{
    WS(ws);
    if (handle) ws.block = handle;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    WS(ws);
    if(central.state == CBManagerStatePoweredOn){
        if (ws.block) ws.block();
    }else{
        NSLog(@"蓝牙状态关闭！");
    }
    
}
@end
