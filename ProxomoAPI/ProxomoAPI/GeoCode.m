//
//  GeoCode.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "GeoCode.h"

@implementation GeoCode
@synthesize Address;
@synthesize City;
@synthesize CountryCode;
@synthesize CountryName;
@synthesize DSTOffset;
@synthesize GMTOffset;
@synthesize Latitude ;
@synthesize Longitude;
@synthesize Precision;
@synthesize RawOffset;
@synthesize Score;
@synthesize State;
@synthesize TimeZoneName ;
@synthesize Zip;
@synthesize IP;

-(enumObjectType) objectType{
    return GEOCODE_TYPE;
}

-(NSString *) objectPath:(enumRequestType)requestType{
    return @"geo";
}

-(void) byAddress:(NSString*)address apiContext:(ProxomoApi*)context  useAsync:(BOOL)useAsync{
    _apiContext = context;
    [context GetByUrl:self searchUrl:@"/lookup/address" searchUri:address objectType:GEOCODE_TYPE useAsync:useAsync];
}

-(void) byIPAddress:(NSString*)ipAddress apiContext:(ProxomoApi*)context  useAsync:(BOOL)useAsync{
    _apiContext = context;
    [context GetByUrl:self searchUrl:@"/lookup/ip" searchUri:ipAddress objectType:GEOCODE_TYPE useAsync:useAsync];
}


-(void) byLatitude:(double)latitude byLogitude:(double)longitude locationDelegate:(Location*)location apiContext:(ProxomoApi*)context {
    NSString *searchUrl = [NSString stringWithFormat:@"/lookup/latitude/%f/longitude",
                           latitude];
    NSString *searchUri = [NSString stringWithFormat:@"%f", longitude];
    _apiContext = context;
    [context GetByUrl:self searchUrl:searchUrl searchUri:searchUri objectType:GEOCODE_TYPE useAsync:YES];
}

-(NSString*) description{
    return [NSString stringWithFormat:@"%0.2fx%0.2f",
                       [Latitude doubleValue], [Longitude doubleValue]];
}

@end
