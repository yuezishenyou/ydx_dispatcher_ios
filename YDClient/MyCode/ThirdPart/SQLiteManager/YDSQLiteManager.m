//
//  YDSQLiteManager.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/23.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDSQLiteManager.h"

@interface YDSQLiteManager ()
@end

@implementation YDSQLiteManager
{
    sqlite3 *_database;
}


- (instancetype)init{
    return self;
}

/** 获取dicument目录并返回数据库目录 */
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documensDirectory = [paths firstObject];
    //    NSLog(@"===========path===========%@", documensDirectory);
    
    return [documensDirectory stringByAppendingPathComponent:@"data.db"];
}

/** 创建, 打开数据库 */
- (BOOL)openDB {
    // 获取数据库路径
    NSString *path = [self dataFilePath];
    if (sqlite3_open([path UTF8String], &_database) != SQLITE_OK) {
        // 如果打开数据库失败则关闭数据库
        sqlite3_close(_database);
        return NO;
    }
    return YES;
}

/** 创建表 */
- (BOOL)createTableListWithDictionary:(NSArray *)keys tableName:(NSString *)tableName{
    if (![self openDB]) {
        return NO;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, ", tableName];
    for (int i = 0; i < keys.count; i++) {
        if ([keys[i] isEqualToString:CHOSE_TIMES]) {
            [sql appendString:[NSString stringWithFormat:@"%@ integer)", keys[i]]];
            break;
        }
        if (i == keys.count - 1) {
            [sql appendString:[NSString stringWithFormat:@"%@ text)", keys[i]]];
            break;
        }
       
        [sql appendString:[NSString stringWithFormat:@"%@ text, ", keys[i]]];
        
    }
    char *errorMesg = NULL;
    
    int result = sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &errorMesg);
    sqlite3_close(_database);
    if (result == SQLITE_OK) {
        return YES;
    } else {
        return NO;
    }
}

/** 插入数据 */
- (BOOL)insertDictionary:(NSDictionary *)dic tableName:(NSString *)tableName{
    if ([self openDB]) {
        NSString *sqlite;
        if ([tableName isEqualToString:ADDRESS_TABLE]) {
            
            sqlite = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@)values('%@','%@','%@','%@',%d)", tableName, ADDRESS_NAME, ADDRESS_INFO, ADDRESS_LAT, ADDRESS_LON,CHOSE_TIMES, dic[ADDRESS_NAME], dic[ADDRESS_INFO], dic[ADDRESS_LAT], dic[ADDRESS_LON], [dic[CHOSE_TIMES] intValue]];
            
        }else{
            sqlite = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", tableName, ORDER_ID, SERVICE_ID, UP_PLACE, UP_LAT,UP_LON, DOWN_PLACE, DOWN_LAT, DOWN_LON, PASSANGER_NAME, PASSANGER_PHONE, PREVIEW_TIME, PRICE, DRIVER_NAME, dic[ORDER_ID],dic[SERVICE_ID],dic[UP_PLACE],dic[UP_LAT],dic[UP_LON],dic[DOWN_PLACE],dic[DOWN_LAT],dic[DOWN_LON],dic[PASSANGER_NAME],dic[PASSANGER_PHONE],dic[PREVIEW_TIME],dic[PRICE],dic[DRIVER_NAME]];
        }
        //        DLog(@"================%@", sqlite);
        //2.执行sqlite语句
        char *error = NULL;
        int result = sqlite3_exec(_database, [sqlite UTF8String], nil, nil, &error);
        sqlite3_close(_database);
        if (result == SQLITE_OK) {
            //            DLog(@"===================success");
            return YES;
        } else {
            //            DLog(@"===================error : %s",error);
            return NO;
        }
    }else{
        return NO;
    }
}

