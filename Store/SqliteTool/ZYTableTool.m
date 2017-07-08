//
//  ZYTableTool.m
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "ZYTableTool.h"
#import "ZYModelTool.h"
#import "ZYSqliteTool.h"

@implementation ZYTableTool
+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid
{
    NSString *tableName = [ZYModelTool tableName:cls];
    /*
     SQLite数据库中一个特殊的名叫 SQLITE_MASTER 上执行一个SELECT查询以获得所有表的索引。每一个 SQLite 数据库都有一个叫 SQLITE_MASTER 的表， 它定义数据库的模式。 SQLITE_MASTER 表看起来如下：
     CREATE TABLE sqlite_master (
     type TEXT,
     name TEXT,
     tbl_name TEXT,
     rootpage INTEGER,
     sql TEXT
     );
     
     其中的sql字段有本数据库的字段信息
     */
    
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    
    NSMutableDictionary *dic = [ZYSqliteTool querySql:queryCreateSqlStr uid:uid].firstObject;
    
    NSString *createTableSql = [dic[@"sql"] lowercaseString];
    if (createTableSql.length == 0) {
        return nil;
    }
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *nameType in nameTypeArray) {
        
        if ([nameType containsString:@"primary"]) {
            continue;
        }
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        
        [names addObject:name];

    }
    
    [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return names;
}
@end
