//
//  VideoInfo.h
//  123
//
//  Created by admin on 17/10/15.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject

/** <#desc#>*/
@property (nonatomic, copy) NSString * videoDuraton;

@property (nonatomic, copy) NSString * cover;
@property (nonatomic, assign) NSInteger  danmu;
@property (nonatomic, copy) NSString * description;
@property (nonatomic, assign) float  length;
@property (nonatomic, copy) NSString * m3u8_url;
@property (nonatomic, copy) NSString * m3u8Hd_url;
@property (nonatomic, copy) NSString * mp4_url;
@property (nonatomic, copy) NSString * mp4Hd_url;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger playersize;
@property (nonatomic, copy) NSString * program;
@property (nonatomic, copy) NSString * prompt;
@property (nonatomic, copy) NSString * replyBoard;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, copy) NSString * replyid;
@property (nonatomic, copy) NSString * sectiontitle;
@property (nonatomic, assign) long  sizeHD;
@property (nonatomic, assign) long  sizeSD;
@property (nonatomic, assign) long  sizeSHD;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * topicDesc;
@property (nonatomic, copy) NSString * topicImg;
@property (nonatomic, copy) NSString * topicName;
@property (nonatomic, copy) NSString * topicSid;
@property (nonatomic, copy) NSString * vid;
@property (nonatomic, copy) NSString * videosource;
@property (nonatomic, strong) NSDictionary  * videoTopic;
@property (nonatomic, strong) NSDictionary  * videobanner;

/** 上次的播放时间 */
@property (nonatomic, assign) CGFloat lastPlayTime;
+ (instancetype)videoInfoWithDictionary:(NSDictionary *)dict;

@end
