//
//  Locations.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"
#import "ProxomoList.h"

typedef enum {
    OPEN_LOCATION = 0,
    PRIVATE_LOCATION = 1
} enumLocationSecurity;

@interface Location : ProxomoObject {
    NSString *Name;
    enumLocationSecurity LocationSecurity;
    NSString *LocationID;
    NSNumber *Latitude;
    NSNumber *Longitude;
    NSString *Address1;
    NSString *Address2;
    NSString *City;
    NSString *State;
    NSString *Zip;
    NSString *CountryName;
    NSString *CountryCode; 
    ProxomoList *_appData;
    ProxomoList *_locations;
}

@property (nonatomic, strong) NSString *Name;
@property (nonatomic) enumLocationSecurity LocationSecurity;
@property (nonatomic, strong) NSString *LocationID;
@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSNumber *Longitude;
@property (nonatomic, strong) NSString *Address1;
@property (nonatomic, strong) NSString *Address2;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *State;
@property (nonatomic, strong) NSString *Zip;
@property (nonatomic, strong) NSString *CountryName;
@property (nonatomic, strong) NSString *CountryCode;

-(NSArray*)byAddress:(NSString*)address apiContext:(id)context  useAsync:(BOOL)useAsync; 
-(NSArray*)byIP:(NSString*)ip apiContext:(id)context useAsync:(BOOL)useAsync; 
-(NSArray *)byLatitude:(NSNumber*)latitude byLogitude:(NSNumber*)longitude apiContext:(ProxomoApi*)context useAsync:(BOOL)useAsync;
-(NSArray*)locations;
-(NSArray*)appData;

@end
