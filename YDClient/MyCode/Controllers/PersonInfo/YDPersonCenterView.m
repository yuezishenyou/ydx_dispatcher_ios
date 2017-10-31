//
//  PersonCenterView.m
//  YDDriver
//
//  Created by 徐丽然 on 17/9/22.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import "YDPersonCenterView.h"
#import "YDPersonCenterCell.h"
#import "YDPersonCenterHeaderView.h"

@interface YDPersonCenterView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong)YDPersonCenterHeaderView *headerView;

@property (nonatomic, copy) NSString *headerString;

@end

@implementation YDPersonCenterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
        
    }
    return self;
}

// 设置UI界面
- (void)setUI{
    
//    NSString *headTemp = [NSString stringWithFormat:@"uid=%@&sid=2013", [[YDGlobal manager] loginModel].data.uid];
    
    
//    NSString *utf = [headTemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    _headerString = [NSString stringWithFormat:@"%@?%@", GATEWAY, utf];
    
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(240 / WIDTH_6S_SCALE, 0, kScreenSize.width, kScreenSize.height)];
    _backGroundView.backgroundColor = [UIColor blackColor];
    _backGroundView.alpha = 0.3f;
    _backGroundView.userInteractionEnabled = YES;
    [self addSubview:_backGroundView];
    
    _imagesArray = @[@"center_schedue_icon", @"center_income_icon"];

    _titlesArray = @[@"我的订单", @"设置"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 240 / WIDTH_6S_SCALE, kScreenSize.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _headerView = [[YDPersonCenterHeaderView alloc] init];
    kWeakSelf(self);
    [_headerView setCheckPersonInfo:^{
        DLog(@"跳转到个人信息页面");
        if (weakself.clickHeaderView) {
            weakself.clickHeaderView();
        }
    }];
    _headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 280 / HEIGHT_6S_SCALE);
    _tableView.tableHeaderView = _headerView;
    
    _tableView.rowHeight = 90;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark --------tableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseString = @"YDPersonCenterCell";
    YDPersonCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseString];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"YDPersonCenterCell" bundle:nil] forCellReuseIdentifier:reuseString];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(YDPersonCenterCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.iconImage.image = [UIImage imageNamed:_imagesArray[indexPath.row]];
    cell.titleLabel.text = _titlesArray[indexPath.row];

    [cell setCheckInfo:^{
        if (self.checkMorePersonInfo) {
            self.checkMorePersonInfo(indexPath.row);
        }
    }];

}


// 返回
- (void)backClick{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.tableView.frame = CGRectMake(-240 / WIDTH_6S_SCALE, 0, 240 / WIDTH_6S_SCALE, kScreenSize.height);
                         self.backGroundView.alpha = 0.0;
                     }completion:^(BOOL finished) {
                         self.hidden = YES;
                     }];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view != _backGroundView) {
        return;
    }
    [self backClick];
    
}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.backGroundView.alpha = 0.3;
                         self.tableView.frame = CGRectMake(240 / WIDTH_6S_SCALE, 0, 240 / WIDTH_6S_SCALE, kScreenSize.height);
                     }];
}

- (void)setDateWithName:(NSString *)name andScore:(CGFloat)score firstLoad:(BOOL)first{
    _headerView.nameLabel.text = name;
//    _headerView.scoreLabel.text = [NSString stringWithFormat:@"%@%.2f",KLocalizedString(@"Level", nil), score];
    
    [self setHeaderImageWithFirstLoad:first];
    
}

- (void)setHeaderImageWithFirstLoad:(BOOL)first{

    if (self.hideLoadingViewForView) {
        self.hideLoadingViewForView();
    }
    [self show];
    UIImage *image = nil;
    if (!first) {
//        image = [UIImage imageWithContentsOfFile:headerPath];
    }
    if (image) {
        self.headerView.headerImage.image = image;

    }else{

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_headerString]]];
            
//            [UIImageJPEGRepresentation(image, 1)writeToFile:headerPath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.headerView.headerImage.image = image;

            });
        });
    
    }
    
}


@end
