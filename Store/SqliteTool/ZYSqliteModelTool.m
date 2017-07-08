//
//  ZYSqliteModelTool.m
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "ZYSqliteModelTool.h"
#import "ZYModelTool.h"
#import "ZYSqliteTool.h"
#import "ZYTableTool.h"

@implementation ZYSqliteModelTool

//如何获取model的成员list，可以根据runtime获取
//例如主键、一些不需要数据库存储的字段，可以用协议来说明不需要存储该字段
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid
{
    NSString *tableName = [ZYModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey方法, 告知主键信息");
        return NO;
    }
    
    NSString *primaryKey = [cls primaryKey];
    
    // 获取一个模型里面所有的字段, 以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [ZYModelTool sqliteStringForColumnNamesAndTypes:cls], primaryKey];
    
    return [ZYSqliteTool deal:createTableSql uid:uid];
}

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid
{
    NSArray *modelNames = [ZYModelTool allTableSortedIvarNames:cls];
    NSArray *tableNames = [ZYTableTool tableSortedColumnNames:cls uid:uid];
    
    return ![modelNames isEqualToArray:tableNames];
}

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid
{
    NSString *tableName = [ZYModelTool tableName:cls];
    NSString *tmpTableName = [ZYModelTool tmpTableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey方法, 告知主键信息");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    NSMutableArray *sqlArr = [NSMutableArray array];
    
    //创建临时表的字段名
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tmpTableName, [ZYModelTool sqliteStringForColumnNamesAndTypes:cls], primaryKey];
    [sqlArr addObject:createTableSql];
    
    //根据主键插入数据
    // insert into ZYStudentEntity_tmp(stuNum) select stuNum from ZYStudentEntity;
    NSString *insertPrimaryKeySql = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [sqlArr addObject:insertPrimaryKeySql];
    
    //根据已经有的主键，把其他字段的值更新到临时表里面
    NSArray *oldNames = [ZYTableTool tableSortedColumnNames:cls uid:uid];
    NSArray *newNames = [ZYModelTool allTableSortedIvarNames:cls];
    
    for (NSString *columnName in newNames)
    {
        if (![oldNames containsObject:columnName])
        {
            continue;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tmpTableName, columnName, columnName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [sqlArr addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [sqlArr addObject:deleteOldTable];
    
    //重命名临时表
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [sqlArr addObject:renameTableName];
    
    return [ZYSqliteTool dealSqls:sqlArr uid:uid];
}

@end
