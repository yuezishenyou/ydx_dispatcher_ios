//
//  YDPopAnnotationView.h
//  YDClient
//
//  Created by yuedao on 2017/10/24.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "YDCustomMapPopView.h"

@interface YDPopAnnotationView : MAPinAnnotationView

@property (nonatomic, strong) YDCustomMapPopView *popView;

@property (nonatomic, assign) CLLocationCoordinate2D location;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
