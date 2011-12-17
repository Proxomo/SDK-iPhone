//
//  Locations.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoApi+Proxomo.h"
#import "Location.h"
#import "ProxomoObject+Proxomo.h"
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

-(void) updateFromJsonRepresentation:(NSDictionary*)jsonRepresentation{
    if(jsonRepresentation){
        [super updateFromJsonRepresentation:jsonRepresentation];
        Name = [jsonRepresentation objectForKey:@"Name"];
        Latitude = [jsonRepresentation objectForKey:@"Latitude"];
        Longitude = [jsonRepresentation objectForKey:@"Longitude"];
        LocationID = [jsonRepresentation objectForKey:@"LocationID"];
        Address1 = [jsonRepresentation  objectForKey:@"Address1"];
        Address2  = [jsonRepresentation objectForKey:@"Address2"];
        City = [jsonRepresentation objectForKey:@"City"];
        State = [jsonRepresentation objectForKey:@"State"];
        Zip = [jsonRepresentation objectForKey:@"Zip"];
        CountryName = [jsonRepresentation objectForKey:@"CountryName"];
        CountryCode = [jsonRepresentation objectForKey:@"CountryCode"];
        LocationSecurity = [[jsonRepresentation objectForKey:@"LocationSecurity"] intValue];
    }
}

-(NSMutableDictionary*)jsonRepresentation{    
    NSMutableDictionary *dict = nil;
    
    dict = [super jsonRepresentation];
    if (Name) [dict setValue:Name forKey:@"Name"];
    if (Latitude) [dict setValue:Latitude forKey:@"Latitude"];
    if (Longitude) [dict setValue:Longitude forKey:@"Longitude"];
    if (LocationID) [dict setValue:LocationID forKey:@"LocationID"];
    if (Address1) [dict setValue:Address1 forKey:@"Address1"];
    if (Address2) [dict setValue:Address2 forKey:@"Address2"];
    if (City) [dict setValue:City forKey:@"City"];
    if (State) [dict setValue:State forKey:@"State"];
    if (Zip) [dict setValue:Zip forKey:@"Zip"];
    if (CountryName) [dict setValue:CountryName forKey:@"CountryName"];
    if (CountryCode) [dict setValue:CountryCode forKey:@"CountryCode"];
    [dict setValue:[NSNumber numberWithInt:LocationSecurity] forKey:@"LocationSecurity"];
    
    return dict;
}

#pragma mark - API Delegate

-(enumObjectType) objectType{
    return LOCATION_TYPE;
}

-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    [super handleError:response requestType:requestType responseCode:code responseStatus:status];
}

-(void) handleResponse:(NSData *)response requestType:(enumRequestType)requestType  responseCode:(NSInteger)code responseStatus:(NSString *)status{
    [super handleResponse:response requestType:requestType responseCode:code responseStatus:status];
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
