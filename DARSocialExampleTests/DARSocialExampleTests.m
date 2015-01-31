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

//- (void)testBaseQuery {
//    NSString *query = @"select * from users where relation = 1";
//    
//    DARDBManager *s1 = [self createUniqueInstance];
//    
//    NSArray *result = [s1 loadDataFromDB:query];
//    
//    XCTAssertEqual(2, result.count);
//}

@end
