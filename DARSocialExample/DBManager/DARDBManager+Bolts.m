//
//  DARDBManager+Bolts.m
//  DARSocialExample
//
//  Created by Alessio Roberto on 25/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

#import "DARDBManager+Bolts.h"

@implementation DARDBManager (Bolts)

- (BFTask *)makeQuery:(NSString *)query
{
    BFTaskCompletionSource *successful = [BFTaskCompletionSource taskCompletionSource];
    
    [self loadDataFromDB:query
       completionHandler:^(NSArray *result) {
           [successful setResult:result];
       }
     ];

    return successful.task;
}

@end
