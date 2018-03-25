//
//  FWPlayerKit.h
//  01-Hello
//
//  Created by FEIWU888 on 2017/8/8.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//
//
#import <Foundation/Foundation.h>
@class PLPlayer;

@interface FWPlayerKit : NSObject

+ (instancetype)sharedInstance;

/** 加载中 */
@property (nonatomic, copy) void (^playerLoadingBlock)(void);

/** 加载完毕 */
@property (nonatomic, copy) void (^playerCompletionBlock)(void);


-(void)play;

-(void)stop;

-(void)pause;


@property (nonatomic, strong) NSString *currenttitle;

@property (nonatomic, assign) BOOL isPlaying;

-(void)playWithURL:(NSURL *)url withName:(NSString *)name;;

@end

