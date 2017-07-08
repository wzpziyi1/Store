//
//  ZYSqliteModelTool.h
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYModelProtocol.h"

@interface ZYSqliteModelTool : NSObject

/**
 根据一个uid以及一个model对象的class，创建一个sqlite

 @param cls model的class
 @return 创建是否成功
 */
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;


/**
 判断一个数据库表是否需要更新，主要就是与本次建立同一表的时候，判断根据本次的model生成的字段名是否与已经存在的数据库表
 字段名是否完全一样
 */
+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;
@end
