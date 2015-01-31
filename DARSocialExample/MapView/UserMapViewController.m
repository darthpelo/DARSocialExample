//
//  UserMapViewController.m
//  DARSocialExample
//
//  Created by Alessio Roberto on 25/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import "UserMapViewController.h"

#import "DARLocalizationManager.h"
#import "DARDBManager+Bolts.h"

@interface UserMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (nonatomic, strong) DARLocalizationManager *localizationManager;
@property (nonatomic, strong) NSDictionary *userLogged;

@end

@implementation UserMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _localizationManager = [DARLocalizationManager sharedInstance];
    
    [self.localizationManager requestUserAuth];
    
    _userLogged = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.alessioroberto.userLogged"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserPositionOnMap)
                                                 name:@"com.alessioroberto.darcountryfinder.newlocation"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.userLogged[@"latitude"] doubleValue] != 0 && [self.userLogged[@"longitude"] doubleValue] != 0) {
        [self.localizationManager stopUserLocalization];
        
        CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:[self.userLogged[@"latitude"] doubleValue]
                                                              longitude:[self.userLogged[@"longitude"] doubleValue]];
        [self.localizationManager setupMapForLocation:lastLocation
                                              mapView:self.mapView];
        
        [self.localizationManager removeAllAnnotationExceptOfCurrentUser:self.mapView];
        
        // Add annotation
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:lastLocation.coordinate];
        annotation.title = NSLocalizedString(@"User Pin", nil);
        
        MKPinAnnotationView *result = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"User Pin"];
        result.pinColor = MKPinAnnotationColorPurple;
        
        [self.mapView addAnnotation:annotation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private methods
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateUserPositionOnMap
{
    [self.localizationManager setupMapForLocation:self.mapView];
    
    [self.localizationManager stopUserLocalization];
    
    CLLocation *location = [self.localizationManager getLastUserLocation];
    
    [self.localizationManager removeAllAnnotationExceptOfCurrentUser:self.mapView];
    
    // Add annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location.coordinate];
    annotation.title = NSLocalizedString(@"User Pin", nil);
    
    MKPinAnnotationView *result = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"User Pin"];
    result.pinColor = MKPinAnnotationColorPurple;
    
    [self.mapView addAnnotation:annotation];
    
    // Prepare the query string.
    NSString *query = [NSString stringWithFormat:@"UPDATE USERS SET LATITUDE = %f, LONGITUDE = %f WHERE USERID = %d",
                       location.coordinate.latitude,
                       location.coordinate.longitude,
                       [self.userLogged[@"userId"] integerValue]
                       ];
    
    // Execute the query.
    DARDBManager *dbManager = [DARDBManager sharedInstance];
    [dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

#pragma mark Actions
- (IBAction)location:(id)sender {
    [self.localizationManager startUserLocalization];
}


@end
