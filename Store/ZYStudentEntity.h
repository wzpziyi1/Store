//
//  ZYStudentEntity.h
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYModelProtocol.h"

@interface ZYStudentEntity : NSObject <ZYModelProtocol>
@property (nonatomic, assign) int stuNum;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) double score;
@end
