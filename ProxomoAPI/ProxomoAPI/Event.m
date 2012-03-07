//
//  Event.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize EventName;
@synthesize Description;
@synthesize EventType;
@synthesize Privacy;
@synthesize Status;
@synthesize ImageUrl;
@synthesize Notes;
@synthesize PersonID;
@synthesize PersonName;
@synthesize StartTime;
@synthesize EndTime;
@synthesize LastUpdate;
@synthesize MinParticipants;
@synthesize MaxParticpants;
@synthesize appData;
// location 
@synthesize LocationID;
@synthesize Latitude;
@synthesize Longitude;
@synthesize Address1;
@synthesize Address2;
@synthesize City;
@synthesize State;
@synthesize Zip;
@synthesize CountryName;
@synthesize CountryCode;


#pragma mark - API Delegate

-(enumObjectType) objectType{
    return EVENT_TYPE;
}

-(NSString *) objectPath:(enumRequestType)requestType{
    return @"event";
}

-(NSArray*) searchByDistance:(double)miles fromLatitude:(double)latitude fromLongitude:(double)longitude startTime:(NSDate*)start endTime:(NSDate*)end apiContext:(id)context useAsync:(BOOL)useAsync{
    
    ProxomoList *proxomoList = [[ProxomoList alloc] init];
    proxomoList.listType = EVENT_TYPE;
    
    /*
    NSString *searchUrl =  [NSString stringWithFormat:@"s/search/latitude/%f/longitude/%f/distance/%0.0f/start/%0.0f/end",
                          latitude, longitude, miles, 
                          [start timeIntervalSince1970]*1000];
    NSString *searchUri = [NSString stringWithFormat:@"%0.0f",
                           [end timeIntervalSince1970]*1000];
     */
    
    NSString *searchUrl =  [NSString stringWithFormat:@"s/search/latitude/%f/longitude/%f/distance/%0.0f/start/%@/end",
                            latitude, longitude, miles, 
                            [ProxomoApi htmlEncodeString:[ProxomoObject dateJsonRepresentation:start]]];
    NSString *searchUri = [ProxomoApi htmlEncodeString:[ProxomoObject dateJsonRepresentation:end]];

    [context Search:proxomoList searchUrl:searchUrl searchUri:searchUri
        withParams:nil forListType:EVENT_TYPE inObject:nil];
    return [proxomoList arrayValue];
}

-(NSArray*) searchByPerson:(Person*)person startTime:(NSDate*)start endTime:(NSDate*)end  apiContext:(id)context useAsync:(BOOL)useAsync{    
    ProxomoList *proxomoList = [[ProxomoList alloc] init];
    proxomoList.listType = EVENT_TYPE;
    

    NSString *searchUrl =  [NSString stringWithFormat:@"s/search/personid/%@/start/%@/end",
                            person.ID, [ProxomoApi htmlEncodeString:[ProxomoObject dateJsonRepresentation:start]]];
    NSString *searchUri = [ProxomoApi htmlEncodeString:[ProxomoObject dateJsonRepresentation:end]];
    
    [context Search:proxomoList searchUrl:searchUrl searchUri:searchUri
        withParams:nil forListType:EVENT_TYPE inObject:nil];
    return [proxomoList arrayValue];
}

-(NSString*)description {
    return EventName;
}

@end
