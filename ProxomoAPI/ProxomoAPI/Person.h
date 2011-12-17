//
//  Persons.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"

typedef enum {
    FACEBOOK = 0
} enumSocialNetwork;

@interface Person : ProxomoObject {
    
}

-(void) login;

/*
-(void) Person_Get:(NSObject*)object;
-(void) Person_Update:(NSObject*)object;
-(void) Person_AppData_Add:(NSObject*)object;
-(void) Person_AppData_Delete:(NSObject*)object : (NSObject*) appDataID;
-(void) Person_AppData_Get:(NSObject*)object : (NSObject *) appDataID;
-(void) Person_AppData_GetAll:(NSObject*)object;
-(void) Person_AppData_Update:(NSObject*)object;
-(void) Person_Locations_Get:(NSObject*)object;
-(void) Person_SocialNetworkInfo_Get:(NSObject*)object;
*/

@end
