//
//  Common.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#ifndef Common_h
#define Common_h


#endif /* Common_h */

/** 华尔道夫酒店经纬度 */
#define HOTEL_LATITUDE 31.233632
#define HOTEL_LONGITUDE 121.489733

#define CONFIRMVIEW_HEIGHT ([[YDDeviceInfo iphoneType] isEqualToString:@"iPhone X"] ? (314 + 34) : (314))
#define BOTTOM_MARGIN (10)

/** 订单信息 */
// 表名
#define ORDER_TABLE @"orders"
// 订单ID
#define ORDER_ID @"orderId"
// 服务人员ID
#define SERVICE_ID @"serviceID"
#define UP_PLACE @"upPlace"
#define DOWN_PLACE @"downPlace"
#define UP_LAT @"upLat"
#define UP_LON @"upLon"
#define DOWN_LAT @"downLat"
#define DOWN_LON @"downLong"
#define PASSANGER_NAME @"passangerName"
#define PASSANGER_PHONE @"passangerPhone"
#define PREVIEW_TIME @"previewTime"
#define PRICE @"price"
#define DRIVER_NAME @"driverName"

/** 常用地址信息 */
// 表名
#define ADDRESS_TABLE @"customAddress"
#define ADDRESS_NAME @"name"
#define ADDRESS_INFO @"address"
#define ADDRESS_LAT @"lat"
#define ADDRESS_LON @"lon"
#define CHOSE_TIMES @"choseTimes"

/** 默认颜色 */
#define kRGBNomal  [UIColor colorWithRed:204/255.0f green:149/255.0f blue:91/255.0f alpha:1.0]

#define MAIN_COLOR @"c3955b"

/** 左边界 */
#define LEFT_MARGIN (8)

/**
 * 弱引用
 */
#define kWeakSelf(type) __weak typeof(type) weak##type = type;

/**
 * 强引用
 */
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

/** 高德地图APP_KEY */
#define MAP_APIKEY @"ffcd139fe0ce1c044ade29e646c4f296";

/**
 * 屏幕尺寸size
 */
#define kScreenSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale, [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

// 状态栏高度
#define kStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏高度
#define kNaviHeight self.navigationController.navigationBar.frame.size.height

// 导航栏和状态栏高度和
#define kNavAndStatusHeight (kStatusHeight + kNaviHeight)


// 6S宽高比例
#define WIDTH_6S_SCALE 375.0 * [UIScreen mainScreen].bounds.size.width
#define HEIGHT_6S_SCALE 667.0 * [UIScreen mainScreen].bounds.size.height

/**
 * NSUserDefault 存 object
 */
#define kYD_USERDEFAULTS_SET_OBJ(obj,key) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]


/**
 * NSUserDefault 获取 object
 */
#define kYD_USERDEFAULTS_READ_OBJ(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

/**
 * NSUserDefault 立即写入数据
 */
#define kYD_USERDEFAULTS_SYN [[NSUserDefaults standardUserDefaults] synchronize]

#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"\n\t[文件名:%s]\n""\t[函数名:%s]\n""\t[行号:%d] \n""\t[打印:" fmt "]\n\n"), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#undef	GPL_H_SINGLETON
#define GPL_H_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	GPL_M_SINGLETON
#define GPL_M_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}
