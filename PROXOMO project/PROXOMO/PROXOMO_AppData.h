//
//  PROXOMO_AppData.h
//  PROXOMO
//
//  Created by Ray Venenoso.
//  Copyright 2011 MSU-IIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PROXOMO_API.h"

@interface PROXOMO_AppData : PROXOMO_API {
    
}
-(void) AppData_Add:(NSObject*)object;
-(void) AppData_Delete:(NSObject*)object;
-(void) AppData_Get:(NSString*)object;
-(void) AppData_GetAll;
-(void) AppData_Update:(NSObject*)object;
-(void) AppData_Search:(NSObject*)object;

@end
