//
//  KDSBaseModel.h
//  WebPlayer
//
//  Created by czljcb on 2018/3/5.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTZPlayer.h"

@interface KDSBaseModel : NSObject <TTZPlayerModel>

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *name;



@property (nonatomic, copy) NSString *icon;
/** radio video html hktv detail */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *main;
/** 0 1->评分 */
@property (nonatomic, assign) BOOL isReview;
/** 0 1->标识 */
@property (nonatomic, assign) BOOL isAddId;

@end
