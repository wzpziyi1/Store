//
//  ZYSqliteTool.h
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYSqliteTool : NSObject


/**
 根据sql语句与uid处理
 */
+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid;


/**
 根据sql与uid进行查询
 @return 根据条件产生的准备语句，在准备语句里面可以获取到某一行有多少列，某一列的name、value与类型(real,integer,blob,text)，字典里面装的就是某一行所有列的数据
 */
+ (NSMutableArray <NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid;
@end
