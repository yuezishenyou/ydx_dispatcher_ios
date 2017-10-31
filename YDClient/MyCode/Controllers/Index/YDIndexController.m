//
//  YDIndexController.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDIndexController.h"
#import "YDIndexUpPlaceView.h"
#import "YDIndexDownPlaceView.h"
#import "YDSearchDownPlaceView.h"
#import "Global.h"
#import "YDPersonCenterView.h"
#import "YDMyBillViewController.h"
#import "YDPopAnnotationView.h"
#import "YDDatePickerView.h"
#import "DDAlertView.h"
#import "YDLoginController.h"
#import "YDXLoginController.h"
#import "YDConfirmOrderView.h"
#import "ChatViewController.h"


#define TOP_MARGIN (3 + kStatusHeight)
#define TOP_VIEW_HEIGHT (50)
#define BOTTOM_VIEW_HEIGHT (75)

typedef NS_ENUM(NSInteger, YDChosePlaceType) {
    YDChoseUpPlace,
    YDChoseDownPlace,
    YDChoseMiddlePlace,
};

@interface YDIndexController ()
/** 上车地址的View */
@property (nonatomic, strong) YDIndexUpPlaceView *upPlaceView;
/** 选择下车地址的View */
@property (nonatomic, strong) YDIndexDownPlaceView *downView;
/** 搜索地址的View */
@property (nonatomic, strong) YDSearchDownPlaceView *searchView;

/** 确认订单的View */
@property (nonatomic, strong) YDConfirmOrderView *confirmView;

// 上下车地址
@property (nonatomic, copy) NSString *upPlace;
@property (nonatomic, copy) NSString *downPlace;

// 上下车经纬度
@property (nonatomic, assign) CLLocationCoordinate2D upLocation;
@property (nonatomic, assign) CLLocationCoordinate2D downLocation;

// 个人中心
@property (nonatomic, strong) YDPersonCenterView *personView;

@property (nonatomic, strong) UIView *upLocationView;

// 选择地址
@property (nonatomic, assign) YDChosePlaceType chosePlaceType;

// 重新定位按钮
@property (nonatomic, strong) UIButton *resetLocation;

@property (nonatomic, strong) UILabel *lat;

@property (nonatomic, strong) NSMutableArray *addressArray;

@property (nonatomic, strong) YDDatePickerView  *datePicker;

@end

@implementation YDIndexController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [GLOABL.mapView showAnnotations:GLOABL.mapView.annotations edgePadding:UIEdgeInsetsMake(100, 100, 100, 100) animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark -------- DatePicker
//    YDDatePickerView *dater = [[YDDatePickerView alloc] init];
//    dater.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
//    [self.view addSubview:dater];
    [self setMapView];
    [self setUI];
    [self addBlock];
    [self.view addSubview:self.personView];
    [self.view bringSubviewToFront:self.personView];
    self.personView.hidden = YES;
    
    //之后删除
   UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(kScreenSize.width - 100, 100, 70, 40);
    chatBtn.backgroundColor = [UIColor redColor];
    [chatBtn setTitle:@"chat" forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatBtn];
}

- (void)chatAction{
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (void)setUI{
    
//    self.upLocationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 50)];
//    self.upLocationView.backgroundColor = [UIColor redColor];
//    self.upLocationView.center = CGPointMake(self.view.center.x, self.view.center.y + 10 - self.upLocationView.height / 2);
//    [GLOABL setGeoPoint:CGPointMake(self.view.center.x, CGRectGetMaxY(self.upLocationView.frame))];
//    [self.view addSubview:self.upLocationView];

    // 定位按钮
    self.resetLocation = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 400 / HEIGHT_6S_SCALE, 38, 38)];
    [self.resetLocation setImage:[UIImage imageNamed:@"process_position_button"] forState:UIControlStateNormal];
    
    [self.resetLocation addTarget:self action:@selector(resetSelfLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.resetLocation];
    
//    self.lat = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 90, (kScreenSize.width - 2 * LEFT_MARGIN), 40)];
//    self.lat.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.lat];


}


- (void)resetSelfLocation{
    float lat = GLOABL.mapView.userLocation.coordinate.latitude;
    float lon = GLOABL.mapView.userLocation.location.coordinate.longitude;
    [GLOABL setChoseUpPlace:NO];
    [GLOABL.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lon)];
    
    [GLOABL regeoWithLat:lat lon:lon];
    
    [GLOABL.mapView removeAnnotations:GLOABL.mapView.annotations];
    [self addAnnotion];
    
}


