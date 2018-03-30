//
//  HKTVManeger.m
//  GetFM
//
//  Created by czljcb on 2017/11/17.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "DSKT.h"
#import "DSHTML.h"

#define KDS1 @"kds1://"
#define KDS2 @"kds2://"
#define LetvHtml @"letvhtml"


@implementation DSKT

/*****/

+(void)getCCTV_KDSModelSucess:(void (^)(NSDictionary *model))modelBlock {
    [[DSHTML sharedInstance] getHtmlWithURL:@"http://m.91kds.com/" sucess:^(NSString *html) {
        !(modelBlock)? : modelBlock([self getCCTVModelWithHtml:html]);
    } error:^(NSError *error) {
        NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://m.91kds.com/"] encoding:NSUTF8StringEncoding error:nil];
        !(modelBlock)? : modelBlock([self getCCTVModelWithHtml:htmlString]);
    }];

}

+(NSDictionary *)getCCTVModelWithHtml:(NSString *)htmlString {
    //__block DACXModel *b_model = [DACXModel new];
    __block NSDictionary *b_model = [NSDictionary dictionary];
    NSArray *tem = [htmlString componentsSeparatedByString:@"<li>"];
    [tem enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSDictionary *model = [self getHtmlKDSModelWithTemArr:tem curentObj:obj idx:idx];
            if ([model[@"province"] isEqualToString:@"央视"]) {
                b_model = model;
                *stop = YES;
            }
        }
    }];
    return b_model;
}

+(NSDictionary *)getWSModelWithHtml:(NSString *)htmlString {
//    __block DACXModel *b_model = [DACXModel new];
    __block NSDictionary *b_model = [NSDictionary dictionary];
    NSArray *tem = [htmlString componentsSeparatedByString:@"<li>"];
    [tem enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSDictionary *model = [self getHtmlKDSModelWithTemArr:tem curentObj:obj idx:idx];
            if ([model[@"province"] isEqualToString:@"卫视"]) {
                b_model = model;
                *stop = YES;
            }
        }
    }];
    return b_model;
}
//
+(void)getWS_KDSModelSucess:(void (^)(NSDictionary *model))modelBlock {
    [[DSHTML sharedInstance] getHtmlWithURL:@"http://m.91kds.com/" sucess:^(NSString *html) {
        !(modelBlock)? : modelBlock([self getWSModelWithHtml:html]);
    } error:^(NSError *error) {
        NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://m.91kds.com/"] encoding:NSUTF8StringEncoding error:nil];
        !(modelBlock)? : modelBlock([self getWSModelWithHtml:htmlString]);
    }];
}


#pragma mark  -  所有省份
+(void)getAll91_KDSModelSucess:(void (^)(NSArray<NSDictionary *> *models))modelBlock {
    [[DSHTML sharedInstance] getHtmlWithURL:@"http://m.91kds.com/" sucess:^(NSString *html) {
        !(modelBlock)? : modelBlock([self getAllModelWithHtmlStr:html]);
    } error:^(NSError *error) {
        NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://m.91kds.com/"] encoding:NSUTF8StringEncoding error:nil];
        !(modelBlock)? : modelBlock([self getAllModelWithHtmlStr:htmlString]);
    }];
}

+ (NSArray <NSDictionary *>*)getAllModelWithHtmlStr:(NSString *)html {
    NSMutableArray *provinceModels = [NSMutableArray array];
    NSArray *tem = [html componentsSeparatedByString:@"<li>"];
    [tem enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSDictionary *model = [self getHtmlKDSModelWithTemArr:tem curentObj:obj idx:idx];
            [provinceModels addObject:model];
        }
    }];
    return provinceModels;
}

#pragma mark  -  省份所有电台
+(void)getOneProvinceAllKDSModelWithUrl:(NSString *)url sucess:(void (^)(NSArray<NSDictionary *> *models))modelBlock {
    [[DSHTML sharedInstance] getHtmlWithURL:[NSString stringWithFormat:@"http://m.91kds.com/%@.html",url] sucess:^(NSString *html) {
        !(modelBlock)? : modelBlock([self getOneProvinceModelWithHtml:html]);
    } error:^(NSError *error) {        NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.91kds.com/%@.html",url]] encoding:NSUTF8StringEncoding error:nil];
        !(modelBlock)? : modelBlock([self getOneProvinceModelWithHtml:htmlString]);
    }];
}


