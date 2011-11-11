//
//  PROXOMO_Locations.h
//  PROXOMO
//
//  Created by Ray Venenoso.
//  Copyright 2011 MSU-IIT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PROXOMO_Locations : NSObject {
    
}
-(void) Location_Add;
-(void) Location_Delete;
-(void) Location_Get;
-(void) Location_Update;
-(void) Location_CategoriesGet;
-(void) Locations_Search_byAddress;
-(void) Locations_Search_byGPS;
-(void) Locations_Search_byIPAddress;
-(void) Location_AppData_Add;
-(void) Location_AppData_Delete;
-(void) Location_AppData_Update;
-(void) Location_AppData_Get;
-(void) Location_AppData_GetAll;

@end
