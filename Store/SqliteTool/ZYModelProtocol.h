//
//  ZYModelProtocol.h
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZYModelProtocol <NSObject>

@required
/**
 model一定要实现的协议，告知主键
 */
+ (NSString *)primaryKey;

@optional



@end
