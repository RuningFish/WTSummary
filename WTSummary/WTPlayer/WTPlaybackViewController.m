//
//  WTPlaybackViewController.m
//  WTSummary
//
//  Created by piyingke on 2017/11/27.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTPlaybackViewController.h"
#import "VideoListTableViewCell.h"
#import "WTPlaybackView.h"
#import "WTPlaybackManager.h"
#import "WTRequestManager.h"
#import "VideoInfo.h"
#import "WTBrightnessView.h"
#import "WTResourceCacheManager.h"
#import "TVideoFileManager.h"
typedef enum {
    ScrollDirectionUp,
    ScrollDirectionDown
}ScrollDirection;

@interface WTPlaybackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,weak) UITableView * tableView;

@property (weak, nonatomic) UILabel *indicatorView;
@property (weak, nonatomic) UIView *scrollIndicator;

@property (nonatomic, strong) NSIndexPath * indexPath;
/** 滚动的方向 */
@property (nonatomic, assign) ScrollDirection direction;

/** 自动播放 */
@property (nonatomic, assign) BOOL autoPlay;
/** playback的array */
@property (nonatomic, strong) NSMutableArray * playbackArray;

@end

@implementation WTPlaybackViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)playbackArray{
    
    if (!_playbackArray) {
        _playbackArray = [NSMutableArray array];
    }
    
    return _playbackArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString * videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WTPlaybackVideo"];
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
    
//    [[WTResourceCacheManager manager] cleanAllCache];
  
    
    NSString * videoList = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"videoList"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:videoList];
    if (exist) {
        NSLog(@"本地缓存数据 ");
        NSArray * videoData = [NSArray arrayWithContentsOfFile:videoList];
        for (int i = 0; i < videoData.count; i ++) {
            VideoInfo * videoInfo = [VideoInfo videoInfoWithDictionary:videoData[i]];
            [self.dataArray addObject:videoInfo];
        }
    }
    else{
        // 请求数据
        [self requestVideoData];
//        NSLog(@"请求数据 ");
    }
    
    [WTResourceCacheManager calculateCachedResourceSizeWithCompletionHandle:^(NSInteger fileCount,unsigned long long cacheSize) {
        NSLog(@"缓存的大小 === %.02lfMB 数量 === %ld",cacheSize/1024.0/1024.0,fileCount);
    }];
    [[WTResourceCacheManager manager] cleanAllCache];
//    [self requestVideoData];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = size.width / 16 * 9 + 10;
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    self.autoPlay = NO;
    
    self.indexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    self.direction = ScrollDirectionUp;
    
}

