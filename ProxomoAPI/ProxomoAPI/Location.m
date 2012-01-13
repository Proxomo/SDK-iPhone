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


#pragma mark - API Delegate

-(enumObjectType) objectType{
    return LOCATION_TYPE;
}

-(NSString *) objectPath{
    return @"location";
}


#pragma mark - Search
-(NSArray*)appData{
    return [_appData arrayValue];
}
-(ProxomoList*)locations{
    return _locations;
}

-(NSArray*)byAddress:(NSString *)address apiContext:(ProxomoApi *)context useAsync:(BOOL)useAsync{
    _locations = [[ProxomoList alloc] init];
    [_locations setAppDelegate:appDelegate];
    [context Search:_locations searchUrl:@"s/search/address" searchUri:address forListType:LOCATION_TYPE useAsync:useAsync inObject:nil];
    return [_locations arrayValue];
}

-(NSArray*)byIP:(NSString*)ip apiContext:(ProxomoApi *)context useAsync:(BOOL)useAsync{
    _locations = [[ProxomoList alloc] init];
    [_locations setAppDelegate:appDelegate];
    [context Search:_locations searchUrl:@"s/search/ip" searchUri:ip forListType:LOCATION_TYPE useAsync:useAsync inObject:nil];
    return [_locations arrayValue];
}

-(NSArray *) byLatitude:(NSNumber*)latitude byLogitude:(NSNumber*)longitude apiContext:(ProxomoApi*)context useAsync:(BOOL)useAsync{
    NSString *searchUrl = [NSString stringWithFormat:@"s/search/latitude/%@/longitude",
                           latitude];
    _locations = [[ProxomoList alloc] init];
    [_locations setAppDelegate:appDelegate];
    [context Search:_locations searchUrl:searchUrl searchUri:[longitude stringValue] forListType:LOCATION_TYPE useAsync:useAsync inObject:nil];
    return [_locations arrayValue];
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@", Name, Address1, City, State, Zip];
}


@end
