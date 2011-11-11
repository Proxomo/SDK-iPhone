//
//  PROXOMO_GeoCode.m
//  PROXOMO
//
//  Created by Ray Venenoso.
//  Copyright 2011 MSU-IIT. All rights reserved.
//

#import "PROXOMO_GeoCode.h"


@implementation PROXOMO_GeoCode

-(void) GeoCode_byAddress{
    
}
-(void) Reverse_GeoCode{
    
}
-(void) GeoCode_byIPAddress:(NSString*)ipAddress{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/geo/lookup/ip/%@",ipAddress] parameters:@"" method:@"GET"];
}

@end
