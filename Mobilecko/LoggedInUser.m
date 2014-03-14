//
//  LoggedInUser.m
//  Mobilecko
//
//  Created by Kyle Davidson on 14/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import "LoggedInUser.h"


@implementation LoggedInUser
@synthesize currentUser;

+ (id)sharedUser {
    static LoggedInUser *sharedCurrentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCurrentUser = [[self alloc] init];
    });
    return sharedCurrentUser;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
