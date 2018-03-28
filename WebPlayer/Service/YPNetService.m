//
//  YPNetService.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/14.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "YPNetService.h"
#import <SystemConfiguration/SystemConfiguration.h>

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


- (BOOL)isProtocolService{
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
