//
//  DARDBManager.h
//  DARSocialExample
//
//  Created by Alessio Roberto on 25/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

@import Foundation;

@interface DARDBManager : NSObject

@property (nonatomic, strong) NSMutableArray *columnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

+ (instancetype)sharedInstance;

- (void)loadDataFromDB:(NSString *)query
          completionHandler:(void (^)(NSArray *result))handler;

- (void)executeQuery:(NSString *)query;

@end
