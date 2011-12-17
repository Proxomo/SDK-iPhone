//
//  ProxomoApi.m
//  ProxomoApi
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoApi.h"
#import "ProxomoList+Proxomo.h"
#import "Proxomo.h"

#import "ProxomoObject+Proxomo.h"
@implementation ProxomoApi

@synthesize apiStatus;
@synthesize apiKey;
@synthesize applicationId;
@synthesize accessToken;
@synthesize apiVersion;
@synthesize appDelegate;

-(void)initData {
    accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    expires = [[NSUserDefaults standardUserDefaults] objectForKey:@"expires"];
    
    responseData = [[NSMutableDictionary alloc] init];
    responseDelegate = [[NSMutableDictionary alloc] init];
    responses = [[NSMutableDictionary alloc] init];
    requests = [[NSMutableDictionary alloc] init];
    
    encode_url_table = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"%24", @"$",
                         @"%26", @"&", 
                         @"%2B", @"+",
                         @"%2C", @",",
                         @"%2F", @"/",
                         @"%3A", @":",
                         @"%3B", @";",
                         @"%3D", @"=",
                         @"%3F", @"?",
                         @"%40", @"@",
                         @"%20", @" ",
                         @"%22", @"\"",
                         @"%3C", @"<",
                         @"%3E", @">",
                         @"%23", @"#",
                         @"%7B", @"{",
                         @"%7D", @"}",
                         @"%7C", @"|",
                         @"%5C", @"\\",
                         @"%5E", @"^",
                         @"%7E", @"~",
                         @"%5B", @"[",
                         @"%5D", @"]",
                         @"%60", @"`",
                         nil];
    numAsyncPending = 0;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (id) initWithKey:(NSString *)appKey appID:(NSString *)appID {
    self = [super init];
    if(self){
        appKey = appKey;
        applicationId = appID;
        [self initData];
    }
    return self;
}

-(BOOL)isAsyncPending{
    return (numAsyncPending!=0);
}

#pragma mark - Events

/*
-(void) Event_Add:(NSObject*)object{
    //[self makeRequest:@"/v09/json/event" parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Event_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Event_Update:(NSObject*)object{
    //[self makeRequest:@"/v09/json/event" parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Comment_Add:(NSObject*)object{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comment",object ]  parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Event_Comment_Delete:(NSObject*)object : (NSObject*) commentID{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comment/%@",object,commentID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Event_Comments_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comments",object ] parameters:@"" method:@"GET"];
}
-(void) Event_Comment_Update:(NSObject*)object{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comment",object ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Participant_Invite:(NSObject*)object: (NSObject*) personID{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participant/invite/personid/%@",object,personID ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Participants_Invite:(NSObject*)object: (NSObject*) personIDs{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participant/invite/personids/%@",object,personIDs ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Request_Invitation:(NSObject*)object: (NSObject*) personID{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/requestinvite/personid/%@",object,personID ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Participants_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participants",object ] parameters:@"" method:@"GET"];
}
-(void) Event_Participant_Delete:(NSObject*)object : (NSObject*) eventParticipantID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participant",object ] parameters:@"" method:@"GET"];
}
-(void) Event_RSVP:(NSObject*)object{
    //no info in website
}
-(void) Event_Search:(NSObject*)object{
    //no info in website
}
-(void) Event_Search_byPersonID:(NSObject*)object : (NSObject*) start :(NSObject *) end{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/Event/search/personid/%@/start/%@/end/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Event_AppData_Add:(NSObject*)object{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Event_AppData_Delete:(NSObject*)object : (NSObject*) appDataID{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata/%@",object,appDataID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Event_AppData_Get:(NSObject*)object : (NSObject *) appDataID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata/%@",object,appDataID ] parameters:@"" method:@"GET"];
}
-(void) Event_AppData_GetAll:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata",object] parameters:@"" method:@"GET"];
    
}
-(void) Event_AppData_Update:(NSObject*)object{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"PUT"];
}
*/

#pragma mark - Friend

