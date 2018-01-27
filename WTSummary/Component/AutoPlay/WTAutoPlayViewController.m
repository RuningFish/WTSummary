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
//        _tableView.decelerationRate = UIScrollViewDecelerationRateNormal;
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
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    UITableView *tableView = (UITableView *)scrollView;
//    // 在这里根据_verticalScrollIndicator的中点，来获取对应的cell行号，从而可以获取对应行的数据来进行显示
//    self.indicatorView.text = [NSString stringWithFormat:@"%zd", [tableView indexPathForRowAtPoint:self.scrollIndicator.center].row];
////
//    NSIndexPath * indexPath =  [tableView indexPathForRowAtPoint:self.scrollIndicator.center];
//
//    VideoListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    NSArray * visibleCells = [tableView visibleCells];
//
//    UITableViewCell * playCell = [tableView cellForRowAtIndexPath:self.indexPath];
//
//    if ([visibleCells containsObject:playCell]) {
//    }
//    else{
//        //        WTPlaybackManager * manager = [WTPlaybackManager sharedManager];
//        //        for (VideoListTableViewCell * videoCell in visibleCells) {
//        //            if ([manager.containterView isDescendantOfView:videoCell.contentView]) {
//        //                [self stop];
//        //            }
//        //        }
//        [self stop];
//    }
//
////    [self findBestCellToPlay];
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    // 这里注意要在点击时获取，如果在view加载完成时设置标签索引的中点，那么获取的_verticalScrollIndicator的frame是不对的
//    if (!self.indicatorView) {
//        self.scrollIndicator = [self.tableView valueForKey:@"verticalScrollIndicator"];
//
//        UILabel *indicatorView = [[UILabel alloc] initWithFrame:CGRectMake(-50, 0, 50, 20)];
//        indicatorView.backgroundColor = [UIColor orangeColor];
//
//        CGPoint center = indicatorView.center;
//        center.y = self.scrollIndicator.bounds.size.height * 0.5;
//        indicatorView.center = center;
//
//        [self.scrollIndicator addSubview:indicatorView];
//        self.indicatorView = indicatorView;
//    }
//
//}
//
//- (void)findBestCellToPlay{
//
//    NSArray * visibleCell = [self.tableView visibleCells];
//
//    WTPlaybackManager * playbackManager = [WTPlaybackManager sharedManager];
//    __weak typeof(playbackManager) weakManager = playbackManager;
////    NSLog(@"playback array === %@",self.playbackArray);
//    [visibleCell enumerateObjectsUsingBlock:^(VideoListTableViewCell * videoCell, NSUInteger index, BOOL * _Nonnull stop) {
//
//        // imgview在cell中的位置
//        CGRect rect1 = [videoCell.imgView convertRect:videoCell.imgView.frame fromView:videoCell.contentView];
//        CGRect rect = [videoCell.imgView convertRect:rect1 toView:self.view];
//
//        CGFloat topMargin = rect.origin.y - 20;
//        CGFloat bottomMargin = self.view.frame.size.height - topMargin - rect.size.height;
//
//        // 寻找满足播放条件的cell
//        if (topMargin >= -rect.size.height/2 && bottomMargin >= -rect.size.height/2) {
//
//            NSString * videoUrl = [self videoUrlWithVideoInfo:videoCell.videoInfo];
//
//            // 符合播放条件要播放的cell
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:videoCell.row inSection:0];
//            if (self.indexPath != indexPath) {
//                // 上次播放的cell
//                VideoListTableViewCell * playCell = [self.tableView cellForRowAtIndexPath:self.indexPath];
//                playCell.playButton.hidden = NO;
//
//                // 存在多个视频同时播放的情况，每次在播放新的时候将之前的都关闭掉
//                for (WTPlaybackContainerView * containter in self.playbackArray) {
//                    [self.playbackArray removeObject:containter];
//                }
//
//                if ([weakManager.containterView isDescendantOfView:videoCell.contentView]) {
//                    [weakManager.containterView removeFromSuperview];
//                    [weakManager shutdown];
//                }
//
//                [weakManager shutdown];
//                videoCell.playButton.hidden = YES;
//                [weakManager setContentUrl:videoUrl];
//                weakManager.containterView.videoInfo = videoCell.videoInfo;
//                [videoCell.contentView addSubview:playbackManager.containterView];
//                weakManager.containterView.frame = videoCell.bounds;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakManager prepareToPlay];
//                });
////                [weakManager prepareToPlay];
//                weakManager.playIndex = videoCell.row;
//                self.indexPath = [NSIndexPath indexPathForRow:videoCell.row inSection:0];
//                NSLog(@"符合播放条件 -> 不相同indexPath %zd",videoCell.row);
//                [self.playbackArray addObject:weakManager.containterView];
//
//                *stop = YES;
//            }
//            else{
//                NSLog(@"符合播放条件 -> 相同indexPath %zd",videoCell.row);
//                *stop = YES;
//            }
//        }
//    }];
//
//}
//
//- (NSString *)videoUrlWithVideoInfo:(VideoInfo *)videoInfo{
//
//    NSString * videoUrl = nil;
//    if (videoInfo.m3u8Hd_url) {
//        videoUrl = videoInfo.m3u8Hd_url;
//    }
//    else{
//        if (videoInfo.mp4Hd_url) {
//            videoUrl = videoInfo.mp4Hd_url;
//        }
//        else{
//            videoUrl = videoInfo.mp4_url;
//        }
//    }
//    return videoUrl;
//}


@end