/** 获取表中所有数据 */
- (NSMutableArray *)getDataWithTableName:(NSString *)tableName{
    if ([self openDB]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        //1.准备sqlite语句
        NSString *sqlite = @"";
        if ([tableName isEqualToString:ORDER_TABLE]) {
            sqlite = [NSString stringWithFormat:@"select * from %@", tableName];
        }else {
            sqlite = [NSString stringWithFormat:@"select * from %@ order by %@ desc limit 5", tableName, CHOSE_TIMES];
        }
        
        DLog(@"==============%@", sqlite);
        //2.伴随指针
        sqlite3_stmt *stmt = NULL;
        //3.预执行sqlite语句
        int result = sqlite3_prepare(_database, [sqlite UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            NSLog(@"查询成功");
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                if ([tableName isEqualToString:ADDRESS_TABLE]) {
                    NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                    NSString *info = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                    NSString *lat = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                    NSString *lon = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                    NSString *times = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                    NSDictionary *dic = @{ADDRESS_NAME : name,
                                          ADDRESS_INFO : info,
                                          ADDRESS_LAT : lat,
                                          ADDRESS_LON : lon,
                                          CHOSE_TIMES : times};
                    [array addObject:dic];
                }else{
                    
                    NSString *orderId = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                    NSString *serviceId = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                    NSString *upPlace = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                    NSString *upLat = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                    NSString *upLon = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                    NSString *downPlace = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                    NSString *downLat = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
                    NSString *downLon = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
                    NSString *passangeName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
                    NSString *passangePhone = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
                    NSString *previewTime = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
                    NSString *price = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 12)];
                    NSString *driverName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 13)];
                    
                    NSDictionary *dic = @{
                                          ORDER_ID : orderId,
                                          SERVICE_ID : serviceId,
                                          UP_PLACE : upPlace,
                                          UP_LAT : upLat,
                                          UP_LON : upLon,
                                          DOWN_PLACE : downPlace,
                                          DOWN_LAT : downLat,
                                          DOWN_LON : downLon,
                                          PASSANGER_NAME : passangeName,
                                          PASSANGER_PHONE : passangePhone,
                                          PREVIEW_TIME : previewTime,
                                          PRICE : price,
                                          DRIVER_NAME : driverName};
                    [array addObject:dic];
                }
            }
        } else {
            NSLog(@"查询失败");
            return nil;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_database);
        
        return array;
        
    }
    return nil;
}

/** 根据经纬查询表中数据 */
- (NSMutableArray *)getDataWithLat:(NSString *)lat long:(NSString *)lon tableName:(NSString *)tableName{
    if ([self openDB]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSString *sqlite = [NSString stringWithFormat:@"select * from %@ where %@ = %@ and %@ = %@", tableName, ADDRESS_LAT, lat, ADDRESS_LON, lon];
        
        sqlite3_stmt *stmt = NULL;
        
        int result = sqlite3_prepare(_database, [sqlite UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            NSLog(@"查询成功");
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString *info = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                NSString *lat = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString *lon = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                NSString *times = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                NSDictionary *dic = @{ADDRESS_NAME : name,
                                      ADDRESS_INFO : info,
                                      ADDRESS_LAT : lat,
                                      ADDRESS_LON : lon,
                                      CHOSE_TIMES : times};
                [array addObject:dic];
                
            }
        } else {
            NSLog(@"查询失败");
            return nil;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_database);
        return array;
        
    }
    return nil;
    
}

/** 更新常用地址表格 */
- (BOOL)updateAddressTableWithlat:(NSString *)lat lon:(NSString *)lon times:(NSString *)times{

    if ([self openDB]) {
        NSString *updateString = [NSString stringWithFormat:@"update %@ set %@ = %d where %@ = '%@' and %@ = '%@'", ADDRESS_TABLE, CHOSE_TIMES, [times intValue], ADDRESS_LAT, lat, ADDRESS_LON, lon];
        sqlite3_stmt *stmt = NULL;
        int updateResult = sqlite3_prepare_v2(_database, [updateString UTF8String], -1, &stmt, nil);
        
        if (updateResult != SQLITE_OK) {
            sqlite3_close(_database);
            sqlite3_step(stmt);
            return NO;
        }else{
            sqlite3_step(stmt);
            sqlite3_close(_database);
            return YES;
        }
    }else{
        return NO;
    }
}

@end
