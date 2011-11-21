//
//  PROXOMO_GeoCode.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PROXOMO_API.h"

@interface PROXOMO_GeoCode : PROXOMO_API {
    
}
-(void) GeoCode_byAddress:(NSObject*)object;
-(void) Reverse_GeoCode:(NSObject*)latitude:(NSObject*)longitude;
-(void) GeoCode_byIPAddress:(NSString*)ipAddress;

@end
