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
@synthesize desiredResult;

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
    desiredResult = YES;
    _apiContext = [[ProxomoApi alloc] initWithKey:@"PUT YOUR API KEY HERE" appID:@"PUT YOUR APP KEY HERE"];
    [_apiContext setAppDelegate:self];
    
    runLoop = [NSRunLoop currentRunLoop];
    _userContext = [[Person alloc] init];
    [_userContext setID:@"PUT PROXOMO ID HERE"];
    [_userContext Get:_apiContext];
    [self waitForAsync];
    STAssertNotNil([_userContext FullName], @"Null Person Name");
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject {
    NSLog(@"Response received for %@", proxomoObject);
    STAssertTrue(success == desiredResult, @"Operation failed for object %@", proxomoObject);
    if(success != desiredResult){
        NSLog(@"%@ operation failed", proxomoObject);
    }
}

#pragma mark - unit tests

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
        [self waitForAsync];
        [data Add:loc];
        [self waitForAsync];
        [data Update:loc];
        [self waitForAsync];
    }
    
    ProxomoList *locData;
    for(Location *loc in save){
        locData = [[ProxomoList alloc] init];
        locData.listType = APPDATA_TYPE;
        [locData GetAll:loc getType:APPDATA_TYPE];
        [self waitForAsync];
    }

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
        
        for(AppData *ad in [loc appData]){
            [ad Delete:loc];
            [self waitForAsync];
        }
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
        desiredResult = NO;
        [loc Get:_apiContext];
    }
    desiredResult = YES;
}

- (void) logLocations:(NSArray*)pList{
    for(Location *loc in pList){
        NSLog(@"%@ %@ %@", [loc Name], [loc City], [loc Address1]);
    }
}

- (void) unitLocationSearch {
    ProxomoList *pList;
    
    Location *location = [[Location alloc] init];
    pList = [location byIP:kTestIP apiContext:_apiContext];    
    [self waitForAsync];
    STAssertTrue([[pList arrayValue] count] > 0, @"Empty Location IP Search");
    [self logLocations:[pList arrayValue]];
    pList = [location byAddress:kTestAddress apiContext:_apiContext];
    [self waitForAsync];
    STAssertTrue([[pList arrayValue] count] > 0, @"Empty Location Search");
    [self logLocations:[pList arrayValue]];
    pList = [location byLatitude:kTestLatitude byLogitude:kTestLongitude apiContext:_apiContext];
    [self waitForAsync];
    STAssertTrue([[pList arrayValue] count] > 0, @"Empty Location Geo Search");
    [self logLocations:[pList arrayValue]];
}

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
        // store local instance for testing
        [save addObject:appData];
        // send to API for adding to cloud
        [appData Add:_apiContext];
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