/*

-(void) Friend_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/Friend/personid/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Friend_Invite:(NSObject*)object: (NSObject*) friendb{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/friend/invite/frienda/%@/friendb/%@",object,friendb ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Friend_Invite_bySocialNetwork:(NSObject*)object{
    //no info on website
}
-(void) Friend_Respond:(NSObject*)object{
    //no info on website
}
-(void) Friend_SocialNetwork_Get:(NSObject*)object: (NSObject*) socialnetwork{
    
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/Friend/personid/%@/socialnetwork/%@",object,socialnetwork ] parameters:@"" method:@"GET"];
}
-(void) Friend_SocialNetwork_AppGet{
    //no info on website
}
*/

#pragma mark - Person

/*
 
 -(void) Person_Get:(NSObject*)object{
 [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@",object ] parameters:@"" method:@"GET"];
 }
 -(void) Person_Update:(NSObject*)object{
 //[self makeRequest:@"/v09/json/person" parameters:[object JSONRepresentation] method:@"PUT"];
 }
 -(void) Person_AppData_Add:(NSObject*)object{
 //[self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"POST"];
 }
 -(void) Person_AppData_Delete:(NSObject*)object : (NSObject*) appDataID{
 //[self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata/%@",object,appDataID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
 }
 -(void) Person_AppData_Get:(NSObject*)object : (NSObject *) appDataID{
 [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata/%@",object,appDataID ] parameters:@"" method:@"GET"];
 }
 -(void) Person_AppData_GetAll:(NSObject*)object{
 [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata",object] parameters:@"" method:@"GET"];
 }
 -(void) Person_AppData_Update:(NSObject*)object{
 //[self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"PUT"];
 }
 -(void) Person_Locations_Get:(NSObject*)object{
 [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/locations",object] parameters:@"" method:@"GET"];
 }
 -(void) Person_SocialNetworkInfo_Get:(NSObject*)object{
 //no info from website
 }
 
*/

#pragma mark - Notification

/*

-(void) Notification_Send:(NSObject*)object{
    //[self makeRequest:@"/v09/json/notification" parameters:[object JSONRepresentation] method:@"POST"];
}

*/

#pragma mark - Location

/*
-(void) Location_Add:(NSObject*)object{
    //[self makeRequest:@"/v09/json/location" parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Location_Delete:(NSObject*)object{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@",object] parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Location_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Location_Update:(NSObject*)object{
    //[self makeRequest:@"/v09/json/location" parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Location_CategoriesGet:(NSObject*)object{
    [self makeRequest:@"/v09/json/location/categories" parameters:@"" method:@"GET"];
}
-(void) Locations_Search_byAddress:(NSObject*)object{
    //[self makeRequest:@"/v09/json/locations/search" parameters:[object JSONRepresentation] method:@"GET"];
}
-(void) Locations_Search_byGPS:(NSObject*)latitude:(NSObject*)longitude{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/locations/search/latitude/%@/longitude/%@",latitude,longitude] parameters:@"" method:@"GET"];
}
-(void) Locations_Search_byIPAddress:(NSString*)ipAddress{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/locations/search/ip/%@",ipAddress] parameters:@"" method:@"GET"];
}
-(void) Location_AppData_Add:(NSObject*)object{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Location_AppData_Delete:(NSObject*)object  : (NSObject*) appDataID{
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata/%@",object,appDataID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Location_AppData_Update:(NSObject*)object {
    //[self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Location_AppData_Get:(NSObject*)object  : (NSObject*) appDataID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata/%@",object,appDataID ] parameters:@"" method:@"GET"];
}
-(void) Location_AppData_GetAll:(NSObject*)object {
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata",object] parameters:@"" method:@"GET"];
}

 */

#pragma mark - GeoCode

/*

-(void) GeoCode_byAddress:(NSObject*)object{
https://service.proxomo.com/v09/json/geo/lookup/address/{address} 
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/geo/lookup/address/%@",object] parameters:@"" method:@"GET"];
}
-(void) Reverse_GeoCode:(NSObject*)latitude:(NSObject*)longitude{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/geo/lookup/latitude/%@/longitude/%@",latitude,longitude] parameters:@"" method:@"GET"];
}
-(void) GeoCode_byIPAddress:(NSString*)ipAddress{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/geo/lookup/ip/%@",ipAddress] parameters:@"" method:@"GET"];
}
 */

@end
