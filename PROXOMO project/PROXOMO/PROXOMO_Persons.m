//
//  PROXOMO_Persons.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "PROXOMO_Persons.h"
#import "SBJson.h"

@interface PROXOMO_Persons()

@end


@implementation PROXOMO_Persons

-(void) Person_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Person_Update:(NSObject*)object{
    [self makeRequest:@"/v09/json/person" parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Person_AppData_Add:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Person_AppData_Delete:(NSObject*)object : (NSObject*) appDataID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata/%@",object,appDataID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Person_AppData_Get:(NSObject*)object : (NSObject *) appDataID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata/%@",object,appDataID ] parameters:@"" method:@"GET"];
}
-(void) Person_AppData_GetAll:(NSObject*)object{
     [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata",object] parameters:@"" method:@"GET"];
}
-(void) Person_AppData_Update:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Person_Locations_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/person/%@/locations",object] parameters:@"" method:@"GET"];
}
-(void) Person_SocialNetworkInfo_Get:(NSObject*)object{
    //no info from website
}

@end
