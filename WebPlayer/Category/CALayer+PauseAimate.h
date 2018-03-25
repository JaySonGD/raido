//
//  CALayer+PauseAimate.h
//  WebPlayer
//
//  Created by czljcb on 2018/3/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (PauseAimate)
// 暂停动画
- (void)pauseAnimate;

// 恢复动画
- (void)resumeAnimate;
- (void)startRotation;
@end
