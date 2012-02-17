//
//  ProxomoAPITests.m
//  ProxomoAPITests
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoAPITests.h"

#define TESTLOOPS 1
#define kTestAddress @"1700 N. Glennville, Richardson, Texas, 75081"
#define kTestIP @"76.13.1.3"
#define kTestLongitude -122.01371
#define kTestLatitude 37.416489
#define kEventStartTime [NSDate date]
#define kEventEndTime [NSDate dateWithTimeIntervalSinceNow:3600*24*7]

@implementation ProxomoAPITests

@synthesize _apiContext;
@synthesize _userContext;

- (BOOL) shouldRunOnMainThread
{
	return NO;
}

-(void)waitForAsync {
    // Begin a run loop terminated when the numAsyncPending == 0
    while ([_apiContext isAsyncPending] && 
           [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)setUp
{
    [super setUp];
    _apiContext = [[ProxomoApi alloc] initWithKey:@"PUT YOUR API KEY HERE" appID:@"PUT YOUR APP KEY HERE"];
    [_apiContext setAppDelegate:self];
    
    runLoop = [NSRunLoop currentRunLoop];
    _userContext = [[Person alloc] init];
    [_userContext setID:@"8mECuOEvlLPj9nHb"];
    [_userContext Get:_apiContext];
    [self waitForAsync];
    STAssertNotNil([_userContext FullName], @"Null Person Name");
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject{
    NSLog(@"Async response received for %@", proxomoObject);
}

#pragma mark Location

-(void) unitLocation_Async
{
    NSMutableArray *save = [[NSMutableArray alloc] init];
    Location *location = nil;
    AppData *data = [[AppData alloc] initWithValue:@"location value" forKey:@"location key"];
    /*
     * Add a bunch of Locations
     */
    for(int x=0; x <= TESTLOOPS; x++){
        location = [[Location alloc] init];
        if(location){
            location.Name = @"Test Location Name";
            location.City = @"Dallas";
            location.Latitude = [NSNumber numberWithInt:x];
            location.Longitude = [NSNumber numberWithDouble:100];
            location.Address1 = @"100 main";
            location.LocationSecurity = PRIVATE_LOCATION;
            // store instance for later
            [save addObject:location];
            // send to API for adding to cloud
            [location Add:_apiContext];
            // track number of async responses pending
        }
    }
    [self waitForAsync];
    
    /*
     * update every instance value
     */
    for(Location *loc in save){
        STAssertNotNil([loc ID], @"ID not set");
        loc.City = [loc ID];
        NSLog(@"Updating %@, City %@",[loc ID], [loc City]);
        [loc Update:_apiContext];
        [data Add:loc];
        [data Update:loc];
    }
    [self waitForAsync];
    
    /*
     * Now make sure we can get all the values
     */
    for(Location *loc in save){
        loc.City = @"empty";
        [loc Get:_apiContext];
    }
    [self waitForAsync];
    
    for(Location *loc in save){
        STAssertTrue([[loc appData] count] > 0, @"Missing App Data in location");
    }
    
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
        [loc Delete:_apiContext];
    }        
    [self waitForAsync];

    for(Location *loc in save){
        STAssertFalse([loc GetSynchronous:_apiContext], @"Was able to get deleted object");
    }
}

-(void) unitLocation_Synchronous {
    NSMutableArray *save = [[NSMutableArray alloc] init];
    Location *location = nil;

    /*
     * Create a bunch of new Location instances
     */
    for(int x=1; x <= TESTLOOPS; x++){
        location = [[Location alloc] init];
        location.Name = [NSString stringWithFormat:@"TestLocation-%d",x];
        location.City = [NSString stringWithFormat:@"City%d",x];
        location.Latitude = [NSNumber numberWithInt:x];
        location.Longitude = [NSNumber numberWithDouble:x];
        location.Address1 = @"100 main";
        location.LocationSecurity = PRIVATE_LOCATION;
        if(![location AddSynchronous:_apiContext]){
            STFail(@"Location add returned false");
        }
        [save addObject:location];
        STAssertNotNil(location.ID, @"Location ID not set");
    }
    
    /*
     * Update an Instance to Other Value
     */
    for (Location *loc in save){
        loc.City = [loc ID];
        NSLog(@"Updating ID %@, City %@",[loc ID], [loc City]);
        if(![loc UpdateSynchronous:_apiContext]){
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
    STAssertTrue([location2 GetSynchronous:_apiContext], @"Could not get location");
    
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
    if(![appData AddSynchronous:location2]){
        STFail(@"Adding AppData to object failed");
    }
    if(![appData UpdateSynchronous:location2]){
        STFail(@"Adding AppData to object failed");
    }
    //if(![appData DeleteSynchronous:location2]){
    //    STFail(@"Failed to delete attached AppData");
    //}
    for(Location *loc in save){
        STAssertTrue([loc DeleteSynchronous:_apiContext],@"Delete returned false");
        STAssertFalse([loc GetSynchronous:_apiContext], @"Could get deleted location");
    }
    
    ProxomoList *plist = [[ProxomoList alloc] init];
    [plist GetAll_Synchronous:location2 getType:APPDATA_TYPE];
}

- (void) logLocations:(NSArray*)pList{
    for(Location *loc in pList){
        NSLog(@"%@ %@ %@", [loc Name], [loc City], [loc Address1]);
    }
}

- (void) unitLocationSearch {
    NSArray *pList;
    
    Location *location = [[Location alloc] init];
    pList = [location byIP:kTestIP apiContext:_apiContext useAsync:NO];    
    STAssertTrue([pList count] > 0, @"Empty Location IP Search");
    [self logLocations:pList];
    pList = [location byAddress:kTestAddress apiContext:_apiContext useAsync:NO];
    // getting 404? STAssertTrue([pList count] > 0, @"Empty Location Search");
    [self logLocations:pList];
    pList = [location byLatitude:kTestLatitude byLogitude:kTestLongitude apiContext:_apiContext useAsync:NO];
    STAssertTrue([pList count] > 0, @"Empty Location Geo Search");
    [self logLocations:pList];
    
    
    // test async
    [location byIP:kTestIP apiContext:_apiContext useAsync:YES];    
    [self waitForAsync];
    pList = [location locations];
    [self logLocations:pList];
    STAssertTrue([pList count] > 0, @"Empty Location IP Search");
    pList = [location byAddress:kTestAddress apiContext:_apiContext useAsync:YES];
    [self waitForAsync];
    pList = [location locations];
    [self logLocations:pList];
    // Getting 404 - STAssertTrue([pList count] > 0, @"Empty Location Search");
    pList = [location byLatitude:kTestLatitude byLogitude:kTestLongitude apiContext:_apiContext useAsync:YES];
    [self waitForAsync];
    pList = [location locations];
    [self logLocations:pList];
    STAssertTrue([pList count] > 0, @"Empty Location Geo Search");

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
            [appData Add:_apiContext];
        }
    }
    [self waitForAsync];
   
    /*
      * update every instance value
      */
    for(appData in save){
        STAssertNotNil([appData ID], @"App Data ID not set");
        appData.Value = [appData ID];
        [appData Update:_apiContext];
    }
    [self waitForAsync];
    
    /*
      * Now make sure we can get all the values
      */
    for(appData in save){
        appData.Value = @"empty";
        [appData Get:_apiContext];
    }
    [self waitForAsync];
    for(appData in save){
        STAssertEqualObjects([appData Value], [appData ID], @"Could not verify App Data");
    }    
    
    /*
      * Search for defalut PROXOMO types
      */
    [AppData searchInContext:_apiContext forObjectType:@"PROXOMO" intoList:list useAsync:YES];
    [self waitForAsync];
    NSLog(@"Search returned %d items",[[list arrayValue] count]);
    array = [list arrayValue];
    STAssertNotNil(array, @"Array nil");
    STAssertTrue([array count] >= TESTLOOPS, @"Did not get enough items back in search");

    /*
      * get all and delete them
      */
    [list GetAll:_apiContext getType:APPDATA_TYPE];
    [self waitForAsync];
    array = [list arrayValue];
    STAssertNotNil(array, @"List of AppData was nil");
    STAssertTrue([array count] >= TESTLOOPS, @"Did not get enough items back");

    // now delete them all
    for (AppData *appDataItem in array) {
        STAssertNotNil(appDataItem, @"Nil App Data Item");
        STAssertEqualObjects([appData Value], [appData ID], @"Invalid App Data");
        [appDataItem Delete:_apiContext];
    }
    [self waitForAsync];
    
    /*
      * Get all again and assure there are none
      */
    [list GetAll:_apiContext getType:APPDATA_TYPE];
    [self waitForAsync];
    array = [list arrayValue];
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
        STAssertTrue([appData AddSynchronous:_apiContext], @"AppData_Add returned false");
        STAssertNotNil(appData.ID, @"App Data ID not set");
        [save addObject:appData];
    }
        
    /*
      * Update an Instance to Other Value
      */
    
    appData.Value = @"Other Value";
    STAssertTrue([appData UpdateSynchronous:_apiContext], @"AppData_Update returned false");
    STAssertNotNil(appData.ID, @"App Data ID not set");
    STAssertEquals(appData.Value, @"Other Value", @"Updated Value is wrong");
   
    /*
      * test getting the value
      */
    AppData *appData2 = [[AppData alloc] initWithID:[appData ID]];
    STAssertTrue([appData2 GetSynchronous:_apiContext] , @"AppData Get returned nil");
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
    
    [AppData searchInContext:_apiContext forObjectType:@"PROXOMO" intoList:pList useAsync:NO];
    NSArray *array = [pList arrayValue];
    STAssertTrue([array count] >= TESTLOOPS, @"No search results");
    
    /*
      * get all and delete them
      */
    ProxomoList *list = [[ProxomoList alloc] init];
    [list GetAll_Synchronous:_apiContext getType:APPDATA_TYPE];
    STAssertNotNil([list arrayValue], @"Get All Fail");
    STAssertTrue([[list arrayValue] count] >= TESTLOOPS, @"Too few GetAll results");

    // test delete all items
    for (AppData *appDataItem in array) {
        STAssertNotNil(appDataItem, @"Nil Item in GetAll");
        STAssertTrue([appDataItem DeleteSynchronous:_apiContext], @"AppData_Delete returned false");        
        STAssertFalse([appDataItem GetSynchronous:_apiContext],@"Got deleted AppData");
    }
    
    /*
      * Get all again and assure there are none
      */
    [list GetAll_Synchronous:_apiContext getType:APPDATA_TYPE];
    STAssertNotNil([list arrayValue], @"GetAll array nil");
    STAssertTrue([[list arrayValue] count] == 0, @"Array should be empty");
}

#pragma mark Event

-(void) unitEvent_Synchronous {
    Event *event = [[Event alloc] init];
    Location *location = [[Location alloc] init];
    
    location.Name = @"TestLocation-event";
    location.City = @"EventCity";
    location.Latitude = [NSNumber numberWithInt:kTestLatitude];
    location.Longitude = [NSNumber numberWithDouble:kTestLongitude];
    location.Address1 = @"100 main";
    location.LocationSecurity = OPEN_LOCATION;
    STAssertTrue([location AddSynchronous:_apiContext], @"Location add returned false");
    
    event.Description = @"Test Event Descr";
    event.StartTime = kEventStartTime;
    event.EndTime = kEventEndTime;
    event.EventName = @"Test Event";
    event.Latitude = [NSNumber numberWithDouble:kTestLatitude];
    event.Longitude = [NSNumber numberWithDouble:kTestLongitude];
    event.MaxParticpants = 2;
    event.MinParticipants = 100;
    event.PersonName = @"Tester";
    event.Privacy = OPEN_EVENT;
    event.Status = UPCOMING;
    event.PersonID = _userContext.ID;
    event.LocationID = location.ID;
        
    STAssertTrue([event AddSynchronous:_apiContext],@"Couldn't add event");
    STAssertTrue([event GetSynchronous:_apiContext], @"Couldn't get event");
    // STAssertTrue([event DeleteSynchronous:_apiContext], @"Could not delete event");
    AppData *eventdata = [[AppData alloc] initWithValue:@"event-value" forKey:@"event-key"];
    STAssertTrue([eventdata AddSynchronous:event], @"Couldn't add event data");
    eventdata.ID = nil;
    eventdata.Value = @"Value2";
    STAssertTrue([eventdata AddSynchronous:event], @"Couldn't add event data");
    eventdata.Value = @"New Value";
    STAssertTrue([eventdata UpdateSynchronous:event], @"Couldn't update event data");
    
    ProxomoList *plist = [[ProxomoList alloc] init];
    [plist GetAll_Synchronous:event getType:APPDATA_TYPE];
    STAssertTrue([[plist arrayValue] count] > 0, @"Empty event app data");
    for (AppData *data in [plist arrayValue]) {
        NSLog(@"Event Data Value %@", data.Value);
        STAssertTrue([data DeleteSynchronous:event], @"Couldn't delete event data");
    }
    
    /*
     Event *eventWho = [[Event alloc] init];
    Event *event2 = [[Event alloc] init];
     NSArray *events;
    events = [event2 searchByDistance:5000 
              fromLatitude:kTestLatitude
             fromLongitude:kTestLongitude
             startTime:[NSDate dateWithTimeIntervalSinceNow:(-36000*24*7)] 
             endTime:[NSDate date]
             apiContext:_apiContext
            useAsync:NO];
    STAssertTrue([events count] > 0, @"Empty event search by distance");
     
    events = [eventWho searchByPerson:_userContext startTime:kEventStartTime endTime:kEventEndTime apiContext:_apiContext useAsync:NO];
    STAssertTrue([events count] > 0, @"Empty event search by person");
     */
    
    EventComment *comment = [[EventComment alloc] init];
    EventComment *save;
    comment.PersonID = _userContext.ID;
    comment.PersonName = @"Test Comment Person";
    comment.Comment = @"Event Comment";
    STAssertTrue([comment AddSynchronous:event], @"Could not add event comment");
    // It is not possible to get the single event comment
    // STAssertTrue([comment GetSynchronous:event], @"Could not get event comment");
    comment.Comment = @"New Event Comment";
    STAssertTrue([comment UpdateSynchronous:event], @"Could not add update comment");
    comment.Comment = @"Empty";
    [plist GetAll_Synchronous:event getType:EVENTCOMMENT_TYPE];
    STAssertTrue([[plist arrayValue] count] > 0, @"Empty event comment data");
    if([[plist arrayValue] count] > 0){
        save = comment;
        comment = [[plist arrayValue] objectAtIndex:0];
    }
    STAssertTrue([comment.Comment isEqualToString:@"New Event Comment"], @"Comment wasn't updated");
    /*
     // Delete failed because event.ID was not set from getting all comments
    for (EventComment *c in [plist arrayValue]) {
        STAssertTrue([comment DeleteSynchronous:event], @"Could not delete event comment");
    }
     */
    [save DeleteSynchronous:event];
    [location DeleteSynchronous:_apiContext];
}

#pragma mark GeoCode

-(void) unitGeoSearch {
    GeoCode *gcode = [[GeoCode alloc] init];
    Location *location = [[Location alloc] init];
    
    [gcode byAddress:kTestAddress apiContext:_apiContext useAsync:NO];
    STAssertNotNil([gcode Address], @"Nil Address");
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");
    
    [gcode setAddress:nil];
    [gcode setLongitude:nil];
    [gcode setLatitude:nil];    
    [gcode byIPAddress:kTestIP apiContext:_apiContext useAsync:NO]; 
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");
    
    
    location = [gcode byLatitude:kTestLatitude byLogitude:kTestLongitude apiContext:_apiContext]; 
    STAssertNotNil([location Latitude], @"Nil Latitude");
    STAssertNotNil([location Longitude], @"Nil Longitude");
    
    
    [gcode setAddress:nil];
    [gcode setLongitude:nil];
    [gcode setLatitude:nil];
    [gcode byAddress:kTestAddress apiContext:_apiContext useAsync:YES];
    [self waitForAsync];
    STAssertNotNil([gcode Address], @"Nil Address");
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");

  
    [gcode setAddress:nil];
    [gcode setLongitude:nil];
    [gcode setLatitude:nil];
    [gcode byIPAddress:kTestIP apiContext:_apiContext useAsync:YES]; 
    [self waitForAsync];
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");
    
    location.Address1 = nil;
    location.Longitude = nil;
    location.Latitude = nil;    
    [gcode byLatitude:kTestLatitude byLogitude:kTestLongitude locationDelegate:location apiContext:_apiContext]; 
    [self waitForAsync];
    STAssertNotNil([location Latitude], @"Nil Latitude");
    STAssertNotNil([location Longitude], @"Nil Longitude");
}

-(void)unitPerson_Synchronous{
    _userContext.FirstName = @"Joe";
    _userContext.LastName = @"Blow";
    [_userContext UpdateSynchronous:_apiContext];
    
    
    ProxomoList *socialNetFriends = [[ProxomoList alloc] init];
    [socialNetFriends GetAll_Synchronous:_userContext getType:SOCIALNETFRIEND_TYPE];
    for (SocialNetworkFriend *friend in [socialNetFriends arrayValue]) {
        [_userContext friendInvite:friend.ID inSocialNetwork:FACEBOOK];
    }
    
    ProxomoList *socialNetworkInfo = [[ProxomoList alloc] init];
    [socialNetworkInfo GetAll_Synchronous:_userContext getType:SOCIALNETWORK_INFO_TYPE];
    ProxomoList *appFriends = [[ProxomoList alloc] init];
    [appFriends GetAll_Synchronous:_userContext getType:FRIEND_TYPE];
    
    
    Location *location = [[Location alloc] init];
    location.PersonID = _userContext.ID;
    location.Name = @"TestLocation-event";
    location.City = @"EventCity";
    location.Latitude = [NSNumber numberWithInt:kTestLatitude];
    location.Longitude = [NSNumber numberWithDouble:kTestLongitude];
    location.Address1 = @"100 main";
    location.LocationSecurity = OPEN_LOCATION;
    STAssertTrue([location AddSynchronous:_apiContext], @"Location add returned false");

    ProxomoList *locations = [[ProxomoList alloc] init];
    [locations GetAll_Synchronous:_userContext getType:LOCATION_TYPE];
    ProxomoList *data = [[ProxomoList alloc] init];
    [data GetAll_Synchronous:_userContext getType:APPDATA_TYPE];
    for (AppData *a in [data arrayValue]) {
        STAssertTrue([a GetSynchronous:_userContext], @"Could not get user data");
        a.Value = @"Update Value";
        STAssertTrue([a UpdateSynchronous:_userContext], @"Could not update user data");
        STAssertTrue([a DeleteSynchronous:_userContext], @"Could not update user data");
    }
    [location DeleteSynchronous:_apiContext];
}

#pragma mark - Tests

-(void) testLocation {
    NSLog(@"--- Location Tests ---");
    [self unitLocation_Async];
    [self unitLocation_Synchronous];
    [self unitLocationSearch];
}

-(void) ntestGeoCode {
    NSLog(@"--- GeoCode Tests ---");
    [self unitGeoSearch];
}

-(void) ntestAppData {
    [self unitAppData_Async];
    [self unitAppData_Synchronous];
}

-(void) ntestEvent {
    NSLog(@"--- Event Tests ---");
    [self unitEvent_Synchronous];
}

-(void) ntestPerson {
    NSLog(@"--- Person Tests ---");
    [self unitPerson_Synchronous];
}

#define kTestSetSize 10

-(void) ntestSeedSample {
    AppData *appData = nil;
    
    for(int x=1; x <= kTestSetSize; x++){
        appData = [[AppData alloc] initWithValue:[[NSString alloc] initWithFormat:@"Value-%d",x] 
                                          forKey:[[NSString alloc] initWithFormat:@"Key-%d",x]];
        [appData Add:_apiContext];
    }
    [self waitForAsync];
    
    Location *location = nil;
    location = [[Location alloc] init];
    location.Name = @"DFW";
    location.City = @"Dallas";
    location.Latitude = [NSNumber numberWithInt:32];
    location.Longitude = [NSNumber numberWithDouble:96];
    location.Address1 = @"100 main";
    location.LocationSecurity = PRIVATE_LOCATION;
    // send to API for adding to cloud
    [location Add:_apiContext];
    
    location = [[Location alloc] init];
    location.Name = @"STL";
    location.City = @"St. Louis";
    location.Latitude = [NSNumber numberWithInt:38];
    location.Longitude = [NSNumber numberWithDouble:90];
    location.Address1 = @"Hwy 70";
    location.LocationSecurity = PRIVATE_LOCATION;
    // send to API for adding to cloud
    [location Add:_apiContext];
    [self waitForAsync];
   
}

@end
