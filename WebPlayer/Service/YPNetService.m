//
//  YPNetService.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/14.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "YPNetService.h"
//#import <SystemConfiguration/SystemConfiguration.h>

@implementation YPNetService
+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)hasSetProxy

{
    
    BOOL proxy = NO;
    
    
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef)(url),
                                                                       
                                                                       (__bridge CFDictionaryRef)(proxySettings)));
    
    NSLog(@"proxies:%@", proxies);
    
    NSDictionary *settings = proxies[0];
    
    NSLog(@"kCFProxyHostNameKey: %@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    
    NSLog(@"kCFProxyPortNumberKey: %@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    
    NSLog(@"kCFProxyTypeKey: %@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]) {
        
        proxy = NO;
        
    }
    
    else {
    
        proxy = YES;
        
    }
    
    
    
    return proxy;
    
}



- (BOOL)isProtocolService{
    
//    [self hasSetProxy];
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        NSLog(@"没代理");
        return NO;
    }
    else
    {
        NSLog(@"设置了代理");
        return YES;
    }
    
    //得到代理
//    CFDictionaryRef proxySettings0 = CFNetworkCopySystemProxySettings();
//    NSDictionary *dictProxy = (__bridge_transfer id)proxySettings0;
//    NSLog(@"%@",dictProxy);
    
    //是否开启了http代理
//    if ([[dictProxy objectForKey:@"HTTPEnable"] boolValue]) {
//
//        NSString *proxyAddress = [dictProxy objectForKey:@"HTTPProxy"]; //代理地址
//        NSInteger proxyPort = [[dictProxy objectForKey:@"HTTPPort"] integerValue];  //代理端口号
//        NSLog(@"%@:%d",proxyAddress,proxyPort);
//
//    }
    
    //return YES;
    
}

#if 0
- (BOOL)isProtocolService
{
    
    
    
    
    NSDictionary* proxySettings = NSMakeCollectable((__bridge CFTypeRef)((__bridge NSDictionary*)CFNetworkCopySystemProxySettings()));
//
    NSArray* proxies = NSMakeCollectable((__bridge NSArray*)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"https://www.google.com"], (__bridge CFDictionaryRef)proxySettings));

    
    
    
    
    
    
    
    NSDictionary* settings = [proxies firstObject];

    if ([settings objectForKey:(NSString*)kCFProxyHostNameKey] == nil && [settings objectForKey:(NSString*)kCFProxyPortNumberKey] == nil) {
        return NO;
    }
    return YES;
}
#endif
@end
