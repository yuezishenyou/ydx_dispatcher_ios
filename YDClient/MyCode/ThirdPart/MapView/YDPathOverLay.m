//
//  YDPathOverLay.m
//  YDClient
//
//  Created by yuedao on 2017/9/20.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDPathOverLay.h"

@implementation YDPathOverLay

#pragma mark - MAOverlay Protocol

- (CLLocationCoordinate2D)coordinate
{
    return [self.overlay coordinate];
}

- (MAMapRect)boundingMapRect
{
    return [self.overlay boundingMapRect];
}

#pragma mark - Life Cycle

- (id)initWithOverlay:(id<MAOverlay>)overlay
{
    self = [super init];
    if (self)
    {
        self.overlay       = overlay;
        
    }
    
    return self;
}

@end
