//
//  DARDBManager+Bolts.h
//  DARSocialExample
//
//  Created by Alessio Roberto on 25/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

#import "DARDBManager.h"
#import <Bolts.h>

@interface DARDBManager (Bolts)

- (BFTask *)makeQuery:(NSString *)query;

@end
