//
//  GJWHKTVController.m
//  GangJuWang
//
//  Created by czljcb on 2018/3/1.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "GJWHomeController.h"
#import "TTZHKTVViewController.h"
#import "TTZResultsController.h"
#import "ViewController.h"
#import "GJWDetailController.h"
#import "TTZTVController.h"
#import "TTZProfileViewController.h"
#import "TableViewAnimationKitHeaders.h"

#import "TTZBannerView.h"
#import "RadioCell.h"
//#import "FWPlayerKit.h"
#import "ZZYueYuTV.h"
#import "TTZPlayer.h"

#import "KDSBaseModel.h"
#import "ZZYueYUModel.h"

#import <MJExtension/MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <SafariServices/SafariServices.h>
#import <Masonry/Masonry.h>

#import "common.h"
#import "CALayer+PauseAimate.h"

@interface GJWHomeController ()
<
UITableViewDelegate,UITableViewDataSource,
UISearchResultsUpdating
>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <KDSBaseModel*>*objs;
@property (nonatomic, strong) NSMutableArray <KDSBaseModel*>*banners;


@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, weak) TTZResultsController *resultsController;

@property (nonatomic, weak) UIButton *playView;
@end

@implementation GJWHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self initUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.playView startPulseWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]
                             scaleFrom:1.0
                                    to:1.5
                             frequency:1.0
                               opacity:0.5
                             animation:PulseViewAnimationTypeRadarPulsing];

    if ([TTZPlayer defaultPlayer].isPlaying){
        [self.playView.layer resumeAnimate];
        
    }else{
        [self.playView.layer pauseAnimate];
    }
}


- (void)loadData{
    [self.view showLoading];
    NSURL * url = [NSURL URLWithString:@"https://tv-1252820456.cos.ap-guangzhou.myqcloud.com/hkradio%20(1)%20.json"];
    //创建请求
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];

    //    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideLoading:nil];
            if(error) return ;
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.objs =[KDSBaseModel mj_objectArrayWithKeyValuesArray:obj[@"list"]];
            self.banners =[KDSBaseModel mj_objectArrayWithKeyValuesArray:obj[@"banner"]];

            [self initUI];
            [self.tableView reloadData];
            [TableViewAnimationKit showWithAnimationType:3 tableView:self.tableView];

        });
        
        
    }];
    //开启网络任务
    [task resume];
    
}

- (void)initUI{
    
    
    self.title = @"港剧";
    


    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    tableView.rowHeight = 165;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"RadioCell" bundle:nil] forCellReuseIdentifier:@"RadioCellID"];
    tableView.rowHeight = 180;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;//这个是标题显示的方式，
    
        if (self.banners.count) {
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 130)];
            TTZBannerView *bannerView = [[TTZBannerView alloc] initWithFrame:CGRectMake(10,10, kScreenW-20, 120)];
            kViewRadius(bannerView, 5);
            [headerView addSubview:bannerView];
            bannerView.models = self.banners;
            bannerView.selectItemAtIndexPath = ^(KDSBaseModel *model) {
                [self doAction:model];
            };
            tableView.tableHeaderView = headerView;
        }

    
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (self.banners.count) {
            
            CGFloat bannerH = 100.0 * kScreenW /320.0;
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, bannerH + 10+self.searchController.searchBar.height)];
            [headerView addSubview:self.searchController.searchBar];
            
            TTZBannerView *bannerView = [[TTZBannerView alloc] initWithFrame:CGRectMake(10,10+self.searchController.searchBar.height, kScreenW-20, bannerH)];
            kViewRadius(bannerView, 5);
            [headerView addSubview:bannerView];
            bannerView.models = self.banners;
            bannerView.selectItemAtIndexPath = ^(KDSBaseModel *model) {
                [self doAction:model];
            };
            
            tableView.tableHeaderView = headerView;
            
            
        }else self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
    
    
    UIButton *playView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:playView];
    playView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    playView.imageView.clipsToBounds = YES;
    kViewBorderRadius(playView, 32, 1, [[UIColor blackColor] colorWithAlphaComponent:0.75]);
    kViewRadius(playView.imageView, 32);
    playView.frame = CGRectMake(kScreenW - 64 - 32, kScreenH - 64 - 64, 64, 64);
    playView.backgroundColor = [UIColor blackColor];
    [playView startPulseWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] scaleFrom:1.0 to:1.5 frequency:1.0 opacity:0.5 animation:PulseViewAnimationTypeRadarPulsing];
    //[playView.layer startRotation];
    //[playView.layer pauseAnimate];
    self.playView = playView;
    
    [playView addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame = CGRectMake(0, 0, 44, 44);
    logoBtn.backgroundColor = [UIColor orangeColor];
    [logoBtn addTarget:self action:@selector(profileClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoBtn];
}

- (void)profileClick{
    [self.navigationController pushViewController:[TTZProfileViewController new] animated:YES];
}

- (void)playClick{
    
    if ([TTZPlayer defaultPlayer].isPlaying) {
        [[TTZPlayer defaultPlayer] pause];
    }else{
        [[TTZPlayer defaultPlayer] play];
    }
}

- (void)doAction:(KDSBaseModel *)model{
    NSString *type = model.type;
    
    if ([type isEqualToString:@"radio"]) {
        
        [[TTZPlayer defaultPlayer] playWithModel:model];
                [self.playView sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
        [self.playView.layer startRotation];

        return;
    } else if([type isEqualToString:@"hktv"]){
        
        TTZHKTVViewController *hktv = [TTZHKTVViewController new];
        hktv.model = model;
        [self.navigationController pushViewController:hktv animated:YES];
        return;
        
    } else if([type isEqualToString:@"tv"]){
        
        TTZTVController *hktv = [TTZTVController new];
        hktv.model = model;
        [self.navigationController pushViewController:hktv animated:YES];
        return;
        
    } else if([type isEqualToString:@"video"]){
        
        ViewController *playVC = [ViewController new];
        playVC.title = model.name;
        playVC.m3u8s = @[model.url];
        
        [self.navigationController pushViewController:playVC animated:YES];
        return;
        
    }else if([type isEqualToString:@"detail"]){
        
        [self.view showLoading];
        [ZZYueYuTV getTVDetail:model.url block:^(NSDictionary *obj) {
            [self.view hideLoading:nil];
            
            GJWDetailController *detail = [GJWDetailController new];
            detail.model = [ZZYueYUModel mj_objectWithKeyValues:obj];
            [self.navigationController pushViewController:detail animated:YES];
        }];
        
        return;
        
    }else if([type isEqualToString:@"html"]){
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:model.url]];
        [self presentViewController:safariVC animated:YES completion:nil];
        return;
    }
    

}

