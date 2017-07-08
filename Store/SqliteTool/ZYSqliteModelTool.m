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
@end
