//
//  GeoCode.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"
#import "ProxomoList.h"
#import "Location.h"

@interface GeoCode : ProxomoObject {
    NSString *Address ;  /// Address for a GeoCode.
    NSString *City ;  ///  City for a GeoCode.
    NSString *CountryCode ;  /// Internationally recognized country code abbreviation.
    NSString *CountryName ;  /// Internationally recognized name of the country.
    NSString *DSTOffset;  ///  Daylight savings time offset.
    NSString *GMTOffset;  ///  Greenwich mean time offset.
    NSNumber *Latitude ;  ///  Yes GPS Latitude.
    NSNumber *Longitude;  ///  Yes GPS Longitude.
    NSNumber *Precision;  ///   Estimated precision for a GeoCode.
    NSString *RawOffset;  ///  Raw time offset.
    NSString *Score;  ///  Estimated relevance score for a GeoCode.
    NSString *State;  ///  State for a GeoCode.
    NSString *TimeZoneName ;  ///  Name of the time zone.
    NSString *Zip ;  /// Zip Code for a GeoCode.
    NSString *IP ;  /// IP Address of GeoCode
    ProxomoList *_locations;
}

@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *CountryCode;
@property (nonatomic, strong) NSString *CountryName;
@property (nonatomic, strong) NSString *DSTOffset;
@property (nonatomic, strong) NSString *GMTOffset;
@property (nonatomic, strong) NSNumber *Latitude ;
@property (nonatomic, strong) NSNumber *Longitude;
@property (nonatomic, strong) NSNumber *Precision;
@property (nonatomic, strong) NSString *RawOffset;
@property (nonatomic, strong) NSString *Score;
@property (nonatomic, strong) NSString *State;
@property (nonatomic, strong) NSString *TimeZoneName;
@property (nonatomic, strong) NSString *Zip;
@property (nonatomic, strong) NSString *IP;

-(void) byAddress:(NSString*)address apiContext:(ProxomoApi*)context useAsync:(BOOL)useAsync;
-(void) byIPAddress:(NSString*)ipAddress apiContext:(ProxomoApi*)context useAsync:(BOOL)useAsync;
-(Location *) byLatitude:(NSNumber*)latitude byLogitude:(NSNumber*)longitude apiContext:(ProxomoApi*)context;
-(void) byLatitude:(NSNumber*)latitude byLogitude:(NSNumber*)longitude locationDelegate:(Location*)location apiContext:(ProxomoApi*)context;

@end
