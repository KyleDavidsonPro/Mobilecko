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
    
    [self placeMarkersForEvents];

}

- (void)placeMarkersForEvents {
    [self.mapView removeAnnotations:mapView.annotations];
    //Plot markers
    for (Event *event in [self.fetchedResultsController fetchedObjects]) {
     
        CLLocationCoordinate2D annotationCoord;
        
        annotationCoord.latitude = [event.latitude doubleValue];
        annotationCoord.longitude = [event.longitude doubleValue];
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = event.name;
        NSString *newAddress = [[event.address componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        
     
        [self.mapView addAnnotation:annotationPoint];
    }
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
    
    //Plot markers
    for (Event *event in [self.fetchedResultsController fetchedObjects]) {
        CLLocationCoordinate2D eventLocation;
        eventLocation.latitude = [[event latitude] doubleValue];
        eventLocation.longitude= [[event longitude] doubleValue];
        
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:eventLocation.latitude longitude:eventLocation.longitude];
        
        //Compare current position distance from all events
        CLLocationDistance dist = [updatedLocation distanceFromLocation:loc2];
        //If the events are around a 1 mile radious
        if (dist < 2500) {
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
            localNotification.alertBody = @"You are near an upcoming blood donation.";
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            return;

        }
        
    }

    

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed with error: %@", error);
    if ([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorDenied) {
        //user denied location services so stop updating manager
        [manager stopUpdatingLocation];
    }
}


#pragma mark - Updating map
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self placeMarkersForEvents];
            break;
        case NSFetchedResultsChangeDelete:
            [self placeMarkersForEvents];
            break;
        case NSFetchedResultsChangeUpdate:
            [self placeMarkersForEvents];
            break;
        case NSFetchedResultsChangeMove:
            // do nothing
            break;
            
        default:
            break;
    }
}

@end
