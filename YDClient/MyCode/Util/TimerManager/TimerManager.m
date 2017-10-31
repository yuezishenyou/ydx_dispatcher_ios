//
//  TimerManager.m
//  Bulletin
//
//  Created by maoziyue on 2017/9/14.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "TimerManager.h"


@implementation TimerItem

@end


@implementation TimerManager
{
    NSMutableArray *_timerArray;
    NSTimer *_timer;
    NSInteger count;
}
+ (instancetype)manager
{
    static TimerManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager == nil) {
            _manager = [[TimerManager alloc]init];
        }
    });
    return _manager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        count = 0;
        _timerArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)timerAction
{
    count ++;
    for (TimerItem *item in _timerArray)
    {
        if (item.isValid && count % item.timerSpace == 0)
        {
            item.timercb();
        }
    }
}







// -----------------------------------------------
// MARK - methods
// -----------------------------------------------

- (void)addTimerWithName:(NSString *)name timerSpace:(NSInteger)timerSpace timercb:(void(^)())timercb
{
    for (TimerItem *item in _timerArray)
    {
        if ([item.name isEqualToString:name]) {
            return;
        }
    }
    
    TimerItem *item = [[TimerItem alloc]init];
    item.name = name;
    item.timerSpace = timerSpace;
    item.timercb = timercb;
    item.isValid = YES;
    [_timerArray addObject:item];
    
}



- (void)deleteTimerWithName:(NSString *)name
{
    for (NSInteger i = _timerArray.count - 1; i >= 0; i--)
    {
        TimerItem *item = _timerArray[i];
        if ([item.name isEqualToString:name])
        {
            [_timerArray removeObject:item];
        }
    }
}

- (void)stopTimerWithName:(NSString *)name
{
    for (TimerItem *item in _timerArray)
    {
        if ([item.name isEqualToString:name])
        {
            item.isValid = NO;
        }
    }
}

- (void)validTimerWithName:(NSString *)name
{
    for (TimerItem *item in _timerArray)
    {
        if ([item.name isEqualToString:name])
        {
            item.isValid = YES;
        }
    }
}

- (void)modifyTimerWithName:(NSString *)name toTimerSpace:(NSInteger)timerSpace
{
    for (TimerItem *item in _timerArray)
    {
        if ([item.name isEqualToString:name])
        {
            item.timerSpace = timerSpace;
        }
    }
}

- (BOOL)isTimerValid:(NSString *)name
{
    for (TimerItem *item in _timerArray)
    {
        if ([item.name isEqualToString:name])
        {
            return item.isValid;
        }
    }
    return NO;
}

- (void)stopAllTimers
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)validTimers
{
    [_timer setFireDate:[NSDate distantPast]];
}



@end
