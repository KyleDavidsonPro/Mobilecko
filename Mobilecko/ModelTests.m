//
//  ModelTests.m
//  Mobilecko
//
//  Created by Kyle Davidson on 31/03/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"
#import "Event.h"

@interface ModelTests : XCTestCase

@end

@implementation ModelTests

- (NSManagedObjectContext *)managedObjectContextForTests {
    static NSManagedObjectModel *model = nil;
    if (!model) {
        model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    }
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    NSAssert(store, @"Should have a store by now");
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;
    
    return
    
    moc;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUsingInMemoryStore {
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[self managedObjectContextForTests]];
    
    NSManagedObjectContext *moc = [event managedObjectContext];
    NSPersistentStoreCoordinator *psc = [moc persistentStoreCoordinator];
    NSArray *stores = [psc persistentStores];
    int storeCount = [stores count];
    XCTAssertEqual(storeCount, 1, @"Only one store in use");
    NSPersistentStore *store = [stores objectAtIndex:0];
    XCTAssertEqualObjects([store type], NSInMemoryStoreType, @"Using an in-memory store for testing");
}

- (void)testEvent {
     Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[self managedObjectContextForTests]];
    event.name = @"Test";
    event.address = @"Test";
    
    XCTAssert(event, @"The object should exist");
    XCTAssertEqual(event.name, event.address, @"Showing that both attributes saved correctly with same data");
    
}

- (void)testRelationships {
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[self managedObjectContextForTests]];
    event.name = @"Test Event";
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[event managedObjectContext]];
    user.name = @"Test User";
    user.attending = event;
    
    int attendantsCount = [event.attendants count];
    XCTAssertEqualObjects(user.attending, event, @"Testing relationship succesful");
    XCTAssertEqual(attendantsCount, 1, @"Should have one attendant to this event");
    
}

@end
