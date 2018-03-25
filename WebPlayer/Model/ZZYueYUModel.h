//
//  ZZYueYUModel.h
//  GangJuWang
//
//  Created by czljcb on 2018/3/2.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZHLSModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@end


@interface ZZYueYUModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSArray <ZZHLSModel *>*hls;
@property (nonatomic, copy) NSString *main;
@property (nonatomic, copy) NSString *language;


@end