-(void) unitEvent {
    Event *event = [[Event alloc] init];
    Location *location = [[Location alloc] init];
    
    location.Name = @"TestLocation-event";
    location.City = @"EventCity";
    location.Latitude = [NSNumber numberWithInt:kTestLatitude];
    location.Longitude = [NSNumber numberWithDouble:kTestLongitude];
    location.Address1 = @"100 main";
    location.LocationSecurity = OPEN_LOCATION;
    [location Add:_apiContext];
    [self waitForAsync];
    
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
    [event Add:_apiContext];
    [self waitForAsync];
    [event Get:_apiContext];
    [self waitForAsync];
    STAssertNotNil(event.ID, @"Couldn't get event");
    AppData *eventdata = [[AppData alloc] initWithValue:@"event-value" forKey:@"event-key"];
    [eventdata Add:event];
    [self waitForAsync];
    STAssertNotNil(eventdata.ID, @"Couldn't add event data");
    eventdata.ID = nil;
    eventdata.Value = @"Value2";
    [eventdata Add:event];
    [self waitForAsync];
    STAssertNotNil(eventdata.ID, @"Couldn't add event data");
    eventdata.Value = @"New Value";
    [eventdata Update:event];
    [self waitForAsync];
    STAssertNotNil(event.ID, @"Couldn't update event data");
    
    ProxomoList *plist = [[ProxomoList alloc] init];
    [plist GetAll:event getType:APPDATA_TYPE];
    [self waitForAsync];
    STAssertTrue([[plist arrayValue] count] > 0, @"Empty event app data");
    for (AppData *data in [plist arrayValue]) {
        NSLog(@"Event Data Value %@", data.Value);
        [data Delete:event];
        [self waitForAsync];
        STAssertNotNil(data.ID, @"Couldn't delete event data");
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
    [comment Add:event];
    [self waitForAsync];
    STAssertNotNil(comment.ID, @"Could not add event comment");
    // It is not possible to get the single event comment
    // STAssertTrue([comment Get:event], @"Could not get event comment");
    comment.Comment = @"New Event Comment";
    [comment Update:event];
    [self waitForAsync];
    STAssertNotNil(comment.ID, @"Could not add update comment");
    comment.Comment = @"Empty";
    [plist GetAll:event getType:EVENTCOMMENT_TYPE];
    [self waitForAsync];
    STAssertTrue([[plist arrayValue] count] > 0, @"Empty event comment data");
    if([[plist arrayValue] count] > 0){
        save = comment;
        comment = [[plist arrayValue] objectAtIndex:0];
    }
    STAssertTrue([comment.Comment isEqualToString:@"New Event Comment"], @"Comment wasn't updated");
    /*
     // Delete failed because event.ID was not set from getting all comments
    for (EventComment *c in [plist arrayValue]) {
        STAssertTrue([comment Delete:event], @"Could not delete event comment");
    }
     */
    [save Delete:event];
    [self waitForAsync];
    [location Delete:_apiContext];
    [self waitForAsync];
}

-(void) unitGeoSearch {
    [_apiContext setAsync:NO];
    GeoCode *gcode = [[GeoCode alloc] init];
    
    [gcode byAddress:kTestAddress apiContext:_apiContext];
    STAssertNotNil([gcode Address], @"Nil Address");
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");
    
    [gcode setAddress:nil];
    [gcode setLongitude:nil];
    [gcode setLatitude:nil];    
    [gcode byIPAddress:kTestIP apiContext:_apiContext];
    [self waitForAsync];
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");
    
    [gcode setAddress:nil];
    [gcode setLongitude:nil];
    [gcode setLatitude:nil];
    [gcode byAddress:kTestAddress apiContext:_apiContext];
    [self waitForAsync];
    STAssertNotNil([gcode Address], @"Nil Address");
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");

    [gcode setAddress:nil];
    [gcode setLongitude:nil];
    [gcode setLatitude:nil];
    [gcode byIPAddress:kTestIP apiContext:_apiContext];
    [self waitForAsync];
    STAssertNotNil([gcode Latitude], @"Nil Latitude");
    STAssertNotNil([gcode Longitude], @"Nil Longitude");

}

-(void)unitPerson{
    _userContext.FirstName = @"Joe";
    _userContext.LastName = @"Blow";
    [_userContext Update:_apiContext];
    [self waitForAsync];
    ProxomoList *data = [[ProxomoList alloc] init];
    [data GetAll:_userContext getType:APPDATA_TYPE];
    [self waitForAsync];
    for (AppData *a in [data arrayValue]) {
        [a Delete:_userContext];
        [self waitForAsync];
    }
    
    ProxomoList *socialNetFriends = [[ProxomoList alloc] init];
    [socialNetFriends GetAll:_userContext getType:SOCIALNETFRIEND_TYPE];
    [self waitForAsync];
    /*
    for (SocialNetworkFriend *friend in [socialNetFriends arrayValue]) {
        [_userContext friendInvite:friend.ID inSocialNetwork:FACEBOOK];
        [self waitForAsync];
    }
     */

    ProxomoList *socialNetworkInfo = [[ProxomoList alloc] init];
    [socialNetworkInfo GetAll:_userContext getType:SOCIALNETWORK_INFO_TYPE];
    [self waitForAsync];
    ProxomoList *appFriends = [[ProxomoList alloc] init];
    [appFriends GetAll:_userContext getType:FRIEND_TYPE];
    [self waitForAsync];
    
    
    Location *location = [[Location alloc] init];
    location.PersonID = _userContext.ID;
    location.Name = @"TestLocation-event";
    location.City = @"EventCity";
    location.Latitude = [NSNumber numberWithInt:kTestLatitude];
    location.Longitude = [NSNumber numberWithDouble:kTestLongitude];
    location.Address1 = @"100 main";
    location.LocationSecurity = OPEN_LOCATION;
    [location Add:_apiContext];
    [self waitForAsync];
    [location Delete:_apiContext];
    [self waitForAsync];
    
    ProxomoList *locations = [[ProxomoList alloc] init];
    [locations GetAll:_userContext getType:LOCATION_TYPE];
    [self waitForAsync];

}

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
    myCustomData.likes = @"faster";
    [myCustomData Update:_apiContext];
    [self waitForAsync];
    myCustomData.likes = @"overwritten";
    [myCustomData Get:_apiContext];
    [self waitForAsync];
    STAssertTrue([myCustomData.likes isEqual:@"faster"], @"no custom data");
    
    ProxomoList *searchData;
    searchData = [myCustomData Search:@"likes eq 'faster'" apiContext:_apiContext];
    [self waitForAsync];
    STAssertTrue([[searchData arrayValue] count] > 0, @"Empty Search");
    for (TestCustomData *tcd in [searchData arrayValue]) {
        [tcd Delete:_apiContext];
        [self waitForAsync];
    }
    
    // clean up 
    searchData = [myCustomData Search:@"likes eq 'easy'" apiContext:_apiContext];
    [self waitForAsync];
    for (TestCustomData *tcd in [searchData arrayValue]) {
        [tcd Delete:_apiContext];
        [self waitForAsync];
    }

    
    desiredResult = NO;
    [myCustomData Get:_apiContext]; // should fail now
    [self waitForAsync];
    desiredResult = YES;
}

