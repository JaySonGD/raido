//
//  GJWDetailController.m
//  GangJuWang
//
//  Created by czljcb on 2018/3/1.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "GJWDetailController.h"
#import "ZZYueYUModel.h"
#import "GJWDetailHeaderView.h"
//#import "GJWPlayController.h"
#import "UIView+Extension.h"
#import "ViewController.h"

#import "ZZYueYUCell.h"

#import "ZZYueYuTV.h"

#import "common.h"
#import "LBLADMob.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface GJWDetailController ()
<UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) GJWDetailHeaderView *headerView;

@end

@implementation GJWDetailController

- (GJWDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [GJWDetailHeaderView detailHeaderView];
        _headerView.width = kScreenW;
        _headerView.backgroundColor = kBackgroundColor;
        
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    
    self.title = self.model.name;
    [self.headerView.iconIV sd_setImageWithURL:[NSURL URLWithString:self.model.icon] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.headerView.nameLB.text = self.model.name;
    self.headerView.mainLB.text = [NSString stringWithFormat:@"主演：%@",self.model.main];
    self.headerView.statusLB.text = [NSString stringWithFormat:@"状态：%@",self.model.status];
    self.headerView.typeLB.text = [NSString stringWithFormat:@"类型：%@",self.model.type];
    self.headerView.yearLB.text = [NSString stringWithFormat:@"年份：%@",self.model.year];//self.model.year;
    self.headerView.languageLB.text = [NSString stringWithFormat:@"语言：%@",self.model.language];
    self.headerView.desLB.text = self.model.des;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.headerReferenceSize = CGSizeMake(kScreenW, self.headerView.headerHeight);
    layout.itemSize = CGSizeMake((kScreenW - 16 * 2 - 3*8)/4.0 ,35);
    layout.sectionInset = UIEdgeInsetsMake(8, 16, 16, 16);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    
    collectionView.alwaysBounceVertical = YES;
    collectionView.backgroundColor = kBackgroundColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FooterView"];
    [collectionView registerNib:[UINib nibWithNibName:@"ZZYueYUCell" bundle:nil] forCellWithReuseIdentifier:@"ZZYueYUCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:collectionView];
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        
        __weak typeof(self) weakSelf = self;
        [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
        
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.model.hls.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        [footerview addSubview:self.headerView];
        footerview.clipsToBounds = YES;
        reusableView = footerview;
        
    }
    
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZYueYUCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZYueYUCell" forIndexPath:indexPath];
    cell.nameLB.text = self.model.hls[indexPath.row].name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.view showHud];
    
    ZZHLSModel *omodel = self.model.hls[indexPath.item];
    [ZZYueYuTV getTVM3u8:omodel.url title:omodel.name block:^(NSArray *obj) {
        ViewController *channelVC = [ViewController new];
        channelVC.m3u8s = obj;
        channelVC.title = omodel.name;
        [self.navigationController pushViewController:channelVC animated:YES];
        [self.view hideHud];
    }];
}


@end
