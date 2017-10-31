//
//  Global.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "Common.h"
#import "YDSQLiteManager.h"
#import "YDImageAnnotation.h"
#import "YDPopAnnotationView.h"
#define GLOABL ((Global *)[Global sharedInstance])

@interface Global : NSObject

GPL_H_SINGLETON(Global);

@property (nonatomic, copy) NSString *hotelAddress;

/** 数据库操作 */
@property (nonatomic, strong) YDSQLiteManager *manager;

#pragma mark --------- 地图操作
/** 高德地图 */
@property (nonatomic, strong) MAMapView *mapView;
/** 导航管理类, 负责驾车路线规划 */
@property (nonatomic, strong) AMapNaviDriveManager *driverManager;

/** 地理围栏管理类 */
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;

@property (nonatomic, strong) AMapLocationManager *locationManager;

/** 逆地理编码的上车点 */
@property (nonatomic, assign) CGPoint geoPoint;

/** 逆地理编码成功的回调 */
@property (nonatomic, copy) void (^regeoSucess)(NSString *, CLLocationCoordinate2D);

/** 暂时存放酒店信息的数组 */
@property (nonatomic, strong) NSArray *hotelPoints;

/** 搜索兴趣点成功的回调 */
@property (nonatomic, copy) void (^searchPOISucess)(NSArray *);

/** 显示经纬度 */
@property (nonatomic, copy) void (^showLatAndLon)(float, float);

/** 计算距离成功的回调 */
@property (nonatomic, copy) void (^calculateRouteSucess)(NSInteger, NSString *);

@property (nonatomic, strong) AMapSearchAPI *search;
/** 当前所在城市 */
@property (nonatomic, copy) NSString *cityName;

/** 根据经纬度进行逆地理编码 */
- (void)regeoWithLat:(float)lat lon:(float)lon;

/** 搜索兴趣点 */
- (void)searchPOIWithString:(NSString *)string;

/** 计算距离和价格 */
- (void)calculateDistanceAndPriceWithStartLat:(double)lat StartLon:(double)lon EndLat:(double)endlat EndLon:(double)endlon;

- (void)calculateDistanceWithArray:(NSArray *)array;

/** 添加只有图片的大头针 */
//- (void)addImageAnnotationWithLat:(double)lat lon:(double)lon type:(YDImageAnnotationType)type;

/** 清空地图上的所有标注点 */
- (void)clearAnnotions;

- (void)configLocationManager;

// 地图上弹出的popView
@property (nonatomic, strong) YDPopAnnotationView *popView;

// 判断用户是否自己选择地址 选择了为YES
@property (nonatomic, assign) BOOL choseUpPlace;

@end
