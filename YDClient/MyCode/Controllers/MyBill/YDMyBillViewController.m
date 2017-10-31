//
//  YDMyBillViewController.m
//  YDClient
//
//  Created by yuedao on 2017/9/22.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDMyBillViewController.h"
#import "Global.h"

@interface YDMyBillViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YDMyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleString = @"我的订单";
    
    [self.view addSubview:self.tableView];
    
    
    [self.dataArray addObjectsFromArray:[[GLOABL manager] getDataWithTableName:ORDER_TABLE]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"11111"];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[ORDER_ID];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"从 %@ 到 %@", dic[UP_PLACE], dic[DOWN_PLACE]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark --------- 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;

}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
