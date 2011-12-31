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

#pragma mark - Search

+(void)searchInContext:(ProxomoApi*)context forAddress:(NSString *)address intoList:(ProxomoList*)proxomoList useAsync:(BOOL)useAsync{
    [context Search:proxomoList searchUrl:@"s/search/ip" searchUri:address forListType:LOCATION_TYPE useAsync:useAsync];
}
+(void)searchInContext:(ProxomoApi*)context forIP:(NSString *)ip intoList:(ProxomoList*)proxomoList useAsync:(BOOL)useAsync{
    [context Search:proxomoList searchUrl:@"s/search/ip" searchUri:ip forListType:LOCATION_TYPE useAsync:useAsync];
}

#pragma mark - AppData Functions

-(void) AddAppData:(AppData*)appData withContext:(ProxomoApi*)context{
    // let the object know it will receive a post response
    NSString *url = [NSString stringWithFormat:@"%@/%@/appdata", [context getUrlForRequest:LOCATION_TYPE requestType:POST], [context htmlEncodeString:[self ID]]];
    [context makeAsyncRequest:url method:POST delegate:self];
}

-(BOOL) AddAppData_Synchronous:(AppData*)appData withContext:(ProxomoApi*)context {
    NSString *url = [NSString stringWithFormat:@"%@/%@/appdata", [context getUrlForRequest:LOCATION_TYPE requestType:POST], [context htmlEncodeString:[self ID]]];
    
    return [context makeSyncRequest:url method:POST delegate:appData];
}


@end
