//
//  WTAutoPlayViewController.m
//  WTSummary
//
//  Created by piyingke on 2018/1/19.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTAutoPlayViewController.h"
#import "VideoListTableViewCell.h"
#import "VideoInfo.h"
@interface WTAutoPlayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) NSMutableArray * data;
@property (nonatomic ,strong) NSIndexPath * indexPath;
/** playback的array */
@property (nonatomic, strong) NSMutableArray * playbackArray;
@property (weak, nonatomic) UILabel *indicatorView;
@property (weak, nonatomic) UIView *scrollIndicator;
@end

@implementation WTAutoPlayViewController
- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableArray *)playbackArray{
    if (!_playbackArray) {
        _playbackArray = [NSMutableArray array];
    }
    return _playbackArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = self.view.frame.size.width/16*9 + 10;
    }
    return _tableView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    for (int i = 1; i < 6; i ++) {
        NSString * autoBundle = [[NSBundle mainBundle] pathForResource:@"AutoPlay" ofType:@".bundle"];
        NSString * string = [NSString stringWithFormat:@"0%zd.mp4",i];
        NSString * videoUrl = [NSString stringWithFormat:@"%@/%@",autoBundle,string];
        VideoInfo * videoInfo = [[VideoInfo alloc] init];
        videoInfo.mp4_url = videoUrl;
        [self.data addObject:videoInfo];
    }
    
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stop];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoListTableViewCell * videoListCell = [VideoListTableViewCell cellWithTableview:tableView];
    videoListCell.imgView.backgroundColor = WTRandomColor;
    videoListCell.videoInfo = self.data[indexPath.row];
    videoListCell.row = indexPath.row;
    return videoListCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.indexPath = indexPath;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    VideoInfo * videoInfo = self.data[indexPath.row];;
    WTPlaybackManager * playbackManager = [WTPlaybackManager sharedManager];
    
    [playbackManager shutdown];
    [playbackManager setContentUrl:videoInfo.mp4_url];
    playbackManager.containterView.videoInfo = nil;
    [cell.contentView addSubview:playbackManager.containterView];
    playbackManager.containterView.frame = cell.bounds;
    [playbackManager prepareToPlay];
}

- (void)stop{
    
    [[WTPlaybackManager sharedManager] shutdown];
}



@end
