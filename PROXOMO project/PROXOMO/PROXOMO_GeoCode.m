//
//  PROXOMO_GeoCode.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "PROXOMO_GeoCode.h"
#import "SBJson.h"

@interface PROXOMO_GeoCode()

@end

@implementation PROXOMO_GeoCode

-(void) GeoCode_byAddress:(NSObject*)object{
    https://service.proxomo.com/v09/json/geo/lookup/address/{address} 
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/geo/lookup/address/%@",object] parameters:@"" method:@"GET"];
}
-(void) Reverse_GeoCode:(NSObject*)latitude:(NSObject*)longitude{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/geo/lookup/latitude/%@/longitude/%@",latitude,longitude] parameters:@"" method:@"GET"];
}
-(void) GeoCode_byIPAddress:(NSString*)ipAddress{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/geo/lookup/ip/%@",ipAddress] parameters:@"" method:@"GET"];
}

@end