/** 添加代码块 */
- (void)addBlock
{
    kWeakSelf(self);
    [self.upPlaceView setShowPersonInfo:^{
        
        
        DLog(@"---判断有没有登录---");
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        BOOL isLogin  = [ud boolForKey:@"isLogin"];
        
        if (!isLogin)
        {
            YDXLoginController *vc = [[YDXLoginController alloc]initWithNibVCName:@"YDXLoginController"];
            
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
        
            [weakself presentViewController:navc animated:YES completion:nil];
            
            return ;
        }
        
    
        [weakself.personView show];
        
        
    }];
    
    
    
    
    
    
    
    [self.personView setCheckMorePersonInfo:^(NSInteger index){
        switch (index) {
            case 0:{
                // 跳转到我的订单页面
                YDMyBillViewController *myBill = [[YDMyBillViewController alloc] init];
                [weakself.navigationController pushViewController:myBill animated:YES];
                break;
            }
            default:
                // 跳转到设置界面
                break;
        }
    }];
    
//    [GLOABL setShowLatAndLon:^(float lat, float lon){
//        weakself.lat.text = [NSString stringWithFormat:@"lat :  %f, lon : %f", lat, lon];
//    }];
}

/** 设置导航栏 */
- (void)setNavigationController{}

/** 设置地图 */
- (void)setMapView {
    MAMapView *mapView = GLOABL.mapView;
    mapView.frame = CGRectMake(0, kStatusHeight, kScreenSize.width, kScreenSize.height - kStatusHeight);
//    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude);
//    [mapView setCenterCoordinate:coor];

    [GLOABL setRegeoSucess:^(NSString *address, CLLocationCoordinate2D location) {
        GLOABL.hotelAddress = address;
        self.upPlaceView.upPlaceLabel.text = address;
        self.upPlace = address;
        self.upLocation = location;
        
    }];
    
    [self.view addSubview:mapView];
    
    [self.view addSubview:self.upPlaceView];
    [self.view addSubview:self.downView];
    
    [self addAnnotion];

}

// 在地图上添加大头针
- (void)addAnnotion{
    // 添加大头针
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSArray *arr in GLOABL.hotelPoints) {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([arr[0] floatValue], [arr[1] floatValue]);
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = coor;
//        pointAnnotation.title = arr[2];
        [tempArray addObject:pointAnnotation];
    }
    
    [GLOABL.mapView addAnnotations:tempArray];
    
    DLog(@"----------------%lu", (unsigned long)GLOABL.mapView.annotations.count);
}

/** 显示搜索的view */
- (void)showChosePlace{
    [self.view bringSubviewToFront:self.searchView];
    [self.searchView showWithCompeleteBlock:nil];
    if (self.chosePlaceType == YDChoseUpPlace || self.chosePlaceType == YDChoseDownPlace) {
        [UIView animateWithDuration:0.35 animations:^{
            self.upPlaceView.frame = CGRectMake(self.upPlaceView.x, - (kStatusHeight  + kNaviHeight), self.upPlaceView.width, self.upPlaceView.height);
        }];
    }
}

/** 隐藏搜索的view */
- (void)hideChosePlace {
    [self.searchView hiddenWithCompeleteBlock:nil];
    
    if (self.chosePlaceType == YDChoseDownPlace || self.chosePlaceType == YDChoseUpPlace) {
        [UIView animateWithDuration:0.35 animations:^{
            self.upPlaceView.frame = CGRectMake(LEFT_MARGIN, TOP_MARGIN, kScreenSize.width - 2 * LEFT_MARGIN, TOP_VIEW_HEIGHT);
        }];

    }
}

/** 选择地址后确认叫车页面 */
- (void)setConfirmCallView {
    if (!self.navView) {
        [super setNavigationController];
        UIView *view = [self.navView viewWithTag:100];
        view.hidden = YES;
    }
    
    [GLOABL setCalculateRouteSucess:^(NSInteger distance, NSString *time){
        float km = distance / 1000.0;
        self.confirmView.mileLabel.text = [NSString stringWithFormat:@"%.1f公里", km];
        self.confirmView.timeLabel.text = time;
        
    }];
    
    self.titleString = @"确认呼叫信息";
    self.resetLocation.hidden = YES;
    self.downView.hidden = YES;
//    [GLOABL calculateDistanceAndPriceWithStartLat:self.upLocation.latitude StartLon:self.upLocation.longitude EndLat:self.downLocation.latitude EndLon:self.downLocation.longitude];
    self.navView.frame = CGRectMake(0, - (kNaviHeight + kStatusHeight), kScreenSize.width, (kNaviHeight + kStatusHeight));
    [self.confirmView show];
    self.confirmView.addressArray = self.addressArray;
    [UIView animateWithDuration:0.35 animations:^{
       self.navView.frame = CGRectMake(0, 0, kScreenSize.width, (kNaviHeight + kStatusHeight));
    }];
}

