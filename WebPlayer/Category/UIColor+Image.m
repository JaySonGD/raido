//
//  UIColor+Image.m
//  WebPlayer
//
//  Created by Jay on 2018/3/20.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIColor+Image.h"

@implementation UIColor (Image)

- (UIImage*) imageForColorandHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