#pragma mark  -  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.objs.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KDSBaseModel *model = self.objs[indexPath.row];
    [self doAction:model];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioCellID" forIndexPath:indexPath];
    
    cell.model = self.objs[indexPath.row];
    return cell;
}

#pragma mark  -  UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    //模糊查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchController.searchBar.text]; //
    NSArray <KDSBaseModel *>*results = [self.objs filteredArrayUsingPredicate:predicate];
    self.resultsController.objs = results.mutableCopy;
    
    NSLog(@"%s", __func__);
}


#pragma mark  -  get/set 方法
- (UISearchController *)searchController
{
    if(!_searchController){
        
        TTZResultsController *vc = [[TTZResultsController alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
        _resultsController = vc;
        //背景
        //        _searchController.searchBar.barTintColor = [UIColor orangeColor];//[UIColor colorWithRed:67/255.0 green:205/255.0 blue:135/255.0 alpha:1.0];
        _searchController.searchBar.tintColor = [UIColor whiteColor];
        _searchController.searchBar.barTintColor = kCommonColor;
        
        //        [_searchController.searchBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        //        [_searchController.searchBar setBackgroundImage:[UIImage new]];
        //        [_searchController.searchBar setSearchFieldBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        //UIImage* searchBarBg = [kCommonColor imageForColorandHeight:35.0];
        //设置背景图片
        [_searchController.searchBar setBackgroundImage:[UIImage imageNamed:@"SearchBarBg"]];
        //设置背景色
        //[_searchController.searchBar setBackgroundColor:kCommonColor];
        //设置文本框背景
        UIImage* searchFieldBackgroundImage = [[UIColor whiteColor] imageForColorandHeight:35.0];
        
        
        [_searchController.searchBar setSearchFieldBackgroundImage:[searchFieldBackgroundImage imageWithCornerRadius:10.0] forState:UIControlStateNormal];
        
        [_searchController.searchBar setSearchTextPositionAdjustment:UIOffsetMake(10, 0)];// 设置搜索框中文本框的文本偏移量
        
        _searchController.searchBar.placeholder = @"请输入你要搜索的关键字";
        [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
        searchField.tintColor = kCommonColor;

        
        _searchController.searchResultsUpdater = self;
        
        //_searchController.searchBar.delegate = vc;
        //_searchController.delegate = self;
        self.definesPresentationContext = YES;
        //        （1）如果不设置：self.definesPresentationContext = YES;那么如果设置了hidesNavigationBarDuringPresentation为YES，在进入编辑模式的时候会导致searchBar看不见（偏移-64）。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致高度为64的空白区域出现（导航栏未渲染出来）。
        //
        //        （2）如果设置：self.definesPresentationContext = YES;在设置hidesNavigationBarDuringPresentation为YES，进入编辑模式会正常显示和使用。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致搜索框向下偏移64.
        //_searchController.searchBar.scopeButtonTitles = @[@"1",@"3"];
        //_searchController.searchBar.barStyle = UIBarStyleBlack;
        
        
    }
    return _searchController;
}





@end
