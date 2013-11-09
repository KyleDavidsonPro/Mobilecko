//
//  MapViewController.h
//  Mobilecko
//
//  Created by Kyle Davidson on 09/11/2013.
//  Copyright (c) 2013 Kyle Davidson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate> {
    
    CLLocationManager *locationManager;
    MKMapView *mapView;

}

@property (nonatomic,retain) IBOutlet MKMapView *mapView;

@end
