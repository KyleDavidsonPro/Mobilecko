//
//  LoginViewController.m
//  Mobilecko
//
//  Created by Kyle Davidson on 11/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "LoggedInUser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.fbLogin.readPermissions = @[@"basic_info"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipButton: (id)sender {
    
    [self performSegueWithIdentifier:@"Login" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Login"]) {
        UITabBarController *tab = [segue destinationViewController];
        UITabBarItem *profileTab = [tab.tabBar.items lastObject];
        if (!currentUser.fbProfileId) {
            [profileTab setEnabled:NO];
        } else {
            [profileTab setEnabled:YES];
            ProfileViewController *pVC = (ProfileViewController *)[[tab viewControllers] lastObject];
            pVC.currentUser = currentUser;
            [[LoggedInUser sharedUser] setCurrentUser:currentUser];
        }
    }
}

#pragma mark - FB Delegates
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
    
    //Create/Set current user
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"User" inManagedObjectContext:[del managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"fbProfileId == %@", user.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [[del managedObjectContext] countForFetchRequest:request
                                                            error:&error];
    if (count == NSNotFound) {
        NSLog(@"Error: %@", error);
    } else if (count == 0) {
        User *newUser = [NSEntityDescription
                        insertNewObjectForEntityForName:@"User"
                        inManagedObjectContext:[del managedObjectContext]];
        newUser.name = user.name;
        newUser.fbProfileId = user.id;
        currentUser = newUser;
    } else {
        currentUser = [[[del managedObjectContext] executeFetchRequest:request error:nil] lastObject];
    }
    
    //dont forget to save
    [del saveContext];
    
    [self performSegueWithIdentifier:@"Login" sender:self];

}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";

}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
