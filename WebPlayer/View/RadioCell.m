//
//  RadioCell.m
//  HKRadio
//
//  Created by czljcb on 2017/10/17.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "RadioCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KDSBaseModel.h"

@interface RadioCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIButton *heart;
@property (weak, nonatomic) IBOutlet UILabel *main;

@end

@implementation RadioCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.borderWidth = 0.5;
    self.icon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;   
}

- (IBAction)heartButton:(UIButton *)sender {
    
    
  
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 20;
    frame.size.width -= 20;
    
    [super setFrame:frame];
}


-(void)setModel:(KDSBaseModel *)model {
    _model = model;
    
    _des.text = model.des;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"logo"]];
    _name.text = model.name;
    _main.text = model.main;
    

}

@end
