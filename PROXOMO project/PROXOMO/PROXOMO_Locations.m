//
//  PROXOMO_Locations.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "PROXOMO_Locations.h"
#import "SBJson.h"

@interface PROXOMO_Locations()

@end

@implementation PROXOMO_Locations

-(void) Location_Add:(NSObject*)object{
    [self makeRequest:@"/v09/json/location" parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Location_Delete:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@",object] parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Location_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Location_Update:(NSObject*)object{
     [self makeRequest:@"/v09/json/location" parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Location_CategoriesGet:(NSObject*)object{
     [self makeRequest:@"/v09/json/location/categories" parameters:@"" method:@"GET"];
}
-(void) Locations_Search_byAddress:(NSObject*)object{
    [self makeRequest:@"/v09/json/locations/search" parameters:[object JSONRepresentation] method:@"GET"];
}
-(void) Locations_Search_byGPS:(NSObject*)latitude:(NSObject*)longitude{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/locations/search/latitude/%@/longitude/%@",latitude,longitude] parameters:@"" method:@"GET"];
}
-(void) Locations_Search_byIPAddress:(NSString*)ipAddress{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/locations/search/ip/%@",ipAddress] parameters:@"" method:@"GET"];
}
-(void) Location_AppData_Add:(NSObject*)object{
     [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Location_AppData_Delete:(NSObject*)object  : (NSObject*) appDataID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata/%@",object,appDataID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Location_AppData_Update:(NSObject*)object {
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Location_AppData_Get:(NSObject*)object  : (NSObject*) appDataID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata/%@",object,appDataID ] parameters:@"" method:@"GET"];
}
-(void) Location_AppData_GetAll:(NSObject*)object {
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/location/%@/appdata",object] parameters:@"" method:@"GET"];
}

@end
