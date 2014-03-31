//
//  Event.h
//  Mobilecko
//
//  Created by Kyle Davidson on 17/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * syncID;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSSet *attendants;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addAttendantsObject:(User *)value;
- (void)removeAttendantsObject:(User *)value;
- (void)addAttendants:(NSSet *)values;
- (void)removeAttendants:(NSSet *)values;

@end