- (void)dealloc{
    
    NSLog(@"WTPlaybackViewController -> dealloc");
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[WTPlaybackManager sharedManager] shutdown];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldPoint;
        id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
        [oldValue getValue:&oldPoint];
        
        CGPoint newpoint;
        id newValue = [change valueForKey:NSKeyValueChangeNewKey];
        [newValue getValue:&newpoint];
        if (oldPoint.y <= newpoint.y) {
            //            NSLog(@"向上滑动");
            self.direction = ScrollDirectionUp;
        }
        else{
            //            NSLog(@"向下滑动");
            self.direction = ScrollDirectionDown;
        }
    }
    
}
- (void)requestVideoData{
    
    NSString * url = @"https://c.m.163.com/recommend/getChanListNews?channel=T1457068979049&passport=&devId=GPREzJTGzbKQXhobRpRjUuzdHr1YMn7HNLBVG3jHmGtu7Oahv7R1ZXiMmOjQ2%2Bw0&version=28.2&spever=false&net=wifi&lat=&lon=&ts=1507821264&sign=aKGvaMNR6dqcLbpHCf6p2bfuF/3U7yl2xbPlu/0juNR48ErR02zJ6/KXOnxX046I&encryption=1&canal=appstore&offset=0&size=40&fn=3";
    
    [[WTRequestManager manager] sendRequestWithType:WTRequestTypeGET requestURL:url parameters:nil progress:nil taskDescription:nil successHandler:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObject allKeys] containsObject:@"视频"]) {
                
                NSLog(@"请求的数据 === %@ ",responseObject);
                NSArray * videoData = [responseObject valueForKey:@"视频"];
                if (videoData.count) {
                    
                    for (int i = 0; i < videoData.count; i ++) {
                        VideoInfo * videoInfo = [VideoInfo videoInfoWithDictionary:videoData[i]];
                        [self.dataArray addObject:videoInfo];
                    }
                }
                
                NSString * videoList = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"videoList"];
                [videoData writeToFile:videoList atomically:YES];
            }
            
            [self.tableView reloadData];
            
            if (self.autoPlay) {
                [self findBestCellToPlay];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoListTableViewCell * cell = [VideoListTableViewCell cellWithTableview:tableView];
    //    cell.videoInfo = self.dataArray[indexPath.row];
    //    cell.row = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(VideoListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.videoInfo = self.dataArray[indexPath.row];
    cell.row = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    PlayerView * playerView = [PlayerView playerView];
    //    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    //    NSString *movePath =  [document stringByAppendingPathComponent:@"temp.mp4"];
    //    playerView.videoURL = movePath;
    //    return;
    
    VideoListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString * videoUrl =  [self videoUrlWithVideoInfo:cell.videoInfo];;
    
    WTPlaybackManager * playbackManager = [WTPlaybackManager sharedManager];
    
    if (self.indexPath.row != indexPath.row) {
        
        VideoListTableViewCell * lastCell = [tableView cellForRowAtIndexPath:self.indexPath];
        lastCell.playButton.hidden = NO;
        
        self.indexPath = indexPath;
        [playbackManager shutdown];
        cell.playButton.hidden = YES;
        [playbackManager setContentUrl:videoUrl];
        playbackManager.containterView.videoInfo = cell.videoInfo;
        [cell.contentView addSubview:playbackManager.containterView];
        playbackManager.containterView.frame = cell.bounds;
        playbackManager.containterView.playbackView.playCache = YES;
        [playbackManager prepareToPlay];
        
    }
    else{
        
        if (![playbackManager.containterView isDescendantOfView:cell.contentView]) {
            
            VideoListTableViewCell * lastCell = [tableView cellForRowAtIndexPath:self.indexPath];
            lastCell.playButton.hidden = NO;
            
            self.indexPath = indexPath;
            [playbackManager shutdown];
            cell.playButton.hidden = YES;
            [playbackManager setContentUrl:videoUrl];
            playbackManager.containterView.videoInfo = cell.videoInfo;
            [cell.contentView addSubview:playbackManager.containterView];
            playbackManager.containterView.frame = cell.bounds;
            [playbackManager prepareToPlay];
            
        }
        
    }
}


