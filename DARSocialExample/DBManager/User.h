//
//  User.h
//  DARSocialExample
//
//  Created by Alessio Roberto on 25/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) CLLocation *lastLocation;

@end
