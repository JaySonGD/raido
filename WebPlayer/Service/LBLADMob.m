

#import "LBLADMob.h"
#import "common.h"
#import "TTZAppConfig.h"

//#ifdef DEBUG
//
//
//
//// 测试 应用ID
//#define kGoogleMobileAdsAppID @"ca-app-pub-3940256099942544~1458002511"
//
////插页式广告ID
//#define kGoogleMobileAdsInterstitialID @"ca-app-pub-3940256099942544/4411468910"
//
////横幅广告ID
//#define kGoogleMobileAdsBannerID  @"ca-app-pub-3940256099942544/6300978111"
//
//#else
//
////// 应用ID
////#define kGoogleMobileAdsAppID @"ca-app-pub-8803735862522697~8253379170"
////
//////插页式广告ID
////#define kGoogleMobileAdsInterstitialID @"ca-app-pub-8803735862522697/1432819955"
////
//////横幅广告ID
////#define kGoogleMobileAdsBannerID @"ca-app-pub-8803735862522697/1304827447"
//
//#endif

static LBLADMob *instance = nil;

@interface LBLADMob()<GADBannerViewDelegate,GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation LBLADMob

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
   
    dispatch_once(&onceToken, ^{
    
        instance = [super allocWithZone:zone];
    
    });
    
    return instance;
}


+ (instancetype)sharedInstance{
  
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
    
        instance = [[self alloc] init];
    
    });
    
    return instance;
}

+ (void)initAdMob{
    
    LBLADMob.sharedInstance.isRemoveAd = [TTZAppConfig defaultConfig].isRemoveAd;
    
    if(LBLADMob.sharedInstance.isRemoveAd) return;

    [GADMobileAds configureWithApplicationID:[TTZAppConfig defaultConfig].googleMobileAdsAppID];
}

- (void)GADLoadInterstitial {
    
    if(LBLADMob.sharedInstance.isRemoveAd) return;

    
    if (self.interstitial.isReady) return;
    
    GADInterstitial *gjs_interstitial = [[GADInterstitial alloc] initWithAdUnitID:[TTZAppConfig defaultConfig].googleMobileAdsInterstitialID];
    
    self.interstitial = gjs_interstitial;
    self.interstitial.delegate = self;
    
    GADRequest *gjs_request = [GADRequest request];
    
    gjs_request.testDevices = @[kGADSimulatorID];
    
    [gjs_interstitial loadRequest:gjs_request];
}


- (void)GADInterstitialWithVC:(UIViewController *)VC {
   
    
    if(LBLADMob.sharedInstance.isRemoveAd) return;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        if (self.interstitial.isReady) {
        
            [self.interstitial presentFromRootViewController:VC];
        
        } else {
        
            NSLog(@"Ad wasn't ready");
            
            [self GADLoadInterstitial];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                if (VC && self.interstitial.isReady) {
                
                    [self.interstitial presentFromRootViewController:VC];
                }
            });
        }
    });
}


+(void)GADBannerViewNoTabbarHeightWithVC:(UIViewController *)VC {
    
    if(LBLADMob.sharedInstance.isRemoveAd) return;

    GADRequest *gjs_request = [[GADRequest alloc] init];
    
    gjs_request.testDevices = @[kGADSimulatorID];
    
    int pointY = IS_PAD?90:iPhoneX?kTabbarSafeBottomMargin+50:50;
    
    GADBannerView *gjs_bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(kScreenW, pointY)) origin:CGPointMake(0, kScreenH-pointY)];
    
    gjs_bannerView.rootViewController = VC;
    gjs_bannerView.delegate = self.sharedInstance;
    
    gjs_bannerView.adSize = kGADAdSizeSmartBannerPortrait;
    
    gjs_bannerView.adUnitID = [TTZAppConfig defaultConfig].googleMobileAdsBannerID;
    
    [gjs_bannerView loadRequest:gjs_request];
    
    [VC.view addSubview:gjs_bannerView];
}



+(void)GADBannerViewWithVC:(UIViewController *)VC
                         AddView:(UIView *)view {
    
    if(LBLADMob.sharedInstance.isRemoveAd) return;

    GADRequest *gjs_request = [[GADRequest alloc] init];
    
    gjs_request.testDevices = @[kGADSimulatorID];
    
    GADBannerView *gjs_bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(kScreenW, IS_PAD?90:50)) origin:CGPointMake(0, 0)];
    
    gjs_bannerView.rootViewController = VC;
    gjs_bannerView.delegate = self.sharedInstance;

    gjs_bannerView.adSize = kGADAdSizeSmartBannerPortrait;
    
    gjs_bannerView.adUnitID = [TTZAppConfig defaultConfig].googleMobileAdsBannerID;
    
    [gjs_bannerView loadRequest:gjs_request];
    
    [view addSubview:gjs_bannerView];
}

#pragma mark GADBannerViewDelegate

/// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
  NSLog(@"%s-横幅广告已经接受", __func__);
}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"%s-横幅广告接收失败：%@", __func__,error);
}
#pragma mark GADInterstitialDelegate

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"%s-插页广告已经接受", __func__);

}

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"%s-插页广告接收失败：%@", __func__,error);

}


@end
