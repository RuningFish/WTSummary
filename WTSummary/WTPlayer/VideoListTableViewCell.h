//
//  VideoListTableViewCell.h
//  123
//
//  Created by piyingke on 17/1/23.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPlaybackView.h"

@class PlayerView;
@interface VideoListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableView;

@property (nonatomic, strong) VideoInfo * videoInfo;

@property (nonatomic,weak) UIButton * playButton;

@property (nonatomic,assign) NSInteger row;
/** imageView */
@property (nonatomic,strong) UIImageView * imgView;

@end
