//
//  DARLocalizationManager.m
//  DARCountryFinder
//
//  Created by Alessio Roberto on 06/12/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "DARLocalizationManager.h"

@interface DARLocalizationManager ()
@property (nonatomic, strong) CLLocation *lastUserLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *actualUserPlacemark;
@end

@implementation DARLocalizationManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static DARLocalizationManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[DARLocalizationManager alloc] init]; });
    return sharedInstance;
}

#pragma mark - Public methods

- (void)requestUserAuth
{
    if (!self.locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.delegate = self;
    }
    
    // ask for "when in use" permission
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
}

- (CLLocation *)getLastUserLocation
{
    return _lastUserLocation;
}

- (void)startUserLocalization
{
    _lastUserLocation = nil;
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopUserLocalization
{
    [self.locationManager stopUpdatingLocation];
}

- (void)reverseGeocode:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure
{
    [self reverseGeocode:self.lastUserLocation
                 success:^(NSDictionary *info) {
                     success(info);
                 } failure:^(NSError *error) {
                     failure(error);
                 }
     ];
}

- (void)setupMapForLocation:(MKMapView *)mapView
{
    [self setupMapForLocation:self.lastUserLocation mapView:mapView];
}

- (void)setupMapForLocation:(CLLocation*)newLocation
                    mapView:(MKMapView *)mapView
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.00725;
    span.longitudeDelta = 0.00725;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
}

- (void)removeAllAnnotationExceptOfCurrentUser:(MKMapView *)mapView
{
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:mapView.annotations];
    if ([mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:mapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in mapView.annotations)
        {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [mapView removeAnnotations:annForRemove];
    [mapView removeOverlays:mapView.overlays];
}

#pragma mark - Private methods
- (void)reverseGeocode:(CLLocation *)location
               success:(void(^)(NSDictionary *info))success
               failure:(void(^)(NSError *error))failure
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // Use current user location to determinate, address, country name and country ISO code
    __weak __typeof(self)weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            failure(error);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.actualUserPlacemark = [placemarks lastObject];
            
            if (strongSelf.actualUserPlacemark.addressDictionary &&
                strongSelf.actualUserPlacemark.ISOcountryCode &&
                strongSelf.actualUserPlacemark.country) {
                NSMutableDictionary *info = [NSMutableDictionary new];
                
                [info setObject:[NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(strongSelf.actualUserPlacemark.addressDictionary, NO)]
                         forKey:@"address"];
                [info setObject:strongSelf.actualUserPlacemark.ISOcountryCode forKey:@"countryCode"];
                [info setObject:strongSelf.actualUserPlacemark.country forKey:@"country"];
                
                success(info);
            } else
                failure([[NSError alloc] initWithDomain:@"No info" code:99 userInfo:nil]);
            
        }
    }];
}
#pragma mark CLLocationManager Delegate

//- (void)locationManager:(CLLocationManager *)manager
//didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusNotDetermined) {
//        [self.locationManager startUpdatingLocation];
//    }
//}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *tmp = locations[0];
    
    /**
     *    Send notification only if user location is changed.
     */
    if (_lastUserLocation.coordinate.latitude != tmp.coordinate.latitude || _lastUserLocation.coordinate.longitude != tmp.coordinate.longitude) {
        // Save the last new user location
        _lastUserLocation = tmp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.alessioroberto.darcountryfinder.newlocation"
                                                            object:self
         ];
    }
}

@end
