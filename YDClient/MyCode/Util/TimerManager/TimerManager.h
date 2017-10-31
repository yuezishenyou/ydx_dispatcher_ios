//
//  TimerManager.h
//  Bulletin
//
//  Created by maoziyue on 2017/9/14.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TimerItem : NSObject

@property (nonatomic,copy) void(^timercb)();
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger timerSpace;
@property (nonatomic,assign) BOOL isValid;

@end


//*************** *******************/
@interface TimerManager : NSObject

+ (instancetype)manager;

- (void)addTimerWithName:(NSString *)name timerSpace:(NSInteger)timerSpace timercb:(void(^)())timercb;

- (void)deleteTimerWithName:(NSString *)name;

- (void)stopTimerWithName:(NSString *)name;

- (void)validTimerWithName:(NSString *)name;

- (void)modifyTimerWithName:(NSString *)name toTimerSpace:(NSInteger)timerSpace;

- (BOOL)isTimerValid:(NSString *)name;

- (void)stopAllTimers;

- (void)validTimers;









@end













