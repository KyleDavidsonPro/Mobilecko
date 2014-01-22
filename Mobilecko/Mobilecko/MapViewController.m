//
//  MapViewController.m
//  Mobilecko
//
//  Created by Kyle Davidson on 09/11/2013.
//  Copyright (c) 2013 Kyle Davidson. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "Event.h"
@interface MapViewController ()

@end
#define METERS_PER_MILE 1609.344

@implementation MapViewController
@synthesize mapView;
@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Event" inManagedObjectContext:[del managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[del managedObjectContext] sectionNameKeyPath:nil cacheName:@"Root"];
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];

    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    if ([CLLocationManager locationServicesEnabled]) {
        // Find the current location
        [self.locationManager startMonitoringSignificantLocationChanges];
    }

    [self.mapView setShowsUserLocation:YES];
    
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    //Plot markers
    for (Event *event in [self.fetchedResultsController fetchedObjects]) {
        [self placeMarkerForEvent:event];
    }
    
    //Focus on last marker placed
    CLLocationCoordinate2D zoomLocation;
    Event *lastEvent = [[self.fetchedResultsController fetchedObjects] lastObject];
    zoomLocation.latitude = [[lastEvent latitude] doubleValue];
    zoomLocation.longitude= [[lastEvent longitude] doubleValue];
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [self.mapView setRegion:viewRegion animated:YES];
    


}

- (void)placeMarkerForEvent:(Event *)event {
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude = [event.latitude doubleValue];
    annotationCoord.longitude = [event.longitude doubleValue];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = event.name;
    annotationPoint.subtitle = event.address;
    [self.mapView addAnnotation:annotationPoint];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Background Location Tracking
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // locations contains an array of recent locations, but this app only cares about the most recent
    // which is also "manager.location"
    CLLocation *updatedLocation = manager.location;

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed with error: %@", error);
    if ([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorDenied) {
        //user denied location services so stop updating manager
        [manager stopUpdatingLocation];
            
    }
}

@end
