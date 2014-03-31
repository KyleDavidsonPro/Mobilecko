//
//  EventDetailViewController.m
//  Mobilecko
//
//  Created by Kyle Davidson on 03/02/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import "EventDetailViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoggedInUser.h"
#import "User.h"
#import "AppDelegate.h"
@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
@synthesize event;
@synthesize name,address,date;
@synthesize shareBtn, attendSeg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    name.text = event.name;
    address.text = event.address;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:event.date];
    
    date.text = stringFromDate;
    
    if ([[[[LoggedInUser sharedUser] currentUser] fbProfileId] isEqualToString:@"default"]) {
        [self.shareBtn setHidden:YES];
    }
    
    if ([[[LoggedInUser sharedUser] currentUser].attending isEqual:event]) {
        [self.attendSeg setSelectedSegmentIndex:1];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)eventAttend {
    // Check if the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:nil]) {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              NSLog(@"Error: %@", error.description);
                                          } else {
                                              NSLog(@"Success!");
                                          }
                                      }];
    } else {
        
    }
    
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (IBAction)segmentChanged:(id)sender {
    if (self.attendSeg.selectedSegmentIndex == 0) {
        //Not Attending
        User *currentuser = [[LoggedInUser sharedUser] currentUser];
        currentuser.attending = nil;
        //Cancel scheduled reminder
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    } else {
        //Attending
        User *currentuser = [[LoggedInUser sharedUser] currentUser];
        currentuser.attending = event;
        //Schedule a reminder
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = event.date;
        localNotification.alertBody = @"You're attending a blood donation session today!";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    //don't forget to save
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    if (![appDel.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
