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
@end
