//
//  YDSilderView.m
//  YDClient
//
//  Created by yuedao on 2017/10/24.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDSilderView.h"

#define SILDER_VIEW_MARGIN 3
#define SILDER_WIDTH (110 / WIDTH_6S_SCALE)

@interface YDSilderView ()

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) UILabel *realtimeButton;

@property (nonatomic, strong) UILabel *reservedButton;

// 判断是实时还是预约 YES -- 实时 NO -- 预约
@property (nonatomic, assign) BOOL callModel;

@end

@implementation YDSilderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
        self.callModel = YES;
    }
    return self;
}

- (void)setSubViews {
    
    self.backgroundColor = getColor(MAIN_COLOR);
    
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(SILDER_VIEW_MARGIN, SILDER_VIEW_MARGIN, self.width / 2 - 2 * SILDER_VIEW_MARGIN, self.height - 2 * SILDER_VIEW_MARGIN)];
    self.sliderView.layer.cornerRadius = 5;
    self.sliderView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.sliderView];
    
    CGRect buttonFrame = CGRectMake(0, 0, self.width / 2, self.height);
    self.realtimeButton = [self setButtonWithFrame:buttonFrame fontSize:12 needAction:YES];
    self.realtimeButton.text = @"实时";
    self.realtimeButton.textColor = getColor(MAIN_COLOR);
    [self addSubview:self.realtimeButton];
    
    self.reservedButton = [self setButtonWithFrame:CGRectMake(self.width / 2, 0, self.width / 2, self.height) fontSize:12 needAction:YES];
    self.reservedButton.textColor =getColor(@"ffffff");
    self.reservedButton.text = @"预约";
    [self addSubview:self.reservedButton];

    
}

- (UILabel *)setButtonWithFrame:(CGRect)rect fontSize:(float)size needAction:(BOOL)action{
    UILabel *button = [[UILabel alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    button.font = [UIFont systemFontOfSize:size];
    button.textAlignment = NSTextAlignmentCenter;
    
    if (action) {
        button.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(silderAction:)];
        [button addGestureRecognizer:tap];
    }
    
    return button;
}

/** 滑块滑动的事件 */
- (void)silderAction:(UITapGestureRecognizer *)tap{
    UILabel *label= (UILabel *)tap.view;
   
    if (label == self.reservedButton) {
        if (self.callModel == NO) {
            return;
        }
        self.callModel = NO;
        if (self.changeCallModel) {
            self.changeCallModel(NO);
        }

        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction commit];
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderView.frame = CGRectMake(SILDER_WIDTH / 2 + SILDER_VIEW_MARGIN, SILDER_VIEW_MARGIN, self.sliderView.width, self.sliderView.height);
            label.textColor = getColor(MAIN_COLOR);
            self.realtimeButton.textColor = getColor(@"ffffff");
        } completion:nil];
    }else if(label == self.realtimeButton) {
        if (self.callModel == YES) {
            return;
        }
        self.callModel = YES;
        if (self.changeCallModel) {
            self.changeCallModel(YES);
        }

        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction commit];
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderView.frame = CGRectMake(SILDER_VIEW_MARGIN , SILDER_VIEW_MARGIN, self.sliderView.width, self.sliderView.height);
            label.textColor = getColor(MAIN_COLOR);
            self.reservedButton.textColor = getColor(@"ffffff");
        } completion:nil];
    }
}

- (void)setInstallView{
    self.sliderView.frame = CGRectMake(SILDER_VIEW_MARGIN , SILDER_VIEW_MARGIN, self.sliderView.width, self.sliderView.height);
    self.realtimeButton.textColor = getColor(MAIN_COLOR);
    self.reservedButton.textColor = getColor(@"ffffff");
    self.callModel = YES;
}

@end

