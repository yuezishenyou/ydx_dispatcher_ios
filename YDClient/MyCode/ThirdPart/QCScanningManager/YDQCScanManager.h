//
//  YDQCScanManager.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/17.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YDQCCode (YDQCScanManager *)[YDQCScanManager sharedInstance]

@class YDQCScanManager;

@protocol YDQCScanManagerDelegate <NSObject>

@required
/** 二维码扫描获取数据的回调方法 (metadataObjects: 扫描二维码数据信息) */
- (void)QRCodeScanManager:(YDQCScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects;

@end

@interface YDQCScanManager : NSObject

GPL_H_SINGLETON(YDQCScanManager);

/**  SGQRCodeScanManagerDelegate */
@property (nonatomic, weak) id<YDQCScanManagerDelegate> delegate;

/**
 *  创建扫描二维码会话对象以及会话采集数据类型和扫码支持的编码格式的设置
 *
 *  @param sessionPreset    会话采集数据类型
 *  @param metadataObjectTypes    扫码支持的编码格式
 *  @param currentController      SGQRCodeScanManager 所在控制器
 */
- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController;
/** 开启会话对象扫描 */
- (void)startRunning;
/** 停止会话对象扫描 */
- (void)stopRunning;

/** 移除 videoPreviewLayer 对象 */
- (void)videoPreviewLayerRemoveFromSuperlayer;
/** 添加 videoPreviewLayer 对象 */
- (void)videoPreviewLayerAddToSuperlayer;

@end
