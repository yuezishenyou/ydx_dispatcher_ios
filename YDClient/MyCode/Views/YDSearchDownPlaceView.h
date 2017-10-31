//
//  YDSearchDownPlaceView.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/22.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface YDSearchDownPlaceView : UIView

/** 搜索框 */
@property (nonatomic, strong) UITextField *searchText;
/** 显示订单列表 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 取消按钮的回调方法 */
@property (nonatomic, copy) void (^cancelButtonAciton)(void);

/** 选择地址成功, 返回名称, lat, lon */
@property (nonatomic, copy) void (^choseAddressSucess)(NSString *,CLLocationCoordinate2D);

/** 显示 */
- (void)showWithCompeleteBlock:(void (^)(void))block;
/** 隐藏 */
- (void)hiddenWithCompeleteBlock:(void (^)(void))block;

@end
