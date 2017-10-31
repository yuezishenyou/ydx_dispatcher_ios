//
//  HHServicePickerView.m
//  shiwo
//
//  Created by maoziyue on 2017/10/30.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "HHServicePickerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define KNavH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication]statusBarFrame].size.height)

#define kH  (216 + 44)

@interface HHServicePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;// 所有数据

@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;

@property (strong, nonatomic) NSString *initialService;// 初始化显示
@property (strong, nonatomic) NSString *selectedService;// 选中

@end

@implementation HHServicePickerView

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithInitialService:(NSString *)initialService
{
    if ([super init])
    {
        self.initialService = initialService;
        self.selectedService = initialService;
        [self setup];
    }
    
    return self;
}


- (void)setup
{

    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.618];
    
    [self initialize];
    [self drawView];
    
    self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kH);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomView.frame = CGRectMake(0, kScreenHeight - kH , kScreenWidth, kH);
        [self.bottomView layoutIfNeeded];
    }];
}



#pragma mark - initialize

- (void)initialize
{
    
    self.dataSource = [[NSMutableArray alloc]init];
}


#pragma mark - drawView

- (void)drawView
{
    
    [self addSubview:self.bottomView];
}


#pragma mark - action

- (void)cancelButtonAction:(UIButton *)button {
    
    self.bottomView.frame = CGRectMake(0, kScreenHeight - kH, kScreenWidth, kH);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kH);
        [self.bottomView layoutIfNeeded];
        
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)confirmButtonAction:(UIButton *)button
{
    
    self.confirmBlock(self.selectedService);
    
    self.bottomView.frame = CGRectMake(0, kScreenHeight - kH, kScreenWidth, kH);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kH);
        [self.bottomView layoutIfNeeded];
        
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


#pragma mark - pickerView 代理方法

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.dataSource.count;
}

// 显示什么
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.dataSource[row];
}

// 选中时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedService = self.dataSource[row];
}


#pragma mark - 懒加载

- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:self.cancelButton];
        [_bottomView addSubview:self.confirmButton];
        [_bottomView addSubview:self.pickerView];
    }
    
    return _bottomView;
}

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 12, 44, 20)];
        _cancelButton.backgroundColor = [UIColor clearColor];
        
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitleColor:[UIColor colorWithRed:195 / 255.0 green:195 / 255.0 blue:195 / 255.0 alpha:1] forState:(UIControlStateNormal)];
        
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _cancelButton;
}

- (UIButton *)confirmButton {
    
    if (!_confirmButton) {
        
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 44 - 20, 12, 44, 20)];
        _confirmButton.backgroundColor = [UIColor clearColor];
        
        [_confirmButton setTitle:@"完成" forState:(UIControlStateNormal)];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmButton setTitleColor:[UIColor colorWithRed:195 / 255.0 green:195 / 255.0 blue:195 / 255.0 alpha:1] forState:(UIControlStateNormal)];
        
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _confirmButton;
}

- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 216)];
        _pickerView.backgroundColor = [UIColor clearColor];
        
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        [self.dataSource addObject:@"华尔道夫酒店"];
        [self.dataSource addObject:@"安达仕酒店"];
        [self.dataSource addObject:@"虹桥机场T1"];
        [self.dataSource addObject:@"虹桥机场T2"];
        [self.dataSource addObject:@"浦东机场T1"];
        [self.dataSource addObject:@"浦东机场T2"];
        [self.dataSource addObject:@"华尔道夫酒店"];
        [self.dataSource addObject:@"安达仕酒店"];
        [self.dataSource addObject:@"虹桥机场T1"];
        [self.dataSource addObject:@"虹桥机场T2"];
        [self.dataSource addObject:@"浦东机场T1"];
        [self.dataSource addObject:@"浦东机场T2"];
        [self.dataSource addObject:@"华尔道夫酒店"];
        [self.dataSource addObject:@"安达仕酒店"];
        [self.dataSource addObject:@"虹桥机场T1"];
        [self.dataSource addObject:@"虹桥机场T2"];
        [self.dataSource addObject:@"浦东机场T1"];
        [self.dataSource addObject:@"浦东机场T2"];
        
        // 换东西 华尔道夫酒店  安达仕酒店  虹桥机场T1  虹桥机场T2 浦东机场T1 浦东机场T2
        
        // _pickerView 初始化显示的身高值
        if (self.initialService.length == 0) {// 默认显示 177cm
            
            [_pickerView selectRow:0 inComponent:0 animated:YES];
            self.selectedService = self.dataSource[0];
        }else {// 否则获取要显示的身高值下标, 显示相应身高值
            
            [_pickerView selectRow:[self.dataSource indexOfObject:self.initialService] inComponent:0 animated:YES];
        }
    }
    
    return _pickerView;
}



@end