- (void)stop{
    
    [[WTPlaybackManager sharedManager] shutdown];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableView *tableView = (UITableView *)scrollView;
    
    // 在这里根据_verticalScrollIndicator的中点，来获取对应的cell行号，从而可以获取对应行的数据来进行显示
    self.indicatorView.text = [NSString stringWithFormat:@"%zd", [tableView indexPathForRowAtPoint:self.scrollIndicator.center].row];
    
    NSIndexPath * indexPath =  [tableView indexPathForRowAtPoint:self.scrollIndicator.center];
    
    VideoListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSArray * visibleCells = [tableView visibleCells];
    
    VideoListTableViewCell * playCell = [tableView cellForRowAtIndexPath:self.indexPath];
    
    if ([visibleCells containsObject:playCell]) {
        cell.playButton.hidden = NO;
    }
    else{
        //        WTPlaybackManager * manager = [WTPlaybackManager sharedManager];
        //        for (VideoListTableViewCell * videoCell in visibleCells) {
        //            if ([manager.containterView isDescendantOfView:videoCell.contentView]) {
        //                [self stop];
        //            }
        //        }
        [self stop];
    }
    
//    if (self.autoPlay) {
//        [self findBestCellToPlay];
//    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 这里注意要在点击时获取，如果在view加载完成时设置标签索引的中点，那么获取的_verticalScrollIndicator的frame是不对的
    if (!self.indicatorView) {
        self.scrollIndicator = [self.tableView valueForKey:@"verticalScrollIndicator"];
        
        UILabel *indicatorView = [[UILabel alloc] initWithFrame:CGRectMake(-50, 0, 50, 20)];
        indicatorView.backgroundColor = [UIColor orangeColor];
        
        CGPoint center = indicatorView.center;
        center.y = self.scrollIndicator.bounds.size.height * 0.5;
        indicatorView.center = center;
        
        [self.scrollIndicator addSubview:indicatorView];
        self.indicatorView = indicatorView;
    }
    
    //    NSLog(@"contentOffset == 1 %lf",self.tableView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //停止的时候找出最合适的播放
    if (self.autoPlay) {
        [self findBestCellToPlay];
        NSLog(@"Decelerating");
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //停止的时候找出最合适的播放
    if (self.autoPlay) {
        [self findBestCellToPlay];
        NSLog(@"Dragging");
    }
    
}

- (void)findBestCellToPlay{
    
    NSArray * visibleCell = [self.tableView visibleCells];
    
    WTPlaybackManager * playbackManager = [WTPlaybackManager sharedManager];
    __weak typeof(playbackManager) weakManager = playbackManager;
    NSLog(@"playback array === %@",self.playbackArray);
    [visibleCell enumerateObjectsUsingBlock:^(VideoListTableViewCell * videoCell, NSUInteger index, BOOL * _Nonnull stop) {
        
        // imgview在cell中的位置
        CGRect rect1 = [videoCell.imgView convertRect:videoCell.imgView.frame fromView:videoCell.contentView];
        CGRect rect = [videoCell.imgView convertRect:rect1 toView:self.view];
        
        CGFloat topMargin = rect.origin.y - 20;
        CGFloat bottomMargin = self.view.frame.size.height - topMargin - rect.size.height;
        
        // 寻找满足播放条件的cell
        if (topMargin >= -rect.size.height/2 && bottomMargin >= -rect.size.height/2) {
            
            NSString * videoUrl = [self videoUrlWithVideoInfo:videoCell.videoInfo];
            
            // 符合播放条件要播放的cell
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:videoCell.row inSection:0];
            if (self.indexPath != indexPath) {
                // 上次播放的cell
                VideoListTableViewCell * playCell = [self.tableView cellForRowAtIndexPath:self.indexPath];
                playCell.playButton.hidden = NO;
                
                // 存在多个视频同时播放的情况，每次在播放新的时候将之前的都关闭掉
                for (WTPlaybackContainerView * containter in self.playbackArray) {
                    [self.playbackArray removeObject:containter];
                    //                    [containter removeFromSuperview];
                    //                    [containter shutdown];
                }
                
                [weakManager shutdown];
                videoCell.playButton.hidden = YES;
                [weakManager setContentUrl:videoUrl];
                weakManager.containterView.videoInfo = videoCell.videoInfo;
                [videoCell.contentView addSubview:playbackManager.containterView];
                weakManager.containterView.frame = videoCell.bounds;
                [weakManager prepareToPlay];
                weakManager.playIndex = videoCell.row;
                self.indexPath = [NSIndexPath indexPathForRow:videoCell.row inSection:0];
                NSLog(@"符合播放条件 -> 不相同indexPath %zd",videoCell.row);
                [self.playbackArray addObject:weakManager.containterView];
                
                *stop = YES;
            }
            else{
                NSLog(@"符合播放条件 -> 相同indexPath %zd",videoCell.row);
                *stop = YES;
            }
            
        }
    }];
    
}

- (NSString *)videoUrlWithVideoInfo:(VideoInfo *)videoInfo{
    
    NSString * videoUrl = nil;
    if (videoInfo.m3u8Hd_url) {
        videoUrl = videoInfo.m3u8Hd_url;
    }
    else{
        if (videoInfo.mp4Hd_url) {
            videoUrl = videoInfo.mp4Hd_url;
        }
        else{
            videoUrl = videoInfo.mp4_url;
        }
    }
    return videoUrl;
}

@end
