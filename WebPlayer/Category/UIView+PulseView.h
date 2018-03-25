//
//  UIView+PulseView.h
//  WebPlayer
//
//  Created by czljcb on 2018/3/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>

typedef NS_ENUM(NSUInteger, PulseViewAnimationType) {
    PulseViewAnimationTypeRegularPulsing,
    PulseViewAnimationTypeRadarPulsing
};

@interface UIView (PulseView)

- (void)startPulseWithColor:(UIColor *)color;

- (void)startPulseWithColor:(UIColor *)color animation:(PulseViewAnimationType)animationType;

- (void)startPulseWithColor:(UIColor *)color scaleFrom:(CGFloat)initialScale to:(CGFloat)finishScale frequency:(CGFloat)frequency opacity:(CGFloat)opacity animation:(PulseViewAnimationType)animationType;

- (void)stopPulse;

@end
