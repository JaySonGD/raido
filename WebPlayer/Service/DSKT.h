//
//  HKTVManeger.h
//  GetFM
//
//  Created by czljcb on 2017/11/17.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DSKT : NSObject

// CCTV ["provinceUrl": index1_sc, "province": 四川]
+(void)getCCTV_KDSModelSucess:(void (^)(NSDictionary *model))modelBlock;
// 卫视  ["provinceUrl": index1_sc, "province": 四川]
+(void)getWS_KDSModelSucess:(void (^)(NSDictionary *model))modelBlock;
// 所有省份 [["provinceUrl": index1_sc, "province": 四川]]
+(void)getAll91_KDSModelSucess:(void (^)(NSArray<NSDictionary *> *models))modelBlock;
// 一个省份的所有台 [["provinceUrl": jiemu_zjws, "province": 浙江卫视]]

+(void)getOneProvinceAllKDSModelWithUrl:(NSString *)url sucess:(void (^)(NSArray<NSDictionary *> *models))modelBlock;
/*
 @{
    @"allURLs" :
                @[
                    @"",
                    @""
                ],
    @"programLists:@[
                        @"",
        @""
 ]
 }

 */
+(void)getOneChannelKDSModelWithUrl:(NSString *)url
                             sucess:(void (^)(NSDictionary *model))modelBlock;
//
+(void)getPayURLWithBaseURL:(NSString *)baseURL
                    success:(void(^)(NSString *))success
                    failure:(void(^)(NSError *error))failure;
@end
