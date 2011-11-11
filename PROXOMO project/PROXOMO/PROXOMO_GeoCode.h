//
//  PROXOMO_GeoCode.h
//  PROXOMO
//
//  Created by Ray Venenoso.
//  Copyright 2011 MSU-IIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PROXOMO_API.h"

@interface PROXOMO_GeoCode : PROXOMO_API {
    
}
-(void) GeoCode_byAddress;
-(void) Reverse_GeoCode;
-(void) GeoCode_byIPAddress:(NSString*)ipAddress;

@end
