//
//  AppDelegate.m
//  WebPlayer
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "LBLADMob.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self configAudioSession];
    [LBLADMob initAdMob];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}


-(void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self.beginTime==nil?[NSDate date]:self.beginTime];
    
    if (delta >= 8.0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"isReview" forKey:@"isReview"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}




- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configAudioSession{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [session setActive:YES error:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    // add interruption handler
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionWasInterrupted:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    
}


- (void)audioSessionWasInterrupted:(NSNotification *)notification
{
    NSLog(@"the notification is %@",notification);
    if (AVAudioSessionInterruptionTypeBegan == [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue])
    {
        NSLog(@"begin");
        //[[FWPlayerKit sharedInstance] pause];
    }
    else if (AVAudioSessionInterruptionTypeEnded == [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue])
    {
        NSLog(@"begin - end");
        //[[FWPlayerKit sharedInstance] play];

    }
}


@end
