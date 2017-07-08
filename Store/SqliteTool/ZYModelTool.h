//
//  ZYModelTool.h
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYModelTool : NSObject

/**
 以这个class的类名作为表名
 */
+ (NSString *)tableName:(Class)cls;


/**
 临时表名称
 */
+ (NSString *)tmpTableName:(Class)cls;

/**
 利用runtime把这个class的所有属性转化出来，按照 propertyName: type 键值对来组成字典
 */
+ (NSDictionary *)ocClassIvarNameTypeDict:(Class)cls;


/**
 需要返回sqlite支持的name: type 键值对，例如
 name: text
 age: integer
 data: blob
 float\double: real
 
 这里是把cls里面的属性转成oc对应的键值对字典，再转化成sqlite对应的键值对字典
 */
+ (NSDictionary *)sqliteNeedTypeDict:(Class)cls;


/**
 转化为sqlite格式的字符串

 诸如：create table if not exists t_ppp (name text, age integer, data blob);
 
 但是这里只有属性，所以拼接key-value即可
 */
+ (NSString *)sqliteStringForColumnNamesAndTypes:(Class)cls;


/**
 获取model里面所有有用的propertyName，并排序
 */
+ (NSArray *)allTableSortedIvarNames:(Class)cls;
@end
