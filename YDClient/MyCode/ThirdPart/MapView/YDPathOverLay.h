//
//  YDPathOverLay.h
//  YDClient
//
//  Created by yuedao on 2017/9/20.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface YDPathOverLay : NSObject<MAOverlay>

@property (nonatomic, strong) id<MAOverlay> overlay;

- (id)initWithOverlay:(id<MAOverlay>) overlay;

@end
