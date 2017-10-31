//
//  YDSearchDownPlaceView.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/22.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDSearchDownPlaceView.h"
#import "YDSearchPlaceCell.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"


#define SEARCH_WIDTH (300 / WIDTH_6S_SCALE)
#define TABLEVIEW_TOP_MARGIN (7 / HEIGHT_6S_SCALE + 44)

@interface YDSearchDownPlaceView ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *pois;

@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKey;

@property (nonatomic, assign) BOOL choseDataFromDateBase;

@end

@implementation YDSearchDownPlaceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YDSearchDownPlaceView" owner:nil options:nil] lastObject];
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.toolbarDoneBarButtonItemText =@"搜索";
        
        [_searchText addTarget:self action:@selector(searchTextChanged) forControlEvents:UIControlEventEditingChanged];
        
        
    }
    return self;
}

- (void)setUI {
    UIView *searchBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    searchBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:searchBackView];
    
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 7, SEARCH_WIDTH, 30)];
    self.searchText.backgroundColor = getColor(@"d5d5d5");
    self.searchText.delegate = self;
    self.searchText.layer.cornerRadius = 5;
    self.searchText.layer.masksToBounds = YES;
    self.searchText.font = [UIFont systemFontOfSize:15];
    self.searchText.placeholder = @"去哪儿?";
    self.searchText.delegate = self;
    self.searchText.returnKeyType = UIReturnKeySearch;
    
    [searchBackView addSubview:self.searchText];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchText.frame), 0, kScreenSize.width - CGRectGetMaxX(self.searchText.frame) - LEFT_MARGIN, searchBackView.height)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBackView addSubview:cancelButton];
    
    /** 显示搜索结果的View */
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
    DLog(@"------------2222_----%f======%f", self.height, self.tableView.height);
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:self.tableView];
}

/** 当文字变化时进行搜索 */
- (void)searchTextChanged {
    
    UITextRange *selectedRange = [self.searchText markedTextRange];
    NSString * newText = [self.searchText textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0){
        return;
    }else{
        if (self.searchText.text.length == 0) {
            return;
        }
        kWeakSelf(self)
        [GLOABL setSearchPOISucess:^(NSArray *array) {
            kStrongSelf(self)
            if (self.pois.count > 0) {
                [weakself.pois removeAllObjects];
            }
            self.choseDataFromDateBase = NO;
            [self.pois addObjectsFromArray:array];
            [self.tableView reloadData];
        }];
        [GLOABL searchPOIWithString:self.searchText.text];
    }

}

- (void)cancelAction{
    if (self.cancelButtonAciton) {
        self.cancelButtonAciton();
    }
}

/** 显示 */
- (void)showWithCompeleteBlock:(void (^)(void))block{
    NSArray *array = [[GLOABL manager] getDataWithTableName:ADDRESS_TABLE];
    if (array.count > 0) {
        self.choseDataFromDateBase = YES;
        [self.pois addObjectsFromArray:array];
        [self.tableView reloadData];
    }else{
        self.choseDataFromDateBase = NO;
    }
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, kStatusHeight, kScreenSize.width, kScreenSize.height - kStatusHeight);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
        [self.searchText becomeFirstResponder];
    }];
}

/** 隐藏 */
- (void)hiddenWithCompeleteBlock:(void (^)(void))block{
    [self.searchText resignFirstResponder];
    self.choseDataFromDateBase = NO;
    self.searchText.text = @"";
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, kScreenSize.height - kStatusHeight);
        if (block) {
            block();
        }
    } completion:^(BOOL finished) {
        if (self.pois.count > 0) {
            [self.pois removeAllObjects];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark ------------ textField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchText resignFirstResponder];
    [self searchTextChanged];
    return YES;
}


#pragma mark ------------- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseString = @"YDSearchPlaceCell";
    YDSearchPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseString];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"YDSearchPlaceCell" bundle:nil] forCellReuseIdentifier:reuseString];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseString];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.choseAddressSucess) {
        if (!self.choseDataFromDateBase) {
            AMapPOI *poi = self.pois[indexPath.row];
            NSArray *array = [[GLOABL manager] getDataWithLat:[NSString stringWithFormat:@"%lf", poi.location.latitude] long:[NSString stringWithFormat:@"%lf", poi.location.longitude] tableName:ADDRESS_TABLE];
            if (array.count > 0) {
                // 查询到数据中有相同数据, 则更新数据库, 使数据 + 1
                NSDictionary *dic = array.firstObject;
                [[GLOABL manager] updateAddressTableWithlat:dic[ADDRESS_LAT] lon:dic[ADDRESS_LON] times:[NSString stringWithFormat:@"%ld", [dic[CHOSE_TIMES] integerValue] + 1]];
            }else{
                NSDictionary *dic = @{ADDRESS_NAME : poi.name,
                                      ADDRESS_INFO: poi.address,
                                      ADDRESS_LAT : [NSString stringWithFormat:@"%lf",
                                                     poi.location.latitude],
                                      ADDRESS_LON : [NSString stringWithFormat:@"%lf",poi.location.longitude],
                                      CHOSE_TIMES : @"1"};
                [[GLOABL manager] insertDictionary:dic tableName:ADDRESS_TABLE];
            }
            
            self.choseAddressSucess(poi.name, CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude));
        }else {
            NSDictionary *dic = [self.pois objectAtIndex:indexPath.row];

            self.choseAddressSucess(dic[ADDRESS_NAME], CLLocationCoordinate2DMake([dic[ADDRESS_LAT] doubleValue], [dic[ADDRESS_LON] doubleValue]));
            [[GLOABL manager] updateAddressTableWithlat:dic[ADDRESS_LAT] lon:dic[ADDRESS_LON] times:[NSString stringWithFormat:@"%ld", [dic[CHOSE_TIMES] integerValue] + 1]];
        }
        
    }
    [self hiddenWithCompeleteBlock:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(YDSearchPlaceCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.choseDataFromDateBase) {
        NSDictionary *dic = self.pois[indexPath.row];
        cell.nameLabel.text = dic[ADDRESS_NAME];
        cell.addressLabel.text = dic[ADDRESS_INFO];
    }else{
        AMapPOI *poi = self.pois[indexPath.row];
        cell.nameLabel.text = poi.name;
        cell.addressLabel.text = poi.address;
    }
    
}

#pragma mark ------------- 懒加载
- (NSMutableArray *)pois{
    if (!_pois) {
        _pois = [[NSMutableArray alloc] init];
    }
    return _pois;
}

@end
