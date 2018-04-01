//
//  TTZProvinceController.m
//  WebPlayer
//
//  Created by Jay on 2018/3/30.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZProvinceController.h"
#import "WKWebController.h"

#import "GJWClassifyCell.h"
#import "KDSBaseModel.h"

#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>

#import "common.h"
#import "DSKT.h"
#import "LBLADMob.h"
#import "UIAlertController+Blocks.h"
#import "TTZAppConfig.h"
#import "AppDelegate.h"


@interface TTZProvinceController ()
<
UICollectionViewDelegate,UICollectionViewDataSource
>
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation TTZProvinceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

#pragma mark  -  自定义方法
- (void)setUI{

    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 0;
    
    layout.itemSize = CGSizeMake((kScreenW - (IS_PAD?4:2)) /(IS_PAD?5.0:3.0), 1.0*(kScreenW - (IS_PAD?4:2)) /(IS_PAD?5.0:3.0));
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.backgroundColor = kBackgroundColor;
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:@"GJWClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    collectionView.alwaysBounceVertical = YES;
    self.collectionView = collectionView;
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        __weak typeof(self) weakSelf = self;
        [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
    }
    
}

- (void)setModels:(NSMutableArray<KDSBaseModel *> *)models
{
    _models = models;
    self.navigationItem.title = self.model.name;
    [self.collectionView reloadData];
}

#pragma mark  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GJWClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    KDSBaseModel *model = self.models[indexPath.item];
    
    
    cell.nameLabel.text = model.name;
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    
    if(!self.model.isReview || [[NSUserDefaults standardUserDefaults] objectForKey:@"isReview"])
    {
        
        KDSBaseModel *model = self.models[indexPath.item];
        WKWebController *vc = [WKWebController new];
        vc.model = model;
        
        [self.presentingViewController.navigationController?self.presentingViewController.navigationController : self.navigationController pushViewController:vc animated:YES];
        
        return;
    }


    [UIAlertController showAlertInViewController:self withTitle:@"" message:@"好评后才能观看哦！立即给我好评。" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex != controller.cancelButtonIndex){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[TTZAppConfig defaultConfig].leaveReviewURL]];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.beginTime = [NSDate date];
        }
        
    }];
}

@end
