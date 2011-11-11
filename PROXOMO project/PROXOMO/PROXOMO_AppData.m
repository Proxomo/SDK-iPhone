//
//  PROXOMO_AppData.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "PROXOMO_AppData.h"
#import "SBJson/SBJson.h"
@interface PROXOMO_AppData()

@end

@implementation PROXOMO_AppData

-(void) AppData_Add:(NSObject*)object{
    [self makeRequest:@"/v09/json/appdata" parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) AppData_Delete:(NSObject*)object{
    [self makeRequest:@"/v09/json/appdata" parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) AppData_Get:(NSString*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/appdata/%@",object ] parameters:@"" method:@"GET"];
}
-(void)AppData_GetAll{
    [self makeRequest:@"/v09/json/appdata" parameters:@"" method:@"GET"];
}
-(void) AppData_Update:(NSObject*)object{
    [self makeRequest:@"/v09/json/appdata" parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) AppData_Search:(NSObject*)object{
    [self makeRequest:@"/v09/json/appdata" parameters:[object JSONRepresentation] method:@"GET"];    
}
- (void)handleRequest:(NSString*)response {
    [super handleRequest:response];
    if (request && delegate) {
        if ([[request HTTPMethod] isEqualToString:@"GET"]) {
            [delegate AppData_GetEventHandler:response];
        } else if ([[request HTTPMethod] isEqualToString:@"POST"]) {
            [delegate AppData_AddEventHandler:[response stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        } else if ([[request HTTPMethod] isEqualToString:@"PUT"]) {
            [delegate AppData_UpdateEventHandler:response];
        } else if ([[request HTTPMethod] isEqualToString:@"DELETE"]) {
            [delegate AppData_DeleteEventHandler:response];
        }
    }
}


@end
