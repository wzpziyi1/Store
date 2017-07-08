//
//  ZYSqliteModelToolTest.m
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZYSqliteModelTool.h"
#import "ZYStudentEntity.h"

@interface ZYSqliteModelToolTest : XCTestCase

@end

@implementation ZYSqliteModelToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    BOOL result = [ZYSqliteModelTool createTable:[ZYStudentEntity class] uid:nil];
    XCTAssertEqual(result, YES);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
