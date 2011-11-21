//
//  PROXOMO_Persons.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PROXOMO_API.h"

@interface PROXOMO_Persons : PROXOMO_API {
    
}
-(void) Person_Get:(NSObject*)object;
-(void) Person_Update:(NSObject*)object;
-(void) Person_AppData_Add:(NSObject*)object;
-(void) Person_AppData_Delete:(NSObject*)object : (NSObject*) appDataID;
-(void) Person_AppData_Get:(NSObject*)object : (NSObject *) appDataID;
-(void) Person_AppData_GetAll:(NSObject*)object;
-(void) Person_AppData_Update:(NSObject*)object;
-(void) Person_Locations_Get:(NSObject*)object;
-(void) Person_SocialNetworkInfo_Get:(NSObject*)object;

@end
