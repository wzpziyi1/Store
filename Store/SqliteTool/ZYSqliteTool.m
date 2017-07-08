//
//  ZYSqliteTool.m
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "ZYSqliteTool.h"
#import <sqlite3.h>

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@implementation ZYSqliteTool

sqlite3 *_ppDB = nil;

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid
{
    if (![self openDB:uid])
    {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    BOOL result = sqlite3_exec(_ppDB, [sql UTF8String], nil, nil, nil) == SQLITE_OK;
    
    [self closeDB];
    return result;
}


+ (NSMutableArray <NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid
{
    [self openDB:uid];
    
    //产生预编译语句（准备语句）
    sqlite3_stmt *stmt = nil;
    
    // 参数1: 一个已经打开的数据库
    // 参数2: 需要中的sql
    // 参数3: 参数2取出多少字节的长度 -1 自动计算 \0
    // 参数4: 准备语句
    // 参数5: 通过参数3, 取出参数2的长度字节之后, 剩下的字符串
    if (sqlite3_prepare_v2(_ppDB, sql.UTF8String, -1, &stmt, nil) != SQLITE_OK)
    {
        NSLog(@"产生准备语句失败");
        return nil;
    }
    
    NSMutableArray *allRowArr = [NSMutableArray array];
    
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        //一行有多少列
        int column = sqlite3_column_count(stmt);
        NSMutableDictionary *colDict = [NSMutableDictionary dictionary];
        [allRowArr addObject:colDict];
        
        for (int i = 0; i < column; i++)
        {
            //获取这一列的name
            const char *colNameC = sqlite3_column_name(stmt, i);
            NSString *colName = [NSString stringWithUTF8String:colNameC];
            
            //获取这一列的类型
            int type = sqlite3_column_type(stmt, i);
            
            //根据类型，获取这一列对应的value
            id value = nil;
            switch (type)
            {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(stmt, i));
                    break;
                    
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(stmt, i));
                    break;
                    
                case SQLITE_TEXT:
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(stmt, i)];
                    break;
                    
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(stmt, i));
                    break;
                    
                case SQLITE_NULL:
                    value = @"";
                    break;
                    
                default:
                    break;
            }
            colDict[colName] = value;
        }
    }
    //释放资源
    sqlite3_finalize(stmt);
    [self closeDB];
    
    return allRowArr;
}

#pragma makr - private


/**
 根据一个uid打开一个数据库
 */
+ (BOOL)openDB:(NSString *)uid
{
    NSString *dbName = @"common.sqlite";
    
    if (uid != nil && uid.length != 0)
    {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    return sqlite3_open([dbPath UTF8String], &_ppDB) == SQLITE_OK;
    
}


/**
 关闭数据库
 */
+ (void)closeDB
{
    sqlite3_close(_ppDB);
}

@end
