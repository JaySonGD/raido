 //
//  FWPlayerKit.m
//  01-Hello
//
//  Created by FEIWU888 on 2017/8/8.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "FWPlayerKit.h"

#import <PLPlayer.h>
#import <MediaPlayer/MediaPlayer.h>


static FWPlayerKit *instance = nil;

static NSString *status[] = {
    @" 未知状态",
    @"正在准备播放所需组件，在调用 -play 方法时出现。",
    @"播放组件准备完成，准备开始播放，在调用 -play 方法时出现。",
    @"缓存数据为空状态",
    @"正在播放状态",
    @"暂停状态",
    @"停止状态",
    @"错误状态，"
};


@interface FWPlayerKit ()< PLPlayerDelegate>
@property (nonatomic, strong) PLPlayer  *player;
/** 七牛SDK播放器重连次数 */
@property (nonatomic, assign) int reconnectCount;

@property (nonatomic, assign) NSInteger itemIndex;

/** 是否是手动暂停 */
@property (nonatomic, assign) BOOL isManualPaused;
@end

@implementation FWPlayerKit

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


#pragma mark  开始播放

-(void)playWithURL:(NSURL *)url
          withName:(NSString *)name{
    self.currenttitle = name;
    [self.player playWithURL:url];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [dict setObject:name forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [dict setObject:@"歌手" forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [dict setObject:@"专辑" forKey:MPMediaItemPropertyAlbumTitle];
    //设置显示的图片
    UIImage *newImage = [UIImage imageNamed:@"SearchBarBg"];
    [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:newImage]
     
             forKey:MPMediaItemPropertyArtwork];
    
    //设置歌曲时长
    //[dict setObject:[NSNumber numberWithDouble:300] forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    //[dict setObject:[NSNumber numberWithDouble:150] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    //更新字典
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}


- (void)play
{
    //[self.player setVolume:1.0];
    self.isManualPaused = NO;
    [self.player play];
}

- (void)stop{
    [self.player stop];
}

- (void)pause
{
    self.isManualPaused = YES;
    [self.player pause];
    //[self.player setVolume:0.0];
}


- (BOOL)isPlaying
{
    return self.player.isPlaying;
}

#pragma mark - <PLPlayerDelegate>
#pragma mark  -

// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
    // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
    // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
    // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
    // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    
    
    if (PLPlayerStatusPlaying == state) {
        !(_playerCompletionBlock)? : _playerCompletionBlock();
        
        NSLog(@"加载完毕。。。。");
        
    }else if (PLPlayerStatusReady == state) {
        NSLog(@"加载完毕。。。。");
        !(_playerCompletionBlock)? : _playerCompletionBlock();

    }else if (PLPlayerStatusError == state) {
        NSLog(@"加载中。。。。");
        !(_playerLoadingBlock)? : _playerLoadingBlock();
    }else if(PLPlayerStatusPaused == state){
        
        if(!self.isManualPaused){
            [self.player play];
        }
        NSLog(@"暂停中。。。。");

    }
    

    NSLog(@"%@", status[state]);
    
    
}


/**
 当发生错误，停止播放时，会回调这个方法
 */
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    [self tryReconnect:error];
    !(_playerLoadingBlock)? : _playerLoadingBlock();
    NSLog(@"%@", error);
}

/**
 当解码器发生错误时，会回调这个方法
 当 videotoolbox 硬解初始化或解码出错时
 error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
 播发器也将自动切换成软解，继续播放
 */
- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
    NSLog(@"%@", error);
}

- (void)tryReconnect:(nullable NSError *)error {
    if (self.reconnectCount < 3) {
        _reconnectCount ++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player play];
        });
    }else {
        
    }
}



#pragma mark  -  get/set 方法
#pragma mark  -
- (PLPlayer *)player
{
    if (!_player) {
        // 1. 配置参数
        PLPlayerOption *option = [PLPlayerOption defaultOption];
        [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
      
        // 2. 播放url
        NSURL *liveurl = [NSURL URLWithString:@""];
        _player = [PLPlayer playerWithURL:liveurl option:option];
        _player.backgroundPlayEnable = YES;
        _player.delegate = self;
        
    }
    return _player;
}

@end

