

#import "LBLADMob.h"
#import "common.h"



#ifdef DEBUG



// 测试 应用ID
#define kGoogleMobileAdsAppID @"ca-app-pub-3940256099942544~1458002511"

//插页式广告ID
#define kGoogleMobileAdsInterstitialID @"ca-app-pub-3940256099942544/4411468910"

//横幅广告ID
#define kGoogleMobileAdsBannerID  @"ca-app-pub-3940256099942544/6300978111"

#else

//// 应用ID
//#define kGoogleMobileAdsAppID @"ca-app-pub-8803735862522697~8253379170"
//
////插页式广告ID
//#define kGoogleMobileAdsInterstitialID @"ca-app-pub-8803735862522697/1432819955"
//
////横幅广告ID
//#define kGoogleMobileAdsBannerID @"ca-app-pub-8803735862522697/1304827447"

#endif

static LBLADMob *instance = nil;

@interface LBLADMob()

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
    
    LBLADMob.sharedInstance.isRemoveAd = YES;
    
    if(LBLADMob.sharedInstance.isRemoveAd) return;

    [GADMobileAds configureWithApplicationID:kGoogleMobileAdsAppID];
}

- (void)GADLoadInterstitial {
    
    if(LBLADMob.sharedInstance.isRemoveAd) return;

    
    if (self.interstitial.isReady) return;
    
    GADInterstitial *gjs_interstitial = [[GADInterstitial alloc] initWithAdUnitID:kGoogleMobileAdsInterstitialID];
    
    self.interstitial = gjs_interstitial;
    
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
    
    gjs_bannerView.adSize = kGADAdSizeSmartBannerPortrait;
    
    gjs_bannerView.adUnitID = kGoogleMobileAdsBannerID;
    
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
    
    gjs_bannerView.adSize = kGADAdSizeSmartBannerPortrait;
    
    gjs_bannerView.adUnitID = kGoogleMobileAdsBannerID;
    
    [gjs_bannerView loadRequest:gjs_request];
    
    [view addSubview:gjs_bannerView];
}
@end
