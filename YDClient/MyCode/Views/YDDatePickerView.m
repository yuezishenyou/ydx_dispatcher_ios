//
//  YDDatePickerView.m
//  YDClient
//
//  Created by yuedao on 2017/10/26.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDDatePickerView.h"

@interface YDDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, strong) NSArray *hourArray;

@property (nonatomic, strong) NSArray *minuteArray;

@property (nonatomic, strong) NSDateComponents *components;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *hour;

@property (nonatomic, copy) NSString *minute;

@end

@implementation YDDatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YDDatePickerView" owner:nil options:nil] lastObject];
        [self setDatePicker];
    }
    return self;
}

- (void)setDatePicker{
    NSMutableArray *dayArray = [[NSMutableArray alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSinceNow:1800]];
    
    if (self.components.hour == 0 && self.components.minute < 30) {
        [dayArray addObject:[NSString stringWithFormat:@"%ld月%ld日 %@", self.components.month, self.components.day, [self week:self.components.weekday]]];

    }else{
        [dayArray addObject:[NSString stringWithFormat:@"%ld月%ld日 今天", self.components.month, self.components.day]];

    }
    
    self.components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSinceNow:1800 + 24 * 60 * 60]];
    [dayArray addObject:[NSString stringWithFormat:@"%ld月%ld日 %@", self.components.month, self.components.day, [self week:self.components.weekday]]];
    self.components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSinceNow:1800 + 24 * 60 * 60  * 2]];

    [dayArray addObject:[NSString stringWithFormat:@"%ld月%ld日 %@", self.components.month, self.components.day, [self week:self.components.weekday]]];

    self.dayArray = dayArray;
    [self setHoursWithRow:0];
    [self setMinutesWithRow:0 hour:self.components.hour];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.date = self.dayArray.firstObject;
    self.hour = self.hourArray.firstObject;
    self.minute = self.minuteArray.firstObject;
    [self.pickerView reloadAllComponents];
}

// 判断是星期几
- (NSString *)week:(NSInteger)week{
    NSString *str = @"星期";
    switch (week) {
        case 1:
            return [NSString stringWithFormat:@"%@日", str];
        case 2:
            return [NSString stringWithFormat:@"%@一", str];
        case 3:
            return [NSString stringWithFormat:@"%@二", str];
        case 4:
            return [NSString stringWithFormat:@"%@三", str];
        case 5:
            return [NSString stringWithFormat:@"%@四", str];
        case 6:
            return [NSString stringWithFormat:@"%@五", str];
        case 7:
            return [NSString stringWithFormat:@"%@六", str];
        default:
        return @"";
            
    }
}

- (void)setHoursWithRow:(NSInteger)row{
    if (row == 0) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        DLog(@"%ld", self.components.hour);
        for (NSInteger i = self.components.hour; i <= 23; i++) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
        }
        self.hourArray = arr;
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i <= 23; i++) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
        }
        self.hourArray = arr;

    }
    self.hour = self.hourArray.firstObject;
}

- (void)setMinutesWithRow:(NSInteger)row hour:(NSInteger) hour{
    if (row == 0 && hour == self.components.hour) {
        NSInteger temp = self.components.minute % 5;
        NSInteger i;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (temp != 0) {
            i = self.components.minute + (5 - temp);
            if (i >= 60) {
                i = 0;
            }
        }else {
            i = self.components.minute;
        }
        
        for (NSInteger j = i; j <= 55; j= j + 5) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", j]];
        }
        self.minuteArray = arr;
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc] init];

        for (NSInteger j = 0; j <= 55; j= j + 5) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", j]];
        }
        self.minuteArray = arr;
    }
    self.minute = self.minuteArray.firstObject;
    
}
// 列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.dayArray.count;
        case 1:
            return self.hourArray.count;
        default:
            return self.minuteArray.count;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.dayArray[row];
        case 1:
            return [NSString stringWithFormat:@"%@时", self.hourArray[row]];
        default:
            return [NSString stringWithFormat:@"%@分", self.minuteArray[row]
                ];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [self setHoursWithRow:row];
        if (row == 0) {
            [self setMinutesWithRow:0 hour:self.components.hour];
        }else{
            [self setMinutesWithRow:10 hour:0];
        }
        
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
        
        self.date = self.dayArray[row];

    } else if (component == 1){
        
        [self setMinutesWithRow:row hour:[self.hourArray[row] integerValue]];
        [self.pickerView reloadComponent:2];
        
        self.hour = self.hourArray[row];

    }else{
        self.minute = self.minuteArray[row];
    }
    
}

// 确定
- (IBAction)confirmAction:(id)sender {
    if (self.choseTimeSucess) {
        self.choseTimeSucess(self.date, self.hour, self.minute);
    }
    [self hidden];
}

// 取消
- (IBAction)cancelAction:(id)sender {
    [self hidden];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidden];
}


- (NSArray *)dataArray{
    if (!_dayArray) {
        _dayArray = [[NSArray alloc] init];
    }
    return _dayArray;
}

- (NSArray *)hourArray{
    if (!_hourArray) {
        _hourArray = [[NSArray alloc] init];
    }
    return _hourArray;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.width / 2 * 1;
            break;
        default:
            return self.width / 4;
            break;
    }
}

- (NSArray *)minuteArray{
    if (!_minuteArray) {
        _minuteArray = [[NSArray alloc] init];
    }
    return _minuteArray;
}

- (void)show{
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.topLayout.constant = 260;
        [self layoutIfNeeded];
    }];
}

- (void)hidden{
    [UIView animateWithDuration:0.3 animations:^{
        [self.topLayout setConstant:0];
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
@end
