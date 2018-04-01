//
//  TTZProfileViewController.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/25.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZProfileViewController.h"
#import <MessageUI/MessageUI.h>
#import <SafariServices/SafariServices.h>
#import "TTZAppConfig.h"
#import "common.h"

@interface TTZProfileViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;

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

//FIXME:  -  事件监听
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goodReview:(UIButton *)sender {
    [self leaveReview];
}

- (IBAction)drinkCoffee:(UIButton *)sender {
//    [];
    SFSafariViewController *vc = [[SFSafariViewController alloc]
                                  initWithURL:[NSURL URLWithString:[TTZAppConfig defaultConfig].coffeeURL]
                                  entersReaderIfAvailable:YES];
    if (@available(iOS 10.0, *)) {
        vc.preferredBarTintColor = kCommonColor;
    }
    if (@available(iOS 11.0, *)) {
        vc.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
    }     
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)shareOthers:(UIButton *)sender {
    [self share:sender];
}
- (IBAction)sendMessage:(UIButton *)sender {
    [self sendMail];
}


#pragma mark  -  自定义方法
- (void)setUI{
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bar.barStyle = UIBarStyleBlack;
    
    [self.bgIV addSubview:bar];
    kViewRadius(self.logoIV, 12);
}


-(void)leaveReview{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[TTZAppConfig defaultConfig].leaveReviewURL]];
}


- (void)sendMail{
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    MFMailComposeViewController *mailVC = [MFMailComposeViewController new];
    [mailVC setSubject:@"Contact from TTZ"];
    [mailVC setToRecipients:@[TTZAppConfig.defaultConfig.mail]];
    mailVC.mailComposeDelegate = self;
    [self presentViewController:mailVC animated:YES completion:nil];
    
}

//FIXME:   -  MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)share:(UIView *)sender{
    NSURL *url  = [NSURL URLWithString:[TTZAppConfig defaultConfig].shareURL];
    UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    
    if(!IS_PAD){
        [self presentViewController:shareVC animated:YES completion:nil];
    }else{
        UIPopoverController *popVC = [[UIPopoverController alloc] initWithContentViewController:shareVC];
        [popVC presentPopoverFromRect:sender.frame inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }

}



@end
