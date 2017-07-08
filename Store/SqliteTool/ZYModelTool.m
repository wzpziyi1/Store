//
//  ZYModelTool.m
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "ZYModelTool.h"
#import <objc/runtime.h>
#import "ZYModelProtocol.h"

@implementation ZYModelTool
+ (NSString *)tableName:(Class)cls
{
    return NSStringFromClass(cls);
}

+ (NSDictionary *)ocClassIvarNameTypeDict:(Class)cls
{
    
    NSArray *ignoreNames = nil;
    if ([cls respondsToSelector:@selector(ignoreColumnNames)])
    {
        ignoreNames = [cls ignoreColumnNames];
    }
    
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    NSMutableDictionary *nameTypeDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < outCount; i++)
    {
        Ivar var = varList[i];
        
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(var)];
        
        if ([propertyName hasPrefix:@"_"])
        {
            propertyName = [propertyName substringFromIndex:1];
        }
        
        if([ignoreNames containsObject:propertyName])
        {
            continue;
        }
        
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        nameTypeDict[propertyName] = type;
    }
    return nameTypeDict;
}

+ (NSDictionary *)sqliteNeedTypeDict:(Class)cls
{
    NSMutableDictionary *dic = [[self ocClassIvarNameTypeDict:cls] mutableCopy];
    
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        dic[key] = typeDic[obj];
    }];
    return dic;
}


+ (NSString *)sqliteStringForColumnNamesAndTypes:(Class)cls
{
    NSDictionary *nameTypeDic = [self sqliteNeedTypeDict:cls];
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    return [result componentsJoinedByString:@","];
}

+ (NSArray *)allTableSortedIvarNames:(Class)cls
{
    NSDictionary *dic = [self ocClassIvarNameTypeDict:cls];
    NSArray *keys = dic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return keys;
}

/**
 利用runtime转出来的类型对应sqlite里面的类型

 */
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
    
}

@end
