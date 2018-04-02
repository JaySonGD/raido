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
#define kCoffeeURL @"HTTPS://QR.ALIPAY.COM/FKX03085VVOKMVPYBHPM8B"
#define kLeaveReviewURL @"itms-apps://itunes.apple.com/app/id1367069452?action=write-review"
#define kShareURL @"https://itunes.apple.com/cn/app/id1367069452?mt=8"
#define kJoinQQURL @"https://jq.qq.com/?_wv=1027&k=5DPXEe5"

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


- (BOOL)hasNewVersion{

    NSString* AppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* onLineVersion = self.version;

    //版本号相等,返回0(最新版); v1小于v2,返回-1(未上线); 否则返回1(要更新).
    NSInteger r =  [self compareVersion:onLineVersion to:AppVersion];
    
    
    return r > 0;

}

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
- (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

- (NSString *)version{
    NSString *version =  [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    return version.length? version : _version;
}

- (NSString *)joinQQURL{
    NSString *joinQQURL =  [[NSUserDefaults standardUserDefaults] objectForKey:@"joinQQURL"];
    return joinQQURL.length? joinQQURL : kJoinQQURL;
}

-(BOOL)isIsOnLine{
        BOOL isIsOnLine =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isIsOnLine"] boolValue];
        return isIsOnLine? isIsOnLine : NO;
}

- (BOOL)isRemoveAd{
    BOOL isRemoveAd =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isRemoveAd"] boolValue];
    return isRemoveAd? isRemoveAd : NO;
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
