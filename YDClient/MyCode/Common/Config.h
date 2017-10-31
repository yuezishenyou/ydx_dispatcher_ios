//
//  Config.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 * 文字颜色
 * 可以在此处保存颜色主色调，方便以后修改
 */

extern NSString * textColor;

@interface Config : NSObject

/**
 * 将16为颜色值转换为 UIColor
 */
UIColor* getColor(NSString * hexColor);

@end
