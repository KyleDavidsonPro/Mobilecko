//
//  LoggedInUser.h
//  Mobilecko
//
//  Created by Kyle Davidson on 14/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface LoggedInUser : NSObject {
    User *currentUser;
}

@property (nonatomic, retain) User *currentUser;

+ (id)sharedUser;
@end
