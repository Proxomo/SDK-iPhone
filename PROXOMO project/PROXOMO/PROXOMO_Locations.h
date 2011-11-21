//
//  PROXOMO_Locations.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PROXOMO_API.h"

@interface PROXOMO_Locations : PROXOMO_API {
    
}
-(void) Location_Add:(NSObject*)object;
-(void) Location_Delete:(NSObject*)object;
-(void) Location_Get:(NSObject*)object;
-(void) Location_Update:(NSObject*)object;
-(void) Location_CategoriesGet:(NSObject*)object;
-(void) Locations_Search_byAddress:(NSObject*)object;
-(void) Locations_Search_byGPS:(NSObject*)latitude:(NSObject*)longitude;
-(void) Locations_Search_byIPAddress:(NSString*)ipAddress;
-(void) Location_AppData_Add:(NSObject*)object;
-(void) Location_AppData_Delete:(NSObject*)object  : (NSObject*) appDataID;
-(void) Location_AppData_Update:(NSObject*)object;
-(void) Location_AppData_Get:(NSObject*)object  : (NSObject*) appDataID;
-(void) Location_AppData_GetAll:(NSObject*)object ;

@end