/** 返回 */
- (void)backClick{
    [UIView animateWithDuration:0.35 animations:^{
        self.navView.frame = CGRectMake(0, -kNavAndStatusHeight, kScreenSize.width, kNavAndStatusHeight);
        self.confirmView.frame = CGRectMake(LEFT_MARGIN, kScreenSize.height + CONFIRMVIEW_HEIGHT+ BOTTOM_MARGIN, self.confirmView.width, CONFIRMVIEW_HEIGHT);
        self.upPlaceView.frame = CGRectMake(LEFT_MARGIN, TOP_MARGIN, kScreenSize.width - 2 * LEFT_MARGIN, TOP_VIEW_HEIGHT);
    }];
    [GLOABL setChoseUpPlace:NO];
    self.resetLocation.hidden = NO;
    self.downView.hidden = NO;
    [GLOABL clearAnnotions];
    [GLOABL.mapView setCenterCoordinate:GLOABL.mapView.userLocation.coordinate];
    [GLOABL regeoWithLat:GLOABL.mapView.userLocation.coordinate.latitude lon:GLOABL.mapView.userLocation.coordinate.longitude];
    [GLOABL.mapView setZoomLevel:16];
    self.upLocationView.hidden = NO;
    [self addAnnotion];
    
}

/** 发起叫车 */
- (void)callACar{
    // 发起叫车的网络请求
    // 将订单信息保存在本地
    NSString *time = [self createOrderID];
    NSString *orderID = [[time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- :"]] componentsJoinedByString:@""];
    NSDictionary *dic = @{
                          ORDER_ID : orderID,
                          SERVICE_ID : @"",
                          UP_PLACE : self.upPlace,
                          UP_LAT : [NSString stringWithFormat:@"%lf", self.upLocation.latitude],
                          UP_LON : [NSString stringWithFormat:@"%lf", self.upLocation.longitude],
                          DOWN_PLACE : self.downPlace,
                          DOWN_LAT : [NSString stringWithFormat:@"%lf", self.downLocation.latitude],
                          DOWN_LON : [NSString stringWithFormat:@"%lf", self.downLocation.longitude],
                          PASSANGER_NAME : @"",
                          PASSANGER_PHONE : @"",
                          PREVIEW_TIME : time,
                          PRICE : self.confirmView.priceLabel.text,
                          DRIVER_NAME : @""
                          };

    [[GLOABL manager] insertDictionary:dic tableName:ORDER_TABLE];

    [self backClick];

}

/** 格式化时间戳 */
- (NSString *)createOrderID{
    
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // 获取当前日期
    NSDate *currentDate = [NSDate date];
    
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    
    DLog(@"=======%@", currentDateString);
    return currentDateString;

}

#pragma mark ----------- 懒加载
// 个人中心View
- (YDPersonCenterView *)personView{
    if (!_personView) {
        _personView = [[YDPersonCenterView alloc] initWithFrame:CGRectMake(- 240 / WIDTH_6S_SCALE, 0, kScreenSize.width + 240 / WIDTH_6S_SCALE, kScreenSize.height)];
    }
    return _personView;
}

- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [[NSMutableArray alloc] init];
    }
    return _addressArray;
}

/** 上车地址的View */
- (YDIndexUpPlaceView *)upPlaceView{
    if (!_upPlaceView) {
        _upPlaceView = [[YDIndexUpPlaceView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, kScreenSize.width - 2 * LEFT_MARGIN, TOP_VIEW_HEIGHT)];
        kWeakSelf(self);
        [_upPlaceView setChoseUpPlace:^{
            weakself.chosePlaceType = YDChoseUpPlace;
            [weakself showChosePlace];
        }];
    }
    return _upPlaceView;
}

/** 下车地址的view */
- (YDIndexDownPlaceView *)downView{
    if (!_downView) {
        _downView = [[YDIndexDownPlaceView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, (kScreenSize.height - BOTTOM_VIEW_HEIGHT - BOTTOM_MARGIN), (kScreenSize.width - 2 * LEFT_MARGIN) , BOTTOM_VIEW_HEIGHT)];
        kWeakSelf(self)
        [_downView setChoseDownPlace:^(BOOL realTime) {
            if (realTime) {
                weakself.chosePlaceType = YDChoseDownPlace;
                [weakself showChosePlace];
            }else{
#pragma mark ---------- 选择时间
            }
        }];
    }
    return _downView;

}

