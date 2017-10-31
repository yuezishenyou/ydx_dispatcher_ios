//
//  YDSQLiteManager.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/23.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define YDFILE_PATH @"order.db"

@interface YDSQLiteManager : NSObject

// 创建数据库
- (BOOL)createTableListWithDictionary:(NSArray *)keys tableName:(NSString *)tableName;
//
///** 插入数据 */
- (BOOL)insertDictionary:(NSDictionary *)dic tableName:(NSString *)tableName;
//
///** 更新数据 */
//- (BOOL)updataData:(NSDictionary *)updateList;
//
/** 查询表中全部数据 */
- (NSMutableArray *)getDataWithTableName:(NSString *)tableName;

/** 查询表中带有制定经纬度的位置信息 */
- (NSMutableArray *)getDataWithLat:(NSString *)lat long:(NSString *)lon tableName:(NSString *)tableName;

/** 更新指定经纬度的数据 */
- (BOOL)updateAddressTableWithlat:(NSString *)lat lon:(NSString *)lon times:(NSString *)times;

//
///** 删除数据 */
//- (BOOL)deleteDataWithDictionary:(NSDictionary *)dic;
//
///** 根据ID查询数据 */
//- (NSMutableArray *)searchDataWithKey:(NSString *)searchString;
@end
