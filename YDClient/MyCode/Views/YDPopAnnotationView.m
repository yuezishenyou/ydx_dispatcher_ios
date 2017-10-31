//
//  YDPopAnnotationView.m
//  YDClient
//
//  Created by yuedao on 2017/10/24.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDPopAnnotationView.h"
#import "Global.h"

#define kCalloutWidth       (200 / 1.1)
#define kCalloutHeight      (200 / 1.1)


@implementation YDPopAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    DLog(@"%d ------------ %d ======%d", self.selected, selected, animated);
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.popView == nil)
        {
            self.popView = [[YDCustomMapPopView alloc] init];
        }
    
        self.popView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
        [GLOABL setPopView:self];
        self.popView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                          -CGRectGetHeight(self.popView.bounds)  * 1.1 / 2.f + self.calloutOffset.y);
        [self addSubview:self.popView];
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.5 options:0 animations:^{
            self.popView.frame = CGRectMake(self.popView.x - self.popView.width * 0.1 / 2, self.popView.y - self.popView.height * 0.1 / 2, self.popView.width * 1.1, self.popView.height * 1.1);

        } completion: nil];

    }
    else
    {
        [self.popView removeFromSuperview];
        [GLOABL setPopView:nil];
    }
    
    [super setSelected:selected animated:animated];
    
}

@end
