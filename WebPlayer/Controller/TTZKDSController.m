//
//  TTZKDSController.m
//  WebPlayer
//
//  Created by Jay on 2018/3/30.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZKDSController.h"
#import "TTZProvinceController.h"
#import "DSKT.h"

#import "GJWDetailController.h"
#import "HKTVResultController.h"
#import "KDSBaseModel.h"
#import "ZZYueYUModel.h"
#import "GJWClassifyCell.h"

#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "common.h"
#import "ZZYueYuTV.h"
#import "LBLADMob.h"
#import "UIAlertController+Blocks.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"


@interface TTZKDSController ()
<
UICollectionViewDelegate,UICollectionViewDataSource,
UISearchResultsUpdating
>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, weak) TTZProvinceController *resultsController;

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIView *emContentView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <KDSBaseModel*>*models;

@property (nonatomic, weak) UITextField *tf;
@end

@implementation TTZKDSController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

#pragma mark  -  自定义方法

- (void)addCollectionView{
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;//这个是标题显示的方式，
        
    }else{
        self.searchController.hidesNavigationBarDuringPresentation = YES;
        //self.navigationItem.titleView = self.searchController.searchBar;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((kScreenW - (IS_PAD?4:2)) /(IS_PAD?5.0:3.0), 1.0*(kScreenW - (IS_PAD?4:2)) /(IS_PAD?5.0:3.0));
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.backgroundColor = kBackgroundColor;
    [self.view addSubview:collectionView];
    
    if (@available(iOS 11.0, *)){}else{
        layout.headerReferenceSize = CGSizeMake(kScreenW, 44);
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    }
    [collectionView registerNib:[UINib nibWithNibName:@"GJWClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    collectionView.alwaysBounceVertical = YES;
    
    self.collectionView = collectionView;

    [self loadRData];
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH+44, 0);
    }
}

- (void)setUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.model.name;
    
    if (!self.model.isAddId || [[NSUserDefaults standardUserDefaults] objectForKey:@"isAddId"]) {
        
        [self addCollectionView];
        
        
    }else{
        
        if (@available(iOS 11.0, *)) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;//这个是标题显示的方式，
        }
        
        UIView * emContentView = [[UIView alloc] initWithFrame:CGRectMake(16, kStatusBarAndNavigationBarHeight+64, kScreenW-32, 220)];
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, emContentView.width, 30)];
        tf.placeholder = @"请输入标识";
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.font = [UIFont systemFontOfSize:14];
        [emContentView addSubview:tf];
        _tf = tf;
        
        UILabel *desLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, emContentView.width, 20)];
        desLB.text = @"注:添加标识后,资源会自动更新！获取港剧标识请加群:704837957";
        desLB.font = [UIFont systemFontOfSize:9];
        [emContentView addSubview:desLB];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 50+25, emContentView.width, 40);
        [addBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn setBackgroundColor:kCommonColor];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        kViewRadius(addBtn, 8);
        
        [emContentView addSubview:addBtn];
        
        self.emContentView = emContentView;
        
        [self.view addSubview:emContentView];
    }
    
    
}


- (void)addAction{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy";
    NSInteger yyyy = [[formatter stringFromDate:date] integerValue];
    
    formatter.dateFormat = @"MM";
    NSInteger mm = [[formatter stringFromDate:date] integerValue];
    
    formatter.dateFormat = @"dd";
    NSInteger dd = [[formatter stringFromDate:date] integerValue];
    
    NSString *Id = [NSString stringWithFormat:@"hk-%ld-tv",yyyy+mm+dd];
    
    
    if ([self.tf.text isEqualToString:Id]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"isAddId" forKey:@"isAddId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.emContentView removeFromSuperview];
        [self addCollectionView];
        
    }
    
}

#pragma mark 处理网络数据
- (void)loadRData{
    __weak typeof(self) weakSelf = self;
    [DSKT getAll91_KDSModelSucess:^(NSArray<NSDictionary *> *obj) {

        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.models = [KDSBaseModel mj_objectArrayWithKeyValuesArray:obj];
            [weakSelf.collectionView reloadData];
        });

    }];
}

