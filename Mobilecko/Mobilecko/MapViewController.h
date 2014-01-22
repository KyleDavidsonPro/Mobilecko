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

@interface MapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate, NSFetchedResultsControllerDelegate> {
    
    CLLocationManager *locationManager;
    MKMapView *mapView;

}

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end
