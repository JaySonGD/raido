//
//  TTZAppConfig.h
//  WebPlayer
//
//  Created by Jay on 2018/3/31.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTZAppConfig : NSObject

+ (instancetype)defaultConfig;


/** 评分*/
@property (nonatomic, copy) NSString *leaveReviewURL;

@property (nonatomic, copy) NSString *mail;

@property (nonatomic, copy) NSString *shareURL;


@property (nonatomic, copy) NSString *coffeeURL;



@property (nonatomic, copy) NSString *googleMobileAdsAppID;
@property (nonatomic, copy) NSString *googleMobileAdsInterstitialID;
@property (nonatomic, copy) NSString *googleMobileAdsBannerID;
@property (nonatomic, assign) BOOL isRemoveAd;

@end
