//
//  LoginViewController.h
//  Mobilecko
//
//  Created by Kyle Davidson on 11/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property (nonatomic, retain) IBOutlet FBLoginView *fbLogin;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;

- (IBAction)skipButton:(id)sender;
@end
