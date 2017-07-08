//
//  ZYTableTool.h
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYTableTool : NSObject

/**
 从一个数据库里面获取它的所有字段名，并排序
 */
+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid;
@end