+(NSArray <NSDictionary *>*)getOneProvinceModelWithHtml:(NSString *)html {
    NSMutableArray *all = [NSMutableArray array];
    NSArray *tem = [html componentsSeparatedByString:@"<li>"];
    [tem enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 1) {
            NSDictionary *model = [self getHtmlKDSModelWithTemArr:tem curentObj:obj idx:idx] ;
            [all addObject:model];
        }
    }];
    
    return all;
}

#pragma mark  -  电台内容

+(void)getOneChannelKDSModelWithUrl:(NSString *)url sucess:(void (^)(NSDictionary *model))modelBlock {
    //DACXModel *model = [DACXModel new];
    NSMutableDictionary *model = [NSMutableDictionary dictionary];
    
    [[DSHTML sharedInstance] getHtmlWithURL:[NSString stringWithFormat:@"http://m.91kds.com/%@.html",url] sucess:^(NSString *html) {
        !(modelBlock)? : modelBlock([self OneChannelKDSModelWithHtml:html model:model]);
    } error:^(NSError *error) {
        NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.91kds.com/%@.html",url]] encoding:NSUTF8StringEncoding error:nil];
        !(modelBlock)? : modelBlock([self OneChannelKDSModelWithHtml:htmlString model:model]);
    }];
}



+(NSDictionary *)OneChannelKDSModelWithHtml:(NSString *)htmlString model:(NSMutableDictionary *)model {
    NSArray *tem8 = [htmlString componentsSeparatedByString:@"getLiveKey('"];
    tem8 = [tem8.lastObject componentsSeparatedByString:@"')"];
    //model.curentUrl = tem8.firstObject;
    model[@"curentUrl"] = tem8.firstObject;
    
    tem8 =  [htmlString componentsSeparatedByString:@"线路"];
    NSMutableArray *allurls = [NSMutableArray array];
    [tem8 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != tem8.count - 1) {
            NSArray *ps = [[[obj componentsSeparatedByString:@"value"] lastObject] componentsSeparatedByString:@"\""];
            if (ps.count >1) {
                [allurls addObject:ps[1]];
            }
        }
    }];
    //model.allURLs = allurls;
    model[@"allURLs"] = allurls;
    tem8 = [htmlString componentsSeparatedByString:@"</li><li>"];
    NSMutableArray *programs = [NSMutableArray array];
    [tem8 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([@[@"0",@"1",@"2"] containsObject:[obj substringToIndex:1]]) {
            if ([obj containsString:@"<"]) {
                obj = [[obj componentsSeparatedByString:@"<"] firstObject];
            }
            [programs addObject:obj];
        }
    }];
    //model.programLists = programs;
    model[@"programLists"] = programs;
    
    return model;
}


#pragma mark  -  省字典
+(NSDictionary *)getHtmlKDSModelWithTemArr:(NSArray *)tem  curentObj:(NSString *)obj idx:(NSUInteger )idx{
    NSRange rangeHTML = [obj rangeOfString:@".html"];
    NSRange rangeHREF = [obj rangeOfString:@"href=\""];
    NSString *indexHtml = [obj substringWithRange:NSMakeRange(rangeHREF.location+rangeHREF.length, rangeHTML.location-rangeHREF.location-rangeHREF.length)];
    //DACXModel  *model = [DACXModel new];
    NSMutableDictionary *model = [NSMutableDictionary dictionary];
    
    //model.province = [self getAStringOfChineseWord:obj];
    model[@"province"] = [self getAStringOfChineseWord:obj];
    model[@"provinceUrl"] = indexHtml;
    
    //model.provinceUrl = indexHtml;
    if (idx == tem.count-1) {
        NSString *name = [self getAStringOfChineseWord:obj];
        if ([name containsString:@"看电视版权所有"]) {
            name = [name stringByReplacingOccurrencesOfString:@"看电视版权所有" withString:@""];
        }
        if ([name containsString:@"移动广告"]) {
            name = [name stringByReplacingOccurrencesOfString:@"移动广告" withString:@""];
        }
        //model.province = name;
        model[@"province"] = indexHtml;
        
    }
    return model;
}


