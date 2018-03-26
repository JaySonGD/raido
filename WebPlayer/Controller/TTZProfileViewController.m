//
//  TTZProfileViewController.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/25.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZProfileViewController.h"

@interface TTZProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;

@end

@implementation TTZProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  自定义方法
- (void)setUI{
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bar.barStyle = UIBarStyleBlack;
    
    [self.bgIV addSubview:bar];
}

@end