/** 搜索的view */
- (YDSearchDownPlaceView *)searchView {
    if (!_searchView) {
//        _searchView = [[YDSearchDownPlaceView alloc] initWithFrame:CGRectMake(0, kScreenSize.height, kScreenSize.width, kScreenSize.height - kStatusHeight)];
        
        _searchView = [[YDSearchDownPlaceView alloc] init];
        _searchView.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, kScreenSize.height);
        kWeakSelf(self)
        [_searchView setCancelButtonAciton:^{
            [weakself hideChosePlace];
        }];

        [_searchView setChoseAddressSucess:^(NSString *name, CLLocationCoordinate2D location) {
            [GLOABL setChoseUpPlace:YES];
            switch (weakself.chosePlaceType) {
                case YDChoseUpPlace:
                {
                    // 选择上车地址
                    weakself.upPlace = name;
                    weakself.upLocation = location;
                    weakself.upPlaceView.upPlaceLabel.text = name;
                    weakself.upPlaceView.frame = CGRectMake(LEFT_MARGIN, TOP_MARGIN, kScreenSize.width - 2 * LEFT_MARGIN, TOP_VIEW_HEIGHT);
                    [[GLOABL mapView] setCenterCoordinate:location];
                    break;
                }
                case YDChoseDownPlace:{
                    // 选择下车地址
                    weakself.downLocation = location;
                    weakself.downPlace = name;
                    weakself.upLocationView.hidden = YES;
                    if (weakself.addressArray.count > 0) {
                        [weakself.addressArray removeAllObjects];
                    }
                    
                    NSDictionary *dicUpPlace = @{ADDRESS_NAME : weakself.upPlace,
                                                 ADDRESS_LAT : @(weakself.upLocation.latitude),
                                                 ADDRESS_LON : @(weakself.upLocation.longitude)
                                                 };
                    [weakself.addressArray addObject:dicUpPlace];
                    
                    NSDictionary *dicDownPlace = @{ADDRESS_NAME : name,
                                                   ADDRESS_LAT : @(location.latitude),
                                                   ADDRESS_LON : @(location.longitude)
                                                   
                                                   };
                    [weakself.addressArray addObject:dicDownPlace];
                    [weakself setConfirmCallView];
                    break;

                }
                default:{
                    DLog(@"==============选择其他地址");
                    NSDictionary *dic = @{ADDRESS_NAME : name,
                                                   ADDRESS_LAT : @(location.latitude),
                                                   ADDRESS_LON : @(location.longitude)
                                                   };
                    [weakself.addressArray addObject:dic];
                    weakself.confirmView.addressArray = weakself.addressArray;

                   break;
                }
                
        }
        
        }];
        [weakself.view addSubview:_searchView];
    }
    return _searchView;
}

/** 确认订单的View */
- (YDConfirmOrderView *)confirmView{
    if (!_confirmView) {
        _confirmView = [[YDConfirmOrderView alloc] init];
        _confirmView.frame = CGRectMake(LEFT_MARGIN,kScreenSize.height + CONFIRMVIEW_HEIGHT + BOTTOM_MARGIN , kScreenSize.width - 2 * LEFT_MARGIN, CONFIRMVIEW_HEIGHT);
        kWeakSelf(self)
        [_confirmView setCallCar:^{
            [weakself callACar];
        }];
        [_confirmView setAddMiddlePlace:^{
            weakself.chosePlaceType = YDChoseMiddlePlace;
            [weakself showChosePlace];
        }];
        
        [_confirmView setChoseTimeAction:^{
            weakself.datePicker.hidden = NO;
            [weakself.datePicker show];
        }];
        [self.view addSubview:_confirmView];
    }
    return _confirmView;
}

// 时间选择器
- (YDDatePickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [[YDDatePickerView alloc] init];
        _datePicker.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        _datePicker.hidden = YES;
        kWeakSelf(self);
        [_datePicker setChoseTimeSucess:^(NSString *date, NSString *hour, NSString *minute) {
            weakself.confirmView.departureTime.text = [NSString stringWithFormat:@"%@ %@ : %@", date, hour, minute];
        }];
        [self.view addSubview:_datePicker];
    }
    return _datePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
