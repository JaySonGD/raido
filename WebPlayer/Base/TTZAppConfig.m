//
//  TTZAppConfig.m
//  WebPlayer
//
//  Created by Jay on 2018/3/31.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZAppConfig.h"
static TTZAppConfig *instance = nil;
#ifdef DEBUG
// 测试 应用ID
#define kGoogleMobileAdsAppID @"ca-app-pub-3940256099942544~1458002511"
//插页式广告ID
#define kGoogleMobileAdsInterstitialID @"ca-app-pub-3940256099942544/4411468910"
//横幅广告ID
#define kGoogleMobileAdsBannerID  @"ca-app-pub-3940256099942544/6300978111"
#else
// 应用ID
#define kGoogleMobileAdsAppID @"ca-app-pub-8803735862522697~2882119068"
//插页式广告ID
#define kGoogleMobileAdsInterstitialID @"ca-app-pub-8803735862522697/1541117236"
//横幅广告ID
#define kGoogleMobileAdsBannerID @"ca-app-pub-8803735862522697/8775350241"
#endif
#define kMail @"853945995@qq.com"
#define kCoffeeURL @"https://www.baidu.com/"
#define kLeaveReviewURL @"itms-apps://itunes.apple.com/app/id1297897150?action=write-review"
#define kShareURL @"https://itunes.apple.com/cn/app/%E9%A6%99%E6%B8%AF%E7%94%B5%E5%8F%B0-%E9%A6%99%E6%B8%AF%E5%B9%BF%E6%92%AD%E7%94%B5%E5%8F%B0-hk-radio-%E8%A6%81%E5%90%AC%E5%90%AC%E9%A6%99%E6%B8%AF%E6%94%B6%E9%9F%B3%E6%9C%BA/id1297897150?mt=8&uo=4"

@implementation TTZAppConfig

+ (instancetype)defaultConfig{
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

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (BOOL)isRemoveAd{
    BOOL isRemoveAd =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isRemoveAd"] boolValue];
//    return isRemoveAd? isRemoveAd : NO;
    return NO;
}

- (NSString *)googleMobileAdsAppID{
    NSString * googleMobileAdsAppID =  [[NSUserDefaults standardUserDefaults] stringForKey:@"googleMobileAdsAppID"];
    return googleMobileAdsAppID.length? googleMobileAdsAppID : kGoogleMobileAdsAppID;

}

- (NSString *)googleMobileAdsInterstitialID{
    NSString * googleMobileAdsInterstitialID =  [[NSUserDefaults standardUserDefaults] stringForKey:@"googleMobileAdsInterstitialID"];
    return googleMobileAdsInterstitialID.length? googleMobileAdsInterstitialID : kGoogleMobileAdsInterstitialID;

}

- (NSString *)googleMobileAdsBannerID{
    NSString * googleMobileAdsBannerID =  [[NSUserDefaults standardUserDefaults] stringForKey:@"googleMobileAdsBannerID"];
    return googleMobileAdsBannerID.length? googleMobileAdsBannerID : kGoogleMobileAdsBannerID;
}

- (NSString *)mail{
    NSString * mail =  [[NSUserDefaults standardUserDefaults] stringForKey:@"mail"];
    return mail.length? mail : kMail;
}

- (NSString *)leaveReviewURL{
    NSString * url =  [[NSUserDefaults standardUserDefaults] stringForKey:@"leaveReviewURL"];
    return url.length? url : kLeaveReviewURL;
}

- (NSString *)shareURL{
    NSString * url =  [[NSUserDefaults standardUserDefaults] stringForKey:@"shareURL"];
    return url.length? url : kShareURL;
}

- (NSString *)coffeeURL{
    NSString * url =  [[NSUserDefaults standardUserDefaults] stringForKey:@"coffeeURL"];
    return url.length? url : kCoffeeURL;
}

@end
