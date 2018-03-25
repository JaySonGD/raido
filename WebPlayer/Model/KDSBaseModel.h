//
//  KDSBaseModel.h
//  WebPlayer
//
//  Created by czljcb on 2018/3/5.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDSBaseModel : NSObject

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *name;



@property (nonatomic, strong) NSString *icon;
/** radio video html hktv detail */
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *main;
/** 0 1->评分 */
@property (nonatomic, assign) BOOL isReview;
/** 0 1->标识 */
@property (nonatomic, assign) BOOL isAddId;

@end
