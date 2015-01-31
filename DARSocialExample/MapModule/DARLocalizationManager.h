//
//  DARLocalizationManager.h
//  DARCountryFinder
//
//  Created by Alessio Roberto on 06/12/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import AddressBookUI;
@import MapKit;

@interface DARLocalizationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedInstance;

/**
 *    Request user auth to use GEO position (> iOS 8)
 */
- (void)requestUserAuth;

- (CLLocation *)getLastUserLocation;

/**
 *    Start updating user position
 */
- (void)startUserLocalization;

/**
 *    Stop updating user position
 */
- (void)stopUserLocalization;

/**
 *    Return geocode information (address, country and ISO country code) about user last know position
 *
 *    @param success A block with a single parameter, a NSDictionary with address, country name and country code.
 *    @param failure The failure block if geocode fails.
 */
- (void)reverseGeocode:(void(^)(NSDictionary *info))success
               failure:(void(^)(NSError *error))failure;

/**
 *    Center MKMapView respect a specific location
 *
 *    @param newLocat The specific location
 *    @param mapView  The MKMapView instance
 */
- (void)setupMapForLocation:(CLLocation*)newLocat mapView:(MKMapView *)mapView;

/**
 *    Center KMMapView respect last know user position
 *
 *    @param mapView The MKMapView instance
 */
- (void)setupMapForLocation:(MKMapView *)mapView;

/**
 *    Remove all annotations and overlays on the MKMapView, excepet user position, if present
 *
 *    @param mapView The MKMapView instance
 */
- (void)removeAllAnnotationExceptOfCurrentUser:(MKMapView *)mapView;


@end
