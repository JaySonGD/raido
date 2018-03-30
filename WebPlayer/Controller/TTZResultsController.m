//
//  TTZResultsController.m
//  WebPlayer
//
//  Created by Jay on 2018/3/20.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZResultsController.h"

#import <SafariServices/SafariServices.h>
#import <MJExtension/MJExtension.h>

#import "TTZHKTVViewController.h"
#import "ViewController.h"
#import "GJWDetailController.h"
#import "TTZKDSController.h"

#import "ZZYueYUModel.h"
#import "ZZYueYuTV.h"
#import "RadioCell.h"
#import "KDSBaseModel.h"

#import "TTZPlayer.h"
#import "common.h"

@interface TTZResultsController ()
<
UITableViewDelegate,UITableViewDataSource
>

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation TTZResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)initUI{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    
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
}

- (void)setObjs:(NSMutableArray<KDSBaseModel *> *)objs
{
    _objs = objs;
    [self.tableView reloadData];
}


- (void)doAction:(KDSBaseModel *)model{
    NSString *type = model.type;
    
    if ([type isEqualToString:@"radio"]) {
        
        [[TTZPlayer defaultPlayer] playWithModel:model];
        return;
    } else if([type isEqualToString:@"hktv"]){
        
        TTZHKTVViewController *hktv = [TTZHKTVViewController new];
        hktv.title = model.name;
        [self.presentingViewController.navigationController pushViewController:hktv animated:YES];
        return;
        
    } else if([type isEqualToString:@"video"]){
        
        ViewController *playVC = [ViewController new];
        playVC.title = model.name;
        playVC.m3u8s = @[model.url];
        
        [self.presentingViewController.navigationController pushViewController:playVC animated:YES];
        return;
        
    }else if([type isEqualToString:@"detail"]){
        
        [self.view showLoading];
        [ZZYueYuTV getTVDetail:model.url block:^(NSDictionary *obj) {
            [self.view hideLoading:nil];
            
            GJWDetailController *detail = [GJWDetailController new];
            detail.model = [ZZYueYUModel mj_objectWithKeyValues:obj];
            [self.presentingViewController.navigationController pushViewController:detail animated:YES];
        }];
        
        return;
        
    }else  if([type isEqualToString:@"html"]){
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:model.url]];
        [self presentViewController:safariVC animated:YES completion:nil];
        return;
    }else if([type isEqualToString:@"kds"]){
        TTZKDSController *vc = [TTZKDSController new];
        vc.model = model;
        [self.presentingViewController.navigationController  pushViewController:vc animated:YES];
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
    [self doAction:self.objs[indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioCellID" forIndexPath:indexPath];
    
    cell.model = self.objs[indexPath.row];
    return cell;
}

@end
