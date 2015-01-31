//
//  DARSocialExampleTests.m
//  DARSocialExampleTests
//
//  Created by Alessio Roberto on 25/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DARDBManager.h"

@interface DARSocialExampleTests : XCTestCase

@end

@implementation DARSocialExampleTests

#pragma mark - helper methods

- (DARDBManager *)createUniqueInstance {
    
    return [[DARDBManager alloc] init];
    
}

- (DARDBManager *)getSharedInstance {
    
    return [DARDBManager sharedInstance];
    
}

#pragma mark - tests

- (void)testSingletonSharedInstanceCreated {
    
    XCTAssertNotNil([self getSharedInstance]);
    
}

- (void)testSingletonUniqueInstanceCreated {
    
    XCTAssertNotNil([self createUniqueInstance]);
    
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    
    DARDBManager *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
    
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    
    DARDBManager *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    DARDBManager *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testBaseQuery {
    NSString *query = @"select * from users where relation = 0";
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"completion"];
    
    DARDBManager *s1 = [self createUniqueInstance];
    
    [s1 loadDataFromDB:query
     completionHandler:^(NSArray *result) {
         XCTAssertEqual(2, result.count);
         [requestExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testSelectAllQuery {
    NSString *query = @"select * from users";
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"completion"];
    
    DARDBManager *s1 = [self createUniqueInstance];
    
    [s1 loadDataFromDB:query
     completionHandler:^(NSArray *result) {
         XCTAssertNotNil(result);
         NSLog(@"%@", result);
         [requestExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testInsertQuery {
    NSString *insert = @"INSERT INTO USERS VALUES ('Anna', 'Smith', 'anna@gmail.com', '22223', '5th street, New York', 0, 4, 0, 0)";
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"completion"];
    
    DARDBManager *s1 = [self createUniqueInstance];
    
    [s1 executeQuery:insert];
    
    NSString *query = @"select * from users where name = 'Alex'";
    [s1 loadDataFromDB:query
     completionHandler:^(NSArray *result) {
         XCTAssertEqual(1, result.count);
         [requestExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        XCTAssertNil(error, "Error");
    }];
}

@end
