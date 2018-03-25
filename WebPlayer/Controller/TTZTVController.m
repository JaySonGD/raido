
//
//  TTZTVController.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/25.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZTVController.h"
#import "KDSBaseModel.h"
#import "GJWClassifyCell.h"
#import "ViewController.h"

#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "common.h"
#import "LBLADMob.h"
#import "UIAlertController+Blocks.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"


@interface TTZTVController ()
<
UICollectionViewDelegate,UICollectionViewDataSource
>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIView *emContentView;
@property (nonatomic, strong) NSMutableArray <KDSBaseModel*>*models;

@property (nonatomic, weak) UITextField *tf;

@end

@implementation TTZTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.models = @[].mutableCopy;
    [self setUI];
}

#pragma mark  -  自定义方法

- (void)addCollectionView{
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;//这个是标题显示的方式
    }
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
    
    
    [self loadData];
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        
        [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
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

-(void)loadData {
    
    [self.view showLoading];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *kk = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://m.567it.com/"] encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *allKK = [kk componentsSeparatedByString:@"<a href=\""];
        
        
        [allKK enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx != 0) {
                
                KDSBaseModel *gg = [KDSBaseModel new];
                
                gg.url = [obj componentsSeparatedByString:@"\""].firstObject;
                
                gg.icon = @"http://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
                
                if ([obj containsString:@"</font>"]) {
                    
                    gg.name = [[obj componentsSeparatedByString:@"</font>"].firstObject componentsSeparatedByString:@">"].lastObject;
                }else {
                    
                    gg.name = [[obj componentsSeparatedByString:@"</a>"].firstObject componentsSeparatedByString:@">"].lastObject;
                    
                }
                
                [self.models addObject:gg];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
            [self.view hideLoading:nil];
        });
    });
}


//
//- (void)loadRData{
//    __weak typeof(self) weakSelf = self;
//
//
//    [ZZYueYuTV getHKTVPage:self.page block:^(NSArray<NSDictionary *> *obj) {
//        NSLog(@"%s", __func__);
//
//        [weakSelf.collectionView.mj_header endRefreshing];
//        [weakSelf.collectionView.mj_footer endRefreshing];
//
//        NSArray *models = [KDSBaseModel mj_objectArrayWithKeyValuesArray:obj];
//        if (weakSelf.page == 1) {
//            weakSelf.models = models.mutableCopy;
//        }else{
//            [weakSelf.models addObjectsFromArray:models];
//        }
//        weakSelf.page += (models.count > 0);
//        [weakSelf.collectionView reloadData];
//
//    }];
//}

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
        
        [self loadM3u8Data:model block:^(NSArray <NSString *>*m3u8s) {
            
            ViewController *playVC = [ViewController new];
            playVC.title = model.name;
            playVC.m3u8s = m3u8s;
            [self.navigationController pushViewController:playVC animated:YES];
        }];
        return;
    }
    
    [UIAlertController showAlertInViewController:self withTitle:@"" message:@"好评后才能观看哦！立即给我好评。" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex != controller.cancelButtonIndex){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1359761086?action=write-review"]];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.beginTime = [NSDate date];
        }
        
    }];
    
}


-(void)loadM3u8Data :(KDSBaseModel *)model block: (void(^)(NSArray *))block{
    
    [self.view showLoading];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url = nil;
        
        if ([model.url containsString:@"/"]) {
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.567it.com%@",model.url]];
            
        }else {
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.567it.com/%@",model.url]];
        }
        
        NSString *kk = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *url = [[kk componentsSeparatedByString:@"video:'"].lastObject componentsSeparatedByString:@"'"].firstObject;
            
            !(block)? : block(@[url]);
            [self.view hideLoading:nil];
            
        });
    });
}






@end
