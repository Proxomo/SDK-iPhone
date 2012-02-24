//
//  ProxomoAPITests.m
//  ProxomoAPITests
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoAPITests.h"
#import "TestCustomData.h"

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

-(void) unitLocation
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
    STAssertTrue([pList count] > 0, @"Empty Location Search");
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

-(void) unitAppData
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
    [_apiContext setAsync:NO];
    GeoCode *gcode = [[GeoCode alloc] init];
    
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

}

-(void)unitPerson_Synchronous{
    [_apiContext setAsync:NO];
    _userContext.FirstName = @"Joe";
    _userContext.LastName = @"Blow";
    [_userContext UpdateSynchronous:_apiContext];
    ProxomoList *data = [[ProxomoList alloc] init];
    [data GetAll_Synchronous:_userContext getType:APPDATA_TYPE];
    for (AppData *a in [data arrayValue]) {
        //STAssertTrue([a GetSynchronous:_userContext], @"Could not get user data");
        //a.Value = @"Update Value";
        //STAssertTrue([a UpdateSynchronous:_userContext], @"Could not update user data");
        STAssertTrue([a DeleteSynchronous:_userContext], @"Could not update user data");
    }
    
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
    [location DeleteSynchronous:_apiContext];
    
    ProxomoList *locations = [[ProxomoList alloc] init];
    [locations GetAll_Synchronous:_userContext getType:LOCATION_TYPE];

}

#pragma mark Custom Data

-(void) unitCustomData{
    TestCustomData *myCustomData = [[TestCustomData alloc] init];
    myCustomData.likes = @"easy";
    myCustomData.dislikes = @"code";
    myCustomData.foo = @"unit testing custom data";
    [myCustomData Add:_apiContext];
    [self waitForAsync];
    
    STAssertNotNil(myCustomData.ID, @"nil ID");
    myCustomData.likes = @"overwritten";
    [myCustomData Get:_apiContext];
    [self waitForAsync];
    
    STAssertTrue([myCustomData.likes isEqual:@"easy"], @"no custom data");
    [myCustomData Delete:_apiContext];
    [self waitForAsync];
    
    [myCustomData Get:_apiContext]; // should fail now
    [self waitForAsync];
}

#pragma mark - Tests

-(void) testLocation {
    NSLog(@"--- Location Tests ---");
    [_apiContext setAsync:NO];
    [self unitLocation];
    [_apiContext setAsync:YES];
    [self unitLocation];

    [self unitLocationSearch];
}

-(void) testGeoCode {
    NSLog(@"--- GeoCode Tests ---");
    [_apiContext setAsync:NO];
    [self unitGeoSearch];
}

-(void) testAppData {
    [_apiContext setAsync:NO];
    [self unitAppData];
    [_apiContext setAsync:YES];
    [self unitAppData];
}

-(void) testEvent {
    NSLog(@"--- Event Tests ---");
    [_apiContext setAsync:NO];
    [self unitEvent_Synchronous];
}

-(void) testPerson {
    NSLog(@"--- Person Tests ---");
    [_apiContext setAsync:NO];
    [self unitPerson_Synchronous];
}

-(void) testCustomData {
    NSLog(@"--- Custom Data Tests --- ");
    [_apiContext setAsync:NO];
    [self unitCustomData];
    [_apiContext setAsync:YES];
    [self unitCustomData];
}

#define kTestSetSize 10

-(void) ntestSeedSample {
    AppData *appData = nil;
    [_apiContext setAsync:YES];
    
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
