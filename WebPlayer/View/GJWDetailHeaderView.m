//
//  GJWDetailHeaderView.m
//  GangJuWang
//
//  Created by czljcb on 2018/3/1.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "GJWDetailHeaderView.h"

@interface GJWDetailHeaderView()

@end

@implementation GJWDetailHeaderView

+ (instancetype)detailHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:@"GJWDetailHeaderView" owner:nil options:nil].lastObject;
}


- (CGFloat)headerHeight
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.hlsLB.frame);
}

@end