#pragma mark  -  UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *HeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        [HeaderView addSubview:self.searchController.searchBar];
        HeaderView.clipsToBounds = YES;
        reusableView = HeaderView;
        
    }
    
    return reusableView;
}

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
    
    KDSBaseModel *model = self.models[indexPath.item];
    model.isAddId = self.model.isAddId;
    model.isReview = self.model.isReview;

    __weak typeof(self) weakSelf = self;
    [DSKT getOneProvinceAllKDSModelWithUrl:model.url sucess:^(NSArray<NSDictionary *> *obj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
    
            TTZProvinceController *vc = [TTZProvinceController new];
            vc.models = [KDSBaseModel mj_objectArrayWithKeyValuesArray:obj];
            vc.model = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        });
        
    }];

    

    
    return;
//    if(!self.model.isReview || [[NSUserDefaults standardUserDefaults] objectForKey:@"isReview"])
//    {
//        [self.view showLoading];
//        KDSBaseModel *model = self.models[indexPath.item];
//        [ZZYueYuTV getTVDetail:model.url block:^(NSDictionary *obj) {
//            [self.view hideLoading:nil];
//            GJWDetailController *detail = [GJWDetailController new];
//            detail.model = [ZZYueYUModel mj_objectWithKeyValues:obj];
//            [self.navigationController pushViewController:detail animated:YES];
//        }];
//
//        return;
//    }
//
//    [UIAlertController showAlertInViewController:self withTitle:@"" message:@"好评后才能观看哦！立即给我好评。" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//
//        if(buttonIndex != controller.cancelButtonIndex){
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1359761086?action=write-review"]];
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            appDelegate.beginTime = [NSDate date];
//        }
//
//    }];
    
}

#pragma mark  -  UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    //模糊查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchController.searchBar.text]; //
    NSArray <NSDictionary *>*results = [DSKT.lists filteredArrayUsingPredicate:predicate];

    KDSBaseModel *model = [KDSBaseModel new];
    model.isAddId = self.model.isAddId;
    model.isReview = self.model.isReview;
    model.name = [NSString stringWithFormat:@"%@-的相关结果",searchController.searchBar.text];
    self.resultsController.model = model;
    self.resultsController.models = [KDSBaseModel mj_objectArrayWithKeyValuesArray:results];
    
    NSLog(@"%s", __func__);
}



