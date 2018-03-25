//
//  CALayer+PauseAimate.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "CALayer+PauseAimate.h"

@implementation CALayer (PauseAimate)
- (void)pauseAnimate
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAnimate
{
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

- (void)startRotation{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.fromValue = @(0);
    anim.toValue = @(M_PI * 2);
    anim.duration = 10;
    anim.repeatCount = NSIntegerMax;
    anim.removedOnCompletion = NO;
    [self addAnimation:anim forKey:nil];
}

@end