-(void) unitCustomAuth {
    PersonLogin *login = [[PersonLogin alloc] init];
    
    [login createPerson:_apiContext userName:@"tester" password:@"testpwd" role:PERSON_ROLE_USER];
    [self waitForAsync];
    STAssertNotNil(login.PersonID, @"Login ID NIL");
    [login updateRole:_apiContext toRole:PERSON_ROLE_ADMIN];
    [self waitForAsync];
    [login passwordChange:_apiContext newPassword:@"mynewsecret"];
    [self waitForAsync];
    
    ProxomoList *plist = [[ProxomoList alloc] init];
    [plist GetAll:_apiContext getType:PERSON_LOGIN_TYPE];
    [self waitForAsync];
    for (PersonLogin *account in [plist arrayValue]) {
        [account Delete:_apiContext];
        [self waitForAsync];
    }
}

#pragma mark - Tests

-(void) testLocation {
    NSLog(@"--- Location Tests ---");
    [_apiContext setAsync:NO];
    [self unitLocation];
    [_apiContext setAsync:YES];
    [self unitLocation];
}

-(void) testLocationSearch {
    NSLog(@"--- Location Search Tests ---");
    [_apiContext setAsync:NO];
    [self unitLocationSearch];
    [_apiContext setAsync:YES];
    [self unitLocationSearch];
}

-(void) testGeoCode {
    NSLog(@"--- GeoCode Tests ---");
    [_apiContext setAsync:NO];
    [self unitGeoSearch];
    [_apiContext setAsync:YES];
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
    [self unitEvent];
    [_apiContext setAsync:YES];
    [self unitEvent];
}

-(void) testPerson {
    NSLog(@"--- Person Tests ---");
    [_apiContext setAsync:NO];
    [self unitPerson];
    [_apiContext setAsync:YES];
    [self unitPerson];
}

-(void) testCustomData {
    NSLog(@"--- Custom Data Tests --- ");
    [_apiContext setAsync:NO];
    [self unitCustomData];
    [_apiContext setAsync:YES];
    [self unitCustomData];
}

-(void) testCustomAuth {
    NSLog(@"--- Custom Auth Tests --- ");
    [_apiContext setAsync:NO];
    [self unitCustomAuth];
    [_apiContext setAsync:YES];
    [self unitCustomAuth];
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
