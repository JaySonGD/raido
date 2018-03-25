//
//  GJWDetailHeaderView.h
//  GangJuWang
//
//  Created by czljcb on 2018/3/1.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GJWDetailHeaderView : UIView
+ (instancetype)detailHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *mainLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *yearLB;
@property (weak, nonatomic) IBOutlet UILabel *languageLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;

@property (weak, nonatomic) IBOutlet UILabel *hlsLB;

- (CGFloat )headerHeight;

@end
