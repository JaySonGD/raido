//
//  TTZNavigationController.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/6.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZNavigationController.h"
#import "common.h"
#import "LBLADMob.h"

@interface TTZNavigationController ()

@end

@implementation TTZNavigationController


- (void)pop{    
    [self popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)backButtonItem{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    but.width = 20;but.height = 44;
    [but setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    return [[UIBarButtonItem alloc] initWithCustomView:but];
}


//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    

    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = YES;//这句话表示是否显示大标题
        [self.navigationBar setLargeTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:28.0f],NSFontAttributeName,nil]];
    } else {
        // Fallback on earlier versions
    }

    
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                                 NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    self.navigationBar.barTintColor = kCommonColor;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count >= 1)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [self backButtonItem];
    }
    [[LBLADMob sharedInstance] GADLoadInterstitial];
    
    [super pushViewController:viewController animated:animated];
}

@end
