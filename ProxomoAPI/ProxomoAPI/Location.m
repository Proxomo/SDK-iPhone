//
//  Locations.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Location.h"
#import "AppData.h"

@implementation Location
@synthesize Name;
@synthesize LocationSecurity;
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
@synthesize LocationType;
@synthesize PersonID;


#pragma mark - API Delegate

-(enumObjectType) objectType{
    return LOCATION_TYPE;
}

-(NSString *) objectPath:(enumRequestType)requestType{
    return @"location";
}


#pragma mark - Search
-(NSArray*)appData{
    return [_appData arrayValue];
}
-(NSArray*)locations{
    return [_locations arrayValue];
}

-(ProxomoList*)byAddress:(NSString *)address apiContext:(ProxomoApi *)context {
    _locations = [[ProxomoList alloc] init];
    _locations.appDelegate = appDelegate;
    _apiContext = context;
    [context Search:_locations searchUrl:@"s/search?address=" searchUri:address withParams:nil forListType:LOCATION_TYPE inObject:nil];
    return _locations;
}

-(ProxomoList*)byAddress:(NSString *)address byRadius:(NSNumber*)radius withQueryString:(NSString*)query maxResults:(NSNumber*)maxResults forPerson:(NSString*)personID apiContext:(ProxomoApi *)context {
    _locations = [[ProxomoList alloc] init];
    _locations.appDelegate = appDelegate;
    _apiContext = context;
    [context Search:_locations searchUrl:@"s/search?address=" searchUri:address withParams:nil forListType:LOCATION_TYPE inObject:nil];
    return _locations;
}

-(ProxomoList*)byIP:(NSString*)ip apiContext:(ProxomoApi *)context{
    _locations = [[ProxomoList alloc] init];
    _locations.appDelegate = appDelegate;
    _apiContext = context;
    [context Search:_locations searchUrl:@"s/search/ip" searchUri:ip withParams:nil forListType:LOCATION_TYPE inObject:nil];
    return _locations;
}

-(ProxomoList *) byLatitude:(double)latitude byLogitude:(double)longitude apiContext:(ProxomoApi*)context {
    NSString *searchUrl = [NSString stringWithFormat:@"s/search/latitude/%f/longitude",
                           latitude];
    NSString *searchUri = [NSString stringWithFormat:@"%f",
                           longitude];
    _locations = [[ProxomoList alloc] init];
    _locations.appDelegate = appDelegate;
    _apiContext = context;
    [context Search:_locations searchUrl:searchUrl searchUri:searchUri withParams:nil forListType:LOCATION_TYPE inObject:nil];
    return _locations;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@", Name, Address1, City, State, Zip];
}


@end
