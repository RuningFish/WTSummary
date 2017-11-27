//
//  VideoListTableViewCell.m
//  123
//
//  Created by piyingke on 17/1/23.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "VideoListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
@interface VideoListTableViewCell ()

@property (nonatomic,weak) UILabel * timeLabel;
@end

@implementation VideoListTableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableView{
    
    VideoListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSubviews];
    }
    
    return self;
}


- (void)setSubviews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView];
    
    // 播放按钮
    UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView insertSubview:playButton atIndex:0];
    [self.contentView addSubview:playButton];
    self.playButton = playButton;
    [playButton setImage:[UIImage imageNamed:WTPlaybackBundle(@"playMiniNormal@2x")] forState:UIControlStateNormal];
    playButton.layer.cornerRadius = 45*0.5;
    playButton.layer.masksToBounds = YES;
    playButton.layer.borderColor = [UIColor whiteColor].CGColor;
    playButton.layer.borderWidth = 1;
    playButton.userInteractionEnabled = NO;
    
    // 视频的时长
    UILabel * timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel = timeLabel;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
    
    CGFloat WH = 45;
    CGFloat x = (self.frame.size.width - WH) * 0.5;
    CGFloat y = (self.frame.size.height - WH) * 0.5;
    self.playButton.frame = CGRectMake(x, y, WH, WH);
    
    CGFloat w = 100;
    CGFloat h = 30;
    CGFloat timeLabelX = self.frame.size.width - w - 10;
    CGFloat timeLabelY = self.frame.size.height - 5 - h;
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, w, h);
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setVideoInfo:(VideoInfo *)videoInfo{
    
    _videoInfo = videoInfo;
    
    UIColor * backColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:0.3];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:videoInfo.cover] placeholderImage:[UIImage createImageWithColor:backColor]];
    
    if (videoInfo.length) {
        NSInteger minute = (NSInteger)(videoInfo.length / 60);
        NSInteger second = videoInfo.length - minute * 60;
        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
        self.videoInfo.videoDuraton = self.timeLabel.text;
    }
    
}


- (void)setFrame:(CGRect)frame{

    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
