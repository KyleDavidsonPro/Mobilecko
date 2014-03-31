//
//  ProfileViewController.m
//  Mobilecko
//
//  Created by Kyle Davidson on 12/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import "ProfileViewController.h"
#import "Event.h"
#import "LoggedInUser.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize currentUser;

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

    self.profilePictureView.profileID = currentUser.fbProfileId;
    self.nameLabel.text = currentUser.name;
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[LoggedInUser sharedUser] currentUser].attending) {
        Event *event = [[LoggedInUser sharedUser] currentUser].attending;
        self.eventLabel.text = event.name;
    } else {
        self.eventLabel.text = @"No upcoming events";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
