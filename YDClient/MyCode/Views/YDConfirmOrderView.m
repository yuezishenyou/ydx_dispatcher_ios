//
//  YDConfirmOrderView.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/22.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDConfirmOrderView.h"
#import "Global.h"
#import "YDSilderView.h"
#import "YDConfirmMileAndPriceView.h"
#import "YDEditAddressCell.h"

typedef NS_ENUM(NSUInteger, YDConfirmOrderViewEditType) {
    YDConfirmOrderViewEditDelete,
    YDConfirmOrderViewEditInsert,
    YDConfirmOrderViewEditDrag,
};

#define SILDER_WIDTH 110
#define SILDER_HEIGHT 30
#define SILDER_VIEW_MARGIN 3
#define PLACEVIEW_MARGIN 10

@interface YDConfirmOrderView ()<UITableViewDelegate, UITableViewDataSource>
// 显示地址的tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 滑块
@property (strong, nonatomic) YDSilderView *sliderView;
// 重置地图按钮

@property (weak, nonatomic) IBOutlet UIButton *resetButton;

// 叫车按钮
@property (weak, nonatomic) IBOutlet UIView *backMiddleView;

// 编辑的背景
@property (weak, nonatomic) IBOutlet UIView *editBackView;
// 编辑按钮
@property (nonatomic, strong) UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

// 判断是否是删除地址的操作
@property (nonatomic, assign) YDConfirmOrderViewEditType editType;

// 判断是实时车还是预约车 YES -- 实时, NO -- 为预约
@property (nonatomic, assign) BOOL callModel;

@end

@implementation YDConfirmOrderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YDConfirmOrderView" owner:nil options:nil] lastObject];
        self.callModel = YES;
        [self setSubViews];
    }
    
    
    return self;
}

/** 布局 */
- (void)setSubViews{
    [self setSilderButton];
    [self setConfrimView];
    [self setEditViee];
}

/** 设置滑块开关 */
- (void)setSilderButton{
    [self.resetButton addTarget:self action:@selector(showAllPath) forControlEvents:UIControlEventTouchUpInside];
    kWeakSelf(self);
    self.sliderView = [[YDSilderView alloc] initWithFrame:CGRectMake(0, 0, self.silderBackView.width, self.silderBackView.height)];
    [self.silderBackView addSubview:self.sliderView];
    [self.sliderView setChangeCallModel:^(BOOL callModel) {
        
        if (callModel) {
            // 实时用车
            if (weakself.callModel == YES) {
                return;
            }
            weakself.callModel = callModel;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                weakself.frame = CGRectMake(weakself.x, weakself.y + 45, weakself.width, weakself.height - 45);
                [weakself layoutIfNeeded];
                weakself.tableViewTopLayout.constant = 0;
                [weakself.backMiddleView layoutIfNeeded];
                
            }];
            
            
        }else{
            // 预约用车
            if (weakself.callModel == NO) {
                return;
            }
            weakself.departureTime.text = @"请选择预约时间";
            weakself.callModel = callModel;
            [UIView animateWithDuration:0.2 animations:^{
                
                weakself.frame = CGRectMake(weakself.x, weakself.y - 45, weakself.width, weakself.height + 45);
                [weakself layoutIfNeeded];
                
                weakself.tableViewTopLayout.constant = 45;
                [weakself.backMiddleView layoutIfNeeded];
            }];
        }
    }];
    self.sliderView.layer.cornerRadius = 5;
    self.sliderView.layer.masksToBounds = YES;
    
}


- (void)setConfrimView{
    
    [self.callButton setBackgroundColor:getColor(MAIN_COLOR)];
    [self.callButton setTitle:@"确认呼叫" forState:UIControlStateNormal];
    self.callButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.callButton.layer.cornerRadius = 8;
    self.callButton.layer.masksToBounds = YES;
    [self.callButton addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    [self.callButton setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [self addSubview:self.callButton];
    
    
    self.backMiddleView.layer.cornerRadius = 5;
    self.backMiddleView.layer.borderColor = getColor(@"d8d8d8").CGColor;
    self.backMiddleView.layer.borderWidth = .5;
    self.backMiddleView.layer.masksToBounds = YES;
    
    self.departureTime.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseTime)];
    [self.departureTime addGestureRecognizer:tap];
    
    [self.backMiddleView sendSubviewToBack:self.departureTime];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.rowHeight = 45;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

/** 叫车按钮的点击事件 */
- (void)callAction {
    if (self.callCar) {
        self.callCar();
    }
    
}

// 编辑View
- (void)setEditViee{
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(_editBackView.height + 5, 0, _editBackView.width - _editBackView.height - 5, _editBackView.height)];
    [self.editButton setTitleColor:getColor(MAIN_COLOR) forState:UIControlStateNormal];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitle:@"完成" forState:UIControlStateSelected];
    self.editButton.layer.cornerRadius = 5;
    self.editButton.layer.borderColor = getColor(MAIN_COLOR).CGColor;
    self.editButton.layer.borderWidth = 1;
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(_editBackView.width - _editBackView.height, 0, _editBackView.height, _editBackView.height)];
    [plusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusButton setBackgroundColor:[UIColor whiteColor]];
    [_editBackView addSubview:plusButton];
    [plusButton addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
    [_editBackView addSubview:self.editButton];
}

