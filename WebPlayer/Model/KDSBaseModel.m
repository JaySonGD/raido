//
//  KDSBaseModel.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/5.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "KDSBaseModel.h"

@implementation KDSBaseModel

- (void)setIcon:(NSString *)icon{
    _icon = [icon containsString:@"nopic.gif"]? @"" : icon;
}

@end
