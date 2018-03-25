//
//  UIImage+Radius.m
//  WebPlayer
//
//  Created by Jay on 2018/3/20.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIImage+Radius.h"

@implementation UIImage (Radius)

- (UIImage *)imageWithCornerRadius:(CGFloat)radius{
    
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    
    CGContextClip(UIGraphicsGetCurrentContext());
    
    
    
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    [UIImagePNGRepresentation(image) writeToFile:@"/Users/jay/Desktop/曹志.png" atomically:YES];
    
    UIGraphicsEndImageContext();
    
    
    
    return image;
    
}

@end
