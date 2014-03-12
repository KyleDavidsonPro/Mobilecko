//
//  User.h
//  Mobilecko
//
//  Created by Kyle Davidson on 12/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * fbProfileId;

@end