+ (NSString *)getAStringOfChineseWord:(NSString *)string{
    return  [[string componentsSeparatedByString:@"</a></li>"].firstObject componentsSeparatedByString:@">"].lastObject;
}


#pragma mark  -  获取M3u8
+(void)getPayURLWithBaseURL:(NSString *)baseURL
                    success:(void(^)(NSString *))success
                    failure:(void(^)(NSError *error))failure {
    NSString *kds1 = [[NSUserDefaults standardUserDefaults] objectForKey:KDS1];
    kds1 = kds1.length? kds1 : @"http://v.91kds.com/b9/";
    NSString *kds2 = [[NSUserDefaults standardUserDefaults] objectForKey:KDS2];
    kds2 = kds2.length? kds2 : @"http://v.91kds.com/c9/";
    NSString *letvHtml = [[NSUserDefaults standardUserDefaults] objectForKey:LetvHtml];
    letvHtml = letvHtml.length? letvHtml : @"http://m.91kds.com/auth3.php";
    if ([baseURL containsString:KDS1] || [baseURL containsString:KDS2]) {
        if ([baseURL containsString:KDS1]) {
            baseURL = [baseURL stringByReplacingOccurrencesOfString:KDS1 withString:kds1];
        }else if([baseURL containsString:KDS2]){
            baseURL = [baseURL stringByReplacingOccurrencesOfString:KDS2 withString:kds2];
        }
        baseURL = [baseURL stringByReplacingOccurrencesOfString:@"@@" withString:@".m3u8?"];
        NSString *auth = [NSString stringWithFormat:@"%@?t=%f",letvHtml,[[NSDate date] timeIntervalSince1970]];
        [[DSHTML sharedInstance] getRequest:auth parameters:nil success:^(id respones) {
            NSString *m3u8 = [self startPlay:baseURL k:respones[@"livekey"] token:respones[@"token"]];
            !(success)? : success(m3u8);
        } failure:^(NSError *error) {
            !(failure)? : failure(error);
        }];
        
    }else if ([baseURL containsString:LetvHtml]){
        NSString *child = [baseURL substringToIndex:11];
        NSString *auth = [NSString stringWithFormat:@"%@?t=%f&id=%@",letvHtml,[[NSDate date] timeIntervalSince1970],child];
        [[DSHTML sharedInstance] getRequest:auth parameters:nil success:^(id respones) {
            NSString *m3u8 = [self startPlay:baseURL k:respones[@"livekey"] token:respones[@"token"]];
            !(success)? : success(m3u8);
        } failure:^(NSError *error) {
            !(failure)? : failure(error);
        }];
    }else{
        !(success)? : success(baseURL);
    }
}

#pragma mark  -  获取M3u8
+ (NSString *)startPlay:(NSString *)url k:(NSString *)k  token:(NSString *)token{
    NSString *src = nil;
    if([url containsString:@".91kds.com"]){
        src = [NSString stringWithFormat:@"%@&%@",url,k];
    }else if([url containsString:@"letvhtml"]){
        NSString *child = [url substringToIndex:11];
        NSString *jsurl = [NSString stringWithFormat:@"http://live.gslb.letv.com/gslb?stream_id=%@&tag=live&ext=m3u8&sign=live_photerne&p1=0&p2=00&p3=001&splatid=1004&ostype=andriod&hwtype=un&platid=10&playid=1&termid=2&pay=0&expect=3&format=1&%@&jsonp=?",child,token];
        NSString *cc = [NSString stringWithContentsOfURL:[NSURL URLWithString:jsurl] encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *ccDict = [self JSONObject:cc];
        src = ccDict[@"location"];
    }else{
        src = url;
    }
    return src;
}


+(NSDictionary *)JSONObject:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