- (void)plusAction{
    self.editType = YDConfirmOrderViewEditInsert;
    if (self.addMiddlePlace) {
        self.addMiddlePlace();
    }
}

- (void)editAction:(UIButton *)button{
    if (button.selected) {
        [UIView animateWithDuration:.5 animations:^{
            button.frame = CGRectMake(self.editBackView.height + 5, 0, self.editBackView.width - self.editBackView.height - 5, self.editBackView.height);
        }];
    }else{
        [UIView animateWithDuration:.5 animations:^{
            button.frame = CGRectMake(0, 0, button.width, button.height);
        }];
        
    }
    [self.tableView setEditing:!button.selected animated:YES];
    button.selected = ! button.selected;
}

- (void)showAllPath{
    [GLOABL.mapView showOverlays:GLOABL.mapView.overlays edgePadding:UIEdgeInsetsMake(110, 50, 300, 50)animated:YES];
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSDictionary *dic = self.addressArray[sourceIndexPath.row];
    //删除之前行的数据
    [self.addressArray removeObject:dic];
    // 插入数据到新的位置
    [self.addressArray insertObject:dic atIndex:destinationIndexPath.row];
    
    [GLOABL calculateDistanceWithArray:self.addressArray];
}

/** 显示当前视图 */
- (void)show{
    [self.sliderView setInstallView];
    self.callModel = YES;
    self.editButton.selected = NO;
    self.editButton.frame = CGRectMake(_editBackView.height + 5, 0, _editBackView.width - _editBackView.height - 5, _editBackView.height);
    self.departureTime.text = @"请选择出发时间";
    [self.tableView setEditing:NO];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(self.x, kScreenSize.height - CONFIRMVIEW_HEIGHT, self.width, CONFIRMVIEW_HEIGHT);
        self.tableViewTopLayout.constant = 0;
        [self.backMiddleView layoutIfNeeded];
    }];
    
}

#pragma mark ---------------- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDEditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDEditAddressCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"YDEditAddressCell" bundle:nil] forCellReuseIdentifier:@"YDEditAddressCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"YDEditAddressCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.addressArray[indexPath.row];
    cell.address.text = dic[ADDRESS_NAME];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    view.backgroundColor = getColor(@"d8d8d8");
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    view.backgroundColor = getColor(@"d8d8d8");
    return view;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone | UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editType = YDConfirmOrderViewEditDelete;
    [self.addressArray removeObjectAtIndex:indexPath.row];
    self.addressArray = self.addressArray;
}

- (void)setAddressArray:(NSMutableArray *)addressArray{
    _addressArray = addressArray;
    if (addressArray.count < 2) {
        self.priceLabel.text = @"0元";
        self.mileLabel.text = @"0公里";
        self.timeLabel.text = @"0分钟";
    }
    
    if (self.callModel) {
        if (2 <= self.addressArray.count && self.addressArray.count <= 4) {
            DLog(@"============11111==%f", kScreenSize.height);
            self.frame = CGRectMake(self.x, kScreenSize.height - (CONFIRMVIEW_HEIGHT + self.tableView.rowHeight * (self.addressArray.count - 2) + 1) - BOTTOM_MARGIN, self.width, CONFIRMVIEW_HEIGHT + self.tableView.rowHeight * (self.addressArray.count - 2) + 1);
        }
        if (self.addressArray.count == 5) {
            self.frame = CGRectMake(self.x, kScreenSize.height - (CONFIRMVIEW_HEIGHT +self.tableView.rowHeight * (self.addressArray.count - 3) + 1 + 20) - BOTTOM_MARGIN, self.width, CONFIRMVIEW_HEIGHT + self.tableView.rowHeight * (self.addressArray.count - 3) + 1 + 20);
        }
    }else {
        if (2 <= self.addressArray.count && self.addressArray.count <= 4) {
            self.frame = CGRectMake(self.x, kScreenSize.height - (CONFIRMVIEW_HEIGHT + self.tableView.rowHeight * (self.addressArray.count - 2) + 1 + 45) - BOTTOM_MARGIN, self.width, CONFIRMVIEW_HEIGHT + self.tableView.rowHeight * (self.addressArray.count - 2) + 1 + 45);
        }
        if (self.addressArray.count == 5) {
            self.frame = CGRectMake(self.x, kScreenSize.height - (CONFIRMVIEW_HEIGHT + self.tableView.rowHeight * (self.addressArray.count - 3) + 1 + 20 + 45) - BOTTOM_MARGIN, self.width, CONFIRMVIEW_HEIGHT + self.tableView.rowHeight * (self.addressArray.count - 3) + 1 + 20 + 45);
        }
    }
    
    
    [self.tableView reloadData];
    if (self.addressArray.count >= 5) {
        self.tableView.contentOffset = CGPointMake(0, self.tableView.rowHeight * (self.addressArray.count - 5) + 20);
    }
    
    
    [GLOABL calculateDistanceWithArray:addressArray];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
        return nil;
    }
    else
    {
        return hitView;
    }
}


- (void)choseTime{
    if (self.choseTimeAction) {
        self.choseTimeAction();
    }
}

@end

