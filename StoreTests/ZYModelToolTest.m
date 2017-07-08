//
//  ZYModelToolTest.m
//  Store
//
//  Created by 王志盼 on 2017/7/8.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZYModelTool.h"
#import "ZYStudentEntity.h"

@interface ZYModelToolTest : XCTestCase

@end

@implementation ZYModelToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)testOcClassIvarNameTypeDict
{
    NSDictionary *dict = [ZYModelTool ocClassIvarNameTypeDict:[ZYStudentEntity class]];
    NSLog(@"%@", dict);
}

- (void)testSqliteStringForColumnNamesAndTypes
{
    NSString *str = [ZYModelTool sqliteStringForColumnNamesAndTypes:[ZYStudentEntity class]];
    NSLog(@"%@", str);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
