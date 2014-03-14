//
//  ProfileViewController.h
//  Mobilecko
//
//  Created by Kyle Davidson on 12/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>
@interface ProfileViewController : UIViewController {
    User *currentUser;
}

@property (nonatomic, retain) User *currentUser;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;


@end