#pragma mark  -  get/set 方法
- (UISearchController *)searchController
{
    if(!_searchController){
        
        TTZProvinceController *vc = [[TTZProvinceController alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
        _resultsController = vc;
        //背景
        //        _searchController.searchBar.barTintColor = [UIColor orangeColor];//[UIColor colorWithRed:67/255.0 green:205/255.0 blue:135/255.0 alpha:1.0];
        _searchController.searchBar.tintColor = [UIColor whiteColor];
        _searchController.searchBar.barTintColor = kCommonColor;
        
        //        [_searchController.searchBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        //        [_searchController.searchBar setBackgroundImage:[UIImage new]];
        //        [_searchController.searchBar setSearchFieldBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        //UIImage* searchBarBg = [self GetImageWithColor:[UIColor orangeColor] andHeight:35.0f];
        //设置背景图片
        [_searchController.searchBar setBackgroundImage:[UIImage imageNamed:@"SearchBarBg"]];
        //设置背景色
        //        [_searchController.searchBar setBackgroundColor:[UIColor orangeColor]];
        //设置文本框背景
        UIImage* searchFieldBackgroundImage = [[UIColor whiteColor] imageForColorandHeight:35.0];
        //        UIImage* searchFieldBackgroundImage = [self GetImageWithColor:[UIColor whiteColor] andHeight:35.0f];
        
        
        [_searchController.searchBar setSearchFieldBackgroundImage:[searchFieldBackgroundImage imageWithCornerRadius:10.0] forState:UIControlStateNormal];
        
        [_searchController.searchBar setSearchTextPositionAdjustment:UIOffsetMake(10, 0)];// 设置搜索框中文本框的文本偏移量
        
        _searchController.searchBar.placeholder = @"请输入你要搜索的名字";
        [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        
        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
        searchField.tintColor = kCommonColor;
        
        _searchController.searchResultsUpdater = self;
        //_searchController.searchBar.delegate = self;
        //_searchController.delegate = self;
        self.definesPresentationContext = YES;
        //        （1）如果不设置：self.definesPresentationContext = YES;那么如果设置了hidesNavigationBarDuringPresentation为YES，在进入编辑模式的时候会导致searchBar看不见（偏移-64）。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致高度为64的空白区域出现（导航栏未渲染出来）。
        //
        //        （2）如果设置：self.definesPresentationContext = YES;在设置hidesNavigationBarDuringPresentation为YES，进入编辑模式会正常显示和使用。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致搜索框向下偏移64.
        //        _searchController.searchBar.scopeButtonTitles = @[@"1",@"3"];
        //        _searchController.searchBar.barStyle = UIBarStyleBlack;
        
        // titleView -->NO   headerView -->YES
        //_searchController.hidesNavigationBarDuringPresentation = NO;
        
        
    }
    return _searchController;
}

//- (UISearchController *)searchController
//{
//    if(!_searchController){
//
//
//        HKTVResultController *vc = [HKTVResultController new];
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
//        //背景
//        //        _searchController.searchBar.barTintColor = [UIColor orangeColor];//[UIColor colorWithRed:67/255.0 green:205/255.0 blue:135/255.0 alpha:1.0];
//        _searchController.searchBar.tintColor = [UIColor whiteColor];
//        _searchController.searchBar.barTintColor = kCommonColor;
//
//        //        [_searchController.searchBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        //        [_searchController.searchBar setBackgroundImage:[UIImage new]];
//        //        [_searchController.searchBar setSearchFieldBackgroundImage:[UIImage new] forState:UIControlStateNormal];
//        //UIImage* searchBarBg = [kCommonColor imageForColorandHeight:35.0];
//        //设置背景图片
//        [_searchController.searchBar setBackgroundImage:[UIImage imageNamed:@"SearchBarBg"]];
//        //设置背景色
//        //[_searchController.searchBar setBackgroundColor:kCommonColor];
//        //设置文本框背景
//        UIImage* searchFieldBackgroundImage = [[UIColor whiteColor] imageForColorandHeight:35.0];
//
//
//        [_searchController.searchBar setSearchFieldBackgroundImage:[searchFieldBackgroundImage imageWithCornerRadius:10.0] forState:UIControlStateNormal];
//
//        [_searchController.searchBar setSearchTextPositionAdjustment:UIOffsetMake(10, 0)];// 设置搜索框中文本框的文本偏移量
//
//        _searchController.searchBar.placeholder = @"请输入你要搜索的关键字";
//        [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
//        //_searchController.searchResultsUpdater = self;
//
//        _searchController.searchBar.delegate = vc;
//        //_searchController.delegate = self;
//        self.definesPresentationContext = YES;
//        //        （1）如果不设置：self.definesPresentationContext = YES;那么如果设置了hidesNavigationBarDuringPresentation为YES，在进入编辑模式的时候会导致searchBar看不见（偏移-64）。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致高度为64的空白区域出现（导航栏未渲染出来）。
//        //
//        //        （2）如果设置：self.definesPresentationContext = YES;在设置hidesNavigationBarDuringPresentation为YES，进入编辑模式会正常显示和使用。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致搜索框向下偏移64.
//        //_searchController.searchBar.scopeButtonTitles = @[@"1",@"3"];
//        //_searchController.searchBar.barStyle = UIBarStyleBlack;
//
//
//    }
//    return _searchController;
//}




@end
