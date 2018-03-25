//
//  HKTVResultController.m
//  WebPlayer
//
//  Created by Jay on 2018/3/20.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "HKTVResultController.h"
#import "GJWDetailController.h"
#import "GJWClassifyCell.h"
#import "KDSBaseModel.h"
#import "ZZYueYUModel.h"

#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>

#import "common.h"
#import "ZZYueYuTV.h"
#import "LBLADMob.h"

@interface HKTVResultController ()
<
UICollectionViewDelegate,UICollectionViewDataSource
>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <KDSBaseModel*>*models;
@property (nonatomic, assign) NSInteger searchPage;
@property (nonatomic, copy) NSString *kw;
@end

@implementation HKTVResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark  -  自定义方法
- (void)setUI{
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 0;
    
    layout.itemSize = CGSizeMake((kScreenW - (IS_PAD?4:2)) /(IS_PAD?5.0:3.0), 1.35*(kScreenW - (IS_PAD?4:2)) /(IS_PAD?5.0:3.0));
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.backgroundColor = kBackgroundColor;
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:@"GJWClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

    collectionView.alwaysBounceVertical = YES;
    self.collectionView = collectionView;
    
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    footer.refreshingTitleHidden = YES;
    footer.height = 35.f;
    //footer.automaticallyHidden = YES;
    footer.stateLabel.font = [UIFont systemFontOfSize:12.0];
    footer.stateLabel.textColor = kColorWithHexString(0x666666);
    footer.backgroundColor = kBackgroundColor;
    footer.triggerAutomaticallyRefreshPercent = 0.1f;
    [footer setTitle:@"没有更多了~" forState:MJRefreshStateNoMoreData];
    collectionView.mj_footer = footer;
    collectionView.mj_footer.hidden = YES;
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        __weak typeof(self) weakSelf = self;
        [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
    }

}
#pragma mark 处理网络数据
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    
    [ZZYueYuTV search:self.kw page:self.searchPage block:^(NSArray<NSDictionary *> *obj, BOOL hasMore) {
        [weakSelf.collectionView.mj_footer endRefreshing];
        NSArray *models = [KDSBaseModel mj_objectArrayWithKeyValuesArray:obj];
        [weakSelf.models addObjectsFromArray:models];
        [weakSelf.collectionView reloadData];
        if(hasMore) weakSelf.searchPage ++;
        else [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];

    }];
}

#pragma mark  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    collectionView.mj_footer.hidden = !self.models.count;
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
    [self.view showLoading];
    
    KDSBaseModel *model = self.models[indexPath.item];
    
    [self.view showLoading];
    [ZZYueYuTV getTVDetail:model.url block:^(NSDictionary *obj) {
        NSLog(@"%s", __func__);
        [self.view hideLoading:nil];
        
        GJWDetailController *detail = [GJWDetailController new];
        detail.model = [ZZYueYUModel mj_objectWithKeyValues:obj];
        [self.presentingViewController.navigationController pushViewController:detail animated:YES];
    }];
    
}
#pragma mark  -  UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.searchPage = 1;
    self.kw = searchBar.text;
     __weak typeof(self) weakSelf = self;
    [self.view showLoading];
    [ZZYueYuTV search:searchBar.text page:self.searchPage block:^(NSArray<NSDictionary *> *obj, BOOL hasMore) {
        [weakSelf.view hideLoading:nil];
        weakSelf.models = [KDSBaseModel mj_objectArrayWithKeyValuesArray:obj];
        [weakSelf.collectionView reloadData];
        if(hasMore) weakSelf.searchPage = 2;
        else [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];

    }];
}
@end
