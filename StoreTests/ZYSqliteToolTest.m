//
//  ZYSqliteToolTest.m
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZYSqliteTool.h"

@interface ZYSqliteToolTest : XCTestCase

@end

@implementation ZYSqliteToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSString *sql = @"create table if not exists t_ppp (id integer primary key, name text not null, age integer, score real)";
    BOOL result = [ZYSqliteTool deal:sql uid:nil];
    XCTAssertEqual(result, YES);
    
    for (int i = 0; i <= 100; i++)
    {
        sql = [NSString stringWithFormat:@"insert into t_ppp (name, age, score) values ('www', %d, %f)", 10 + i, 20.6 + i];
        BOOL result = [ZYSqliteTool deal:sql uid:nil];
        XCTAssertEqual(result, YES);
    }
    
    
}

- (void)testQuery
{
    NSString *sql = @"select * from t_ppp where id >= 1 and id <= 10";
    NSMutableArray *resultArr = [ZYSqliteTool querySql:sql uid:nil];
    NSLog(@"%@", resultArr);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
