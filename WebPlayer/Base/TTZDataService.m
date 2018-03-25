//
//  TTZDataService.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/24.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZDataService.h"

static TTZDataService *instance = nil;

@implementation TTZDataService
+ (instancetype)defaultData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


//- (void)

@end
