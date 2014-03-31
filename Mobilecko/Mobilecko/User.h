//
//  User.h
//  Mobilecko
//
//  Created by Kyle Davidson on 17/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * fbProfileId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Event *attending;

@end
