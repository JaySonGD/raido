//
//  ViewController.m
//  WebPlayer
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>
#import "UIAlertController+Blocks.h"
#import "common.h"
#import "TTZPlayer.h"
#import "LBLADMob.h"
@interface ViewController ()
@property (nonatomic, strong)  WKWebView *webView;
@property (nonatomic, assign) NSInteger  index;
@end

@implementation ViewController


- (WKWebView *)webView
{
    if (!_webView) {
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.mediaPlaybackRequiresUserAction = NO;//把手动播放设置NO ios(8.0, 9.0)
        config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        config.mediaPlaybackAllowsAirPlay = YES;//允许播放，ios(8.0, 9.0)
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, w, h) configuration:config];
        _webView.backgroundColor = [UIColor blackColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.autoresizingMask =
        
        UIViewAutoresizingFlexibleLeftMargin   |
        
        UIViewAutoresizingFlexibleWidth        |
        
        UIViewAutoresizingFlexibleRightMargin  |
        
        UIViewAutoresizingFlexibleTopMargin    |
        
        UIViewAutoresizingFlexibleHeight       |
        
        UIViewAutoresizingFlexibleBottomMargin ;
        
        
        
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    [self.navigationController setNavigationBarHidden:YES];
    [self setUI];
    //    [self.navigationController setHidesBarsOnTap:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if([TTZPlayer defaultPlayer].isPlaying) [[TTZPlayer defaultPlayer] pause];
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        
        __weak typeof(self) weakSelf = self;
        [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
    }
}
- (void)dealloc{
    NSLog(@"%s---guole", __func__);
}

- (void)setUI{
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor blackColor];
    [self changeURL:self.m3u8s[self.index]];
    self.navigationItem.rightBarButtonItem = [self kkButtonItem];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
}

- (UIBarButtonItem *)kkButtonItem{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(kkAciton) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    but.width = 35;but.height = 35;
    
    return [[UIBarButtonItem alloc] initWithCustomView:but];
}

- (void)kkAciton {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"切换播放源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.m3u8s enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = (idx == self.index)?[NSString stringWithFormat:@"             线路%ld    ✔ ",idx+1]:[NSString stringWithFormat:@"       线路%ld    ",idx+1];
        NSLog(@"url %@",obj);
        
        UIAlertAction *name = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self changeURL:self.m3u8s[idx]];
        }];
        
        [alertVC addAction:name];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:cancel];
    
    
    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.navigationItem.rightBarButtonItem.customView;
        popover.sourceRect = self.navigationItem.rightBarButtonItem.customView.bounds;
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}



- (void)changeURL:(NSString *)m3u8 {
    //    NSString *m3u8 = @"http://acm.gg/inews.m3u8";
    
    
    if([YPNetService hasSetProxy]) return;
    
    NSString * html = [NSString stringWithFormat:@"<html><body style=\"margin:0;background-color:#000000;width:100%%;height:100%%;\" ><video style=\"margin:0;background-color:#000000; width:100%%; \"   controls autoplay playsinline webkit-playsinline  type=\"application/vnd.apple.mpegurl\"><source src=\"%@\" id=\"myVideo\">当前环境不支持播放</video></body></html>",m3u8];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *fileExtension = m3u8.pathExtension;
        
        if ([m3u8 containsString:@"pan.baidu.com"]) {
            [UIAlertController showActionSheetInViewController:self withTitle:@"title" message:@"该链接为百度云连接,是否保存到百度云" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                popover.sourceView = self.navigationItem.rightBarButtonItem.customView;
                popover.sourceRect = self.navigationItem.rightBarButtonItem.customView.bounds;

            } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.cancelButtonIndex) return ;
                
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:m3u8]];
                if (@available(iOS 10.0, *)) {
                    safariVC.preferredBarTintColor = kCommonColor;
                }
                if (@available(iOS 11.0, *)) {
                    safariVC.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
                }
                [self presentViewController:safariVC animated:YES completion:nil];
                
                
            }];
        }
        else if([m3u8 containsString:@"html"] ||
                [fileExtension isEqualToString:@""] ||
                [fileExtension containsString:@"php"] ||
                [fileExtension containsString:@"mp4"]){
            [UIAlertController showActionSheetInViewController:self withTitle:@"title" message:@"该链接可能无法播放,是否跳到站外观看" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if(buttonIndex == controller.cancelButtonIndex) return ;
                
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:m3u8]];
                if (@available(iOS 10.0, *)) {
                    safariVC.preferredBarTintColor = kCommonColor;
                }
                if (@available(iOS 11.0, *)) {
                    safariVC.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
                }
                [self presentViewController:safariVC animated:YES completion:nil];
                
            }];
            return;
        }
    });
    
}




- (void)orientChange:(NSNotification *)notification
{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    if(orient == UIDeviceOrientationPortrait){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

@end
