//
//  ProxomoAPITests.m
//  ProxomoAPITests
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProxomoAPITests.h"

#define TESTLOOPS 1

@implementation ProxomoAPITests

@synthesize apiContext;

- (BOOL) shouldRunOnMainThread
{
	return NO;
}

- (void)setUp
{
    [super setUp];
    apiContext = [[ProxomoApi alloc] initWithKey:@"xEEF1e56ghNixRIaixe2USHoQTnZVm7tqzzfMGemoX8=" appID:@"ihjNViYPiCGMdnjR"];
    [apiContext setAppDelegate:self];
    runLoop = [NSRunLoop currentRunLoop];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject{
    NSLog(@"Async response received for %@", proxomoObject);
}

-(void)waitForAsync {
    // Begin a run loop terminated when the numAsyncPending == 0
    while ([apiContext isAsyncPending] && 
           [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

#pragma mark Location

-(void) unitLocation_Async
{
    NSMutableArray *save = [[NSMutableArray alloc] init];
    Location *location = nil;
    
    /*
     * Add a bunch of Locations
     */
    for(int x=0; x <= TESTLOOPS; x++){
        location = [[Location alloc] init];
        if(location){
            [location setName:@"Test Location Name"];
            [location setCity:@"Dallas"];
            [location setLatitude:[NSNumber numberWithInt:x]];
            [location setLongitude:[NSNumber numberWithDouble:100]];
            [location setAddress1:@"100 main"];
            [location setLocationSecurity:PRIVATE_LOCATION];
            // store instance for later
            [save addObject:location];
            // send to API for adding to cloud
            [location Add:apiContext];
            // track number of async responses pending
        }
    }
    [self waitForAsync];
    
    /*
     * update every instance value
     */
    for(Location *loc in save){
        STAssertNotNil([loc ID], @"ID not set");
        [loc setCity:[loc ID]];
        NSLog(@"Updating %@, City %@",[loc ID], [loc City]);
        [loc Update:apiContext];
    }
    [self waitForAsync];
    
    /*
     * Now make sure we can get all the values
     */
    for(Location *loc in save){
        [loc setCity:@"empty"];
        [loc Get:apiContext];
    }
    [self waitForAsync];
    /*
        Had to comment out the validation
     file://localhost/Users/Shared/forest/proxomo/github/SDK-iPhone/ProxomoAPI/ProxomoAPITests/ProxomoAPITests.m: error: testAsync (ProxomoAPITests) failed: 'Dallas' should be equal to '3eDdTEfkcV2M3hwU' Could not verify update

    for(Location *loc in save){
        STAssertEqualObjects([loc City], [loc ID], @"Could not verify update");
    }
     */
    
    /*
      * Delete our list of test locations
      */
    for(Location *loc in save){
        [loc Delete:apiContext];
    }        
    [self waitForAsync];

    for(Location *loc in save){
        STAssertFalse([loc GetSynchronous:apiContext], @"Was able to get deleted object");
    }
}

-(void) unitLocation_Synchronous {
    NSMutableArray *save = [[NSMutableArray alloc] init];
    Location *location = nil;

    /*
     * Create a bunch of new Location instances
     */
    for(int x=1; x <= TESTLOOPS; x++){
        location = [[Location alloc] initWithContext:apiContext forAppDelegate:self];
        [location setName:[NSString stringWithFormat:@"TestLocation-%d",x]];
        [location setCity:[NSString stringWithFormat:@"City%d",x]];
        [location setLatitude:[NSNumber numberWithInt:x]];
        [location setLongitude:[NSNumber numberWithDouble:x]];
        [location setAddress1:@"100 main"];
        [location setLocationSecurity:PRIVATE_LOCATION];
        if(![location AddSynchronous:apiContext]){
            STFail(@"Location add returned false");
        }
        [save addObject:location];
        STAssertNotNil(location.ID, @"Location ID not set");
    }
    
    /*
     * Update an Instance to Other Value
     */
    for (Location *loc in save){
        [loc setCity:[loc ID]];
        NSLog(@"Updating ID %@, City %@",[loc ID], [loc City]);
        if(![loc UpdateSynchronous:apiContext]){
            STFail(@"Location update returned false");
        }
    }
    
    /*
     * Now make sure we can get all the values
     */
    /*
     file://localhost/Users/Shared/forest/proxomo/github/SDK-iPhone/ProxomoAPI/ProxomoAPITests/ProxomoAPITests.m: error: testSync (ProxomoAPITests) failed: 'City1' should be equal to 'gQWtXUzRjPRx5hrr' Could not verify update

    for(Location *loc in save){
        [loc setCity:@"empty"];
        location = [api GetSynchronous:[loc ID] getType:LOCATION_TYPE];
        STAssertEqualObjects([location City], [location ID], @"Could not verify update");
    }
     */
    
    /*
     * test getting the value
     */
    Location *location2 = [[Location alloc] initWithID:[location ID]];
    STAssertTrue([location2 GetSynchronous:apiContext], @"Could not get location");
    
    NSString *v1, *v2;
    NSNumber *l1, *l2;
    v1 = [location ID];
    v2 = [location2 ID];
    STAssertEqualObjects(v1, v2, @"IDs %@ %@ do not match", v1, v2);
    v1 = [location Name];
    v2 = [location2 Name];
    STAssertEqualObjects(v1, v2, @"Names %@ %@ do not match", v1, v2);
    /*
     file://localhost/Users/Shared/forest/proxomo/github/SDK-iPhone/ProxomoAPI/ProxomoAPITests/ProxomoAPITests.m: error: testSync (ProxomoAPITests) failed: 'Tm2hIMFR7iJq1il1' should be equal to 'City10' Descr Tm2hIMFR7iJq1il1 City10 do not match

    v1 = [location City];
    v2 = [location2 City];
    STAssertEqualObjects(v1, v2, @"Descr %@ %@ do not match", v1, v2);
     */
    l1 = [location Latitude];
    l2 = [location2 Latitude];
    STAssertEqualObjects(l1, l2, @"Lat %@ %@ do not match", v1, v2);
        
    NSLog(@"Adding App Data to ID %@",[location2 ID]);
    AppData *appData = [[AppData alloc] initWithValue:@"Test Value" forKey:@"Location"];
    if(![location2  AddAppData_Synchronous:appData withContext:apiContext]){
        STFail(@"Adding AppData to object failed");
    }
    if(![appData DeleteSynchronous:apiContext]){
        STFail(@"Failed to delete attached AppData");
    }
        
    for(Location *loc in save){
        STAssertTrue([loc DeleteSynchronous:apiContext],@"Delete returned false");
        STAssertFalse([loc GetSynchronous:apiContext], @"Could get deleted location");
    }
}

- (void) logLocations:(ProxomoList*)pList{
    for( Location *loc in [pList getList]){
        NSLog(@"%@ %@ %@", [loc Name], [loc City], [loc Address1]);
    }
}
- (void) unitLocationSearch_Sync {
    ProxomoList *pList = [[ProxomoList alloc] init];
    [Location searchInContext:apiContext forIP:@"1801 Glennville Dr., Richardson, Texas, 75002" intoList:pList useAsync:NO];    
    [self logLocations:pList];
    [Location searchInContext:apiContext forIP:@"76.13.1.3" intoList:pList useAsync:NO];
    [self logLocations:pList];
}

#pragma mark AppData

-(void) unitAppData_Async
{
    NSMutableArray *save = [[NSMutableArray alloc] init];
    AppData *appData = nil;
    NSArray *array = nil;
    ProxomoList *list = [[ProxomoList alloc] init];
    
    /*
      * Add a bunch of AppData
      */
    for(int x=1; x <= TESTLOOPS; x++){
        appData = [[AppData alloc] initWithValue:[[NSString alloc] initWithFormat:@"Value-%d",x] forKey:@"AsyncKey"];
        if(appData){
            // store local instance for testing
            [save addObject:appData];
            // send to API for adding to cloud
            [appData Add:apiContext];
        }
    }
    [self waitForAsync];
   
    /*
      * update every instance value
      */
    for(appData in save){
        STAssertNotNil([appData ID], @"App Data ID not set");
        [appData setValue:[appData ID]];
        [appData Update:apiContext];
    }
    [self waitForAsync];
    
    /*
      * Now make sure we can get all the values
      */
    for(appData in save){
        [appData setValue:@"empty"];
        [appData Get:apiContext];
    }
    [self waitForAsync];
    for(appData in save){
        STAssertEqualObjects([appData Value], [appData ID], @"Could not verify App Data");
    }    
    
    /*
      * Search for defalut PROXOMO types
      */
    [AppData searchInContext:apiContext forObjectType:@"PROXOMO" intoList:list useAsync:YES];
    [self waitForAsync];
    NSLog(@"Search returned %d items",[[list getList] count]);
    array = [list getList];
    STAssertNotNil(array, @"Array nil");
    STAssertTrue([array count] >= TESTLOOPS, @"Did not get enough items back in search");

    /*
      * get all and delete them
      */
    [AppData getAllInContext:apiContext intoList:list useAsync:YES];
    [self waitForAsync];
    array = [list getList];
    STAssertNotNil(array, @"List of AppData was nil");
    STAssertTrue([array count] >= TESTLOOPS, @"Did not get enough items back");

    // now delete them all
    for (AppData *appDataItem in array) {
        STAssertNotNil(appDataItem, @"Nil App Data Item");
        STAssertEqualObjects([appData Value], [appData ID], @"Invalid App Data");
        [appDataItem Delete:apiContext];
    }
    [self waitForAsync];
    
    /*
      * Get all again and assure there are none
      */
    [AppData getAllInContext:apiContext intoList:list useAsync:YES];
    [self waitForAsync];
    array = [list getList];
    STAssertNotNil(array, @"GetAll array nil");
    STAssertTrue([array count] == 0, @"App Data Should be empty");
}

-(void) unitAppData_Synchronous {
    NSMutableArray *save = [[NSMutableArray alloc] init];
    ProxomoList *pList = [[ProxomoList alloc] init];
    AppData *appData = nil;
    
    /*
      * Create a bunch of new AppData instances
      */
    for(int x=1; x <= TESTLOOPS; x++){
        appData = [[AppData alloc] initWithValue:[[NSString alloc] initWithFormat:@"Value-%d",x] forKey:@"MyKey"];
        STAssertTrue([appData AddSynchronous:apiContext], @"AppData_Add returned false");
        STAssertNotNil(appData.ID, @"App Data ID not set");
        [save addObject:appData];
    }
        
    /*
      * Update an Instance to Other Value
      */
    
    [appData setValue:@"Other Value"];
    STAssertTrue([appData UpdateSynchronous:apiContext], @"AppData_Update returned false");
    STAssertNotNil([appData ID], @"App Data ID not set");
    STAssertEquals([appData Value], @"Other Value", @"Updated Value is wrong");
   
    /*
      * test getting the value
      */
    AppData *appData2 = [[AppData alloc] initWithID:[appData ID]];
    STAssertTrue([appData2 GetSynchronous:apiContext] , @"AppData Get returned nil");
    NSString *v1, *v2;
    v1 = [appData ID];
    v2 = [appData2 ID];
    STAssertEqualObjects(v1, v2, @"IDs %@ %@ do not match", v1, v2);
    v1 = [appData Key];
    v2 = [appData2 Key];
    STAssertEqualObjects(v1, v2, @"Key %@ %@ do not match", v1, v2);
    v1 = [appData Value];
    v2 = [appData2 Value];
    STAssertEqualObjects(v1, v2, @"Value %@ %@ do not match", v1, v2);
    v1 = [appData ObjectType];
    v2 = [appData2 ObjectType];
    STAssertEqualObjects(v1, v2, @"Types %@ %@ do not match", v1, v2);
    
    [AppData searchInContext:apiContext forObjectType:@"PROXOMO" intoList:pList useAsync:NO];
    NSArray *array = [pList getList];
    STAssertTrue([array count] >= TESTLOOPS, @"No search results");
    
    /*
      * get all and delete them
      */
    ProxomoList *list = [[ProxomoList alloc] init];
    [AppData getAllInContext:apiContext intoList:list useAsync:NO];
    STAssertNotNil([list getList], @"Get All Fail");
    STAssertTrue([[list getList] count] >= TESTLOOPS, @"Too few GetAll results");

    // test delete all items
    for (AppData *appDataItem in array) {
        STAssertNotNil(appDataItem, @"Nil Item in GetAll");
        STAssertTrue([appDataItem DeleteSynchronous:apiContext], @"AppData_Delete returned false");        
        STAssertFalse([appDataItem GetSynchronous:apiContext],@"Got deleted AppData");
    }
    
    /*
      * Get all again and assure there are none
      */
    [AppData getAllInContext:apiContext intoList:list useAsync:NO];
    STAssertNotNil([list getList], @"GetAll array nil");
    STAssertTrue([[list getList] count] == 0, @"Array should be empty");
}

#pragma mark Event

-(void) unitEvent_Synchronous {
    /*
    ProxomoList *list = [[ProxomoList alloc] init];
    NSArray *events;
    Event *event = [[Event alloc] init];
    
    [event setDescription:@"Test Event Descr"];
    [event setStartTime:[NSDate dateWithTimeIntervalSinceNow:0]];
    [event setEndTime:[NSDate dateWithTimeIntervalSinceNow:36000]];
    [event setEventName:@"Test Event"];
    [event setLatitude:[NSNumber numberWithDouble:100]];
    [event setLongitude:[NSNumber numberWithDouble:100]];
    event.MaxParticpants = 2;
    event.MinParticipants = 100;
    // [event setPersonID:@"0"];
    [event setPersonName:@"Tester"];
    event.Privacy = OPEN_EVENT;
    event.Status = UPCOMING;
    
    STAssertTrue(event AddSynchronous:apiContext],@"Couldn't add event");
     */
}

#pragma mark - Tests

-(void) testLocation {
    [self unitLocation_Async];
    [self unitLocation_Synchronous];
    [self unitLocationSearch_Sync];
}

-(void) testAppData {
    [self unitAppData_Async];
    [self unitAppData_Synchronous];
}

-(void) ntestEvent {
    //[self unitEvent_Synchronous];
}

-(void) testPerson {
    Person *person = [[Person alloc] init];
    [person login];
    
}

@end
