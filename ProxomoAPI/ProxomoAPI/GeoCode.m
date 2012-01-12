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

-(NSString *) objectPath{
    return @"geo";
}

-(void) byAddress:(NSString*)address apiContext:(ProxomoApi*)context  useAsync:(BOOL)useAsync{
    [context GetByUrl:self searchUrl:@"/lookup/address" searchUri:address objectType:GEOCODE_TYPE useAsync:useAsync];
}

-(void) byIPAddress:(NSString*)ipAddress apiContext:(ProxomoApi*)context  useAsync:(BOOL)useAsync{
     [context GetByUrl:self searchUrl:@"/lookup/ip" searchUri:ipAddress objectType:GEOCODE_TYPE useAsync:useAsync];
}

-(Location *) byLatitude:(NSNumber*)latitude byLogitude:(NSNumber*)longitude apiContext:(ProxomoApi*)context {
    NSString *searchUrl = [NSString stringWithFormat:@"/lookup/latitude/%@/longitude",
                           latitude];
    Location *location = [[Location alloc] init];
    [context GetByUrl:location searchUrl:searchUrl searchUri:[longitude stringValue] objectType:GEOCODE_TYPE useAsync:NO];
    return location;
}

-(void) byLatitude:(NSNumber*)latitude byLogitude:(NSNumber*)longitude locationDelegate:(Location*)location apiContext:(ProxomoApi*)context {
    NSString *searchUrl = [NSString stringWithFormat:@"/lookup/latitude/%@/longitude",
                           latitude];
    [context GetByUrl:location searchUrl:searchUrl searchUri:[longitude stringValue] objectType:GEOCODE_TYPE useAsync:YES];
}


@end
