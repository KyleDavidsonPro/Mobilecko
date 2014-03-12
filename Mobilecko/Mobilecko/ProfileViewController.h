//
//  ProfileViewController.h
//  Mobilecko
//
//  Created by Kyle Davidson on 12/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface ProfileViewController : UIViewController {
    User *currentUser;
}

@property (nonatomic, retain) User *currentUser;

@end
